import 'package:flutter/material.dart';
import 'package:patient/presentation/chatbot/widgets/message_bubble.dart';

import 'util/chat_manager.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();

  void _handleSend() {
    final String inputText = _textController.text.trim();
    if (inputText.isEmpty) return;

    ChatManager.instance.addMessage(inputText, ChatMessageType.user);
    ChatManager.instance.sendResponseFromChatbot(inputText);
    _textController.clear();
    setState(() {});
  }

  Widget _buildSearchField() {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 30),
        child:  TextField(
          controller: _textController,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => _handleSend(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Search',
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send_rounded),
              color: const Color(0xff7A86F8),
              onPressed: _handleSend,
              tooltip: 'Send',
            ),
          ),
        ),
      );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: _buildSearchField(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff7A86F8),
        title: const Text(
          'NeuroBot',
           style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<ChatMessageModel>>(
        stream: ChatManager.instance.messageStream,
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final ChatMessageModel message = snapshot.data![index];
                if (message.type == ChatMessageType.typing) {
                  return const TypingBubble();
                }
                return MessageBubble(
                  message: message.text,
                  isUserMessage: message.type == ChatMessageType.user,
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      )
    );
  }
}