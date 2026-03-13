import 'package:flutter/material.dart';
import 'package:patient/presentation/reports/widgets/custom_circular_progress_indicator.dart';

class MilestoneProgressCard extends StatelessWidget {
  final String value;
  final String label;
  final int percentage;
  final double height;

  const MilestoneProgressCard({
    super.key,
    required this.value,
    required this.label,
    required this.percentage,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 30,
      ),
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF8A07A),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          CustomCircularProgressIndicator(
            percentage: percentage,
            size: 80, // Increased size
            strokeWidth: 8, // Increased stroke width
          ),
        ],
      ),
    );
  }
}
