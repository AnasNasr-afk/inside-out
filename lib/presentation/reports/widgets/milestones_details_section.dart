import 'package:flutter/material.dart';
import 'package:patient/core/models/responses/child_report_model.dart';
import 'package:patient/presentation/reports/widgets/report_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MilestonesDetailsSection extends StatefulWidget {
  const MilestonesDetailsSection({super.key, required this.reports});

  final List<ChildReportEntry> reports;

  @override
  State<MilestonesDetailsSection> createState() =>
      _MilestoneDetailsSectionState();
}

class _MilestoneDetailsSectionState extends State<MilestonesDetailsSection> {
  int? _openIndex;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    if (widget.reports.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h),
          child: Text(
            'No reports yet',
            style: tt.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Reports',
          style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 12.h),
        ...List.generate(widget.reports.length, (i) {
          final entry = widget.reports[i];
          return Column(
            children: [
              _ReportTile(
                date: entry.formattedDate,
                specialist: entry.studentName,
                content: entry.content,
                isOpen: _openIndex == i,
                onTap: () =>
                    setState(() => _openIndex = _openIndex == i ? null : i),
              ),
              Divider(color: ReportColors.divider, height: 1.h),
            ],
          );
        }),
      ],
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({
    required this.date,
    required this.specialist,
    required this.content,
    required this.isOpen,
    required this.onTap,
  });

  final String date;
  final String specialist;
  final String content;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.h,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: const BoxDecoration(
                    color: ReportColors.completedIcon,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(date, style: tt.bodyLarge),
                      if (specialist.isNotEmpty)
                        Text(
                          specialist,
                          style: tt.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: EdgeInsets.only(bottom: 16.h, left: 20.w),
            child: Text(
              content,
              style: tt.bodyMedium?.copyWith(
                color: const Color(0xFF374151),
                height: 1.6.h,
              ),
            ),
          ),
          crossFadeState:
              isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}
