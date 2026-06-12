import 'package:flutter/material.dart';
import 'package:patient/presentation/reports/widgets/report_colors.dart';

class MilestonesProgressSection extends StatelessWidget {
  const MilestonesProgressSection({
    super.key,
    required this.totalReports,
    required this.latestDate,
    required this.specialistName,
  });

  final int totalReports;
  final String latestDate;
  final String specialistName;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Overview',
          style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _StatCard(
                  backgroundColor: ReportColors.completedBg,
                  icon: Icons.bar_chart_rounded,
                  iconColor: ReportColors.completedIcon,
                  iconBg: Colors.white,
                  value: totalReports.toString(),
                  label: 'Total Reports',
                  large: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _StatCard(
                      backgroundColor: ReportColors.missedBg,
                      icon: Icons.calendar_today_rounded,
                      iconColor: ReportColors.missedIcon,
                      iconBg: Colors.white,
                      value: latestDate,
                      label: 'Latest',
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      backgroundColor: ReportColors.lateBg,
                      icon: Icons.person_rounded,
                      iconColor: ReportColors.lateIcon,
                      iconBg: Colors.white,
                      value: specialistName.isNotEmpty ? specialistName : '—',
                      label: 'Specialist',
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
                  style: tt.displayMedium?.copyWith(fontSize: 36),
                ),
                const SizedBox(height: 2),
                Text(label, style: tt.bodyMedium),
              ],
            )
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        style: tt.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        label,
                        style: tt.bodyMedium?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
