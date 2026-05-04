import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/businessLogic/task_cubit/task_cubit.dart';
import 'package:patient/presentation/tasks%20/widgets/progress_banner.dart';
import 'package:patient/presentation/tasks%20/widgets/task_card.dart';
import 'package:patient/presentation/tasks%20/widgets/task_header.dart';
import '../../core/businessLogic/task_cubit/task_listener.dart';
import '../../model/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'Completed'];

  @override
  void initState() {
    super.initState();
    TaskCubit.get(context).getTasks(1);
  }

  List<TaskModel> _filterTasks(List<TaskModel> tasks) {
    if (_selectedFilter == 'Pending') return tasks.where((t) => !t.isCompleted).toList();
    if (_selectedFilter == 'Completed') return tasks.where((t) => t.isCompleted).toList();
    return tasks;
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
              if (state is TaskSuccessState) {
                final total = state.tasks.length;
                final completed =
                    state.tasks.where((t) => t.isCompleted).length;

                return ProgressBanner(
                  totalTasks: total,
                  completedTasks: completed,
                );
              }

              return const ProgressBanner(
                totalTasks: 0,
                completedTasks: 0,
              );
            },
          ),
          const SizedBox(height: 20),

          // ── Filter chips ──────────────────────────────
          SizedBox(
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
          ),

          const SizedBox(height: 16),

          // ── Task list ─────────────────────────────────
          Expanded(
            child: BlocBuilder<TaskCubit, TaskStates>(
              builder: (context, state) {
                if (state is TaskLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TaskErrorState) {
                  return Center(child: Text(state.message));
                }

                if (state is TaskSuccessState) {
                  final filtered = _filterTasks(state.tasks);
                  if (filtered.isEmpty) {
                    return const Center(child: Text('No tasks found.'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return TaskCard(task: filtered[index]);
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}