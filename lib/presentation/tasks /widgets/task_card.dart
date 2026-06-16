import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/models/task_model.dart';
import 'package:patient/core/routing/routes.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/core/cubits/task_cubit/task_cubit.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});
  final TaskModel task;

  // ── Derived state ─────────────────────────────────────────────────────────

  Color get _accentColor {
    if (task.isCompleted) return T.mint;
    if (task.isOverdue) return T.coral;
    return T.primary;
  }

  Color get _badgeBg {
    if (task.isCompleted) return T.mintTint;
    if (task.isOverdue) return T.coralTint;
    return T.goldTint;
  }

  Color get _badgeText {
    if (task.isCompleted) return T.mintDeep;
    if (task.isOverdue) return T.coral;
    return T.goldText;
  }

  String get _badgeLabel {
    if (task.isCompleted) return 'Completed';
    if (task.isOverdue) return 'Overdue';
    return 'Pending';
  }

  String get _metaText {
    if (task.isCompleted) {
      return task.completedAt != null
          ? 'Completed · ${task.formattedDueDate}'
          : 'Completed';
    }
    if (task.isOverdue) return 'Overdue · ${task.formattedDueDate}';
    return 'Due · ${task.timeLabel.replaceFirst('Due ', '')}';
  }

  Color get _metaColor {
    if (task.isCompleted) return T.mintDeep;
    if (task.isOverdue) return T.coral;
    return T.muted;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          Routes.taskDetailsScreen,
          arguments: task,
        );
        if (result == true && context.mounted) {
          final childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);
          if (childId != 0) TaskCubit.get(context).getTasks(childId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: T.card,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: T.cardShadow,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Left accent bar ──────────────────────────────────────────
              Container(
                width: 5.w,
                decoration: BoxDecoration(
                  color: _accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    bottomLeft: Radius.circular(20.r),
                  ),
                ),
              ),

              // ── Content ──────────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  child: Row(
                    children: [
                      // Icon tile
                      _IconTile(completed: task.isCompleted, color: _accentColor),
                      SizedBox(width: 12.w),

                      // Title + meta
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              task.title,
                              style: T.cardTitle().copyWith(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: const Color(0xFF9A98B6),
                                color: task.isCompleted
                                    ? const Color(0xFF9A98B6)
                                    : T.ink,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              _metaText,
                              style: T.caption().copyWith(color: _metaColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: _badgeBg,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          _badgeLabel,
                          style: T.badge().copyWith(color: _badgeText),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.completed, required this.color});
  final bool completed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (completed) {
      return Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: T.mint,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.check_rounded, color: Colors.white, size: 22.sp),
      );
    }

    // Dashed border tile for pending / overdue
    return SizedBox(
      width: 40.w,
      height: 40.h,
      child: CustomPaint(
        painter: _DashedBorderPainter(color: color),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8.w
      ..style = PaintingStyle.stroke;

    final dashLen = 4.0.r;
    final gap = 3.0.r;
    final r = 12.0.r;
    final pad = 1.0.r;

    final rect = RRect.fromLTRBR(
      pad, pad, size.width - pad, size.height - pad, Radius.circular(r));

    final path = Path()..addRRect(rect);
    final metric = path.computeMetrics().first;
    double dist = 0;
    while (dist < metric.length) {
      final seg = metric.extractPath(dist, dist + dashLen);
      canvas.drawPath(seg, paint);
      dist += dashLen + gap;
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}
