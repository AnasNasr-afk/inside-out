import 'package:flutter/material.dart';
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
          borderRadius: BorderRadius.circular(20),
          boxShadow: T.cardShadow,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Left accent bar ──────────────────────────────────────────
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: _accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),

              // ── Content ──────────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Row(
                    children: [
                      // Icon tile
                      _IconTile(completed: task.isCompleted, color: _accentColor),
                      const SizedBox(width: 12),

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
                            const SizedBox(height: 5),
                            Text(
                              _metaText,
                              style: T.caption().copyWith(color: _metaColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _badgeBg,
                          borderRadius: BorderRadius.circular(999),
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
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: T.mint,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
      );
    }

    // Dashed border tile for pending / overdue
    return SizedBox(
      width: 40,
      height: 40,
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
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    const dashLen = 4.0;
    const gap = 3.0;
    const r = 12.0;
    const pad = 1.0;

    final rect = RRect.fromLTRBR(
      pad, pad, size.width - pad, size.height - pad, const Radius.circular(r));

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
