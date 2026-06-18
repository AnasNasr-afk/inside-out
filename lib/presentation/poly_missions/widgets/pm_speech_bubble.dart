import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/presentation/poly_missions/cubit/poly_missions_cubit.dart';

/// A small guidance bubble that floats above Dooby's head. The copy is fully
/// dynamic — it tells the child what to do now, what comes next, and cheers
/// them on, acting as a simple step-by-step guide through every phase.
class PmSpeechBubble extends StatelessWidget {
  final PmPhase phase;
  final bool polyIsTalking;
  final bool allDone;
  final bool allTasksDone;
  final String language;

  const PmSpeechBubble({
    super.key,
    required this.phase,
    required this.polyIsTalking,
    required this.allDone,
    this.allTasksDone = false,
    this.language = 'en',
  });

  bool get _isAr => language == 'ar';

  _BubbleContent get _content {
    switch (phase) {
      case PmPhase.pick:
        if (allTasksDone) {
          return _BubbleContent('🌙',
              _isAr ? 'خلصنا النهارده! تعالى بكره.' : 'All done for today! Come back tomorrow.');
        }
        return _BubbleContent('🎯',
            _isAr ? 'دوس على كارت عشان تبدأ!' : 'Tap a card to start a mission!');
      case PmPhase.focus:
        return polyIsTalking
            ? _BubbleContent('💬',
                _isAr ? 'دوبي عايز يقولك حاجة…' : 'Dooby has something to say…')
            : _BubbleContent('🎤',
                _isAr ? 'دوس على المايك واحكي لدوبي!' : 'Tap the mic and tell Dooby!');
      case PmPhase.recording:
        return _BubbleContent('👂',
            _isAr ? 'سامعك… احكيلي كل حاجة!' : "I'm listening… tell me everything!");
      case PmPhase.analyzing:
        return _BubbleContent('🤔', _isAr ? 'لحظة، خليني أفكر…' : 'Hmm, let me think…');
      case PmPhase.response:
        if (polyIsTalking) {
          return _BubbleContent('🌟', _isAr ? 'شغل حلو! اسمع…' : 'Nice work! Listen up…');
        }
        return allDone
            ? _BubbleContent('🏁',
                _isAr ? 'آخر واحدة — دوس عشان تخلص!' : 'Last one — tap to finish!')
            : _BubbleContent('➡️',
                _isAr ? 'برافو! دوس التالي.' : 'Awesome! Tap Next for more.');
      case PmPhase.celebration:
        return _BubbleContent('🎉', _isAr ? 'إنت عملتها!' : 'You did it!');
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
              child: Directionality(
                textDirection: _isAr ? TextDirection.rtl : TextDirection.ltr,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(content.emoji, style: TextStyle(fontSize: 18.sp)),
                    SizedBox(width: 9.w),
                    Flexible(
                      child: Text(
                        content.text,
                        style: (_isAr
                                ? GoogleFonts.cairo(textStyle: T.cardTitle())
                                : T.cardTitle())
                            .copyWith(
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
          ),

          // Downward tail pointing at Dooby's head.
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
