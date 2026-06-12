import 'package:flutter/material.dart';
import 'package:patient/presentation/reports/widgets/report_colors.dart';

class MilestonesCompletionBanner extends StatelessWidget {
  const MilestonesCompletionBanner({
    super.key,
    required this.totalReports,
    required this.childName,
  });

  final int totalReports;
  final String childName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: ReportColors.salmon,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$totalReports ${totalReports == 1 ? 'Report' : 'Reports'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  childName.isNotEmpty
                      ? 'From Poly sessions\nwith $childName'
                      : 'From Poly sessions',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}
