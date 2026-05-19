import 'package:flutter/foundation.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';


class CheckInHelper {
  CheckInHelper._();

  // Today's date as a string key e.g. "2026-05-17"
  static String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}';
  }

  // Returns true if the parent already checked in today
  static bool hasCheckedInToday() {
    final saved = SharedPrefHelper.getString(SharedPrefKeys.checkInDate);
    return saved == _todayKey;
  }

  // Saves today's check-in with the selected mood (1–5)
  static Future<void> saveCheckIn(int mood) async {
    await SharedPrefHelper.setData(SharedPrefKeys.checkInDate, _todayKey);
    await SharedPrefHelper.setData(SharedPrefKeys.checkInMood, mood);
    debugPrint('✅ Check-in saved: mood=$mood date=$_todayKey');
  }

  // Returns the mood saved today, or null if not checked in
  static int? getTodayMood() {
    if (!hasCheckedInToday()) return null;
    final mood = SharedPrefHelper.getInt(SharedPrefKeys.checkInMood);
    return mood == 0 ? null : mood;
  }
}