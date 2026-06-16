import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonRow extends StatelessWidget {
  final String? initials;
  final IconData? icon;
  final Color avatarColor;
  final Color avatarTextColor;
  final String name;
  final String subtitle;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;

  const PersonRow({super.key,
    this.initials,
    this.icon,
    required this.avatarColor,
    required this.avatarTextColor,
    required this.name,
    required this.subtitle,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 4.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: avatarColor,
            child: icon != null
                ? Icon(icon, color: avatarTextColor, size: 22.sp)
                : Text(initials ?? '',
                style: TextStyle(
                    color: avatarTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                Text(subtitle, style: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF6B7280))),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(badgeLabel,
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: badgeTextColor)),
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: const Color(0xFF9CA3AF)),
          SizedBox(width: 10.w),
          SizedBox(
            width: 52.w,
            child: Text(label,
                style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF9CA3AF))),
          ),
          Expanded(
            child: Text(value,
                style: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF374151)),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

String getInitials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
  return '?';
}