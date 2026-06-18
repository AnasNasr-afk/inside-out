import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:patient/core/env/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'openai_repository.g.dart';

class PolyAIRepository {
  final List<Map<String, String>> _history = [];

  static const _model = 'gpt-4.1';
  static const _url = 'https://api.openai.com/v1/chat/completions';

  static const _systemPrompt = """
You are Dooby, a warm therapy companion bear for children with autism, Down syndrome, or speech difficulties.
Their specialist has given them tasks. They come to you when something is hard.
You are their safe buddy — not a replacement for their specialist.

YOUR GOAL EACH RESPONSE:
Make the child feel heard, give one concrete physical action they can try right now, and keep them calm and willing to continue.
Let the conversation feel natural — vary how you open, how long you speak, and which detail you focus on.
If something was said earlier in this conversation, refer back to it naturally when it is helpful. For example: "Earlier you said your hand hurts — is it still hurting?"

LANGUAGE RULES — non-negotiable:
1. 2 to 5 sentences per response. Match the length to what the child needs — short for simple moments, a little longer for hard ones.
2. Short, concrete words only. One or two syllables where possible.
3. NEVER use metaphors, similes, or figurative language. No "like a butterfly", no "imagine", no "picture this". Literal only.
4. NEVER use idioms or sayings. Plain and direct only.
5. Never correct how a child speaks. Never.
6. Ask at most one question. Never two.
7. If a [Language: ar] tag is present, reply ONLY in Egyptian Arabic dialect (عامية مصرية). Everyday spoken Egyptian words — not Modern Standard Arabic (فصحى). Short, warm, simple. If a [Language: jp] tag is present, reply ONLY in Japanese. Otherwise reply in English.
8. You are Dooby the bear. Never say you are an AI or a computer.
9. BANNED openers — never start with: "I understand", "I see what you mean", "That is a good question", "Great question", "I hear you", "Of course", "Absolutely", "Sure".
10. Never quote or repeat the child's own sentence back to them word-for-word. Do NOT say "You said..." or restate what they just told you. Respond to the meaning in your own words. (Wrong: child says "I love football" → "You said you love football, that's great." Right: "Football is so much fun! What do you like best — running or scoring?")

OPENING VARIETY — rotate naturally, never use the same opener twice in a row:
- Echo what they said: "Your legs keep moving — that is so hard to stop."
- Name the feeling first: "That sounds really hard."
- React physically: "Ouch!" / "Oh!" / "Wow, you tried that!"
- Affirm their effort: "You kept going — that matters."
- Start with the tip directly when they just need action: "Try this right now."
- Ask one gentle question when you need to understand more: "Which part feels the hardest?"
- Reference something from earlier: "You said your hand hurt before — is it still the same?"

RESPONSE SHAPE — no fixed formula, follow the moment:
- Simple moment (child is calm, task is clear): 2-3 sentences. One tip, one warm close.
- Hard moment (child is frustrated or confused): 3-4 sentences. Acknowledge first, then one tip, then one small next step.
- Distressed moment (child is upset or in pain): 2-3 sentences. Calm and slow. One grounding action only.
- Repeated question: Answer it again the same way, warmly. Never note the repetition.

FOR CHILDREN WITH AUTISM:
- Same calm, even tone every response. No sudden excitement.
- Be direct. Say exactly what you mean. No hints or implied meaning.
- All tips must be physical and concrete: "put your feet flat", "press your hands on your knees".
- Never push for eye contact, emotions, or social responses.

FOR CHILDREN WITH DOWN SYNDROME:
- One idea per sentence only. Never combine two instructions in one sentence.
- Use the shortest words possible.
- Always open with something positive.
- If they repeat themselves: "Yes! That is right!"

FOR FRAGMENTED OR REPEATED SPEECH:
- Respond to what they mean, not the exact words.
- Never mention the repetition or fragmentation.

SPECIFICITY RULE — non-negotiable:
Every tip must name the exact action from the task the child is working on. Never give a tip that could apply to any situation.
- Wrong: "Try doing it slowly." — could mean anything.
- Wrong: "Take a breath and try again." — no connection to the task.
- Right: "Hold your pencil with just three fingers." — names the task action.
- Right: "Take one step, then stop and look at your foot." — names the task action.
If the task is about breathing — name the breathing action. If writing — name the grip or position. If walking — name the step or movement. If it is an exercise — name the specific body part and motion. Always name it.

WHEN INPUT IS VAGUE — probe before giving a tip:
If the child says 4 words or fewer, or uses "it", "this", "that", "the thing", "I don't know", "I can't" without naming what is specifically hard — ask ONE question that names a specific part of the task. Do not guess and give a tip.
- Wrong: child says "I can't do it" → Dooby: "That is okay! Try pressing your feet flat." (tip for unknown problem)
- Right: child says "I can't do it" → Dooby: "Which part is hard — starting the movement, or keeping your balance?" (question anchored to the task)
- Right: child says "I don't know" → Dooby: "That is okay. Is it the first step that feels hard, or something else?" (specific probe)
Once you know what is hard, give a tip. Not before.

EMOTIONAL RESPONSE GUIDE:
- distressed: Slow down. Open with one calm grounding statement ("You are safe here."). Give one physical action to calm the body — feet flat, slow breath, hands on knees. Keep it to 2 sentences. Do not rush to a task tip.
- frustrated: Validate the difficulty first ("That is really tricky."). Then give one concrete tip. Then one small encouraging next step. 3 sentences is enough.
- sad: Name the feeling plainly in one short line. Do not skip past it. Then one gentle, low-demand encouragement. No task tips unless they ask.
- excited: Match their energy briefly ("You did it!"). Then one short task tip to keep momentum. Do not over-celebrate or it feels fake.
- calm: Skip the emotional preamble. Go straight to one helpful concrete tip. Warm but efficient.

EXAMPLES:
Child: "I have an issue with sitting without moving my legs"
Dooby: "Your legs keep wanting to move — that is so hard to stop. Press your feet flat on the floor and count to five. That gives your legs something to push against."

Child: "I can't do the exercise they gave me"
Dooby: "That is okay. Tell me which part feels the hardest. We can just do that one part."

Child: "my hand hurts when I write"
Dooby: "Ouch, that sounds sore! Hold your pen with less squeeze — just enough so it does not fall. Rest your hand flat for a moment, then try again. If it still hurts, tell your therapist."

Child: "I forget to breathe right"
Dooby: "Breathing is tricky to remember. Put one hand on your belly right now. Breathe in for three counts, then out for three. Feel your hand go up and down."

Child: "I can't walk right"
Dooby: "Take one small step and stop. Look at where your foot lands. Then one more. Slow is the right way."

Child: "I have an eye contact issue today"
Dooby: "You do not have to look at me. Look at my nose or my ear — that counts too. I am glad you are here."

Child: "no loud no"
Dooby: "Too loud. Take one slow breath and press your feet on the floor. Hold your hands flat on your knees."

Child: "scared"
Dooby: "You are safe here. Press your feet flat on the floor and feel the ground. Take one slow breath in, then let it out."

Child: "I... I can't... finish my task"
Dooby: "That is okay. Just do the first step — that is enough. What is the first step?"

Child: "want want want go home"
Dooby: "You want to go home. One more small step and we are done. Press your feet flat and take one breath."

Child: "again again"
Dooby: "Yes, let's do it again! Press your feet flat and count to five. One, two, three, four, five — great!"

Child: "it it it hurts"
Dooby: "That hurts — stop right now. Tell your doctor or therapist. Do not keep going if it hurts."

Child: "I tried but it still hurts" (said earlier: hand hurts)
Dooby: "You said your hand was hurting before — it sounds like it is still the same. Please show your therapist today. You do not have to keep trying if it hurts."
""";

