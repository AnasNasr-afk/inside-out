import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:patient/ai_avatar/data/google_cloud_repository.dart';
import 'package:patient/ai_avatar/providers/animation_state_controller.dart';
import 'package:patient/ai_avatar/providers/openai_response_controller.dart';
import 'package:patient/ai_avatar/providers/session_state_controller.dart';

class TextToSpeechCloud extends ConsumerStatefulWidget {
  const TextToSpeechCloud({super.key, this.child});
  final Widget? child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends ConsumerState<TextToSpeechCloud> {
  final player = AudioPlayer();
  late final StreamSubscription<PlayerState> _playerSub;

  @override
  void initState() {
    super.initState();
    _playerSub = player.playerStateStream.listen(_onPlayerState);
  }

  void _onPlayerState(PlayerState event) {
    if (event.processingState == ProcessingState.completed) {
      debugPrint('🐻 Bear talking: false');
      _updateTalkingAnimation(false);
      if (mounted) _onTtsComplete();
    }
  }

  void _onTtsComplete() {
    final session = ref.read(sessionStateControllerProvider);
    final controller = ref.read(sessionStateControllerProvider.notifier);
    switch (session.phase) {
      case SessionPhase.greeting:
        controller.startListening();
      case SessionPhase.processing:
        controller.setResponded();
      default:
        break;
    }
  }

  void _stopAudio() {
    player.stop();
    _updateTalkingAnimation(false);
  }

  @override
  void dispose() {
    _playerSub.cancel();
    player.dispose();
    super.dispose();
  }

  void _updateTalkingAnimation(bool isTalking) {
    ref.read(animationStateControllerProvider.notifier).updateTalking(isTalking);
  }

  void _speakCloudTTS(String text) async {
    if (text.trim().isEmpty) return;

    try {
      final String currentLang =
          ref.read(animationStateControllerProvider).language;

      debugPrint('🔊 TTS synthesizing [$currentLang]: "$text"');
      final repo = ref.read(googleCloudRepositoryProvider);
      final audioSource = await repo.synthesizeToFileSource(text, currentLang);
      await player.setAudioSource(audioSource);
      _updateTalkingAnimation(true);
      debugPrint('🐻 Bear talking: true');
      player.play();
    } catch (e) {
      debugPrint('❌ TTS failed: $e');
      _updateTalkingAnimation(false);
      if (mounted) _onTtsComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sessionStateControllerProvider, (previous, next) {
      if (previous?.phase != SessionPhase.idle &&
          next.phase == SessionPhase.idle) {
        _stopAudio();
      }
    });

    ref.listen(openAIResponseControllerProvider, (previous, next) {
      next.when(
        data: (data) {
          if (data != null && data.isNotEmpty) {
            _speakCloudTTS(data);
          }
        },
        error: (error, _) {
          _speakCloudTTS("Oops! I didn't catch that. Can you say it again?");
          debugPrint('❌ TTS error fallback triggered: $error');
        },
        loading: () {},
      );
    });

    return widget.child ?? const SizedBox();
  }
}
