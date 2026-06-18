import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:patient/core/env/env.dart';

class Voice {
  final String name;
  final String languageCode;
  final String ssmlGender;

  Voice({
    required this.name,
    required this.languageCode,
    required this.ssmlGender,
  });

  factory Voice.fromJson(Map<String, dynamic> json) {
    return Voice(
      name: json['name'] as String? ?? '',
      languageCode:
      (json['languageCodes'] as List?)
          ?.firstOrNull as String? ??
          '',
      ssmlGender:
      json['ssmlGender'] as String? ?? '',
    );
  }
}

extension _ListExt<T> on List<T> {
  T? get firstOrNull =>
      isEmpty ? null : first;
}

class TextToSpeechAPI {
  static const String _baseUrl =
      'https://texttospeech.googleapis.com/v1';

  String get _apiKey =>
      Env.googleCloudApiKey;

  // ── Fetch available voices ──────────────────────────
  Future<List<Voice>> getVoices() async {
    final uri = Uri.parse(
      '$_baseUrl/voices?key=$_apiKey',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'getVoices failed: '
            '${response.statusCode} ${response.body}',
      );
    }

    final body =
    jsonDecode(response.body)
    as Map<String, dynamic>;

    final voices =
        (body['voices'] as List?) ??
            const [];

    return voices
        .map(
          (v) => Voice.fromJson(
        v as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  // ── Generate speech audio ───────────────────────────
  /// Returns MP3 bytes for [text]. Arabic is routed to OpenAI TTS for an
  /// Egyptian accent; English/Japanese stay on Google Cloud TTS.
  Future<List<int>> synthesizeText(String text, String lang) async {
    if (lang == 'ar') {
      return _synthesizeOpenAI(text);
    }
    return _synthesizeGoogle(text, lang);
  }

  // ── OpenAI TTS — Egyptian Arabic ─────────────────────
  // Voice to use for Arabic. 'shimmer' is one of the softest, gentlest voices
  // (less sharp than 'coral'). Other soft options to A/B test: 'sage', 'nova'.
  static const String _arabicVoice = 'shimmer';

  // Detailed Cairo-dialect pronunciation guidance — far more effective than a
  // generic "speak Arabic" instruction at steering the accent.
  static const String _egyptianInstructions =
      'You are Dooby, a soft-spoken cartoon bear talking to a young Egyptian child. '
      'Speak ONLY in natural spoken Egyptian Arabic, the Cairo dialect '
      '(عامية مصرية القاهرية) — never Modern Standard Arabic (فصحى). '
      'Pronounce the letter ج as a hard English "g" (as in "go", never "j"). '
      'Pronounce ق as a glottal stop (hamza). Pronounce ث as "s". '
      'Use everyday Egyptian street words and intonation. '
      'Tone: very soft, gentle, calm and soothing — like a tender lullaby or a '
      'caring mother comforting a small child. Keep your voice low, warm and '
      'mellow. Never sharp, loud, bright, or excited. '
      'Speak slowly and softly, with gentle pauses, as if talking to a 5-year-old.';

  /// gpt-4o-mini-tts with an accent instruction. Returns raw MP3 bytes.
  Future<List<int>> _synthesizeOpenAI(String text) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/audio/speech'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Env.openAiApiKey}',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini-tts',
        'input': text,
        'voice': _arabicVoice,
        'instructions': _egyptianInstructions,
        'response_format': 'mp3',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'OpenAI TTS failed: ${response.statusCode} ${response.body}',
      );
    }

    return response.bodyBytes;
  }

  // ── Google Cloud TTS — English / Japanese ────────────
  Future<List<int>> _synthesizeGoogle(String text, String lang) async {
    final uri = Uri.parse(
      '$_baseUrl/text:synthesize?key=$_apiKey',
    );

    final languageCode = switch (lang) {
      'jp' => 'ja-JP',
      _ => 'en-US',
    };

    final voiceName = switch (lang) {
      'jp' => 'ja-JP-Neural2-B',
      _ => 'en-US-Neural2-J',
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'input': {
          'text': text,
        },

        'voice': {
          'languageCode': languageCode,
          'name': voiceName,
        },

        'audioConfig': {
          'audioEncoding': 'MP3',

          // Slightly deeper voice
          'pitch': -2.0,

          // Slower and friendlier for kids
          'speakingRate': 0.9,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'synthesizeText failed: '
            '${response.statusCode} ${response.body}',
      );
    }

    final body =
    jsonDecode(response.body)
    as Map<String, dynamic>;

    final audioContent =
    body['audioContent'] as String;

    return base64Decode(audioContent);
  }
}