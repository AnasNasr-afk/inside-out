import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/cubits/task_cubit/task_cubit.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/presentation/tasks%20/widgets/progress_banner.dart';
import 'package:patient/presentation/tasks%20/widgets/task_card.dart';
import 'package:patient/presentation/tasks%20/widgets/task_header.dart';

import '../../core/cubits/task_cubit/task_listener.dart';
import '../../core/models/task_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    switch (_selectedFilter) {
      case 'Pending':
        return tasks.where((t) => !t.isCompleted).toList();
      case 'Completed':
        return tasks.where((t) => t.isCompleted).toList();
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final active = _selectedFilter == _filters[i];
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = _filters[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: active ? const Color(0xFF6366F1) : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: active
                    ? [BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 8.r, offset: const Offset(0, 4))]
                    : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6.r)],
              ),
              child: Text(
                _filters[i],
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : const Color(0xFF6B7280),
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
                Text(state.message, textAlign: TextAlign.center),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: _fetchTasks,
                  child: const Text('Retry'),
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
          return RefreshIndicator(
            onRefresh: () async => _fetchTasks(),
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 24.h),
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