import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Color constants matching app theme ──────────────────────
const _primary       = Color(0xFF6366F1);
const _bgPage        = Color(0xFFF5F5F0); // warm off-white from web
const _bubbleIn      = Color(0xFFEEEFF8); // incoming bubble (light purple-grey)
const _bubbleOut     = _primary;          // outgoing bubble (purple)
const _textDark      = Color(0xFF1F2937);
const _textMid       = Color(0xFF6B7280);
const _textLight     = Color(0xFF9CA3AF);
const _onlineGreen   = Color(0xFF10B981);
const _inputBorder   = Color(0xFFE5E7EB);
const _loggedBanner  = Color(0xFFD1D5DB);

// ═══════════════════════════════════════════════════════════
// ChatScreen
// ═══════════════════════════════════════════════════════════
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller  = TextEditingController();
  final _scrollCtrl  = ScrollController();
  final List<_Message> _messages = [
    _Message(
      text: 'Hi Dr. Amr, I wanted to check in on Sara\'s progress this week. She seemed a bit more anxious than usual on Tuesday morning.',
      isMe: false,
      time: '09:15 AM',
      dateLabel: 'MONDAY, OCT 23',
    ),
    _Message(
      text: 'Hello Omnia! Sara did great overall. We focused on social interaction today and she actually shared a toy with another peer for the first time!',
      isMe: true,
      time: '09:42 AM',
    ),
    _Message(
      text: 'That\'s wonderful to hear! She hasn\'t mentioned it yet, but she was quite happy when I picked her up. Is there any specific homework or focus for the weekend?',
      isMe: false,
      time: '10:05 AM',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(
        text: text,
        isMe: true,
        time: _nowTime(),
      ));
      _controller.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _nowTime() {
    final now = DateTime.now();
    final h   = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m   = now.minute.toString().padLeft(2, '0');
    final p   = now.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // ── Message list ─────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg  = _messages[index];
                final prev = index > 0 ? _messages[index - 1] : null;
                return Column(
                  children: [
                    // Date label
                    if (msg.dateLabel != null)
                      _DateLabel(label: msg.dateLabel!),
                    _BubbleRow(
                      message: msg,
                      showAvatar: !msg.isMe &&
                          (prev == null || prev.isMe || prev.dateLabel != null),
                    ),
                  ],
                );
              },
            ),
          ),

          // ── "Logged" banner ───────────────────────────────
          _LoggedBanner(),

          // ── Input bar ─────────────────────────────────────
          _InputBar(
            controller: _controller,
            onSend: _send,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            size: 18, color: _textDark),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          // ── Avatar with online dot ──────────────────────
          Stack(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFEDE8FF),
                child: Text(
                  'O',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _primary,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _onlineGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Specialist',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              Text(
                'Online',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: _onlineGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: _textMid),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 0.5, color: _inputBorder),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Message model
// ═══════════════════════════════════════════════════════════
class _Message {
  final String text;
  final bool isMe;
  final String time;
  final String? dateLabel;

  const _Message({
    required this.text,
    required this.isMe,
    required this.time,
    this.dateLabel,
  });
}

// ═══════════════════════════════════════════════════════════
// Date label
// ═══════════════════════════════════════════════════════════
class _DateLabel extends StatelessWidget {
  const _DateLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: _textLight,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Bubble row
// ═══════════════════════════════════════════════════════════
class _BubbleRow extends StatelessWidget {
  const _BubbleRow({required this.message, required this.showAvatar});
  final _Message message;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Incoming avatar ──────────────────────────────
          if (!isMe) ...[
            showAvatar
                ? CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFEDE8FF),
              child: Text(
                'O',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _primary,
                ),
              ),
            )
                : const SizedBox(width: 32),
            const SizedBox(width: 8),
          ],

          // ── Bubble ───────────────────────────────────────
          Flexible(
            child: Column(
              crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? _bubbleOut : _bubbleIn,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isMe ? Colors.white : _textDark,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.time,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: _textLight,
                  ),
                ),
              ],
            ),
          ),

          // ── Outgoing avatar ──────────────────────────────
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFEDE8FF),
              child: Text(
                'A',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// "Communication is logged" banner
// ═══════════════════════════════════════════════════════════
class _LoggedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      child: Text(
        'COMMUNICATION IS LOGGED FOR CLINICAL RECORD',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: _loggedBanner,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Input bar
// ═══════════════════════════════════════════════════════════
class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _inputBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          // ── Attachment ───────────────────────────────────
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.attach_file_rounded,
                color: _textMid, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),

          // ── Emoji ────────────────────────────────────────
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sentiment_satisfied_alt_rounded,
                color: _textMid, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),

          const SizedBox(width: 4),

          // ── Text field ───────────────────────────────────
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.poppins(fontSize: 14, color: _textDark),
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 14, color: _textLight),
                border: InputBorder.none,
                isDense: true,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: (_) => onSend(),
              textInputAction: TextInputAction.send,
              maxLines: 4,
              minLines: 1,
            ),
          ),

          const SizedBox(width: 8),

          // ── Send button ──────────────────────────────────
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: _primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}