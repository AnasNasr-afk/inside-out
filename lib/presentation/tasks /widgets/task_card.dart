import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cubits/task_cubit/task_cubit.dart';
import '../../../core/helpers/shared_pref.dart';
import '../../../core/helpers/shared_pref_keys.dart';
import '../../../core/models/task_model.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/theme.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});
  final TaskModel task;

  String get _statusLabel {
    if (task.isCompleted) return 'Completed';
    if (task.isOverdue) return 'Overdue';
    return 'Pending';
  }

  Color get _statusColor {
    if (task.isCompleted) return const Color(0xFF059669);
    if (task.isOverdue) return const Color(0xFFDC2626);
    return AppTheme.orange;
  }

  Color get _statusBg {
    if (task.isCompleted) return const Color(0xFFD1FAE5);
    if (task.isOverdue) return const Color(0xFFFFE4E4);
    return const Color(0xFFFEF3C7);
  }

  Color get _timeLabelColor {
    if (task.isCompleted) return const Color(0xFF059669);
    if (task.isOverdue) return const Color(0xFFDC2626);
    return const Color(0xFF6B7280);
  }

  IconData get _timeLabelIcon {
    if (task.isCompleted) return Icons.check_circle_outline_rounded;
    if (task.isOverdue) return Icons.warning_amber_rounded;
    return Icons.calendar_today_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          Routes.taskDetailsScreen,
          arguments: task,
        );
        if (result == true && context.mounted) {
          final childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);
          if (childId != 0) {
            TaskCubit.get(context).getTasks(childId);
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: task.isCompleted
                ? const Color(0xFF10B981).withValues(alpha: 0.3)
                : const Color(0xFF6B7280).withValues(alpha: 0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Top row ────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _statusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFF3F4F6)),

            // ── Bottom meta row ─────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    _timeLabelIcon,
                    size: 13,
                    color: _timeLabelColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.timeLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: _timeLabelColor,
                      fontWeight: task.isOverdue ? FontWeight.w700 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            if (task.isCompleted)
              Container(
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}