import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:patient/ai_avatar/data/openai_repository.dart';
import 'package:patient/ai_avatar/data/session_repository.dart';
import 'package:patient/ai_avatar/env/env.dart';
import 'package:patient/ai_avatar/utils/input_preprocessor.dart';
import 'package:patient/ai_avatar/utils/text_to_speech_api.dart';

class PolyMissionsService {
  PolyMissionsService._();
  static final instance = PolyMissionsService._();

  final AudioPlayer _player = AudioPlayer();
  final _ttsApi = TextToSpeechAPI();

  // Same repository used by the AI bear — full system prompt + history.
  final _repo = PolyAIRepository();

  // Per-mission session metrics (mirrors AiBearScreen fields).
  DateTime? _sessionStartTime;
  int _turnCount = 0;
  final List<String> _emotionsPerTurn = [];
  final StringBuffer _fullTranscript = StringBuffer();

  // Held for report generation.
  String _currentLabel = '';
  String _currentQuestion = '';
  int _currentMissionIndex = 0;

  // ── Session lifecycle ──────────────────────────────────────────────────────

  void startMission({
    required int missionIndex,
    required String label,
    required String question,
    String memory = '',
  }) {
    _repo.clearHistory();
    _repo.primeWithTaskContext(taskTitle: label, taskDescription: question);
    if (memory.isNotEmpty) _repo.primeWithChildMemory(memory);

    _sessionStartTime = DateTime.now();
    _turnCount = 0;
    _emotionsPerTurn.clear();
    _fullTranscript.clear();

    _currentMissionIndex = missionIndex;
    _currentLabel = label;
    _currentQuestion = question;

    debugPrint('🎯 Poly mission started: $label${memory.isNotEmpty ? ' (memory injected)' : ''}');
  }

  // ── GPT response — exact same flow as OpenAIResponseController ─────────────

  Future<String> fetchResponse({
    required String transcript,
    required String childName,
    required int childAge,
    required String childCase,
  }) async {
    // Accumulate metrics (same as _handleProcessing in AiBearScreen).
    _turnCount++;
    final emotion = InputPreprocessor.classifyEmotion(transcript);
    _emotionsPerTurn.add(emotion);
    if (_fullTranscript.isNotEmpty) _fullTranscript.write(' ');
    _fullTranscript.write(transcript);

    // Build contextual prompt — same as OpenAIResponseController.getResponse().
    final taskContext = _currentLabel.isNotEmpty
        ? 'Specialist task: $_currentLabel — $_currentQuestion'
        : '';

    final contextualPrompt = InputPreprocessor.buildPrompt(
      transcript,
      'en',
      taskContext: taskContext,
      childName: childName,
      childAge: childAge,
      childCase: childCase,
    );

    debugPrint('📝 Poly missions prompt:\n$contextualPrompt');

    final response = await _repo.fetchAnswer(contextualPrompt);
    debugPrint('✅ Poly response: $response');

    return response;
  }

  // ── Report — exact same flow as _handleDone in AiBearScreen ───────────────

  Future<void> generateAndSaveReport({required int childId}) async {
    if (_fullTranscript.isEmpty) {
      debugPrint('⚠️ No transcript — skipping report for: $_currentLabel');
      return;
    }

    debugPrint(
      '✅ Done — task: $_currentMissionIndex | turns: $_turnCount '
      '| transcript: "${_fullTranscript.toString().trim()}"',
    );

    final duration = _sessionStartTime != null
        ? DateTime.now().difference(_sessionStartTime!).inSeconds
        : 0;

    final wordCount =
        _fullTranscript.toString().trim().split(RegExp(r'\s+')).length;

    try {
      final report = await _repo.generateReport(
        taskId: _currentMissionIndex,
        taskTitle: _currentLabel,
        taskDescription: _currentQuestion,
        transcript: _fullTranscript.toString(),
        durationSeconds: duration,
        turnCount: _turnCount,
        emotionsPerTurn: List.from(_emotionsPerTurn),
        wordCount: wordCount,
      );
      debugPrint('📊 Report generated → $report');

      if (childId > 0) {
        await SessionRepository().saveAvatarReport(
          childId: childId,
          avatarReport: report,
        );
        debugPrint('✅ Report saved to backend');
      }
    } catch (e) {
      debugPrint('❌ Report save failed: $e');
    }
  }

  // ── Memory ────────────────────────────────────────────────────────────────

  /// Generates a concise updated memory string combining [existingMemory] with
  /// this session's data. Uses GPT-4.1 mini — fast and cheap for summarization.
  Future<String> generateUpdatedMemory({required String existingMemory}) async {
    if (_fullTranscript.isEmpty) return existingMemory;

    final dominantEmotion = _emotionsPerTurn.isEmpty
        ? 'calm'
        : (() {
            final counts = <String, int>{};
            for (final e in _emotionsPerTurn) {
              counts[e] = (counts[e] ?? 0) + 1;
            }
            return counts.entries
                .reduce((a, b) => a.value >= b.value ? a : b)
                .key;
          })();

    final prompt = '''
Update the child memory log for a therapy companion app.
Be very concise. Plain text only. Max 5 lines total.
Each line = one past session. Newest session goes at the top.
Focus on: what was hard, what went well, emotional state, any notable words the child used.
Do NOT include dates, names, or bullet points.

New session:
- Mission: $_currentLabel
- Transcript: "${_fullTranscript.toString().trim()}"
- Turns: $_turnCount
- Dominant emotion: $dominantEmotion

Previous memory (keep relevant lines, drop oldest if over 5 lines):
${existingMemory.isEmpty ? 'None' : existingMemory}

Output the full updated memory now:''';

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Env.openAiApiKey}',
      },
      body: jsonEncode({
        'model': 'gpt-4.1-mini',
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 120,
        'temperature': 0.3,
      }),
    );

    if (response.statusCode != 200) {
      debugPrint('❌ Memory generation failed: ${response.statusCode}');
      return existingMemory;
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final updated = ((body['choices'] as List).first
            as Map<String, dynamic>)['message']['content']
        .toString()
        .trim();

    debugPrint('💾 Memory updated:\n$updated');
    return updated;
  }

  // ── TTS ───────────────────────────────────────────────────────────────────

  /// Exposes player state so the avatar widget can animate in sync with audio.
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// Synthesizes [text] and awaits full playback before returning.
  Future<void> speakAndWait(String text) async {
    try {
      final bytes = await _ttsApi.synthesizeText(text, 'en-US');
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/pm_tts.mp3');
      await file.writeAsBytes(bytes);

      final completer = Completer<void>();
      // Guard: only complete on idle/completed after we have confirmed the
      // player actually started playing. Without this, setAudioSource() briefly
      // emits ProcessingState.idle and the completer fires before audio begins.
      bool hasPlayed = false;
      late StreamSubscription sub;
      sub = _player.playerStateStream.listen((s) {
        if (s.playing) hasPlayed = true;
        if (!completer.isCompleted &&
            hasPlayed &&
            (s.processingState == ProcessingState.completed ||
                s.processingState == ProcessingState.idle)) {
          completer.complete();
          sub.cancel();
        }
      });

      await _player.setAudioSource(AudioSource.uri(Uri.file(file.path)));
      _player.play();

      await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          if (!completer.isCompleted) completer.complete();
        },
      );
    } catch (_) {
      // Non-blocking — cubit still advances the phase.
    }
  }

  void stopAudio() => _player.stop();

  void dispose() => _player.dispose();
}
