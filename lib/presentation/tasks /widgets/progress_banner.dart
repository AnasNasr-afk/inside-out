import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/theme/app_tokens.dart';

class ProgressBanner extends StatelessWidget {
  const ProgressBanner({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  final int totalTasks;
  final int completedTasks;

  @override
  Widget build(BuildContext context) {
    final percent = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
    final pctInt = (percent * 100).round();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: T.primaryCta,
          image: const DecorationImage(
            image: AssetImage('assets/illustrations/tasksBackgroud.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Progress',
                    style: T.caption().copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '$completedTasks of $totalTasks tasks completed',
                    style: T.sectionHeader().copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999.r),
                    child: LinearProgressIndicator(
                      value: percent,
                      backgroundColor: Colors.white.withValues(alpha: 0.22),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      minHeight: 7.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.w),
            Text(
              '$pctInt%',
              style: T.bigNumeral().copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
