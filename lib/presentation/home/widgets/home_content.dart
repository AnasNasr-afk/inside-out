import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/cubits/task_cubit/task_cubit.dart';
import 'package:patient/core/cubits/task_cubit/task_listener.dart';
import 'package:patient/core/models/task_model.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/gen/assets.gen.dart';
import 'package:patient/presentation/home/widgets/mood_check_in_card.dart';
import 'package:patient/presentation/home/widgets/child_mode_button.dart';

import 'home_header.dart';

class HomeContent extends StatelessWidget {
  final VoidCallback onSeeAllTasks;
  final VoidCallback onAvatarTap;
  final VoidCallback onChatTap;
  const HomeContent({super.key, required this.onSeeAllTasks, required this.onAvatarTap, required this.onChatTap});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskStates>(
      builder: (context, state) {
        final cubit = TaskCubit.get(context);
        final userData = cubit.parentChildData;

        final displayName = userData?.parentName.isNotEmpty == true
            ? userData!.parentName.split(' ').first
            : 'Parent';
        final displayChild = userData?.childName.isNotEmpty == true
            ? userData!.childName
            : 'Your Child';
        final parentInitial =
            displayName.isNotEmpty ? displayName[0].toUpperCase() : 'P';

        final tasks =
            state is TaskSuccessState ? state.tasks : <TaskModel>[];

        return ColoredBox(
          color: T.appBg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeHeader(
                greeting: _greeting,
                displayName: displayName,
                parentInitial: parentInitial,
                onAvatarTap: onAvatarTap,
                onChatTap: onChatTap,
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    20.w, 0, 20.w,
                    MediaQuery.of(context).padding.bottom + 90.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MoodCheckInCard(childName: displayChild),
                      SizedBox(height: 20.h),
                      const ChildModeButton(),
                      SizedBox(height: 20.h),
                      _HomeSectionHeader(
                        label: 'Upcoming tasks',
                        onSeeAll: onSeeAllTasks,
                      ),
                      SizedBox(height: 12.h),
                      _HomeTasksList(tasks: tasks),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}





class _HomeSectionHeader extends StatelessWidget {
  const _HomeSectionHeader({required this.label, required this.onSeeAll});
  final String label;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: T.sectionHeader()),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            'See all',
            style: T.caption().copyWith(
              color: T.primary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Upcoming tasks ─────────────────────────────────────────────────────────────

class _HomeTasksList extends StatelessWidget {
  const _HomeTasksList({required this.tasks});
  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Text('No tasks scheduled.',
          style: T.body().copyWith(color: T.muted));
    }
    final sorted = tasks.where((t) => !t.isHidden && !t.isOverdue).toList()
      ..sort((a, b) {
        if (a.isCompleted == b.isCompleted) return 0;
        return a.isCompleted ? 1 : -1;
      });
    return Column(
      children: sorted.take(3).map((t) => _HomeTaskRow(task: t)).toList(),
    );
  }
}

class _HomeTaskRow extends StatelessWidget {
  const _HomeTaskRow({required this.task});
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: T.card,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: T.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: T.cardTitle().copyWith(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: T.muted,
                    color: task.isCompleted ? T.muted : T.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h),
                Text(
                  task.timeLabel,
                  style: T.caption().copyWith(
                    fontSize: 12.sp,
                    color: task.isCompleted
                        ? T.mintDeep
                        : task.isOverdue
                            ? T.coral
                            : T.muted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Circle right
          if (task.isCompleted)
            Container(
              width: 30.w,
              height: 30.h,
              decoration: const BoxDecoration(
                color: T.mint,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_rounded,
                  size: 16.sp, color: Colors.white),
            )
          else
            Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isOverdue
                      ? T.coral.withValues(alpha: 0.5)
                      : const Color(0xFFCCCCCC),
                  width: 1.5.w,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
