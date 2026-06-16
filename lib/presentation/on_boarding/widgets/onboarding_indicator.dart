import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(right: 5.w),
          height: 8.h,
          width: 8.w,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? Colors.blueAccent
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }
}