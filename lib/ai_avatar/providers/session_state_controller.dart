import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patient/core/models/task_model.dart';

enum SessionPhase { idle, greeting, listening, processing, responded }

class SessionState {
  final SessionPhase phase;
  final TaskModel? selectedTask;
  final String transcript;
  final String childName;

  const SessionState({
    this.phase = SessionPhase.idle,
    this.selectedTask,
    this.transcript = '',
    this.childName = '',
  });

  SessionState copyWith({
    SessionPhase? phase,
    TaskModel? selectedTask,
    String? transcript,
    String? childName,
  }) {
    return SessionState(
      phase: phase ?? this.phase,
      selectedTask: selectedTask ?? this.selectedTask,
      transcript: transcript ?? this.transcript,
      childName: childName ?? this.childName,
    );
  }
}

class SessionStateController extends StateNotifier<SessionState> {
  SessionStateController() : super(const SessionState());

  void selectTask(TaskModel task, {String childName = ''}) {
    state = SessionState(
      phase: SessionPhase.greeting,
      selectedTask: task,
      childName: childName,
    );
  }

  void startListening() {
    state = state.copyWith(phase: SessionPhase.listening);
  }

  void submitTranscript(String transcript) {
    state = state.copyWith(
      phase: SessionPhase.processing,
      transcript: transcript,
    );
  }

  void setResponded() {
    state = state.copyWith(phase: SessionPhase.responded);
  }

  void reset() {
    state = const SessionState();
  }
}

final sessionStateControllerProvider =
    StateNotifierProvider<SessionStateController, SessionState>(
  (ref) => SessionStateController(),
);
