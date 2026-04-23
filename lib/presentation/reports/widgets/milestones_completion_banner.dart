import 'dart:math';

import 'package:flutter/material.dart';
import 'package:patient/presentation/reports/widgets/report_colors.dart';

class MilestonesCompletionBanner extends StatelessWidget {
  const MilestonesCompletionBanner({
    super.key,
    required this.completed,
    required this.total,
  });

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final percent = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: ReportColors.salmon,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Left: fraction + label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$completed/$total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Milestones Completed\nSuccessfully',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // Right: circular progress
          _CircularProgress(percent: percent),
        ],
      ),
    );
  }
}

// ── Circular progress painter ──────────────────────────────
class _CircularProgress extends StatelessWidget {
  const _CircularProgress({required this.percent});
  final double percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: _CirclePainter(percent: percent),
        child: Center(
          child: Text(
            '${(percent * 100).round()}%',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  _CirclePainter({required this.percent});
  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - 5;
    const strokeWidth = 7.0;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);

    // Track
    canvas.drawArc(
      rect,
      0,
      2 * pi,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha:0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Fill
    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * percent,
      false,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter old) => old.percent != percent;
}