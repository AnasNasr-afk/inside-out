import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_tokens.dart';

class NotificationHeader extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onMarkAllRead;

  const NotificationHeader({
    super.key,
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notifications', style: T.screenTitle()),
              SizedBox(height: 4.h),
              Text(
                unreadCount > 0
                    ? '$unreadCount new update${unreadCount > 1 ? 's' : ''}'
                    : 'No new updates',
                style: T.caption().copyWith(color: T.muted),
              ),
            ],
          ),
        ),
        if (unreadCount > 0)
          GestureDetector(
            onTap: onMarkAllRead,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: T.primaryTint,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.done_all_rounded, size: 16.sp, color: T.primary),
                  SizedBox(width: 6.w),
                  Text(
                    'Mark all read',
                    style: T.badge().copyWith(
                      fontSize: 12.5.sp,
                      color: T.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
