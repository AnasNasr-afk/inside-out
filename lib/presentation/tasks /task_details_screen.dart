import 'package:flutter/material.dart';
import 'package:patient/presentation/tasks%20/widgets/detail_card.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  int? _moodBefore;
  int? _moodAfter;
  bool _markedDone = false;

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😢', 'label': 'Very sad'},
    {'emoji': '😕', 'label': 'Sad'},
    {'emoji': '😐', 'label': 'Okay'},
    {'emoji': '🙂', 'label': 'Happy'},
    {'emoji': '😄', 'label': 'Very happy'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          'Greeting Practice',
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
                  DetailCard(
                    title: 'What to do',
                    icon: Icons.task_alt_rounded,
                    iconColor: const Color(0xFF6366F1),
                    child: Text(
                      'Child practices greeting a familiar person using eye contact and a verbal "hello" or wave.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: const Color(0xFF374151),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const DetailCard(
                    title: 'Steps',
                    icon: Icons.format_list_numbered_rounded,
                    iconColor: Color(0xFF3B82F6),
                    child: Column(
                      children: [
                        _StepItem(
                            number: 1,
                            text:
                                'Stand in front of the person and look at their face.'),
                        SizedBox(height: 8),
                        _StepItem(
                            number: 2, text: 'Say "Hello" or wave your hand.'),
                        SizedBox(height: 8),
                        _StepItem(
                            number: 3,
                            text: 'Wait for them to respond and smile back.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  DetailCard(
                    title: 'Time & schedule',
                    icon: Icons.schedule_rounded,
                    iconColor: const Color(0xFF10B981),
                    child: Column(
                      children: [
                        const _ScheduleRow(label: 'Duration', value: '20 min'),
                        const SizedBox(height: 8),
                        _ScheduleRow(
                          label: 'Days',
                          valueWidget: Row(
                            children: ['MON', 'TUE']
                                .map((d) => Container(
                                      margin: const EdgeInsets.only(right: 6),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEEF2FF),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: const Color(0xFFC7D2FE)),
                                      ),
                                      child: Text(d,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF4338CA),
                                          )),
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _ScheduleRow(
                            label: 'Best time',
                            value: 'Morning after breakfast'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Mood before ─────────────────────────────
                  DetailCard(
                    title: "Sara's Mood before task",
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
                    title: "Sara's Mood after task",
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

          // ── Bottom action bar ─────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Column(
              children: [
                // Mark as Done
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
                // Skip
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
}

// ─────────────────────────────────────────────
// Reusable sub-widgets
// ─────────────────────────────────────────────

class _StepItem extends StatelessWidget {
  const _StepItem({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.label, this.value, this.valueWidget});

  final String label;
  final String? value;
  final Widget? valueWidget;

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
        valueWidget ??
            Text(
              value ?? '',
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
