import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const MenuItem({super.key,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? const Color(0xFFEF4444)
        : const Color(0xFF1F2937);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 4.w,
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color: isDestructive
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF9CA3AF),
                  size: 22.sp,
                ),
              ],
            ),
          ),
        ),

        Divider(
          height: 1.h,
          thickness: 1,
          color: Color(0xFFF3F4F6),
        ),
      ],
    );
  }
}