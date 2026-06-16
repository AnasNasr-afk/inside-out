import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:patient/ai_avatar/data/discussed_tasks_cache.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/models/task_model.dart';
import 'package:patient/core/networking/repositories/tasks_repo.dart';
import 'package:patient/presentation/child_mood/child_mode_sounds.dart';
import 'package:patient/presentation/poly_missions/cubit/poly_missions_service.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'poly_missions_state.dart';

class PolyMissionsCubit extends Cubit<PolyMissionsState> {
  PolyMissionsCubit() : super(const PolyMissionsState()) {
    ChildModeSounds.instance.init();
    _loadChildProfile();
  }

  // Child profile — loaded once from SharedPrefs.
  String _childName = '';
  int _childAge = 0;
  String _childCase = '';
  int _childId = 0;
  String _childMemory = '';

  // Task batch state.
  List<TaskModel> _allTasks = [];
  List<TaskModel> _currentBatch = [];
  Set<int> _localDiscussed = {};
  List<int> _todaysBatchIds = []; // taskIds saved for today's daily batch

  final SpeechToText _stt = SpeechToText();
  bool _sttReady = false;
  bool _stopping = false;
  String _transcript = '';

  Timer? _recTimer;

  // ── Init ───────────────────────────────────────────────────────────────────

  void _loadChildProfile() {
    _childName = SharedPrefHelper.getString(SharedPrefKeys.childName);
    _childAge = SharedPrefHelper.getInt(SharedPrefKeys.childAge);
    _childCase = SharedPrefHelper.getString(SharedPrefKeys.childCase);
    _childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);
    _childMemory = SharedPrefHelper.getString('pm_memory_$_childId');

    _localDiscussed = DiscussedTasksCache.load(_childId);
    final savedCoins = SharedPrefHelper.getInt('pm_coins_$_childId');
    if (savedCoins > 0) emit(state.copyWith(totalCoins: savedCoins));

    // Restore today's daily batch IDs if the saved date matches today.
    final savedDate = SharedPrefHelper.getString('pm_daily_date_$_childId');
    if (savedDate == _todayString()) {
      final raw = SharedPrefHelper.getString('pm_daily_batch_$_childId');
      _todaysBatchIds = raw
          .split(',')
          .where((s) => s.isNotEmpty)
          .map(int.tryParse)
          .whereType<int>()
          .toList();
      if (_todaysBatchIds.isNotEmpty) {
        debugPrint('✅ Restored daily batch IDs: $_todaysBatchIds');
      }
    }

