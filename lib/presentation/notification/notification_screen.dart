import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/models/app_notification.dart';
import '../../core/services/notification_store.dart';
import '../../core/theme/app_tokens.dart';
import 'widgets/notification_empty_state.dart';
import 'widgets/notification_header.dart';
import 'widgets/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = NotificationStore.instance;

    return Scaffold(
      backgroundColor: T.appBg,
      body: SafeArea(
        bottom: false,
        child: ValueListenableBuilder<List<AppNotification>>(
          valueListenable: store.notifier,
          builder: (context, items, _) {
            final unread = items.where((n) => !n.read).length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 14.h),
                  child: NotificationHeader(
                    unreadCount: unread,
                    onMarkAllRead: store.markAllRead,
                  ),
                ),
                Expanded(
                  child: items.isEmpty
                      ? const NotificationEmptyState()
                      : RefreshIndicator(
                          color: T.primary,
                          onRefresh: store.refresh,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 120.h),
                            children: _buildSections(items, store),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildSections(
    List<AppNotification> items,
    NotificationStore store,
  ) {
    final widgets = <Widget>[];
    String? lastBucket;

    for (final n in items) {
      final bucket = _bucketFor(n.receivedAt);
      if (bucket != lastBucket) {
        widgets.add(Padding(
          padding: EdgeInsets.only(top: lastBucket == null ? 4.h : 14.h, bottom: 8.h),
          child: Text(
            bucket.toUpperCase(),
            style: T.badge().copyWith(
              fontSize: 11.sp,
              letterSpacing: 1.0,
              color: T.muted,
            ),
          ),
        ));
        lastBucket = bucket;
      }

      widgets.add(Dismissible(
        key: ValueKey(n.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => store.remove(n.id),
        background: _dismissBackground(),
        child: NotificationTile(
          notification: n,
          onTap: () => store.markRead(n.id),
        ),
      ));
    }
    return widgets;
  }

  Widget _dismissBackground() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.only(right: 22.w),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: T.coralTint,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Icon(Icons.delete_outline_rounded, color: T.coral, size: 22.sp),
    );
  }

  String _bucketFor(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(day).inDays;
    if (diff <= 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return 'This week';
    return 'Earlier';
  }
}
