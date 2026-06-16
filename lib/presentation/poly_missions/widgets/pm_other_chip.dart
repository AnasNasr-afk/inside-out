import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: EdgeInsets.fromLTRB(7.w, 5.h, 11.w, 5.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: mission.color.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(mission.icon, size: 13.sp, color: Colors.white),
            ),
            SizedBox(width: 6.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.w),
              child: Text(
                mission.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: T.navLabel().copyWith(
                  fontSize: 11.5.sp,
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
