import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/cubits/task_cubit/task_cubit.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/presentation/tasks%20/widgets/progress_banner.dart';
import 'package:patient/presentation/tasks%20/widgets/task_card.dart';
import 'package:patient/presentation/tasks%20/widgets/task_header.dart';

import '../../core/cubits/task_cubit/task_listener.dart';
import '../../core/models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // ── State ──────────────────────────────────────────────
  String _selectedFilter = 'All';
  int? _childId;
  bool _childIdLoaded = false;

  final List<String> _filters = ['All', 'Pending', 'Completed'];

  // ── Lifecycle ──────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadChildIdAndFetch();
  }

  void _loadChildIdAndFetch() {
    final stored = SharedPrefHelper.getInt(SharedPrefKeys.childId);

    if (stored == 0) {
      debugPrint('⚠️ TasksScreen: childId not found in SharedPreferences');
      setState(() => _childIdLoaded = true);
      return;
    }

    _childId = stored;
    setState(() => _childIdLoaded = true);
    _fetchTasks();
  }

  void _fetchTasks() {
    if (_childId == null) return;
    TaskCubit.get(context).getTasks(_childId!);
  }

  List<TaskModel> _filterTasks(List<TaskModel> tasks) {
    final visible = tasks.where((t) => !t.isHidden && !t.isOverdue).toList();
    switch (_selectedFilter) {
      case 'Pending':
        return visible.where((t) => !t.isCompleted).toList();
      case 'Completed':
        return visible.where((t) => t.isCompleted).toList();
      default:
        return visible;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: T.appBg,
      child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TaskHeader(),
          SizedBox(height: 20.h),
          BlocBuilder<TaskCubit, TaskStates>(
            builder: (context, state) {
              final cubit = TaskCubit.get(context);
              return ProgressBanner(
                totalTasks: cubit.totalTasks,
                completedTasks: cubit.completedTasks,
              );
            },
          ),
          SizedBox(height: 20.h),
          _buildFilterChips(),
          SizedBox(height: 16.h),
          Expanded(child: _buildTaskList()),
        ],
      ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final active = _selectedFilter == _filters[i];
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = _filters[i]),
            child: AnimatedContainer(
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: active ? T.primary : T.card,
                borderRadius: BorderRadius.circular(999.r),
                border: active ? null : Border.all(color: T.border),
                boxShadow: active
                    ? [BoxShadow(
                        color: T.primary.withValues(alpha: 0.28),
                        blurRadius: 8.r,
                        offset: Offset(0, 4.h),
                      )]
                    : null,
              ),
              child: Text(
                _filters[i],
                style: T.badge().copyWith(
                  fontSize: 14.sp,
                  color: active ? Colors.white : T.muted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskList() {
    if (!_childIdLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_childId == null) {
      return const Center(
        child: Text(
          'Could not load tasks.\nPlease log in again.',
          textAlign: TextAlign.center,

        ),
      );
    }

    return BlocBuilder<TaskCubit, TaskStates>(
      builder: (context, state) {
        if (state is TaskLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TaskErrorState) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    state.message,
                    style: T.body().copyWith(
                      color: T.muted,
                      fontSize: 18.sp,
                    ),
                    textAlign: TextAlign.center),
                SizedBox(height: 12.h),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: T.primary,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  onPressed: _fetchTasks,
                  child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white)
                  ),
                ),
              ],
            ),
          );
        }

        if (state is TaskSuccessState) {
          final filtered = _filterTasks(state.tasks);
          if (filtered.isEmpty) {
            return const Center(child: Text('No tasks found.'));
          }
          final navBottom = MediaQuery.of(context).padding.bottom + 96.h;
          return RefreshIndicator(
            onRefresh: () async => _fetchTasks(),
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, navBottom),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) => TaskCard(task: filtered[index]),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}