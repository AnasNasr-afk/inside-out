import 'package:flutter/material.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/core/utils/api_status_enum.dart';
import 'package:patient/presentation/reports/widgets/expandable_section.dart';
import 'package:patient/presentation/reports/widgets/progress_summary.dart';
import 'package:patient/presentation/reports/widgets/milestone_cards.dart';
import 'package:patient/presentation/reports/widgets/milestone_list_item.dart';
import 'package:patient/provider/reports_provider.dart';
import 'package:provider/provider.dart';

import '../../gen/assets.gen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ReportsProvider>(context, listen: false).getReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Access the provider
    final reportsProvider = Provider.of<ReportsProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(child: Consumer(
        builder: (context, value, child) {
          if(reportsProvider.apiStatus == ApiStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if(reportsProvider.apiStatus == ApiStatus.failure) {
            return const Center(child: Text('Error loading reports'));
          }
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reports',
                            style: theme.textTheme.displayMedium,
                          ),
                          // on click of this icon show a month picker
                          GestureDetector(
                            onTap: () async {
                              void setSelectedDate(DateTime date) {
                                context
                                    .read<ReportsProvider>()
                                    .setSelectedDate(date);
                              }

                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2025),
                                lastDate: DateTime(2026),
                              );
                              if (date != null) {
                                setSelectedDate(date);
                              }
                            },
                            child: Assets.icons.icCalendar.svg(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Milestones Progress Section
                      Row(
                        children: [
                          Text(
                            'Milestones Progress',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),

                          /// It shoud be display the name of month

                          Text(
                            '( 1 ${_months[reportsProvider.selectedDate.month - 1]} - ${reportsProvider.selectedDate.day} ${_months[reportsProvider.selectedDate.month - 1]})',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Milestone Cards - Using provider data
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left column - Completed card
                          CompletedMilestoneCard(
                            cardType: MilestoneCardType.completed,
                            iconColor: const Color(0xff36662C),
                            backgroundColor: const Color(0xFFF5FAF4),
                            value: 'Completed',
                            label: reportsProvider.completedActivities.length
                                .toString(),
                          ),
                          // Right column - Missed and Regressed cards stacked
                          Column(
                            children: [
                              HorizontalMilestoneCard(
                                type: MilestoneCardType.missed,
                                iconColor: const Color(0xffFFA400),
                                backgroundColor: const Color(0xFFFFF2E0),
                                value: reportsProvider
                                    .incompleteActivities.length
                                    .toString(),
                                label: 'Missed',
                              ),
                              const SizedBox(height: 12),
                              HorizontalMilestoneCard(
                                type: MilestoneCardType.regressed,
                                iconColor: const Color(0xffFF0000),
                                backgroundColor: const Color(0xFFFFE0E0),
                                value: reportsProvider.regressions.length
                                    .toString(),
                                label: 'Regressed',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Progress Card - Using provider data
                      MilestoneProgressCard(
                        value:
                            '${reportsProvider.completedActivities.length}/${reportsProvider.incompleteActivities.length + reportsProvider.completedActivities.length}',
                        label: 'Milestones Completed Successfully',
                        percentage: reportsProvider.completedActivities.isEmpty ? 0 : (reportsProvider.completedActivities.length / (reportsProvider.incompleteActivities.length + reportsProvider.completedActivities.length) * 100).toInt(),
                        height: 138.0,
                      ),
                      const SizedBox(height: 24),

                      // Milestones in Details Section
                      Text(
                        'Milestones in Details',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      ExpandableSection(
                          title: 'Completed',
                          children: reportsProvider.completedActivities
                              .map((activity) => MilestoneListItem(
                                  title: activity, description: ''))
                              .toList()),
                      ExpandableSection(
                          title: 'Incomplete',
                          children: reportsProvider.incompleteActivities
                              .map((activity) => MilestoneListItem(
                                  title: activity, description: ''))
                              .toList()),
                      ExpandableSection(
                          title: 'Regressed',
                          children: reportsProvider.regressions
                              .map((activity) => MilestoneListItem(
                                  title: activity, description: ''))
                              .toList()),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      )),
    );
  }
}
