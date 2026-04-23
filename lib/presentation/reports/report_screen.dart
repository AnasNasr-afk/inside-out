import 'package:flutter/material.dart';
import 'package:patient/presentation/reports/widgets/milestones_completion_banner.dart';
import 'package:patient/presentation/reports/widgets/milestones_details_section.dart';
import 'package:patient/presentation/reports/widgets/milstones_progress_section.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            MilestonesProgressSection(
              dateRange: 'Jun 1 – Jun 7',
              completed: 2000,
              missed: 10,
              late: 500,),
            SizedBox(height: 16),

            MilestonesCompletionBanner(
              completed: 12,
              total: 20,
            ),
            SizedBox(height: 28),
            // Widget 3 ── expandable details list
            MilestonesDetailsSection(),
          ],
        ),
      ),
    );
  }
}
