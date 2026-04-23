import 'package:flutter/material.dart';
import 'package:patient/presentation/reports/widgets/report_colors.dart';

class MilestonesDetailsSection extends StatefulWidget {
  const MilestonesDetailsSection({super.key});

  @override
  State<MilestonesDetailsSection> createState() =>
      _MilestoneDetailsSectionState();
}

class _MilestoneDetailsSectionState extends State<MilestonesDetailsSection> {
  // Which panel is open: null = all closed
  String? _openPanel;

  // Dummy milestone data — replace with real data from your provider
  final _completedItems = const ['Morning walk', 'Medication', 'Therapy session'];
  final _missedItems = const ['Evening exercise'];
  final _lateItems = const ['Journal entry', 'Sleep on time'];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Milestones in Details',
          style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        _AccordionTile(
          title: 'Completed Milestones',
          items: _completedItems,
          dotColor: ReportColors.completedIcon,
          isOpen: _openPanel == 'completed',
          onTap: () => setState(() =>
          _openPanel = _openPanel == 'completed' ? null : 'completed'),
        ),
        const Divider(color: ReportColors.divider, height: 1),
        _AccordionTile(
          title: 'Missed Milestones',
          items: _missedItems,
          dotColor: ReportColors.missedIcon,
          isOpen: _openPanel == 'missed',
          onTap: () => setState(
                  () => _openPanel = _openPanel == 'missed' ? null : 'missed'),
        ),
        const Divider(color: ReportColors.divider, height: 1),
        _AccordionTile(
          title: 'Late Milestones',
          items: _lateItems,
          dotColor: ReportColors.lateIcon,
          isOpen: _openPanel == 'late',
          onTap: () => setState(
                  () => _openPanel = _openPanel == 'late' ? null : 'late'),
        ),
        const Divider(color: ReportColors.divider, height: 1),
      ],
    );
  }
}

// ── Single accordion tile ──────────────────────────────────
class _AccordionTile extends StatelessWidget {
  const _AccordionTile({
    required this.title,
    required this.items,
    required this.dotColor,
    required this.isOpen,
    required this.onTap,
  });

  final String title;
  final List<String> items;
  final Color dotColor;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              children: [
                Text(title, style: tt.bodyLarge),
                const Spacer(),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ),
        // Expandable content
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              children: items
                  .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(item, style: tt.bodyMedium),
                  ],
                ),
              ))
                  .toList(),
            ),
          ),
          crossFadeState: isOpen
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}