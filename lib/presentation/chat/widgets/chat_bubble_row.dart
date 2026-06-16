import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_colors.dart';

class ChatBubbleRow extends StatelessWidget {
  const ChatBubbleRow({
    super.key,
    required this.isMe,
    required this.time,
    required this.showAvatar,
    required this.senderInitial,
    required this.child,
  });

  final bool isMe;
  final String time;
  final bool showAvatar;
  final String senderInitial;
  final Widget child;

  static TextStyle get _avatarTextStyle => GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: chatPrimary,
  );
  static TextStyle get _timeStyle => GoogleFonts.poppins(
    fontSize: 11.sp,
    color: chatTextLight,
  );
  static BorderRadius get _bubbleRadiusMe => BorderRadius.only(
    topLeft: Radius.circular(18.r),
    topRight: Radius.circular(18.r),
    bottomLeft: Radius.circular(18.r),
    bottomRight: Radius.circular(4.r),
  );
  static BorderRadius get _bubbleRadiusThem => BorderRadius.only(
    topLeft: Radius.circular(18.r),
    topRight: Radius.circular(18.r),
    bottomLeft: Radius.circular(4.r),
    bottomRight: Radius.circular(18.r),
  );
  static const _avatarBg = Color(0xFFEDE8FF);

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: 16.r,
      backgroundColor: _avatarBg,
      child: Text(senderInitial, style: _avatarTextStyle),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            showAvatar ? avatar : SizedBox(width: 32.w),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isMe ? chatBubbleOut : chatBubbleIn,
                    borderRadius: isMe ? _bubbleRadiusMe : _bubbleRadiusThem,
                  ),
                  child: child,
                ),
                SizedBox(height: 4.h),
                Text(time, style: _timeStyle),
              ],
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 8.w),
            avatar,
          ],
        ],
      ),
    );
  }
}
