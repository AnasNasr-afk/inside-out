import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:patient/presentation/poly_missions/cubit/poly_missions_service.dart';
import 'package:rive/rive.dart' hide RadialGradient, LinearGradient;

class PmPolyArea extends StatefulWidget {
  /// True while the child is recording — drives the 'Hear' SMI.
  final bool isHearing;

  const PmPolyArea({
    super.key,
    this.isHearing = false,
  });

  @override
  State<PmPolyArea> createState() => _PmPolyAreaState();
}

class _PmPolyAreaState extends State<PmPolyArea> {
  Artboard? _artboard;
  SMIBool? _hear;
  SMIBool? _talk;

  StreamSubscription<PlayerState>? _playerSub;

  @override
  void initState() {
    super.initState();

    // Subscribe to actual audio playback state to drive the Talk animation.
    // This ensures the avatar only animates when audio is genuinely playing —
    // not during TTS synthesis latency or after playback has stopped.
    _playerSub = PolyMissionsService.instance.playerStateStream.listen((s) {
      final isPlaying = s.playing &&
          s.processingState != ProcessingState.completed &&
          s.processingState != ProcessingState.idle;
      _talk?.value = isPlaying;
    });

    rootBundle.load('assets/bear_character.riv').then((data) {
      try {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        final ctrl =
            StateMachineController.fromArtboard(artboard, 'State Machine 1');
        if (ctrl != null) {
          artboard.addController(ctrl);
          _hear = ctrl.findSMI('Hear');
          _talk = ctrl.findSMI('Talk');
          _hear?.value = widget.isHearing;
        }
        if (mounted) setState(() => _artboard = artboard);
      } catch (e) {
        debugPrint('PmPolyArea Rive load error: $e');
      }
    });
  }

  @override
  void didUpdateWidget(PmPolyArea old) {
    super.didUpdateWidget(old);
    if (old.isHearing != widget.isHearing) {
      _hear?.value = widget.isHearing;
    }
  }

  @override
  void dispose() {
    _playerSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const RadialGradient(
            center: Alignment(0, 0.25),
            radius: 1.0,
            colors: [Colors.white, Colors.white, Colors.transparent],
            stops: [0.5, 0.5, 0.5],
          ).createShader(bounds),
          blendMode: BlendMode.dstIn,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              width: 400,
              height: 360,
              child: _artboard == null
                  ? const SizedBox.shrink()
                  : Rive(artboard: _artboard!, fit: BoxFit.contain),
            ),
          ),
        ),

        // Ground shadow ellipse
        Transform.translate(
          offset: const Offset(0, -9),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              width: 160,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF2B2360).withValues(alpha: 0.26),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.70],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
