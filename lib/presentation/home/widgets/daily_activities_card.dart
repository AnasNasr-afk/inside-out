import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/theme.dart';

class DailyActivitiesPreviewCard extends StatefulWidget {
  final VoidCallback onSeeAll;

  const DailyActivitiesPreviewCard({super.key, required this.onSeeAll});

  @override
  State<DailyActivitiesPreviewCard> createState() =>
      _DailyActivitiesPreviewCardState();
}

class _DailyActivitiesPreviewCardState
    extends State<DailyActivitiesPreviewCard> {
  // TODO: replace with real data from provider
  final List<Map<String, dynamic>> _tasks = [
    {'name': 'Brush Teeth',       'isCompleted': true},
    {'name': 'Morning Stretches', 'isCompleted': true},
    {'name': 'Have Breakfast',    'isCompleted': false},
    {'name': 'Speech Exercise',   'isCompleted': false},
    {'name': 'Reading Time',      'isCompleted': false},
    {'name': 'Puzzle Activity',   'isCompleted': false},
  ];

  void _toggleTask(int index) {
    setState(() => _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted']);
  }

  @override
  Widget build(BuildContext context) {
    final int completedCount = _tasks.where((t) => t['isCompleted']).length;
    final int totalCount = _tasks.length;
    final double progress = totalCount == 0 ? 0 : completedCount / totalCount;

    // show only first 3, rest counted as remaining
    final previewTasks = _tasks.take(3).toList();
    final int remaining = totalCount - 3;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Activities',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2937),
                ),
              ),
              GestureDetector(
                onTap: widget.onSeeAll,
                child: Row(
                  children: [
                    Text(
                      '$completedCount/$totalCount',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ── Subtitle ─────────────────────────────────────────────────────
          Text(
            completedCount == totalCount && totalCount > 0
                ? 'All done for today! 🎉'
                : '${ totalCount - completedCount} tasks remaining today',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9CA3AF),
            ),
          ),

          const SizedBox(height: 12),

          // ── Progress Bar ─────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor:
              const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              minHeight: 7,
            ),
          ),

          const SizedBox(height: 16),

          // ── Task Previews ────────────────────────────────────────────────
          ...List.generate(previewTasks.length, (i) {
            final task = previewTasks[i];
            final bool done = task['isCompleted'];

            return Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: Row(
                children: [
                  // Tap to toggle
                  GestureDetector(
                    onTap: () => _toggleTask(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        border: Border.all(
                          color: done
                              ? AppTheme.primaryColor
                              : const Color(0xFFD1D5DB),
                          width: 1.5,
                        ),
                      ),
                      child: done
                          ? const Icon(Icons.check_rounded,
                          size: 13, color: Colors.white)
                          : null,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Task name
                  Expanded(
                    child: Text(
                      task['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: done
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF1F2937),
                        decoration:
                        done ? TextDecoration.lineThrough : null,
                        decorationColor: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // ── Remaining count ──────────────────────────────────────────────
          if (remaining > 0)
            GestureDetector(
              onTap: widget.onSeeAll,
              child: Row(
                children: [
                  const SizedBox(width: 34), // align with task text
                  Text(
                    '+ $remaining more tasks',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}