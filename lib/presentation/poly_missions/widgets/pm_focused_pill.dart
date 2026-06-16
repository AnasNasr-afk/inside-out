import 'package:flutter/material.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/presentation/poly_missions/widgets/pm_mission.dart';

class PmFocusedPill extends StatelessWidget {
  final PolyMission mission;
  final bool showDone;

  const PmFocusedPill({
    super.key,
    required this.mission,
    required this.showDone,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.fromLTRB(14, 14, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: mission.color, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D281959),
            blurRadius: 26,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon tile
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: mission.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(mission.icon, size: 22, color: mission.deepColor),
          ),
          const SizedBox(width: 12),

          // Label — Flexible so long backend titles don't overflow the pill.
          Flexible(
            child: Text(
              mission.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: T.sectionHeader().copyWith(
                color: const Color(0xFF2B2360),
                letterSpacing: -0.3,
              ),
            ),
          ),

          // Done chip — slides in on response
          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeInOut,
            child: showDone
                ? Row(
                    children: [
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14B2A0),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_rounded,
                                size: 13, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'Done',
                              style: T.badge().copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
