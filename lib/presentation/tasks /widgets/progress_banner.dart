import 'package:flutter/material.dart';

class ProgressBanner extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;

  const ProgressBanner({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
    totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Weekly Progress",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),

                  /// 🔥 dynamic text
                  Text(
                    "$completedTasks of $totalTasks tasks completed",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white24,
                      valueColor:
                      const AlwaysStoppedAnimation(Colors.white),
                      minHeight: 7,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            /// 🔥 percentage
            Text(
              "${(progress * 100).round()}%",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}