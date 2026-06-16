import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/responses/parent_child_response_model.dart';

class ChildCard extends StatelessWidget {
  const ChildCard({super.key, required this.userData});

  final ParentChildResponseModel? userData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE2FBF6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mood_rounded,
                    color: const Color(0xFF3B6D11),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData?.childName ?? 'Child Name',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${userData?.age ?? 0} years old',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2FBF6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Child',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B6D11),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (userData?.description.isNotEmpty == true)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(16.r)),
                border: Border(
                    top: BorderSide(
                        color: const Color(0xFFE5E7EB), width: 0.5.w)),
              ),
              child: Row(
                children: [
                  Icon(Icons.psychology_outlined,
                      size: 14.sp, color: const Color(0xFF9CA3AF)),
                  SizedBox(width: 6.w),
                  Text(
                    'Case: ',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      userData?.description ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF374151),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
