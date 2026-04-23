import 'package:flutter/material.dart';
import 'package:patient/presentation/tasks%20/widgets/progress_banner.dart';
import 'package:patient/presentation/tasks%20/widgets/task_header.dart';

import '../../core/theme/theme.dart';
import '../../model/task_model.dart';
import '../../routing/routes.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Task> tasks = [
    Task(
      title: "Say the word: Mama",
      date: "Jun 3",
      completed: false,
      duration: "15 min",
    ),
    Task(
      title: "Brush Teeth",
      date: "Jun 1",
      completed: true,
      duration: "5 min",
    ),
    Task(
      title: "Morning Stretch",
      date: "Jun 2",
      completed: true,
      duration: "10 min",
    ),
    Task(
      title: "Social Scenario Practice",
      date: "Jun 4",
      completed: false,
      duration: "20 min",
    ),
    Task(
      title: "Identify Emotion",
      date: "Jun 5",
      completed: false,
      duration: "15 min",
    ),
  ];

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'Completed'];

  List<Task> get _filteredTasks {
    if (_selectedFilter == 'Pending') {
      return tasks.where((t) => !t.completed).toList();
    }
    if (_selectedFilter == 'Completed') {
      return tasks.where((t) => t.completed).toList();
    }
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

         const ProgressBanner(),

          const SizedBox(height: 20),

          // ── Filter chips ─────────────────────────────────
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFF6366F1) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                  color: const Color(0xFF6366F1)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4))
                            ]
                          : [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6)
                            ],
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

          // ── Task list ────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: _filteredTasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _TaskCard(task: _filteredTasks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Task Card — large, match-card style
// ═══════════════════════════════════════════════════════════
class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.taskDetailsScreen);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: task.completed
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
            // ── Top row ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  // Title + assigned by
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.completed
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: task.completed
                          ? const Color(0xFFD1FAE5)
                          : const Color(0xFFFEF3C7).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task.completed ? "Done" : "Pending",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: task.completed
                            ? const Color(0xFF059669)
                            : AppTheme.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Divider ───────────────────────────────────────
            const Divider(height: 1, color: Color(0xFFF3F4F6)),

            // ── Bottom meta row ───────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Duration
                  Row(
                    children: [
                      Icon(Icons.timer_rounded,
                          size: 14, color: theme.textTheme.bodyMedium?.color),
                      const SizedBox(width: 4),
                      Text(
                        task.duration,
                        style:
                            theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Date + arrow
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 13, color: theme.textTheme.bodyMedium?.color),
                      const SizedBox(width: 4),
                      Text(
                        task.date,
                        style:
                            theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Mon,Tue",
                        style:
                            theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),

                      // Container(
                      //   width: 28,
                      //   height: 28,
                      //   decoration: BoxDecoration(
                      //     color: const Color(0xFFF3F4F6),
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      //   child: const Icon(Icons.arrow_forward_ios_rounded,
                      //       size: 13, color: Color(0xFF6B7280)),
                      // ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Completed progress strip (only when done) ─────
            if (task.completed)
              Container(
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
