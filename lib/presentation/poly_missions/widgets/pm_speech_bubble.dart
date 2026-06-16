import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/theme/app_tokens.dart';

class PmSpeechBubble extends StatelessWidget {
  final String text;

  const PmSpeechBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300.w),
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Bubble body
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
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
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: T.cardTitle().copyWith(
                  color: const Color(0xFF2B2360),
                  height: 1.32,
                ),
              ),
            ),

            // Downward tail
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
      ),
    );
  }
}
