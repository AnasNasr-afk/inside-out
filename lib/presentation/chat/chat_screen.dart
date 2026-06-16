import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/networking/repositories/chat_repo.dart';

import 'widgets/chat_app_bar.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/chat_logged_banner.dart';
import 'widgets/chat_message_list.dart';
import 'widgets/chat_colors.dart';

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

      final specialistId =
          SharedPrefHelper.getInt(SharedPrefKeys.specialistId);
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
          if (!mounted) return;
          final alreadyExists = _messages.any((m) => m.messageId == msg.messageId);
          if (alreadyExists) return;
          setState(() => _messages.add(msg));
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

  void _retryChat() {
    setState(() {
      _error = null;
      _isLoading = true;
    });
    _initChat();
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
      backgroundColor: chatBgPage,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ChatAppBar(
              specialistName: _specialistName,
              specialistInitial: _specialistInitial,
              isLoading: _isLoading,
              hasError: _error != null,
            ),
            Expanded(
              child: ChatMessageList(
                isLoading: _isLoading,
                error: _error,
                messages: _messages,
                myUserId: _myUserId,
                parentInitial: _parentInitial,
                specialistInitial: _specialistInitial,
                scrollController: _scrollCtrl,
                onRetry: _retryChat,
                formatTime: _formatTime,
              ),
            ),
            const ChatLoggedBanner(),
            ChatInputBar(
              controller: _controller,
              onSend: _send,
            ),
          ],
        ),
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