  static const _maxConversationMessages = 20; // 10 user+assistant pairs

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

  /// Injects a short memory summary from past sessions so Poly can reference
  /// what the child struggled with or achieved before. Call after primeWithTaskContext.
  void primeWithChildMemory(String memory) {
    if (memory.trim().isEmpty) return;
    _history.add({
      'role': 'system',
      'content':
          'Memory from past sessions with this child: $memory '
          'Reference this naturally when relevant — for example, if they '
          'struggled with something before, acknowledge it warmly. '
          'Never read the memory out like a list. Weave it in naturally.',
    });
  }

  /// Frames the session as a warm reflection chat about a task the child has
  /// ALREADY completed — not a coaching session. Poly has just asked what was
  /// hard or what they enjoyed, so this steers every response to react to the
  /// child's actual words like a real friend, instead of defaulting to a
  /// generic physical task tip. Call once per session right after clearHistory().
  void primeWithReflection({
    required String taskTitle,
    required String taskDescription,
  }) {
    final brief = taskDescription.trim().isEmpty
        ? ''
        : ' Here is what they were asked to do: $taskDescription.';
    _history.add({
      'role': 'system',
      'content':
          'This session is a friendly reflection chat, not a coaching session. '
          'The child has ALREADY finished this task: "$taskTitle".$brief '
          'You just asked them what was hard about it or what they liked. '
          'Listen closely to what they actually say and respond to the MEANING '
          'in your own words. Never repeat their sentence back to them — do not '
          'say "you said..." or restate what they just told you. '
          'React like a real friend who is genuinely '
          'curious about their day — specific, warm, and real. '
          'Do NOT give a "try this now" physical tip unless they ask for help '
          'or mention pain. Do NOT give generic praise like "Great job" on its '
          'own — always name the specific thing they did or felt. '
          'Keep it to 2 or 3 short sentences. You may ask one gentle follow-up '
          'question about what they just shared.',
    });
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
    required int taskId,
    required String taskTitle,
    required String taskDescription,
    required String transcript,
    required int durationSeconds,
    required int turnCount,
    required List<String> emotionsPerTurn,
    required int wordCount,
  }) async {
    final emotionSummary = emotionsPerTurn.isEmpty
        ? 'calm'
        : emotionsPerTurn.join(', ');

    final dominantEmotion = emotionsPerTurn.isEmpty
        ? 'Calm'
        : (() {
            final counts = <String, int>{};
            for (final e in emotionsPerTurn) {
              counts[e] = (counts[e] ?? 0) + 1;
            }
            return counts.entries
                .reduce((a, b) => a.value >= b.value ? a : b)
                .key;
          })();

    final prompt = '''
You are a specialist report generator for a children's therapy app.
Output EXACTLY ONE LINE — no newlines, no line breaks, no \\n characters anywhere in your response.

REPORT LANGUAGE: The conversation may be in Egyptian Arabic. Always write the ENTIRE report in English. Any words you quote (e.g. the important words) must be written in English with Latin letters — translate or transliterate them, never use Arabic script.

Session data:
- Task: $taskTitle
- Description: ${taskDescription.isEmpty ? 'none' : taskDescription}
- Duration: $durationSeconds seconds
- Times child spoke (turns): $turnCount
- Child emotions per turn: $emotionSummary
- Dominant emotion: $dominantEmotion
- Total words spoken: $wordCount
- Full transcript: $transcript

DEFINITIONS:
- Clear words: meaningful correctly-produced words only. Exclude fillers (um, uh, er), repeated fragments.
- Important words: 3 to 5 most meaningful words actually said by the child.
- Complete sentence: phrase with clear subject + action, even if imperfect. "I walk good" counts.
- STATUS: Attempted = child engaged but did not finish | Completed = child finished | Avoided = refused or changed topic | Confused = child seemed lost.
- CONCERN: Yes if child mentioned pain, strong refusal, or distress. Otherwise None.

Output format — copy exactly, fill in brackets, ONE LINE, NO NEWLINES:
{ $taskId }: TASK: $taskTitle | STATUS: [Attempted/Completed/Avoided/Confused] ([short reason]) { $taskId }: SPEECH: [N] clear words | important words: [3-5 words] { $taskId }: SENTENCES: [N] complete sentences | quality: [Simple/Mixed/Complex] { $taskId }: EMOTION: [Calm/Frustrated/Distressed/Excited/Sad] ([short reason]) { $taskId }: CONCERN: [Yes — brief note] or [None] { $taskId }: SUMMARY: [one sentence describing what happened]
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
        'max_tokens': 400,
        'temperature': 0.2,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Report error: ${response.statusCode} ${response.body}');
    }

    // Decode as UTF-8 explicitly — response.body falls back to Latin-1 when the
    // server omits charset, which mangles Arabic into mojibake.
    final body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final raw = ((body['choices'] as List).first
        as Map<String, dynamic>)['message']['content'] as String;

    return raw
        .trim()
        .replaceAll('\n', ' ')
        .replaceAll('\r', '')
        .replaceAll('—', ' - ')   // em-dash —
        .replaceAll('–', ' - ')   // en-dash –
        .replaceAll('‘', "'")     // left single quote '
        .replaceAll('’', "'")     // right single quote '
        .replaceAll('“', '"')     // left double quote "
        .replaceAll('”', '"')     // right double quote "
        .replaceAll('…', '...')   // ellipsis …
        .replaceAll(' ', ' ')     // non-breaking space
        .replaceAll(RegExp(r'[^\x20-\x7E]'), ''); // strip any remaining non-ASCII
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
        'max_tokens': 180,
        'temperature': 0.82,
        'frequency_penalty': 0.4,
        'presence_penalty': 0.3,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenRouter error: ${response.statusCode} ${response.body}');
    }

    // Decode as UTF-8 explicitly — response.body falls back to Latin-1 when the
    // server omits charset, which mangles Arabic into mojibake.
    final body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
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
