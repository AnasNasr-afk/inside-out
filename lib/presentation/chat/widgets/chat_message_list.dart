import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'chat_bubble_row.dart';
import 'chat_colors.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.isLoading,
    required this.error,
    required this.messages,
    required this.myUserId,
    required this.parentInitial,
    required this.specialistInitial,
    required this.scrollController,
    required this.onRetry,
    required this.formatTime,
  });

  final bool isLoading;
  final String? error;
  final List<BaseMessage> messages;
  final String myUserId;
  final String parentInitial;
  final String specialistInitial;
  final ScrollController scrollController;
  final VoidCallback onRetry;
  final String Function(int) formatTime;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error!,
                style: GoogleFonts.poppins(color: chatTextMid, fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: chatPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Try again',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet. Say hi! 👋',
          style: GoogleFonts.poppins(color: chatTextLight, fontSize: 14.sp),
        ),
      );
    }

    final textStyleOut = GoogleFonts.poppins(
      fontSize: 14.sp,
      color: Colors.white,
      height: 1.5,
    );
    final textStyleIn = GoogleFonts.poppins(
      fontSize: 14.sp,
      color: chatTextDark,
      height: 1.5,
    );
    final fileStyleOut = GoogleFonts.poppins(fontSize: 13.sp, color: Colors.white);
    final fileStyleIn = GoogleFonts.poppins(fontSize: 13.sp, color: chatTextDark);

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      itemCount: messages.length,
      itemBuilder: (context, i) {
        final msg = messages[i];
        final isMe = msg.sender?.userId == myUserId;
        final prev = i > 0 ? messages[i - 1] : null;
        final showAvatar = !isMe &&
            (prev == null || prev.sender?.userId != msg.sender?.userId);

        if (msg is UserMessage) {
          return ChatBubbleRow(
            isMe: isMe,
            time: formatTime(msg.createdAt),
            showAvatar: showAvatar,
            senderInitial: isMe ? parentInitial : specialistInitial,
            child: Text(
              msg.message,
              style: isMe ? textStyleOut : textStyleIn,
            ),
          );
        }

        if (msg is FileMessage) {
          final isImage = (msg.type ?? '').startsWith('image/');
          return ChatBubbleRow(
            isMe: isMe,
            time: formatTime(msg.createdAt),
            showAvatar: showAvatar,
            senderInitial: isMe ? parentInitial : specialistInitial,
            child: isImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      msg.url,
                      width: 200.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image_rounded,
                        color: Colors.white54,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.insert_drive_file_rounded,
                        color: isMe ? Colors.white70 : chatTextMid,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          msg.name ?? 'File',
                          style: isMe ? fileStyleOut : fileStyleIn,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
