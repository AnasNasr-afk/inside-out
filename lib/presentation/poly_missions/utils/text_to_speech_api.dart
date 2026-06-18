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
  Future<List<int>> synthesizeText(
      String text,
      String lang,
      ) async {
    final uri = Uri.parse(
      '$_baseUrl/text:synthesize?key=$_apiKey',
    );

    // ── Language selection ─────────────────────────
    final languageCode = switch (lang) {
      'ar' => 'ar-XA',
      'jp' => 'ja-JP',
      _ => 'en-US',
    };

    final voiceName = switch (lang) {
      'ar' => 'ar-XA-Wavenet-B', // Male, warm — closest to Egyptian Arabic
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