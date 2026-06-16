import 'package:flutter/material.dart';
import 'package:patient/presentation/reports/widgets/report_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        SizedBox(height: 14.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _StatCard(
                  backgroundColor: const Color(0xFFE2FBF6),
                  icon: Icons.bar_chart_rounded,
                  iconColor: ReportColors.completedIcon,
                  iconBg: Colors.white,
                  value: totalReports.toString(),
                  label: 'Total Reports',
                  large: true,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  children: [
                    _StatCard(
                      backgroundColor: const Color(0xFFFFF1DD),
                      icon: Icons.calendar_today_rounded,
                      iconColor: ReportColors.missedIcon,
                      iconBg: Colors.white,
                      value: latestDate,
                      label: 'Latest',
                    ),
                    SizedBox(height: 12.h),
                    _StatCard(
                      backgroundColor: Color(0xFFFFE7EC),
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
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: large
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 22.sp),
                ),
                const Spacer(),
                Text(
                  value,
                  style: tt.displayMedium?.copyWith(fontSize: 36.sp),
                ),
                SizedBox(height: 2.h),
                Text(label, style: tt.bodyMedium),
              ],
            )
          : Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 18.sp),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        style: tt.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        label,
                        style: tt.bodyMedium?.copyWith(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
