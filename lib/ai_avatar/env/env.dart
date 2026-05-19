import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get googleCloudApiKey => dotenv.env['GOOGLE_CLOUD_API_KEY'] ?? '';
}
