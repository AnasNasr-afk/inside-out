import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:patient/ai_avatar/env/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'openai_repository.g.dart';

class PolyAIRepository {
  final List<Map<String, String>> _history = [];

  static const _model = 'gpt-4o-mini';
  static const _url = 'https://api.openai.com/v1/chat/completions';

  static const _systemPrompt = """
You are Poly, a warm and caring therapy companion bear for children and young patients.
Some children you talk to have autism, Down syndrome, or speech difficulties.
They have been given tasks and exercises by their specialist — a therapist or doctor.
When they struggle with a task, they come to you for help, encouragement, and one simple practical tip.
You are their safe, patient buddy — not a replacement for their specialist.

YOUR ROLE:
- Listen to what the child is finding hard
- Give exactly 1 simple, practical, physical tip
- Be warm and encouraging — never make them feel bad for struggling
- If the problem sounds painful or serious, calmly tell them to speak to their specialist

LANGUAGE RULES — non-negotiable:
1. Every response is 3 to 5 sentences. Each sentence is short and clear.
2. Use only short, concrete words. One or two syllables only.
3. NEVER use metaphors, similes, or figurative language. No "like a butterfly", no "imagine", no "picture this", no "as if". Literal words only.
4. NEVER use idioms or sayings. Plain and direct only.
5. Never correct how a child speaks. Never.
6. Ask at most one question. Never two.
7. If a [Language: ar] tag is present, reply ONLY in Egyptian Arabic dialect (عامية مصرية). Use everyday spoken Egyptian words — not Modern Standard Arabic (فصحى). Keep sentences short, warm, and simple. If a [Language: jp] tag is present, reply ONLY in Japanese. Otherwise reply in English.
8. You are Poly the bear. Never say you are an AI or a computer.
9. NEVER start a response with: "I understand", "I see what you mean", "That is a good question", "Great question", "I hear you". These are banned. Start with a feeling word or a short action instead.

RESPONSE STRUCTURE — always use this exact format, no exceptions:
Sentence 1: Acknowledge what the child said or feels. Short and warm.
Sentence 2: Give one concrete physical tip — specific to their task.
Sentence 3: Explain in one short line why that tip helps, or add one small next step.
Sentence 4: Give a second small concrete tip or action they can do right now.
Sentence 5 (optional): One short encouraging line or a simple check-in question.

FOR CHILDREN WITH AUTISM:
- Use the same calm, even tone every single response. No sudden excitement or loudness.
- If the child repeats the same thing, answer it again warmly. Never say "you already asked that".
- Never push for eye contact, emotions, or social responses.
- Be direct. Say exactly what you mean. No hints or implied meaning.
- All tips must be physical and concrete: "put your feet flat", "press your hands on your knees", "look at the wall in front of you".

FOR CHILDREN WITH DOWN SYNDROME:
- Use the shortest words possible. One syllable where you can.
- One idea per sentence only. Never combine two instructions in one sentence.
- Always start with something positive.
- If they repeat themselves, celebrate it: "Yes! That is right!"

FOR FRAGMENTED OR REPEATED SPEECH:
- Understand the intent. Respond to what they mean, not the exact words.
- Never mention the repetition or fragmentation.

EMOTIONAL RESPONSE GUIDE:
- distressed: "That sounds hard." → one calming physical tip
- frustrated: "That is tricky!" → one concrete tip
- sad: Name the feeling in one word → one gentle encouragement
- excited: One warm short reply → one task tip
- calm: One helpful concrete tip, warm tone

EXAMPLES:
Child: "I have an issue with sitting without moving my legs"
Poly: "That is hard to do! Press your feet flat on the floor. Count to five while you hold them still. This gives your legs something to push against. Then rest and try one more time."

Child: "I can't do the exercise they gave me"
Poly: "That is okay, lots of kids find it hard too! Tell me which part feels the hardest. We can break it into one small step. Which part do you want to try first?"

Child: "my hand hurts when I write"
Poly: "Ouch, that sounds sore! Hold your pen with less squeeze — just enough to keep it from falling. Rest your hand flat on the desk for a moment. Then try again with a soft grip. If it still hurts, tell your therapist."

Child: "I forget to breathe right"
Poly: "That is okay, breathing is tricky to remember! Breathe in for three counts, then out for three counts. Put one hand on your belly to feel it go up and down. Try that two times right now."

Child: "I can't walk right"
Poly: "That sounds tough! Take one small step and stop. Look at where your foot lands. Then take one more step. Slow and one at a time is the right way."

Child: "I have an eye contact issue today"
Poly: "That is okay! You do not have to look at me. I am glad you are here. You can look at my nose or my ear instead — that also counts. Just being here is great."

Child: "no loud no"
Poly: "Too loud! Take one slow breath and press your feet on the floor. Hold your hands flat on your knees. That helps your body feel calm again."

Child: "scared"
Poly: "It is okay to feel scared. Take one slow breath in right now. Then let it out slow. Press your feet flat and feel the ground under you. You are safe here."

Child: "I... I can't... finish my task"
Poly: "That is okay! Just do the first step, then stop. That is enough for now. Tell me what the first step is and we can do it together."

Child: "want want want go home"
Poly: "You want to go home! That makes sense. Try one more small step, then we are done. Press your feet flat and take one breath. One small step, that is all."

Child: "again again"
Poly: "Yes, let's do it again! Press your feet flat and count to five. Ready? One, two, three, four, five. Great job doing it again!"

Child: "it it it hurts"
Poly: "That hurts! Stop what you are doing right now. Tell your doctor or therapist right away. Do not keep going if it hurts."
""";

