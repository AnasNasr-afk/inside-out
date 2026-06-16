import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        SizedBox(height: 14.h),
        Row(
          children: [
            Icon(Icons.error_outline, color: const Color(0xFFEF4444), size: 18.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                    fontSize: 13.sp, color: const Color(0xFF6B7280)),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
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
                fontSize: 13.sp,
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
        SizedBox(height: 14.h),
        Text(
          'No activities scheduled today.',
          style: GoogleFonts.poppins(
              fontSize: 13.sp, color: const Color(0xFF9CA3AF)),
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
        SizedBox(height: 6.h),
        Text(
          completed == total
              ? 'All done for today!'
              : '${total - completed} ${total - completed == 1 ? 'task' : 'tasks'} remaining',
          style: GoogleFonts.poppins(
              fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
        ),
        SizedBox(height: 10.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFF3F4F6),
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            minHeight: 6.h,
          ),
        ),
        SizedBox(height: 14.h),
        ...preview.map((task) => _TaskCard(task: task)),
        if (remaining > 0)
          GestureDetector(
            onTap: onSeeAll,
            child: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+ $remaining more ${remaining == 1 ? 'task' : 'tasks'}',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11.sp,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(label: "Today's Activities", trailing: ''),
        SizedBox(height: 14.h),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const CircularProgressIndicator(strokeWidth: 2.5),
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
            fontSize: 16.sp,
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
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12.sp,
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
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF1F2937),
  );
  static final _titleDoneStyle = GoogleFonts.poppins(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF9CA3AF),
    decoration: TextDecoration.lineThrough,
    decorationColor: const Color(0xFF9CA3AF),
  );
  static final _subStyle = GoogleFonts.poppins(
    fontSize: 12.sp,
    color: const Color(0xFF6B7280),
  );
  static final _overdueSub = GoogleFonts.poppins(
    fontSize: 12.sp,
    color: const Color(0xFFEF4444),
  );

  @override
  Widget build(BuildContext context) {
    final bool done = task.isCompleted;
    final bool overdue = task.isOverdue;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: overdue && !done
            ? const Color(0xFFFFF1F2)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16.r),
        border: overdue && !done
            ? Border.all(color: const Color(0xFFFECACA), width: 1.w)
            : null,
      ),
      child: Row(
        children: [
          // Completion indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? AppTheme.primaryColor : Colors.transparent,
              border: Border.all(
                color: done
                    ? AppTheme.primaryColor
                    : overdue
                        ? const Color(0xFFEF4444)
                        : const Color(0xFFD1D5DB),
                width: 1.5.w,
              ),
            ),
            child: done
                ? Icon(Icons.check_rounded,
                    size: 14.sp, color: Colors.white)
                : null,
          ),
          SizedBox(width: 12.w),

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
                SizedBox(height: 3.h),
                Row(
                  children: [
                    if (task.isGameTask) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          task.gameDisplayName,
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
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
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13.sp,
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
