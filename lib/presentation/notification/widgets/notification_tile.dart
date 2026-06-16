import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/models/app_notification.dart';
import '../../../core/theme/app_tokens.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;

  const NotificationTile({super.key, required this.notification, this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(notification.type);
    final unread = !notification.read;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: T.cardShadow,
      ),
      child: Material(
        color: unread ? const Color(0xFFF7F5FF) : T.card,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          splashColor: T.primaryTint,
          highlightColor: T.primaryTint.withValues(alpha: 0.4),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: unread ? T.primaryTint : T.border),
            ),
            padding: EdgeInsets.all(14.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type badge
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: style.bg,
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  child: Icon(style.icon, color: style.fg, size: 22.sp),
                ),
                SizedBox(width: 12.w),

                // Title + body
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: T.cardTitle().copyWith(
                                fontSize: 15.sp,
                                fontWeight:
                                    unread ? FontWeight.w800 : FontWeight.w600,
                                color: unread ? T.ink : T.mutedDeep,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            _timeAgo(notification.receivedAt),
                            style: T.caption().copyWith(
                              fontSize: 12.sp,
                              color: T.muted,
                            ),
                          ),
                          if (unread) ...[
                            SizedBox(width: 8.w),
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: const BoxDecoration(
                                color: T.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (notification.body.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          notification.body,
                          style: T.body().copyWith(
                            fontSize: 13.5.sp,
                            color: T.mutedDeep,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _timeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 1) return 'now';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    if (d.inDays < 7) return '${d.inDays}d';
    return '${dt.day}/${dt.month}';
  }

  _TileStyle _styleFor(AppNotificationType type) => switch (type) {
        AppNotificationType.taskAssigned => const _TileStyle(
            bg: T.primaryTint,
            fg: T.primary,
            icon: Icons.assignment_outlined,
          ),
        AppNotificationType.taskCompleted => const _TileStyle(
            bg: T.mintTint,
            fg: T.mintDeep,
            icon: Icons.check_circle_outline_rounded,
          ),
        AppNotificationType.note => const _TileStyle(
            bg: T.goldTint,
            fg: T.goldText,
            icon: Icons.edit_note_rounded,
          ),
        AppNotificationType.general => const _TileStyle(
            bg: Color(0xFFECEAF6),
            fg: T.mutedDeep,
            icon: Icons.notifications_none_rounded,
          ),
      };
}

class _TileStyle {
  final Color bg;
  final Color fg;
  final IconData icon;
  const _TileStyle({required this.bg, required this.fg, required this.icon});
}
