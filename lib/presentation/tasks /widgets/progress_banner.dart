import 'package:flutter/material.dart';
import 'package:patient/core/theme/app_tokens.dart';

class ProgressBanner extends StatelessWidget {
  const ProgressBanner({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  final int totalTasks;
  final int completedTasks;

  @override
  Widget build(BuildContext context) {
    final percent = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
    final pctInt = (percent * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: T.primaryCta,
          image: const DecorationImage(
            image: AssetImage('assets/illustrations/tasksBackgroud.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Progress',
                    style: T.caption().copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$completedTasks of $totalTasks tasks completed',
                    style: T.sectionHeader().copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: percent,
                      backgroundColor: Colors.white.withValues(alpha: 0.22),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      minHeight: 7,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Text(
              '$pctInt%',
              style: T.bigNumeral().copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
