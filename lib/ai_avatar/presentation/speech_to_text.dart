import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patient/ai_avatar/providers/openai_response_controller.dart';
import 'package:patient/ai_avatar/providers/animation_state_controller.dart';
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
  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';
  List<LocaleName> _localeNames = [];
  late AnimationController _idleAnimationController;
  late Animation<double> _idleAnimation;
  bool _isWaitingForResponse = false;
  bool _hasPermission = true;
  bool _speechInitialized = false;
  Timer? _responseTimeout;
  @override
  void initState() {
    super.initState();
    _initSpeech();

    // Idle animation (gentle movement when not active)
    _idleAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _idleAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _idleAnimationController,
      curve: Curves.easeInOut,
    ));
    _idleAnimationController.repeat(reverse: true);
  }


  @override
  void dispose() {
    _idleAnimationController.dispose();
    _responseTimeout?.cancel();
    super.dispose();
  }

  void errorListener(SpeechRecognitionError error) {
    print(
        'Received error status: $error, listening: ${_speechToText.isListening}');
    ref.read(animationStateControllerProvider.notifier).updateHearing(false);
  }

  void statusListener(String status) {
    if (status == 'done') {
      ref.read(animationStateControllerProvider.notifier).updateHearing(false);
    }
    print(
        'Received listener status: $status, listening: ${_speechToText.isListening}');
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechInitialized = await _speechToText.initialize(
        onError: errorListener, onStatus: statusListener);
    if (_speechInitialized) {
      _localeNames = await _speechToText.locales();
    }
    // Don't update _hasPermission here — we'll handle it in _startListening
  }


  /// Each time to start a speech recognition session
  void _startListening() async {
    if (_speechToText.isListening) {
      print('Already listening');
      return;
    }

    // Try to initialize if not yet done
    if (!_speechInitialized) {
      _speechInitialized = await _speechToText.initialize(
          onError: errorListener, onStatus: statusListener);
      if (_speechInitialized) {
        _localeNames = await _speechToText.locales();
      }
    }

    if (!_speechInitialized) {
      print('Speech recognition not available');
      setState(() {
        _hasPermission = false;
      });
      return;
    }

    setState(() {
      _hasPermission = true;
    });

    ref.read(animationStateControllerProvider.notifier).updateHearing(true);
    final localeId = _getCurrentLocale();
    await _speechToText.listen(onResult: _onSpeechResult, localeId: localeId);

    setState(() {});
  }

  String _getCurrentLocale() {
    final String currentLang =
        ref.read(animationStateControllerProvider).language;

    final locale = _localeNames.firstWhereOrNull(
        (locale) => locale.localeId.contains(currentLang.toUpperCase()));
    if (locale == null || _localeNames.isEmpty) {
      return currentLang == 'en' ? 'en-US' : 'ja-JP';
    } else {
      return locale.localeId;
    }
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    // Start waiting for response with timeout
    _startWaitingForResponse();
    await _speechToText.stop();
    ref.read(animationStateControllerProvider.notifier).updateHearing(false);
  }

  void _startWaitingForResponse() {
    setState(() {
      _isWaitingForResponse = true;
    });

    // Start timeout timer (10 seconds)
    _responseTimeout?.cancel();
    _responseTimeout = Timer(const Duration(seconds: 10), () {
      print('OpenAI response timeout - stopping wait');
      _stopWaitingForResponse();
    });
  }

  void _stopWaitingForResponse() {
    _responseTimeout?.cancel();
    if (_isWaitingForResponse) {
      setState(() {
        _isWaitingForResponse = false;
      });
    }
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) async {
    if (result.finalResult) {
      _lastWords = result.recognizedWords;
      _stopListening();

      ref
          .read(openAIResponseControllerProvider.notifier)
          .getResponse(_lastWords);
    }
  }

  bool get _isListening => _speechToText.isListening;

  @override
  Widget build(BuildContext context) {
    print('Built STT widget');
    print("IS LISTENING: $_isListening");

    // Listen to OpenAI response to stop waiting when response received
    ref.listen(openAIResponseControllerProvider, (previous, next) {
      if (_isWaitingForResponse) {
        next.when(
          data: (data) {
            if (data != null) {
              _stopWaitingForResponse();
            }
          },
          error: (error, stackTrace) {
            _stopWaitingForResponse();
          },
          loading: () {}, // Keep waiting during loading
        );
      }
    });

    final bool isIdle = !_isListening && !_isWaitingForResponse;
    final bool isDisabled = _isWaitingForResponse;

    return AnimatedBuilder(
      animation: _idleAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, isIdle ? _idleAnimation.value : 0),
          child: Material(
            color: _getButtonColor(),
            borderRadius: BorderRadius.circular(30),
            elevation: 6,
            child: InkWell(
              onTap: isDisabled
                  ? null
                  : () {
                      print("IS LISTENING: $_isListening");
                      _isListening ? _stopListening() : _startListening();
                    },
              borderRadius: BorderRadius.circular(30),
              child: Semantics(
                label: _getSemanticLabel(),
                button: true,
                enabled: !isDisabled,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconData(),
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _getDisplayText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

  IconData _getIconData() {
    if (_isWaitingForResponse) return Icons.hourglass_empty;
    if (!_hasPermission) return Icons.warning;
    return _isListening ? Icons.mic : Icons.mic_off;
  }

  Color _getButtonColor() {
    if (_isWaitingForResponse) return Colors.orange;
    if (!_hasPermission) return Colors.red;
    if (_isListening) return Colors.red;
    return Colors.deepPurple;
  }

  String _getDisplayText() {
    if (_isWaitingForResponse) return 'THINKING...';
    if (_isListening) return 'LISTENING...';
    if (!_hasPermission) return 'NEED MIC PERMISSION';
    return 'TAP TO SPEAK';
  }

  String _getSemanticLabel() {
    if (_isWaitingForResponse) return 'Waiting for response, please wait';
    if (_isListening) return 'Currently listening, tap to stop';
    if (!_hasPermission)
      return 'Microphone permission required, tap to grant permission';
    return 'Tap to start speaking';
  }
}
