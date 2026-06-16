import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_colors.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, bottomInset > 0 ? bottomInset : 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: chatInputBorder, width: 0.5.w)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.poppins(fontSize: 14.sp, color: chatTextDark),
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                hintStyle:
                    GoogleFonts.poppins(fontSize: 14.sp, color: chatTextLight),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8.h),
              ),
              onSubmitted: (_) => onSend(),
              textInputAction: TextInputAction.send,
              maxLines: 4,
              minLines: 1,
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 42.w,
              height: 42.h,
              decoration: const BoxDecoration(
                color: chatPrimary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send_rounded,
                  color: Colors.white, size: 18.sp),
            ),
          ),
        ],
      ),
    );
  }
}
