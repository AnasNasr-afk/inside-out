import 'package:flutter/services.dart';

class GameHaptics {
  static void onCorrect() => HapticFeedback.lightImpact();
  static void onWrong() => HapticFeedback.mediumImpact();
  static void onComplete() => HapticFeedback.heavyImpact();
}
