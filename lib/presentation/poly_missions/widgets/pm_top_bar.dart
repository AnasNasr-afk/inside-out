import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/theme/app_tokens.dart';

class PmTopBar extends StatelessWidget {
  final int coins;
  final int doneCount;
  final int totalCount;
  final String language;
  final VoidCallback onToggleLanguage;

  const PmTopBar({
    super.key,
    required this.coins,
    required this.doneCount,
    required this.totalCount,
    required this.language,
    required this.onToggleLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, topInset + 12.h, 20.w, 0),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 26.sp,
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

          // Language toggle — occupies the slot that balances the back button.
          GestureDetector(
            onTap: onToggleLanguage,
            child: Container(
              width: 44.w,
              height: 44.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
              ),
              child: Text(
                language == 'ar' ? 'ع' : 'EN',
                style: T.badge().copyWith(
                  color: Colors.white,
                  fontSize: language == 'ar' ? 18.sp : 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: const Color(0xFFFFC93C), size: 17.sp),
          SizedBox(width: 6.w),
          Text(
            '$coins',
            style: T.badge().copyWith(
              fontSize: 14.sp,
              color: Colors.white,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 9.w),
            width: 1.w,
            height: 14.h,
            color: Colors.white.withValues(alpha: 0.30),
          ),
          Text(
            '$doneCount/$totalCount done',
            style: T.navLabel().copyWith(
              fontSize: 13.sp,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
