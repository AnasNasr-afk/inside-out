
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import '../helpers/shared_pref.dart';
import '../helpers/shared_pref_keys.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const String _baseUrl = AppConstants.baseUrl;

  // ── GET ────────────────────────────────────────────────
  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    debugPrint('GET $uri');
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  // ── POST ───────────────────────────────────────────────
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    debugPrint('POST $uri');
    debugPrint('BODY ${jsonEncode(body)}');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // ── PATCH ──────────────────────────────────────────────
  Future<dynamic> patch(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    debugPrint('PATCH $uri');
    if (body != null) debugPrint('BODY ${jsonEncode(body)}');
    final response = await http.patch(
      uri,
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  // ── DELETE ─────────────────────────────────────────────
  Future<dynamic> delete(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    debugPrint('DELETE $uri');
    final response = await http.delete(uri, headers: _headers);
    return _handleResponse(response);
  }

  // ── Headers ────────────────────────────────────────────
  Map<String, String> get _headers {
    final token = SharedPrefHelper.getString(SharedPrefKeys.token);
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

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