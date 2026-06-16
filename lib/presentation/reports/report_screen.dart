import 'package:flutter/material.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/models/responses/child_report_model.dart';
import 'package:patient/core/networking/repositories/assessment_repo.dart';
import 'package:patient/presentation/reports/widgets/milestones_completion_banner.dart';
import 'package:patient/presentation/reports/widgets/milestones_details_section.dart';
import 'package:patient/presentation/reports/widgets/milstones_progress_section.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<ChildReportEntry>? _reports;
  bool _initialLoading = true;
  bool _isFallback = false;

  @override
  void initState() {
    super.initState();
    _loadReports(initial: true);
  }

  Future<void> _loadReports({bool initial = false}) async {
    final childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);

    final (:reports, :isFallback) = childId > 0
        ? await AssessmentRepository().getChildReports(childId)
        : (reports: ChildReportEntry.fallback(), isFallback: true);

    reports.sort((a, b) => b.assignedDate.compareTo(a.assignedDate));

    if (mounted) {
      setState(() {
        _reports = reports;
        _isFallback = isFallback;
        if (initial) _initialLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        centerTitle: true,
      ),
      body: _initialLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _loadReports(),
              child: _buildContent(_reports!),
            ),
    );
  }

  Widget _buildContent(List<ChildReportEntry> reports) {
    final childName = SharedPrefHelper.getString(SharedPrefKeys.childName);
    final latestDate = reports.isNotEmpty ? reports.first.formattedDate : '—';
    final specialist = reports.isNotEmpty ? reports.first.studentName : '—';

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isFallback)
            Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFFFD54F)),
              ),
              child: Row(
                children: [
                  Icon(Icons.wifi_off_rounded, size: 16.sp, color: Color(0xFF795548)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Could not load — showing sample data',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Color(0xFF795548),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          MilestonesProgressSection(
            totalReports: reports.length,
            latestDate: latestDate,
            specialistName: specialist,
          ),
          SizedBox(height: 16.h),
          MilestonesCompletionBanner(
            totalReports: reports.length,
            childName: childName,
          ),
          SizedBox(height: 28.h),
          MilestonesDetailsSection(reports: reports),
        ],
      ),
    );
  }
}
