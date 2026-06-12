import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class _CacheEntry {
  final String date;
  final String report;

  const _CacheEntry({required this.date, required this.report});

  Map<String, dynamic> toJson() => {'date': date, 'report': report};

  factory _CacheEntry.fromJson(Map<String, dynamic> json) => _CacheEntry(
        date: json['date'] as String,
        report: json['report'] as String,
      );
}

class SessionReportCache {
  SessionReportCache._();

  static String _key(int childId) => 'avatar_report_cache_$childId';

  static String get _today {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static Future<List<_CacheEntry>> _loadEntries(int childId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(childId));
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => _CacheEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveEntries(
      int childId, List<_CacheEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(childId),
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> append(int childId, String reportLine) async {
    final entries = await _loadEntries(childId);
    entries.add(_CacheEntry(date: _today, report: reportLine));
    await _saveEntries(childId, entries);
  }

  static Future<List<String>> loadAll(int childId) async {
    final entries = await _loadEntries(childId);
    return entries.map((e) => e.report).toList();
  }

  static Future<bool> hasReports(int childId) async {
    final entries = await _loadEntries(childId);
    return entries.isNotEmpty;
  }

  static Future<void> clear(int childId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(childId));
  }
}
