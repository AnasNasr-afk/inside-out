import 'dart:async';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:patient/core/core.dart';
import 'package:patient/presentation/chatbot/util/data_formatters/activity_data_formatter.dart';
import 'package:rxdart/rxdart.dart';

import 'intent_detector.dart';

enum ChatMessageType {
  user,
  chatbot,
  typing,
}

class ChatMessageModel {
  final String text;
  final ChatMessageType type;

  const ChatMessageModel(this.text, this.type);
}

class ChatManager {
  static final ChatManager _instance = ChatManager._internal();

  ChatManager._internal();

  static ChatManager get instance => _instance;

  final List<ChatMessageModel> _messages = <ChatMessageModel>[];
  final BehaviorSubject<List<ChatMessageModel>> _messageController =
      BehaviorSubject<List<ChatMessageModel>>.seeded([]);

  Stream<List<ChatMessageModel>> get messageStream => _messageController.stream;

  static const String _systemContext =
      'You are NeuroBot, a highly specialized doctor in the field of autism. '
      'Answer only what is asked, concisely and clinically. '
      'Do not include unnecessary details or unrelated information.';

  void addMessage(String text, ChatMessageType type) {
    _messages.add(ChatMessageModel(text, type));
    _messageController.add(List<ChatMessageModel>.unmodifiable(_messages));
  }

  void _addTyping() {
    _messages.add(const ChatMessageModel('', ChatMessageType.typing));
    _messageController.add(List<ChatMessageModel>.unmodifiable(_messages));
  }

  void _removeTypingIfPresent() {
    if (_messages.isNotEmpty && _messages.last.type == ChatMessageType.typing) {
      _messages.removeLast();
      _messageController.add(List<ChatMessageModel>.unmodifiable(_messages));
    }
  }

  void sendResponseFromChatbot(String input) async {
    _addTyping();
    final intent = await IntentDetector.detectIntent(input);
    switch(intent) {
      case ChatIntent.activities:
        _handleActivitiesIntent(input);
        break;
      case ChatIntent.general:
        _handleGeneralIntent(input);
        break;
    }
  }

  void _handleActivitiesIntent(String input) async {
    
    try {
      final result = await getIt<PatientRepository>().getTodayActivities();
      _removeTypingIfPresent();
      if (result is ActionResultSuccess) {
        final activities = result.data.$1;
        final formattedActivitiesResponse =
            ActivityDataFormatter().formatResponse(activities);
        addMessage(formattedActivitiesResponse, ChatMessageType.chatbot);
      } else {
        final failureData = result.errorMessage;
        final failureMessage = '📋✨ $failureData';
        addMessage(failureMessage, ChatMessageType.chatbot);
      }
    } catch (e) {
      addMessage('⚠️ Oops! Failed to fetch activities', ChatMessageType.chatbot);
    }
  }

  void _handleGeneralIntent(String input) {
    Gemini.instance
        .prompt(parts: [
          Part.text(_systemContext),
          Part.text(input),
        ])
        .then((value) {
      _removeTypingIfPresent();
      addMessage(value?.output ?? 'No Response from Chatbot', ChatMessageType.chatbot);
    }).catchError((error) {
      _removeTypingIfPresent();
      addMessage('Error: ${error.toString()}', ChatMessageType.chatbot);
    });
  }
}