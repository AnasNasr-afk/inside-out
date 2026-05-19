import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  SharedPrefHelper._();

  static late SharedPreferences _prefs;

  // Call this once in main() before runApp
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint('✅ SharedPreferences initialized');
  }

  static Future<void> removeData(String key) async {
    await _prefs.remove(key);
    debugPrint('🗑️ Removed key: $key');
  }

  static Future<void> clearAllData() async {
    await _prefs.clear();
    debugPrint('🧹 Cleared all SharedPreferences');
  }

  static Future<void> setData(String key, dynamic value) async {
    debugPrint('💾 Saving "$key" = "$value"');
    switch (value.runtimeType) {
      case const (String):  await _prefs.setString(key, value); break;
      case const (bool):    await _prefs.setBool(key, value);   break;
      case const (int):     await _prefs.setInt(key, value);    break;
      case const (double):  await _prefs.setDouble(key, value); break;
      default:
        throw Exception('Unsupported type for key: $key');
    }
  }

  // ── Now all reads are SYNCHRONOUS — no await needed ──────
  static String getString(String key) {
    final result = _prefs.getString(key) ?? '';
    debugPrint('📤 getString "$key" → "$result"');
    return result;
  }

  static bool getBool(String key) => _prefs.getBool(key) ?? false;
  static int getInt(String key) => _prefs.getInt(key) ?? 0;
  static double getDouble(String key) => _prefs.getDouble(key) ?? 0.0;
}