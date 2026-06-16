import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/theme/app_tokens.dart';

class MenuItem extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;
  final bool isDestructive;

  const MenuItem({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = isDestructive ? T.coral : const Color(0xFF1F2937);
    final chevronColor = isDestructive ? T.coral : const Color(0xFF9CA3AF);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 4.w,
            ),
            child: Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 40.w,
                  height: 40.h,
                  errorBuilder: (_, __, ___) => Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: isDestructive ? T.coralTint : T.primaryTint,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.circle_outlined,
                      size: 18.sp,
                      color: isDestructive ? T.coral : T.primary,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: chevronColor,
                  size: 22.sp,
                ),
              ],
            ),
          ),
        ),

        Divider(
          height: 1.h,
          thickness: 1,
          color: const Color(0xFFF3F4F6),
        ),
      ],
    );
  }
}
