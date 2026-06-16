import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/presentation/child_mood/poly_world_transition.dart';

class ChildModeButton extends StatelessWidget {
  const ChildModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = SharedPrefHelper.getString('userId');
    final frontendId = SharedPrefHelper.getInt('frontendId');
    final rawName = SharedPrefHelper.getString(SharedPrefKeys.childName);
    final childName = rawName.split(' ').first.toUpperCase();

    return GestureDetector(
      onTap: () {
        if (userId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in again.')),
          );
          return;
        }
        PolyWorldTransition.show(
          context,
          childName: childName.isNotEmpty ? childName : 'FRIEND',
          frontendId: frontendId.toString(),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: T.card,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: T.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: T.primary.withValues(alpha: 0.45),
                    blurRadius: 20.r,
                    spreadRadius: 2.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/illustrations/childModeIcon.png',
                width: 52.w,
                height: 52.h,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Child Mode',
                    style: T.cardTitle().copyWith(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: T.ink,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'A calmer, simpler space for kids',
                    style: T.caption().copyWith(
                        color: T.muted,
                        fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
