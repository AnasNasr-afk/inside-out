import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CareTeamCard extends StatelessWidget {
  const CareTeamCard({super.key,
    this.icon,
    this.iconAsset,
    required this.avatarColor,
    required this.iconColor,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.name,
    required this.detail,
    this.initials,
  });

  final IconData? icon;
  final String? iconAsset;
  final Color avatarColor;
  final Color iconColor;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;
  final String name;
  final String detail;
  final String? initials;

  Widget _buildAvatarContent() {
    if (initials != null) {
      return Center(
        child: Text(
          initials!,
          style: TextStyle(
            color: iconColor,
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
          ),
        ),
      );
    }
    if (iconAsset != null) {
      return Image.asset(
        iconAsset!,
        width: 40.w,
        height: 40.h,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.medical_services_rounded, color: iconColor, size: 20.sp),
      );
    }
    return Icon(icon, color: iconColor, size: 20.sp);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: avatarColor,
                  shape: BoxShape.circle,
                ),
                child: _buildAvatarContent(),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (detail.isNotEmpty)
            Text(
              detail,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: const Color(0xFF9CA3AF),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}