import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_colors.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({
    super.key,
    required this.specialistName,
    required this.specialistInitial,
    required this.isLoading,
    required this.hasError,
  });

  final String specialistName;
  final String specialistInitial;
  final bool isLoading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final isConnected = !isLoading && !hasError;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: chatInputBorder, width: 0.5.w)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18.sp),
            color: chatTextDark,
            onPressed: () => Navigator.of(context).pop(),
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: const Color(0xFFEDE8FF),
                child: Text(
                  specialistInitial,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: chatPrimary,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 11.w,
                  height: 11.h,
                  decoration: BoxDecoration(
                    color: isConnected ? chatOnlineGreen : chatTextLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5.w),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  specialistName,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: chatTextDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isLoading
                      ? 'Connecting...'
                      : (hasError ? 'Unavailable' : 'Online'),
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: isConnected ? chatOnlineGreen : chatTextLight,
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
