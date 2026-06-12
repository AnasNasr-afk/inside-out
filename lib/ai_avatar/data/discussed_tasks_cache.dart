import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';

/// Persists the set of task IDs the child has already discussed with Poly.
/// All reads are synchronous (SharedPrefs is pre-loaded); all writes are async.
class DiscussedTasksCache {
  DiscussedTasksCache._();

  static String _key(int childId) =>
      '${SharedPrefKeys.discussedTaskIdsPrefix}$childId';

  static Set<int> load(int childId) {
    final raw = SharedPrefHelper.getString(_key(childId));
    if (raw.isEmpty) return {};
    return raw.split(',').map(int.parse).toSet();
  }

  static Future<void> add(int taskId, int childId) async {
    final ids = load(childId)..add(taskId);
    await _write(childId, ids);
  }

  /// Overwrites the full set — used for stale-ID cleanup on load.
  static Future<void> save(int childId, Set<int> ids) => _write(childId, ids);

  static Future<void> clear(int childId) =>
      SharedPrefHelper.setData(_key(childId), '');

  static Future<void> _write(int childId, Set<int> ids) =>
      SharedPrefHelper.setData(
        _key(childId),
        ids.isEmpty ? '' : ids.map((e) => e.toString()).join(','),
      );
}
