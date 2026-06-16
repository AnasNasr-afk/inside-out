import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 20.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: mission.color, width: 3.w),
        boxShadow: [
          BoxShadow(
            color: const Color(0x4D281959),
            blurRadius: 26.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon tile
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: mission.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(mission.icon, size: 22.sp, color: mission.deepColor),
          ),
          SizedBox(width: 12.w),

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
                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 11.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14B2A0),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_rounded,
                                size: 13.sp, color: Colors.white),
                            SizedBox(width: 4.w),
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
