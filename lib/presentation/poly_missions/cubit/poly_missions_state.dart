part of 'poly_missions_cubit.dart';

enum PmPhase { pick, focus, recording, analyzing, response, celebration }

class PolyMissionsState {
  final PmPhase phase;
  final int? currentIndex;
  final Set<String> done;
  final int recSeconds;
  final String? currentPraise;
  final bool polyIsTalking;
  final List<TaskModel> tasks;
  final bool isLoadingTasks;
  final int totalCoins;

  /// Conversation language: 'en' (English) or 'ar' (Egyptian Arabic).
  final String language;

  const PolyMissionsState({
    this.phase = PmPhase.pick,
    this.currentIndex,
    this.done = const {},
    this.recSeconds = 0,
    this.currentPraise,
    this.polyIsTalking = false,
    this.tasks = const [],
    this.isLoadingTasks = true,
    this.totalCoins = 0,
    this.language = 'en',
  });

  /// True when this is the last undone task in the batch.
  bool get allDone =>
      tasks.isNotEmpty && done.length >= tasks.length - 1;

  PolyMissionsState copyWith({
    PmPhase? phase,
    int? currentIndex,
    Set<String>? done,
    int? recSeconds,
    String? currentPraise,
    bool? polyIsTalking,
    List<TaskModel>? tasks,
    bool? isLoadingTasks,
    int? totalCoins,
    String? language,
    bool clearCurrentIndex = false,
    bool clearPraise = false,
  }) {
    return PolyMissionsState(
      phase: phase ?? this.phase,
      currentIndex:
          clearCurrentIndex ? null : (currentIndex ?? this.currentIndex),
      done: done ?? this.done,
      recSeconds: recSeconds ?? this.recSeconds,
      currentPraise: clearPraise ? null : (currentPraise ?? this.currentPraise),
      polyIsTalking: polyIsTalking ?? this.polyIsTalking,
      tasks: tasks ?? this.tasks,
      isLoadingTasks: isLoadingTasks ?? this.isLoadingTasks,
      totalCoins: totalCoins ?? this.totalCoins,
      language: language ?? this.language,
    );
  }
}
