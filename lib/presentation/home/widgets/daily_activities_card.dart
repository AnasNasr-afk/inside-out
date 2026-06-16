import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/core/cubits/task_cubit/task_cubit.dart';
import 'package:patient/core/cubits/task_cubit/task_listener.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/models/task_model.dart';
import '../../../core/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DailyActivitiesPreviewCard extends StatelessWidget {
  final VoidCallback onSeeAll;

  const DailyActivitiesPreviewCard({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskStates>(
      builder: (context, state) {
        if (state is TaskLoadingState || state is TaskInitialState) {
          return _CardShell(child: _loadingBody());
        }
        if (state is TaskErrorState) {
          return _CardShell(child: _errorBody(context, state.message));
        }
        if (state is TaskSuccessState) {
          if (state.tasks.isEmpty) {
            return _CardShell(child: _emptyBody());
          }
          return _CardShell(
            child: _successBody(context, state.tasks),
          );
        }
        return _CardShell(child: _loadingBody());
      },
    );
  }

  Widget _loadingBody() {
    return SizedBox(
      height: 180.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Activities',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1F2937),
            ),
          ),
          Expanded(
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.5.w)),
          ),
        ],
      ),
    );
  }

  Widget _errorBody(BuildContext context, String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Activities',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 18.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
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

  Widget _emptyBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Activities',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'No activities scheduled today.',
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  Widget _successBody(BuildContext context, List<TaskModel> allTasks) {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Activities',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1F2937),
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: Row(
                children: [
                  Text(
                    '$completed/$total',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13.sp,
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          completed == total
              ? 'All done for today! 🎉'
              : '${total - completed} ${total - completed == 1 ? 'task' : 'tasks'} remaining today',
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9CA3AF),
          ),
        ),
        SizedBox(height: 12.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFF3F4F6),
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            minHeight: 7.h,
          ),
        ),
        SizedBox(height: 16.h),
        ...preview.map((task) => _TaskRow(task: task)),
        if (remaining > 0)
          GestureDetector(
            onTap: onSeeAll,
            child: Row(
              children: [
                SizedBox(width: 34.w),
                Text(
                  '+ $remaining more ${remaining == 1 ? 'task' : 'tasks'}',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11.sp,
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _TaskRow extends StatelessWidget {
  final TaskModel task;
  const _TaskRow({required this.task});

  @override
  Widget build(BuildContext context) {
    final bool done = task.isCompleted;
    return Padding(
      padding: EdgeInsets.only(bottom: 11.h),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22.w,
            height: 22.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? AppTheme.primaryColor : Colors.transparent,
              border: Border.all(
                color: done ? AppTheme.primaryColor : const Color(0xFFD1D5DB),
                width: 1.5.w,
              ),
            ),
            child: done
                ? Icon(Icons.check_rounded, size: 13.sp, color: Colors.white)
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: done
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF1F2937),
                decoration: done ? TextDecoration.lineThrough : null,
                decorationColor: const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
