import 'package:flutter/material.dart';
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

  static final _avatarTextStyle = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: chatPrimary,
  );
  static final _timeStyle = GoogleFonts.poppins(
    fontSize: 11,
    color: chatTextLight,
  );
  static const _bubbleRadiusMe = BorderRadius.only(
    topLeft: Radius.circular(18),
    topRight: Radius.circular(18),
    bottomLeft: Radius.circular(18),
    bottomRight: Radius.circular(4),
  );
  static const _bubbleRadiusThem = BorderRadius.only(
    topLeft: Radius.circular(18),
    topRight: Radius.circular(18),
    bottomLeft: Radius.circular(4),
    bottomRight: Radius.circular(18),
  );
  static const _avatarBg = Color(0xFFEDE8FF);

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: 16,
      backgroundColor: _avatarBg,
      child: Text(senderInitial, style: _avatarTextStyle),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            showAvatar ? avatar : const SizedBox(width: 32),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? chatBubbleOut : chatBubbleIn,
                    borderRadius: isMe ? _bubbleRadiusMe : _bubbleRadiusThem,
                  ),
                  child: child,
                ),
                const SizedBox(height: 4),
                Text(time, style: _timeStyle),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            avatar,
          ],
        ],
      ),
    );
  }
}
