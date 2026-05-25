import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/ai_avatar/providers/openai_response_controller.dart';
import 'package:patient/ai_avatar/providers/animation_state_controller.dart';
import 'package:patient/ai_avatar/providers/session_state_controller.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:collection/collection.dart';

class STTWidget extends ConsumerStatefulWidget {
  const STTWidget({super.key});

  @override
  ConsumerState<STTWidget> createState() => _STTWidgetState();
}

class _STTWidgetState extends ConsumerState<STTWidget>
    with TickerProviderStateMixin {
  static const bool _debugMode = false;
  static const String _debugInput = 'the exercise hurts my arm';

  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';
  String _sessionTranscript = ''; // accumulates across silence-restart gaps
  List<LocaleName> _localeNames = [];
  late AnimationController _idleAnimationController;
  late Animation<double> _idleAnimation;
  bool _isWaitingForResponse = false; // free mode only
  bool _hasPermission = true;
  bool _speechInitialized = false;
  bool _manualStop = false;   // true when child taps STOP SPEAKING
  bool _isRestarting = false; // guards against double-restart
  Timer? _responseTimeout;

  @override
  void initState() {
    super.initState();
    _idleAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _idleAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _idleAnimationController, curve: Curves.easeInOut),
    );
    _idleAnimationController.repeat(reverse: true);
    // No auto-start — child taps the button to begin speaking.
  }

  @override
  void dispose() {
    _idleAnimationController.dispose();
    _responseTimeout?.cancel();
    super.dispose();
  }

  // ── Platform callbacks ────────────────────────────────────────────────────

  void _errorListener(SpeechRecognitionError error) {
    debugPrint('STT error: $error, listening: ${_speechToText.isListening}');
    ref.read(animationStateControllerProvider.notifier).updateHearing(false);
    // On timeout mid-session, silently restart so child can keep speaking.
    if (!_manualStop) _scheduleRestart();
  }

  void _statusListener(String status) {
    if (status == 'done') {
      ref.read(animationStateControllerProvider.notifier).updateHearing(false);
    }
    debugPrint('STT status: $status, listening: ${_speechToText.isListening}');
  }

  // ── Initialization ────────────────────────────────────────────────────────

  Future<bool> _ensureInitialized() async {
    if (_speechInitialized) return true;
    _speechInitialized = await _speechToText.initialize(
        onError: _errorListener, onStatus: _statusListener);
    if (_speechInitialized) {
      _localeNames = await _speechToText.locales();
    }
    return _speechInitialized;
  }

  // ── Session mode ──────────────────────────────────────────────────────────

  /// First tap: start recording for a task session.
  void _startSessionListening() async {
    if (_speechToText.isListening || _isRestarting) return;
    if (!await _ensureInitialized()) {
      if (mounted) setState(() => _hasPermission = false);
      return;
    }

    _sessionTranscript = '';
    _lastWords = '';
    _manualStop = false;

    if (mounted) setState(() => _hasPermission = true);
    ref.read(animationStateControllerProvider.notifier).updateHearing(true);
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: _getCurrentLocale(),
      listenFor: const Duration(seconds: 60),
      // No pauseFor — child decides when they're done.
    );
    if (mounted) setState(() {});
  }

  /// Second tap: stop and send the accumulated transcript to Poly.
  void _stopAndSubmit() {
    _manualStop = true;
    if (_speechToText.isListening) {
      _speechToText.stop();
      // _onSpeechResult(finalResult) will fire and call _handleManualStop().
    } else {
      // STT already stopped (e.g. in a restart gap) — handle directly.
      _handleManualStop();
    }
  }

  /// Central handler for when the child deliberately stops recording.
  void _handleManualStop() {
    _manualStop = false;
    ref.read(animationStateControllerProvider.notifier).updateHearing(false);
    if (!mounted) return;

    if (_lastWords.isNotEmpty) {
      ref
          .read(sessionStateControllerProvider.notifier)
          .submitTranscript(_lastWords);
    } else {
      final lang = ref.read(animationStateControllerProvider).language;
      final nudge = switch (lang) {
        'ar' => 'ما سمعتكش! اضغط على زرار الكلام وحاول تاني.',
        'jp' => '聞こえませんでした。もう一度話してみてください。',
        _ => 'I did not hear you! Press Tap to Speak and try again.',
      };
      ref.read(openAIResponseControllerProvider.notifier).speakDirect(nudge);
    }
  }

  /// Called after an auto-silence break — restarts without resetting transcript.
  void _scheduleRestart() {
    final session = ref.read(sessionStateControllerProvider);
    if (_manualStop || _isRestarting || !mounted ||
        session.phase != SessionPhase.listening) return;
    _restartListening();
  }

  void _restartListening() async {
    if (_isRestarting || !mounted) return;
    _isRestarting = true;
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted ||
        ref.read(sessionStateControllerProvider).phase !=
            SessionPhase.listening ||
        _manualStop) {
      _isRestarting = false;
      return;
    }
    ref.read(animationStateControllerProvider.notifier).updateHearing(true);
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: _getCurrentLocale(),
      listenFor: const Duration(seconds: 60),
    );
    _isRestarting = false;
    if (mounted) setState(() {});
  }

  // ── Free mode ─────────────────────────────────────────────────────────────

  void _startListening() async {
    if (_speechToText.isListening) return;
    if (!await _ensureInitialized()) {
      if (mounted) setState(() => _hasPermission = false);
      return;
    }
    if (mounted) setState(() => _hasPermission = true);
    ref.read(animationStateControllerProvider.notifier).updateHearing(true);
    await _speechToText.listen(
        onResult: _onSpeechResult, localeId: _getCurrentLocale());
    if (mounted) setState(() {});
  }

  void _stopListening() async {
    _startWaitingForResponse();
    await _speechToText.stop();
    ref.read(animationStateControllerProvider.notifier).updateHearing(false);
  }

  // ── Speech result ─────────────────────────────────────────────────────────

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!result.finalResult) return;

    final session = ref.read(sessionStateControllerProvider);

    if (session.phase == SessionPhase.listening) {
      // Accumulate words across silence-restart gaps.
      final newWords = result.recognizedWords.trim();
      if (newWords.isNotEmpty) {
        _sessionTranscript = _sessionTranscript.isEmpty
            ? newWords
            : '$_sessionTranscript $newWords';
        _lastWords = _sessionTranscript;
      }

      if (_manualStop) {
        _handleManualStop();
      } else {
        // Auto-silence break — restart so child can continue speaking.
        _scheduleRestart();
      }
    } else {
      // Free-form mode.
      _lastWords = result.recognizedWords;
      _stopListening();
      ref
          .read(openAIResponseControllerProvider.notifier)
          .getResponse(_lastWords);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _getCurrentLocale() {
    final String lang = ref.read(animationStateControllerProvider).language;
    final String fallback = switch (lang) {
      'ar' => 'ar-EG',
      'jp' => 'ja-JP',
      _ => 'en-US',
    };
    final String searchCode = switch (lang) {
      'ar' => 'ar',
      'jp' => 'ja',
      _ => 'en-US',
    };
    final locale = _localeNames
        .firstWhereOrNull((l) => l.localeId.startsWith(searchCode));
    return locale?.localeId ?? fallback;
  }

  void _startWaitingForResponse() {
    setState(() => _isWaitingForResponse = true);
    _responseTimeout?.cancel();
    _responseTimeout = Timer(const Duration(seconds: 15), _stopWaitingForResponse);
  }

  void _stopWaitingForResponse() {
    _responseTimeout?.cancel();
    if (_isWaitingForResponse && mounted) {
      setState(() => _isWaitingForResponse = false);
    }
  }

  bool get _isListening => _speechToText.isListening;

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionStateControllerProvider);
    final bool inSessionMode = session.phase == SessionPhase.listening;

    ref.listen(openAIResponseControllerProvider, (previous, next) {
      if (!_isWaitingForResponse) return;
      next.when(
        data: (data) {
          if (data != null) _stopWaitingForResponse();
        },
        error: (_, __) => _stopWaitingForResponse(),
        loading: () {},
      );
    });

    final bool isIdle = !_isListening && !_isWaitingForResponse;
    final bool isDisabled = _isWaitingForResponse;

    return AnimatedBuilder(
      animation: _idleAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, isIdle ? _idleAnimation.value : 0),
          child: Material(
            color: _getButtonColor(inSessionMode),
            borderRadius: BorderRadius.circular(30),
            elevation: 6,
            child: InkWell(
              onTap: isDisabled
                  ? null
                  : () {
                      if (_debugMode) {
                        _startWaitingForResponse();
                        ref
                            .read(openAIResponseControllerProvider.notifier)
                            .getResponse(_debugInput);
                        return;
                      }
                      if (inSessionMode) {
                        _isListening
                            ? _stopAndSubmit()
                            : _startSessionListening();
                      } else {
                        _isListening ? _stopListening() : _startListening();
                      }
                    },
              borderRadius: BorderRadius.circular(30),
              child: Semantics(
                label: _getSemanticLabel(inSessionMode),
                button: true,
                enabled: !isDisabled,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getIconData(inSessionMode),
                          color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        _getDisplayText(inSessionMode),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconData(bool inSessionMode) {
    if (_isWaitingForResponse) return Icons.hourglass_empty;
    if (!_hasPermission) return Icons.warning;
    if (inSessionMode && _isListening) return Icons.stop_circle_outlined;
    return _isListening ? Icons.mic : Icons.mic_none_outlined;
  }

  Color _getButtonColor(bool inSessionMode) {
    if (_isWaitingForResponse) return AppTheme.orange;
    if (!_hasPermission) return Colors.red;
    if (_isListening) return Colors.red;
    return AppTheme.primaryColor;
  }

  String _getDisplayText(bool inSessionMode) {
    if (_isWaitingForResponse) return 'THINKING...';
    if (inSessionMode) {
      return _isListening ? 'STOP SPEAKING' : 'TAP TO SPEAK';
    }
    if (_isListening) return 'LISTENING...';
    if (!_hasPermission) return 'NEED MIC PERMISSION';
    return 'TAP TO SPEAK';
  }

  String _getSemanticLabel(bool inSessionMode) {
    if (_isWaitingForResponse) return 'Waiting for response, please wait';
    if (inSessionMode) {
      return _isListening
          ? 'Tap when you are done speaking'
          : 'Tap to start speaking';
    }
    if (_isListening) return 'Currently listening, tap to stop';
    if (!_hasPermission) return 'Microphone permission required';
    return 'Tap to start speaking';
  }
}
