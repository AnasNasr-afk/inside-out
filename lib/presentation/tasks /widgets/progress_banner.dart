import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.35),
              blurRadius: 20.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Progress',
                    style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '$completedTasks of $totalTasks tasks completed',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: percent,
                      backgroundColor: Colors.white24,
                      valueColor:
                      const AlwaysStoppedAnimation(Colors.white),
                      minHeight: 7.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              '${(percent * 100).round()}%',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}