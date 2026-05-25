import 'package:flutter/material.dart';
import 'package:patient/core/models/task_model.dart';
import 'package:patient/presentation/tasks%20/widgets/detail_card.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key, required this.task});

  final TaskModel task;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  int? _moodBefore;
  int? _moodAfter;
  late bool _markedDone;

  final List<Map<String, dynamic>> _moods = const [
    {'emoji': '😢', 'label': 'Very sad'},
    {'emoji': '😕', 'label': 'Sad'},
    {'emoji': '😐', 'label': 'Okay'},
    {'emoji': '🙂', 'label': 'Happy'},
    {'emoji': '😄', 'label': 'Very happy'},
  ];

  @override
  void initState() {
    super.initState();
    _markedDone = widget.task.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final task = widget.task;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        title: Text(
          task.title,
          overflow: TextOverflow.ellipsis,
          style:
              theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFF3F4F6)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusPill(task: task),
                  const SizedBox(height: 16),
                  DetailCard(
                    title: 'What to do',
                    icon: Icons.task_alt_rounded,
                    iconColor: const Color(0xFF6366F1),
                    child: Text(
                      task.description.isEmpty
                          ? 'No description provided for this task.'
                          : task.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: const Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DetailCard(
                    title: 'Time & schedule',
                    icon: Icons.schedule_rounded,
                    iconColor: const Color(0xFF10B981),
                    child: Column(
                      children: [
                        _ScheduleRow(
                            label: 'Duration', value: task.plannedDaysLabel),
                        const SizedBox(height: 8),
                        _ScheduleRow(
                            label: 'Assigned',
                            value: task.formattedAssignedDate),
                        const SizedBox(height: 8),
                        _ScheduleRow(
                            label: 'Due', value: task.formattedDueDate),
                        if (task.isCompleted &&
                            task.completedAt != null) ...[
                          const SizedBox(height: 8),
                          _ScheduleRow(
                            label: 'Completed',
                            value: _formatDate(task.completedAt!),
                          ),
                        ],
                        if (task.isCompleted && task.actualDays > 0) ...[
                          const SizedBox(height: 8),
                          _ScheduleRow(
                            label: 'Took',
                            value:
                                '${task.actualDays.round()} ${task.actualDays.round() == 1 ? 'day' : 'days'}',
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  DetailCard(
                    title: 'Mood before task',
                    icon: Icons.mood_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    child: _MoodPicker(
                      moods: _moods,
                      selected: _moodBefore,
                      onSelect: (i) => setState(() => _moodBefore = i),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DetailCard(
                    title: 'Mood after task',
                    icon: Icons.mood_bad_rounded,
                    iconColor: const Color(0xFFEC4899),
                    child: _MoodPicker(
                      moods: _moods,
                      selected: _moodAfter,
                      onSelect: (i) => setState(() => _moodAfter = i),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _markedDone = !_markedDone),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _markedDone
                          ? const Color(0xFF10B981)
                          : const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (_markedDone
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF6366F1))
                              .withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _markedDone
                              ? Icons.check_circle_rounded
                              : Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _markedDone ? 'Completed ✓' : 'Mark as Done',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Text(
                      'Skip for today',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}

class _StatusPill extends StatelessWidget {
  final TaskModel task;
  const _StatusPill({required this.task});

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color fg;
    late final Color bg;
    late final IconData icon;

    if (!task.isCompleted) {
      label = 'Pending';
      fg = const Color(0xFFB45309);
      bg = const Color(0xFFFEF3C7);
      icon = Icons.hourglass_empty_rounded;
    } else if (task.isLate) {
      label = 'Completed late';
      fg = const Color(0xFFDC2626);
      bg = const Color(0xFFFFE4E4);
      icon = Icons.warning_amber_rounded;
    } else if (task.isEarly) {
      label = 'Completed early';
      fg = const Color(0xFF059669);
      bg = const Color(0xFFD1FAE5);
      icon = Icons.bolt_rounded;
    } else {
      label = 'Completed on time';
      fg = const Color(0xFF059669);
      bg = const Color(0xFFD1FAE5);
      icon = Icons.check_circle_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        const Text(' : ',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}

class _MoodPicker extends StatelessWidget {
  const _MoodPicker({
    required this.moods,
    required this.selected,
    required this.onSelect,
  });

  final List<Map<String, dynamic>> moods;
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(moods.length, (i) {
        final isSelected = selected == i;
        return GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : const Color(0xFFE5E7EB),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                moods[i]['emoji'],
                style: TextStyle(fontSize: isSelected ? 26 : 22),
              ),
            ),
          ),
        );
      }),
    );
  }
}
