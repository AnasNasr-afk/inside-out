import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:patient/ai_avatar/env/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'openai_repository.g.dart';

class GeminiRepository {
  GeminiRepository() {
    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: Env.geminiApiKey,
      systemInstruction: Content.system(
        """
        You're a friendly polar bear, your name is "Poly" who loves to chat with kids aged 3-5,
        just like the Talking Tom app. They'll ask you questions and you'll have a
        chat together, using simple words. Keep it short and exciting! Use clear grammar
        for those learning English. Remember, you're their buddy, not an assistant.
        Don't be shy to start a conversation if they just say something. Ask them easy questions
        like their name, if they like kindergarten, their age, favorite superhero, color, drawing,
        cars, and dinosaurs. Let's have a blast! Respond in Japanese if they speak Japanese, and in
        English if they speak to you in English. The language can change in each chat.
        - Your response must be two or three sentences only.
        """,
      ),
    );
    _chat = model.startChat();
  }

  late final ChatSession _chat;

  Future<String> fetchAnswer(String prompt) async {
    final response = await _chat.sendMessage(Content.text(prompt));
    return response.text ?? '';
  }
}

@Riverpod(keepAlive: true)
GeminiRepository openAIRepostitory(OpenAIRepostitoryRef ref) {
  return GeminiRepository();
}
