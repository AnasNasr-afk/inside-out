import 'package:flutter/material.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/presentation/poly_missions/widgets/pm_mission.dart';

class PmOtherChip extends StatelessWidget {
  final PolyMission mission;

  const PmOtherChip({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.65,
      child: Container(
        padding: const EdgeInsets.fromLTRB(7, 5, 11, 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: mission.color.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(mission.icon, size: 13, color: Colors.white),
            ),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: Text(
                mission.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: T.navLabel().copyWith(
                  fontSize: 11.5,
                  color: Colors.white.withValues(alpha: 0.90),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
