import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_colors.dart';

class ChatLoggedBanner extends StatelessWidget {
  const ChatLoggedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 6.h),
      color: Colors.white,
      child: Text(
        'COMMUNICATION IS LOGGED FOR CLINICAL RECORD',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: chatLoggedBanner,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
