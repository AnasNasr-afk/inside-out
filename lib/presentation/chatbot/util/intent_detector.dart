import 'package:flutter_gemini/flutter_gemini.dart';

enum ChatIntent {
  activities,
  general,
}

extension ChatIntentX on ChatIntent {
  bool get isActivities => this == ChatIntent.activities;
  bool get isGeneral => this == ChatIntent.general;
}

class IntentDetector {

  static final IntentDetector _instance = IntentDetector._internal();

  IntentDetector._internal();

  static IntentDetector get instance => _instance;

  static const String _intentDetectionPrompt = '''
You are an intent detection system for a medical chatbot called NeuroBot that specializes in autism care for patients.

Analyze the user's message and determine their intent. Respond with ONLY one of these exact options:

- "ACTIVITIES" - if the user is asking about daily activities, tasks, today's activities, or what to do today
- "GENERAL" - for any other medical questions, general health inquiries, or autism-related questions

Examples:
- "What are my activities for today?" → ACTIVITIES
- "Show me my daily tasks" → ACTIVITIES
- "What do I need to do today?" → ACTIVITIESa
- "My activities" → ACTIVITIES
- "How can I help my child with autism?" → GENERAL
- "What is autism?" → GENERAL

User message: ''';

  static Future<ChatIntent> detectIntent(String userMessage) async {
    try {
      final response = await Gemini.instance.prompt(
        parts: [Part.text('$_intentDetectionPrompt"$userMessage"')],
      );

      final detectedIntent = response?.output?.trim().toUpperCase();
      
      switch (detectedIntent) {
        case 'ACTIVITIES':
          return ChatIntent.activities;
        case 'GENERAL':
          return ChatIntent.general;
        default:
          return ChatIntent.general;
      }
    } catch (e) {
      return ChatIntent.general;
    }
  }
}
