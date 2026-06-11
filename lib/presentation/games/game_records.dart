import 'package:shared_preferences/shared_preferences.dart';

class GameRecords {
  static Future<({int? moves, int? seconds})> load(String gameKey) async {
    final prefs = await SharedPreferences.getInstance();
    return (
      moves: prefs.getInt('best_moves_$gameKey'),
      seconds: prefs.getInt('best_time_$gameKey'),
    );
  }

  // Saves only if this attempt is strictly better (fewer moves, or same moves faster).
  static Future<void> save(String gameKey, int moves, int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    final bestMoves = prefs.getInt('best_moves_$gameKey');
    final bestSeconds = prefs.getInt('best_time_$gameKey');

    final isFirstRecord = bestMoves == null;
    final isBetterMoves = bestMoves != null && moves < bestMoves;
    final isSameMovesFaster = bestMoves != null &&
        moves == bestMoves &&
        seconds < (bestSeconds ?? 999999);

    if (isFirstRecord || isBetterMoves || isSameMovesFaster) {
      await prefs.setInt('best_moves_$gameKey', moves);
      await prefs.setInt('best_time_$gameKey', seconds);
    }
  }

  static String formatTime(int seconds) {
    if (seconds >= 300) return '5m+';
    if (seconds < 60) return '${seconds}s';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m}m ${s}s';
  }
}
