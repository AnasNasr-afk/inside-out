import 'package:flutter/material.dart';
import 'package:patient/core/theme/app_tokens.dart';

class PmTopBar extends StatelessWidget {
  final int coins;
  final int doneCount;
  final int totalCount;

  const PmTopBar({
    super.key,
    required this.coins,
    required this.doneCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, topInset + 12, 20, 0),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),

          // Progress chip — centered between the two 44px sides
          Expanded(
            child: Center(
              child: _ProgressChip(
                coins: coins,
                doneCount: doneCount,
                totalCount: totalCount,
              ),
            ),
          ),

          // Spacer to balance the back button width
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}

class _ProgressChip extends StatelessWidget {
  final int coins;
  final int doneCount;
  final int totalCount;

  const _ProgressChip({
    required this.coins,
    required this.doneCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFC93C), size: 17),
          const SizedBox(width: 6),
          Text(
            '$coins',
            style: T.badge().copyWith(
              fontSize: 14,
              color: Colors.white,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 9),
            width: 1,
            height: 14,
            color: Colors.white.withValues(alpha: 0.30),
          ),
          Text(
            '$doneCount/$totalCount done',
            style: T.navLabel().copyWith(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
