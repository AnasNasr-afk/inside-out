import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const String _baseUrl = AppConstants.baseUrl;

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    debugPrint('GET $uri');

    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }




  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };

  // ── Response handler ───────────────────────────────────
  dynamic _handleResponse(http.Response response) {
    debugPrint('Response ${response.statusCode}: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: _parseError(response.body),
    );
  }

  String _parseError(String body) {
    try {
      final json = jsonDecode(body);
      return json['message'] ?? json['error'] ?? 'Unknown error';
    } catch (_) {
      return body.isNotEmpty ? body : 'Unknown error';
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}