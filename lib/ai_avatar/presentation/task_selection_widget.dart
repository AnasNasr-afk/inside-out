import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patient/ai_avatar/providers/session_state_controller.dart';
import 'package:patient/ai_avatar/providers/tasks_provider.dart';
import 'package:patient/core/models/task_model.dart';

class TaskSelectionWidget extends ConsumerWidget {
  const TaskSelectionWidget({super.key, required this.childName});
  final String childName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final activeTasks = tasks.where((t) => !t.isCompleted).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              activeTasks.isEmpty
                  ? 'What would you like to talk about?'
                  : 'Which task do you need help with?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (activeTasks.isEmpty)
          _FreeFormButton(childName: childName)
        else ...[
          ...activeTasks.map((task) => _TaskButton(task: task, childName: childName)),
          const SizedBox(height: 4),
          _FreeFormButton(childName: childName),
        ],
      ],
    );
  }
}

class _TaskButton extends ConsumerWidget {
  const _TaskButton({required this.task, required this.childName});
  final TaskModel task;
  final String childName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Material(
        color: Colors.white.withValues(alpha: 0.93),
        borderRadius: BorderRadius.circular(16),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ref
                .read(sessionStateControllerProvider.notifier)
                .selectTask(task, childName: childName);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.assignment_outlined,
                    color: Colors.deepPurple, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      if (task.description.isNotEmpty)
                        Text(
                          task.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FreeFormButton extends ConsumerWidget {
  const _FreeFormButton({required this.childName});
  final String childName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Material(
        color: Colors.deepPurple.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(16),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            final freeFormTask = TaskModel(
              taskId: -1,
              title: 'Talk to Poly',
              description: '',
              assignedDate: DateTime.now(),
              dueDate: DateTime.now(),
              plannedDays: 0,
              actualDays: 0,
              isCompleted: false,
              punctualityStatus: 'Pending',
            );
            ref
                .read(sessionStateControllerProvider.notifier)
                .selectTask(freeFormTask, childName: childName);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, color: Colors.white, size: 22),
                SizedBox(width: 12),
                Text(
                  'Just talk to Poly',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