    if (_childMemory.isNotEmpty) {
      debugPrint('🧠 Loaded child memory:\n$_childMemory');
    }

    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    if (_childId <= 0) {
      emit(state.copyWith(isLoadingTasks: false));
      return;
    }
    try {
      final all = await TaskRepository().getTasks(_childId);
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      _allTasks = all.where((t) {
        if (!t.isCompleted || t.isGameTask) return false;
        final due = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
        return !due.isBefore(todayDate); // due date is today or in the future
      }).toList();

      if (_todaysBatchIds.isNotEmpty) {
        // Restore today's batch in the original saved order.
        _currentBatch = _todaysBatchIds
            .map((id) {
              try {
                return _allTasks.firstWhere((t) => t.taskId == id);
              } catch (_) {
                return null;
              }
            })
            .whereType<TaskModel>()
            .toList();
      }

      // If no saved batch (new day or first launch), pick fresh undiscussed tasks.
      if (_currentBatch.isEmpty) {
        _rebuildBatch();
        _saveDailyBatch();
      }

      // Restore which tasks in today's batch are already Poly-done.
      final done = _currentBatch
          .where((t) => _localDiscussed.contains(t.taskId))
          .map((t) => t.taskId.toString())
          .toSet();

      debugPrint(
        '📋 Poly tasks loaded: ${_allTasks.length} total, '
        '${_currentBatch.length} in batch, ${done.length} already done today',
      );

      if (!isClosed) {
        emit(state.copyWith(
          tasks: List.from(_currentBatch),
          done: done,
          isLoadingTasks: false,
        ));
      }
    } catch (e) {
      debugPrint('❌ Failed to fetch tasks: $e');
      if (!isClosed) emit(state.copyWith(isLoadingTasks: false));
    }
  }

  void _rebuildBatch() {
    _currentBatch = _allTasks
        .where((t) => !_localDiscussed.contains(t.taskId))
        .take(3)
        .toList();
  }

  void _saveDailyBatch() {
    SharedPrefHelper.setData(
      'pm_daily_batch_$_childId',
      _currentBatch.map((t) => t.taskId.toString()).join(','),
    );
    SharedPrefHelper.setData('pm_daily_date_$_childId', _todayString());
    debugPrint(
      '💾 Daily batch saved: ${_currentBatch.map((t) => t.title).join(', ')}',
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void pickMission(int index) {
    if (state.phase != PmPhase.pick) return;
    if (index >= _currentBatch.length) return;
    if (state.done.contains(_keyAt(index))) return;

    ChildModeSounds.instance.playTap();

    final task = _currentBatch[index];
    final question = task.description.trim().isNotEmpty
        ? task.description
        : task.title;

    PolyMissionsService.instance.startMission(
      missionIndex: task.taskId,
      label: task.title,
      question: question,
      memory: _childMemory,
    );

    emit(state.copyWith(
      phase: PmPhase.focus,
      currentIndex: index,
      polyIsTalking: true,
      clearPraise: true,
    ));

    final greeting = _childName.isNotEmpty
        ? 'Hi $_childName! You picked ${task.title}!'
        : 'You picked ${task.title}!';
    _greetThenAsk(greeting, question);
  }

  void startRecording() {
    ChildModeSounds.instance.playSparkle();
    _transcript = '';
    _stopping = false;
    emit(state.copyWith(
      phase: PmPhase.recording,
      recSeconds: 0,
      polyIsTalking: false,
    ));
    _recTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(state.copyWith(recSeconds: state.recSeconds + 1));
    });
    _listenStt();
  }

  void stopRecording() {
    _stopping = true;
    _recTimer?.cancel();
    ChildModeSounds.instance.playThud();
    if (_stt.isListening) {
      _stt.stop();
      Future.delayed(const Duration(milliseconds: 350), _enterAnalyzing);
    } else {
      _enterAnalyzing();
    }
  }

  void nextMission() {
    PolyMissionsService.instance.stopAudio();
    ChildModeSounds.instance.playChime();

    PolyMissionsService.instance.generateAndSaveReport(childId: _childId);
    _updateMemory();

    // Mark task as Poly-done — update local mirror immediately, persist async.
    if (state.currentIndex != null &&
        state.currentIndex! < _currentBatch.length) {
      final taskId = _currentBatch[state.currentIndex!].taskId;
      _localDiscussed.add(taskId);
      DiscussedTasksCache.add(taskId, _childId);
    }

    // Persist earned coins.
    final newCoins = state.totalCoins + 10;
    SharedPrefHelper.setData('pm_coins_$_childId', newCoins);

    final updated = {...state.done};
    if (state.currentIndex != null) updated.add(_keyAt(state.currentIndex!));

    if (updated.length >= _currentBatch.length && _currentBatch.isNotEmpty) {
      // Batch complete → celebrate first, then advance on user tap.
      debugPrint('🎉 Batch complete! Showing celebration.');
      emit(state.copyWith(
        phase: PmPhase.celebration,
        done: updated,
        totalCoins: newCoins,
        recSeconds: 0,
        polyIsTalking: false,
        clearCurrentIndex: true,
        clearPraise: true,
      ));
    } else {
      emit(state.copyWith(
        phase: PmPhase.pick,
        done: updated,
        totalCoins: newCoins,
        recSeconds: 0,
        polyIsTalking: false,
        clearCurrentIndex: true,
        clearPraise: true,
      ));
    }
  }

  void advanceBatch() {
    // Daily limit reached — return to pick with all tasks greyed.
    // A fresh batch will appear tomorrow (new daily batch date).
    debugPrint('🌙 All daily tasks done. See you tomorrow!');
    emit(state.copyWith(
      phase: PmPhase.pick,
      recSeconds: 0,
      polyIsTalking: false,
      clearCurrentIndex: true,
      clearPraise: true,
    ));
  }

  // ── TTS greeting + question ────────────────────────────────────────────────

  Future<void> _greetThenAsk(String greeting, String question) async {
    // Step 1 — warm greeting naming the task.
    await PolyMissionsService.instance.speakAndWait(greeting);
    if (isClosed || state.phase != PmPhase.focus) return;

    // Step 2 — task question that gets the child talking.
    await PolyMissionsService.instance.speakAndWait(question);
    if (isClosed) return;

    if (state.phase == PmPhase.focus) {
      emit(state.copyWith(polyIsTalking: false));
    }
  }

  // ── STT ───────────────────────────────────────────────────────────────────

  Future<void> _ensureSttReady() async {
    if (_sttReady) return;
    _sttReady = await _stt.initialize(
      onError: _onSttError,
      onStatus: _onSttStatus,
    );
  }

  void _listenStt() async {
    await _ensureSttReady();
    if (!_sttReady || _stopping || isClosed) return;
    await _stt.listen(
      onResult: _onSttResult,
      localeId: 'en-US',
      listenFor: const Duration(seconds: 60),
    );
  }

  void _onSttError(SpeechRecognitionError _) {
    if (state.phase == PmPhase.recording && !_stopping) {
      Future.delayed(const Duration(milliseconds: 300), _listenStt);
    }
  }

  void _onSttStatus(String status) {
    if (status == 'done' && state.phase == PmPhase.recording && !_stopping) {
      Future.delayed(const Duration(milliseconds: 300), _listenStt);
    }
  }

  void _onSttResult(SpeechRecognitionResult result) {
    if (!result.finalResult) return;
    final words = result.recognizedWords.trim();
    if (words.isNotEmpty) {
      _transcript = _transcript.isEmpty ? words : '$_transcript $words';
    }
    if (_stopping) return;
    if (state.phase == PmPhase.recording) _listenStt();
  }

  // ── Analyze + respond ──────────────────────────────────────────────────────

  void _enterAnalyzing() {
    if (isClosed) return;
    emit(state.copyWith(phase: PmPhase.analyzing));
    _callGptAndSpeak();
  }

  Future<void> _callGptAndSpeak() async {
    String response;
    try {
      response = await PolyMissionsService.instance.fetchResponse(
        transcript: _transcript,
        childName: _childName,
        childAge: _childAge,
        childCase: _childCase,
      );
    } catch (e) {
      debugPrint('❌ OpenAI error: $e');
      final idx = state.currentIndex;
      response = idx != null ? _fallbackFor(idx) : 'Great job! 🌟';
    }

    if (isClosed) return;
    emit(state.copyWith(
      phase: PmPhase.response,
      currentPraise: response,
      polyIsTalking: true,
    ));

    await PolyMissionsService.instance.speakAndWait(response);

    if (isClosed) return;
    if (state.phase == PmPhase.response) {
      emit(state.copyWith(polyIsTalking: false));
    }
  }

  // ── Memory ────────────────────────────────────────────────────────────────

  Future<void> _updateMemory() async {
    if (_childId <= 0) return;
    try {
      final updated = await PolyMissionsService.instance.generateUpdatedMemory(
        existingMemory: _childMemory,
      );
      _childMemory = updated;
      await SharedPrefHelper.setData('pm_memory_$_childId', updated);
    } catch (e) {
      debugPrint('❌ Memory update failed: $e');
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _todayString() {
    final d = DateTime.now();
    return '${d.year}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  String _keyAt(int i) =>
      i < _currentBatch.length ? _currentBatch[i].taskId.toString() : 'task_$i';

  String _fallbackFor(int i) {
    if (i < _currentBatch.length) {
      return 'Great effort with ${_currentBatch[i].title}! You are doing really well! 🌟';
    }
    return 'Great job! 🌟';
  }

  @override
  Future<void> close() {
    _recTimer?.cancel();
    _stt.cancel();
    PolyMissionsService.instance.stopAudio();
    return super.close();
  }
}
