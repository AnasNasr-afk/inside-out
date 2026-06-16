import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_tokens.dart';

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90.w,
              height: 90.w,
              decoration: const BoxDecoration(
                color: T.primaryTint,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 44.sp,
                color: T.primary,
              ),
            ),
            SizedBox(height: 22.h),
            Text(
              "You're all caught up",
              style: T.sectionHeader(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'New tasks from your specialist and task updates will show up here.',
              style: T.body().copyWith(color: T.mutedDeep),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
