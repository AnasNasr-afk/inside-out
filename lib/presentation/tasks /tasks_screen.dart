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
          const SizedBox(height: 20),
          BlocBuilder<TaskCubit, TaskStates>(
            builder: (context, state) {
              final cubit = TaskCubit.get(context);
              return ProgressBanner(
                totalTasks: cubit.totalTasks,
                completedTasks: cubit.completedTasks,
              );
            },
          ),
          const SizedBox(height: 20),
          _buildFilterChips(),
          const SizedBox(height: 16),
          Expanded(child: _buildTaskList()),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final active = _selectedFilter == _filters[i];
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = _filters[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: active ? const Color(0xFF6366F1) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: active
                    ? [BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]
                    : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
              ),
              child: Text(
                _filters[i],
                style: TextStyle(
                  fontSize: 13,
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
                const SizedBox(height: 12),
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => TaskCard(task: filtered[index]),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}