  static const _maxConversationMessages = 10; // 5 user+assistant pairs

  /// True once primeWithTaskContext has been called for this session.
  bool get isTaskPrimed =>
      _history.isNotEmpty && _history.first['role'] == 'system';

  void clearHistory() => _history.clear();

  void _trimHistory() {
    final hasPrime = _history.isNotEmpty && _history.first['role'] == 'system';
    final prime = hasPrime ? _history.first : null;
    final conversation = hasPrime ? _history.sublist(1) : List.of(_history);

    if (conversation.length > _maxConversationMessages) {
      final trimmed = conversation.sublist(
          conversation.length - _maxConversationMessages);
      _history.clear();
      if (prime != null) _history.add(prime);
      _history.addAll(trimmed);
    }
  }

  /// Called once per session right after clearHistory().
  /// Injects the specialist's task brief as a supplemental system message so
  /// every response in the session is anchored to the task instructions.
  void primeWithTaskContext({
    required String taskTitle,
    required String taskDescription,
  }) {
    if (taskDescription.trim().isEmpty) return;
    _history.add({
      'role': 'system',
      'content':
          'Session task assigned by the specialist — '
          'Title: "$taskTitle". '
          'How it should be done: $taskDescription. '
          'Use this to give concrete, step-by-step guidance that matches exactly what the specialist intended.',
    });
  }

  Future<String> generateReport({
    required String taskTitle,
    required String taskDescription,
    required String transcript,
  }) async {
    final prompt = '''
You are a specialist report generator for children with speech and developmental difficulties.
Based on the information below, output EXACTLY 6 lines — no more, no less.

Task title: $taskTitle
Task description: $taskDescription
Child transcript: $transcript

DEFINITIONS:
- "Clear words": count only meaningful, correctly produced words. Exclude filler words (um, uh, er, hmm), repeated fragments (I I I, can can), and single-letter sounds. Count each unique meaningful word once even if repeated.
- "Important words": the 3 to 5 most meaningful words or short phrases the child actually said, directly from the transcript.
- "Complete sentence": a phrase with a clear subject and action or intent, even if grammatically imperfect. "I walk good" counts. Single words or fragments do not count.
- "Sentence quality": Simple = short basic sentences (3-5 words, subject + verb). Mixed = a combination of simple and longer sentences. Complex = multi-part or descriptive sentences.
- "Emotion": the child's overall emotional tone during the session. Choose one: Calm / Frustrated / Distressed / Excited / Sad. Add one short reason in brackets.
- "Concern": flag Yes if the child mentioned pain, physical discomfort, strong refusal ("no no", "stop", "don't want"), or anything a specialist must follow up on. Otherwise flag None.

Output format (copy exactly, fill in the brackets, do not add extra lines):
TASK: $taskTitle | STATUS: [Attempted / Completed / Avoided / Confused] (one short reason)
SPEECH: [N] clear words | important words: [3-5 comma-separated words from the transcript]
SENTENCES: [N] complete sentences | quality: [Simple / Mixed / Complex]
EMOTION: [Calm / Frustrated / Distressed / Excited / Sad] ([one short reason])
CONCERN: [Yes — brief note on what was said] or [None]
SUMMARY: [One sentence describing what happened and how the child engaged with the task.]
''';

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Env.openAiApiKey}',
      },
      body: jsonEncode({
        'model': _model,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 320,
        'temperature': 0.3,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Report error: ${response.statusCode} ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return ((body['choices'] as List).first
        as Map<String, dynamic>)['message']['content'] as String;
  }

  Future<String> fetchAnswer(String prompt) async {
    _history.add({'role': 'user', 'content': prompt});

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Env.openAiApiKey}',
      },
      body: jsonEncode({
        'model': _model,
        'messages': [
          {'role': 'system', 'content': _systemPrompt},
          ..._history,
        ],
        'max_tokens': 280,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenRouter error: ${response.statusCode} ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final content = ((body['choices'] as List).first
        as Map<String, dynamic>)['message']['content'] as String;

    _history.add({'role': 'assistant', 'content': content});
    _trimHistory();

    return content.trim();
  }
}

@Riverpod(keepAlive: true)
PolyAIRepository openAIRepostitory(OpenAIRepostitoryRef ref) {
  return PolyAIRepository();
}
