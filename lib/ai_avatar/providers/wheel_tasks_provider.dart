import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patient/ai_avatar/data/discussed_tasks_cache.dart';
import 'package:patient/core/models/task_model.dart';
import 'package:patient/core/networking/repositories/tasks_repo.dart';

class WheelTasksNotifier
    extends StateNotifier<AsyncValue<List<TaskModel>>> {
  WheelTasksNotifier() : super(const AsyncValue.loading());

  Future<void> load(int childId) async {
    if (childId <= 0) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final all = await TaskRepository().getTasks(childId);
      final completed = all.where((t) => t.isCompleted).toList();
      final backendIds = completed.map((t) => t.taskId).toSet();

      // Prune stale discussed IDs whose tasks no longer exist in backend
      final discussed = DiscussedTasksCache.load(childId);
      final valid = discussed.intersection(backendIds);
      if (valid.length != discussed.length) {
        await DiscussedTasksCache.save(childId, valid);
      }

      final wheel =
          completed.where((t) => !valid.contains(t.taskId)).toList();
      state = AsyncValue.data(wheel);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Removes the task from the wheel immediately (optimistic) then persists.
  Future<void> dismiss(int taskId, int childId) async {
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(
      current.where((t) => t.taskId != taskId).toList(),
    );
    await DiscussedTasksCache.add(taskId, childId);
  }
}

final wheelTasksProvider = StateNotifierProvider.autoDispose<
    WheelTasksNotifier, AsyncValue<List<TaskModel>>>(
  (_) => WheelTasksNotifier(),
);
