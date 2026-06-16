import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/presentation/poly_missions/cubit/poly_missions_cubit.dart';

/// A small guidance bubble that floats above Poly's head. The copy is fully
/// dynamic — it tells the child what to do now, what comes next, and cheers
/// them on, acting as a simple step-by-step guide through every phase.
class PmSpeechBubble extends StatelessWidget {
  final PmPhase phase;
  final bool polyIsTalking;
  final bool allDone;
  final bool allTasksDone;

  const PmSpeechBubble({
    super.key,
    required this.phase,
    required this.polyIsTalking,
    required this.allDone,
    this.allTasksDone = false,
  });

  _BubbleContent get _content {
    switch (phase) {
      case PmPhase.pick:
        return allTasksDone
            ? const _BubbleContent(
                '🌙', "All done for today! Come back tomorrow.")
            : const _BubbleContent('🎯', 'Tap a card to start a mission!');
      case PmPhase.focus:
        return polyIsTalking
            ? const _BubbleContent('💬', 'Poly has something to say…')
            : const _BubbleContent('🎤', 'Tap the mic and tell Poly!');
      case PmPhase.recording:
        return const _BubbleContent('👂', "I'm listening… tell me everything!");
      case PmPhase.analyzing:
        return const _BubbleContent('🤔', 'Hmm, let me think…');
      case PmPhase.response:
        if (polyIsTalking) {
          return const _BubbleContent('🌟', 'Nice work! Listen up…');
        }
        return allDone
            ? const _BubbleContent('🏁', 'Last one — tap to finish!')
            : const _BubbleContent('➡️', 'Awesome! Tap Next for more.');
      case PmPhase.celebration:
        return const _BubbleContent('🎉', 'You did it!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _content;

    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Bubble body — re-animates whenever the guidance text changes.
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(anim),
                child: child,
              ),
            ),
            child: Container(
              key: ValueKey(content.text),
              constraints: BoxConstraints(maxWidth: 300.w),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 13.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x5914120C),
                    blurRadius: 28.r,
                    offset: Offset(0, 12.h),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(content.emoji, style: TextStyle(fontSize: 18.sp)),
                  SizedBox(width: 9.w),
                  Flexible(
                    child: Text(
                      content.text,
                      style: T.cardTitle().copyWith(
                        fontSize: 14.5.sp,
                        color: const Color(0xFF2B2360),
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Downward tail pointing at Poly's head.
          Positioned(
            bottom: -7.h,
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: 14.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(2.r)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleContent {
  final String emoji;
  final String text;
  const _BubbleContent(this.emoji, this.text);
}
