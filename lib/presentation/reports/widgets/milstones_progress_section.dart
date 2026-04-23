import 'package:flutter/material.dart';
import 'package:patient/presentation/reports/widgets/report_colors.dart';

class MilestonesProgressSection extends StatelessWidget {
  const MilestonesProgressSection({
    super.key,
    required this.dateRange,
    required this.completed,
    required this.missed,
    required this.late,
  });

  final String dateRange;
  final int completed;
  final int missed;
  final int late;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section heading
        Row(
          children: [
            Text(
              'Milestones Progress',
              style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 8),
            Text(
              '($dateRange)',
              style: tt.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Card grid: big Completed card on left, Missed + Late stacked on right
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Completed — tall card
              Expanded(
                child: _StatCard(
                  backgroundColor: ReportColors.completedBg,
                  icon: Icons.local_fire_department_rounded,
                  iconColor: ReportColors.completedIcon,
                  iconBg: Colors.white,
                  value: _formatNumber(completed),
                  label: 'Completed',
                  large: true,
                ),
              ),
              const SizedBox(width: 12),
              // Missed + Late stacked
              Expanded(
                child: Column(
                  children: [
                    _StatCard(
                      backgroundColor: ReportColors.missedBg,
                      icon: Icons.local_cafe_rounded,
                      iconColor: ReportColors.missedIcon,
                      iconBg: Colors.white,
                      value: _formatNumber(missed),
                      label: 'Missed',
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      backgroundColor: ReportColors.lateBg,
                      icon: Icons.directions_run_rounded,
                      iconColor: ReportColors.lateIcon,
                      iconBg: Colors.white,
                      value: _formatNumber(late),
                      label: 'Late',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatNumber(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(0)},000' : n.toString();
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
    this.large = false,
  });

  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: large
      // Tall layout: icon top, numbers bottom
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const Spacer(),
          Text(
            value,
            style: tt.displayMedium?.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 2),
          Text(label, style: tt.bodyMedium),
        ],
      )
      // Compact layout: icon + text in a row
          : Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: tt.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              Text(label, style: tt.bodyMedium?.copyWith(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}