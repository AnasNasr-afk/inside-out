import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/core/cubits/task_cubit/task_cubit.dart';
import 'package:patient/core/cubits/task_cubit/task_listener.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/models/task_model.dart';
import '../../../core/theme/theme.dart';

class DailyActivitiesPreviewCard extends StatelessWidget {
  final VoidCallback onSeeAll;

  const DailyActivitiesPreviewCard({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskStates>(
      builder: (context, state) {
        if (state is TaskLoadingState || state is TaskInitialState) {
          return _buildLoading();
        }
        if (state is TaskErrorState) {
          return _buildError(context, state.message);
        }
        if (state is TaskSuccessState) {
          return state.tasks.isEmpty
              ? _buildEmpty()
              : _buildSuccess(context, state.tasks);
        }
        return const _LoadingBody();
      },
    );
  }

  Widget _buildLoading() => const _LoadingBody();


  Widget _buildError(BuildContext context, String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(label: "Today's Activities", trailing: ''),
        const SizedBox(height: 14),
        Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: const Color(0xFF6B7280)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              final childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);
              if (childId != 0) TaskCubit.get(context).getTasks(childId);
            },
            child: Text(
              'Retry',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(label: "Today's Activities", trailing: ''),
        const SizedBox(height: 14),
        Text(
          'No activities scheduled today.',
          style: GoogleFonts.poppins(
              fontSize: 13, color: const Color(0xFF9CA3AF)),
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context, List<TaskModel> allTasks) {
    final int total = allTasks.length;
    final int completed = allTasks.where((t) => t.isCompleted).length;
    final double progress = total == 0 ? 0 : completed / total;

    final sorted = [...allTasks]
      ..sort((a, b) {
        if (a.isCompleted == b.isCompleted) return 0;
        return a.isCompleted ? 1 : -1;
      });
    final preview = sorted.take(3).toList();
    final int remaining = total - preview.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          label: "Today's Activities",
          trailing: '$completed/$total',
          onTrailingTap: onSeeAll,
        ),
        const SizedBox(height: 6),
        Text(
          completed == total
              ? 'All done for today!'
              : '${total - completed} ${total - completed == 1 ? 'task' : 'tasks'} remaining',
          style: GoogleFonts.poppins(
              fontSize: 12, color: const Color(0xFF9CA3AF)),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFF3F4F6),
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 14),
        ...preview.map((task) => _TaskCard(task: task)),
        if (remaining > 0)
          GestureDetector(
            onTap: onSeeAll,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+ $remaining more ${remaining == 1 ? 'task' : 'tasks'}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ── Loading body ─────────────────────────────────────────────────────────────

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(label: "Today's Activities", trailing: ''),
        SizedBox(height: 14),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      ],
    );
  }
}

// ── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final String trailing;
  final VoidCallback? onTrailingTap;

  const _SectionHeader({
    required this.label,
    required this.trailing,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        if (trailing.isNotEmpty)
          GestureDetector(
            onTap: onTrailingTap,
            child: Row(
              children: [
                Text(
                  trailing,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── Task card (Design 2 style) ───────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final TaskModel task;
  const _TaskCard({required this.task});

  static final _titleStyle = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF1F2937),
  );
  static final _titleDoneStyle = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF9CA3AF),
    decoration: TextDecoration.lineThrough,
    decorationColor: const Color(0xFF9CA3AF),
  );
  static final _subStyle = GoogleFonts.poppins(
    fontSize: 12,
    color: const Color(0xFF6B7280),
  );
  static final _overdueSub = GoogleFonts.poppins(
    fontSize: 12,
    color: const Color(0xFFEF4444),
  );

  @override
  Widget build(BuildContext context) {
    final bool done = task.isCompleted;
    final bool overdue = task.isOverdue;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: overdue && !done
            ? const Color(0xFFFFF1F2)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
        border: overdue && !done
            ? Border.all(color: const Color(0xFFFECACA), width: 1)
            : null,
      ),
      child: Row(
        children: [
          // Completion indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? AppTheme.primaryColor : Colors.transparent,
              border: Border.all(
                color: done
                    ? AppTheme.primaryColor
                    : overdue
                        ? const Color(0xFFEF4444)
                        : const Color(0xFFD1D5DB),
                width: 1.5,
              ),
            ),
            child: done
                ? const Icon(Icons.check_rounded,
                    size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),

          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: done ? _titleDoneStyle : _titleStyle,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    if (task.isGameTask) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          task.gameDisplayName,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      task.timeLabel,
                      style: overdue && !done ? _overdueSub : _subStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Arrow (only for pending tasks)
          if (!done) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: overdue
                  ? const Color(0xFFEF4444)
                  : const Color(0xFFD1D5DB),
            ),
          ],
        ],
      ),
    );
  }
}
