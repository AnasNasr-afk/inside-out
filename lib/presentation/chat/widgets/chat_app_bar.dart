import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: chatInputBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            color: chatTextDark,
            onPressed: () => Navigator.of(context).pop(),
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFEDE8FF),
                child: Text(
                  specialistInitial,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: chatPrimary,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: isConnected ? chatOnlineGreen : chatTextLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  specialistName,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
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
                    fontSize: 11,
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
