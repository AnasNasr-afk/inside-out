import 'package:flutter/material.dart';
import 'package:patient/presentation/reports/widgets/report_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFF7E6B),
            Color(0xFFFF5B72),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$totalReports ${totalReports == 1 ? 'Report' : 'Reports'}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  childName.isNotEmpty
                      ? 'From Poly sessions\nwith $childName'
                      : 'From Poly sessions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    height: 1.4.h,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 72.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 36.sp,
            ),
          ),
        ],
      ),
    );
  }
}
