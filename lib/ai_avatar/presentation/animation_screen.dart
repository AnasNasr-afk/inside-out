import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patient/ai_avatar/providers/animation_state_controller.dart';
import 'package:rive/rive.dart';

class AnimationScreen extends ConsumerStatefulWidget {
  const AnimationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnimationScreenState();
}

class _AnimationScreenState extends ConsumerState<AnimationScreen> {
  Artboard? riveArtboard;
  SMIBool? isHearing;
  SMIBool? talk;

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/bear_character.riv').then(
      (data) async {
        try {
          final file = RiveFile.import(data);
          final artboard = file.mainArtboard;
          final controller =
              StateMachineController.fromArtboard(artboard, 'State Machine 1');
          if (controller != null) {
            artboard.addController(controller);
            isHearing = controller.findSMI('Hear');
            talk = controller.findSMI('Talk');
            setState(() {
              riveArtboard = artboard;
            });
            // Apply current state after the artboard is ready
            _toggleAnimation(ref.read(animationStateControllerProvider));
          }
        } catch (e) {
          debugPrint('❌ Rive load error: $e');
        }
      },
    );
  }

  void _toggleAnimation(AnimationState newValue) {
    debugPrint('toggle animation, is hearing: ${newValue.isHearing}');
    isHearing?.value = newValue.isHearing;
    talk?.value = newValue.isTalking;
  }

  bool get isHearingValue => isHearing?.value ?? false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    ref.listen(animationStateControllerProvider, (_, next) {
      _toggleAnimation(next);
    });

    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 0.65,
        child: riveArtboard == null
            ? const SizedBox()
            : Rive(
                artboard: riveArtboard!,
                alignment: Alignment.center,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
