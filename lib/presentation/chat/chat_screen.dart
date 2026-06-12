import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as ep;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/networking/repositories/chat_repo.dart';

const _primary      = Color(0xFF6366F1);
const _bgPage       = Color(0xFFF5F5F0);
const _bubbleIn     = Color(0xFFEEEFF8);
const _bubbleOut    = _primary;
const _textDark     = Color(0xFF1F2937);
const _textMid      = Color(0xFF6B7280);
const _textLight    = Color(0xFF9CA3AF);
const _onlineGreen  = Color(0xFF10B981);
const _inputBorder  = Color(0xFFE5E7EB);
const _loggedBanner = Color(0xFFD1D5DB);

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();

  GroupChannel? _channel;
  String _myUserId = '';
  String _specialistName = 'Specialist';
  String _specialistInitial = 'S';
  String _parentInitial = 'P';
  bool _isLoading = true;
  String? _error;
  bool _showEmojiPicker = false;
  final List<BaseMessage> _messages = [];

  static const _handlerKey = 'parent_chat_handler';

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  @override
  void dispose() {
    SendbirdChat.removeChannelHandler(_handlerKey);
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _initChat() async {
    try {
      final name = SharedPrefHelper.getString(SharedPrefKeys.specialistName);
      final parentName = SharedPrefHelper.getString(SharedPrefKeys.fullName);
      if (name.isNotEmpty) {
        _specialistName = name;
        _specialistInitial = name.trim()[0].toUpperCase();
      }
      if (parentName.isNotEmpty) {
        _parentInitial = parentName.trim()[0].toUpperCase();
      }

      final specialistId = SharedPrefHelper.getInt(SharedPrefKeys.specialistId);
      if (specialistId <= 0) {
        setState(() {
          _error = 'No specialist assigned yet.';
          _isLoading = false;
        });
        return;
      }

      final (:channelUrl, :sendbirdUserId) =
          await ChatRepository().createChat(specialistId);
      _myUserId = sendbirdUserId;

      await SendbirdChat.connect(sendbirdUserId);

      final channel = await GroupChannel.getChannel(channelUrl);
      _channel = channel;

      final query = PreviousMessageListQuery(
        channelType: ChannelType.group,
        channelUrl: channel.channelUrl,
      )..limit = 50;
      if (query.hasNext) {
        final history = await query.next();
        _messages.addAll(history);
      }

      SendbirdChat.addChannelHandler(
        _handlerKey,
        _ChatHandler(onMessage: (msg) {
          if (mounted) setState(() => _messages.add(msg));
          _scrollToBottom();
        }),
      );

      if (mounted) setState(() => _isLoading = false);
      _scrollToBottom();
    } catch (e) {
      debugPrint('❌ Chat init failed: $e');
      if (mounted) {
        setState(() {
          _error = 'Could not connect to chat. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty || _channel == null) return;
    _controller.clear();

    _channel!.sendUserMessage(
      UserMessageCreateParams(message: text),
      handler: (msg, error) {
        if (error != null) {
          debugPrint('❌ Send failed: $error');
          return;
        }
        if (mounted) {
          setState(() => _messages.add(msg));
          _scrollToBottom();
        }
      },
    );
  }

  Future<void> _pickFile() async {
    if (_channel == null) return;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;

      _channel!.sendFileMessage(
        FileMessageCreateParams.withFile(file, fileName: fileName),
        handler: (msg, error) {
          if (error != null) {
            debugPrint('❌ File send failed: $error');
            return;
          }
          if (mounted) {
            setState(() => _messages.add(msg));
            _scrollToBottom();
          }
        },
      );
    } catch (e) {
      debugPrint('❌ File pick failed: $e');
    }
  }

  void _toggleEmojiPicker() {
    setState(() => _showEmojiPicker = !_showEmojiPicker);
    if (_showEmojiPicker) FocusScope.of(context).unfocus();
  }

  void _scrollToBottom() {
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

  String _formatTime(int createdAt) {
    final dt = DateTime.fromMillisecondsSinceEpoch(createdAt);
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final p = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _LoggedBanner(),
          _InputBar(
            controller: _controller,
            onSend: _send,
            onPickFile: _pickFile,
            onToggleEmoji: _toggleEmojiPicker,
            emojiActive: _showEmojiPicker,
          ),
          if (_showEmojiPicker)
            SizedBox(
              height: 280,
              child: ep.EmojiPicker(
                textEditingController: _controller,
                onEmojiSelected: (_, __) {},
                config: ep.Config(
                  emojiViewConfig: ep.EmojiViewConfig(
                    backgroundColor: Colors.white,
                    columns: 8,
                    emojiSizeMax: 28,
                  ),
                  categoryViewConfig: const ep.CategoryViewConfig(
                    backgroundColor: Colors.white,
                    indicatorColor: _primary,
                    iconColorSelected: _primary,
                  ),
                  bottomActionBarConfig: const ep.BottomActionBarConfig(
                    backgroundColor: Colors.white,
                    buttonColor: _primary,
                  ),
                  searchViewConfig: const ep.SearchViewConfig(
                    backgroundColor: Colors.white,
                    buttonIconColor: _primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                style: GoogleFonts.poppins(color: _textMid, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _error = null;
                    _isLoading = true;
                  });
                  _initChat();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Try again',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      );
    }
    if (_messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet. Say hi! 👋',
          style: GoogleFonts.poppins(color: _textLight, fontSize: 14),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        if (_showEmojiPicker) setState(() => _showEmojiPicker = false);
      },
      child: ListView.builder(
        controller: _scrollCtrl,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        itemCount: _messages.length,
        itemBuilder: (context, i) {
          final msg = _messages[i];
          final isMe = msg.sender?.userId == _myUserId;
          final prev = i > 0 ? _messages[i - 1] : null;
          final showAvatar = !isMe &&
              (prev == null || prev.sender?.userId != msg.sender?.userId);

          if (msg is UserMessage) {
            return _BubbleRow(
              isMe: isMe,
              time: _formatTime(msg.createdAt),
              showAvatar: showAvatar,
              senderInitial: isMe ? _parentInitial : _specialistInitial,
              child: Text(
                msg.message,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isMe ? Colors.white : _textDark,
                  height: 1.5,
                ),
              ),
            );
          }

          if (msg is FileMessage) {
            final isImage = (msg.type ?? '').startsWith('image/');
            return _BubbleRow(
              isMe: isMe,
              time: _formatTime(msg.createdAt),
              showAvatar: showAvatar,
              senderInitial: isMe ? _parentInitial : _specialistInitial,
              child: isImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        msg.url,
                        width: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image_rounded,
                            color: Colors.white54),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.insert_drive_file_rounded,
                            color: isMe ? Colors.white70 : _textMid, size: 20),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            msg.name ?? 'File',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: isMe ? Colors.white : _textDark,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isConnected = !_isLoading && _error == null;
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
          Stack(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFEDE8FF),
                child: Text(
                  _specialistInitial,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _primary),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isConnected ? _onlineGreen : _textLight,
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
                _specialistName,
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _textDark),
              ),
              Text(
                _isLoading
                    ? 'Connecting...'
                    : (_error != null ? 'Unavailable' : 'Online'),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isConnected ? _onlineGreen : _textLight,
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

// ── Sendbird real-time handler ───────────────────────────────────────────────

class _ChatHandler extends GroupChannelHandler {
  final void Function(BaseMessage) onMessage;
  _ChatHandler({required this.onMessage});

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    onMessage(message);
  }
}

// ── Bubble row ───────────────────────────────────────────────────────────────

class _BubbleRow extends StatelessWidget {
  const _BubbleRow({
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            showAvatar
                ? CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFEDE8FF),
                    child: Text(senderInitial,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _primary)),
                  )
                : const SizedBox(width: 32),
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
                    color: isMe ? _bubbleOut : _bubbleIn,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                  ),
                  child: child,
                ),
                const SizedBox(height: 4),
                Text(time,
                    style:
                        GoogleFonts.poppins(fontSize: 11, color: _textLight)),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFEDE8FF),
              child: Text(senderInitial,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _primary)),
            ),
          ],
        ],
      ),
    );
  }
}

// ── "Logged" banner ──────────────────────────────────────────────────────────

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

// ── Input bar ────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.onPickFile,
    required this.onToggleEmoji,
    required this.emojiActive,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onPickFile;
  final VoidCallback onToggleEmoji;
  final bool emojiActive;

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
          IconButton(
            onPressed: onPickFile,
            icon: const Icon(Icons.attach_file_rounded,
                color: _textMid, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          IconButton(
            onPressed: onToggleEmoji,
            icon: Icon(
              emojiActive
                  ? Icons.keyboard_rounded
                  : Icons.sentiment_satisfied_alt_rounded,
              color: emojiActive ? _primary : _textMid,
              size: 22,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.poppins(fontSize: 14, color: _textDark),
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                hintStyle:
                    GoogleFonts.poppins(fontSize: 14, color: _textLight),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: (_) => onSend(),
              textInputAction: TextInputAction.send,
              maxLines: 4,
              minLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: _primary, shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
