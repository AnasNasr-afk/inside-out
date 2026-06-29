import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:patient/presentation/poly_missions/data/discussed_tasks_cache.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/models/task_model.dart';
import 'package:patient/core/networking/repositories/tasks_repo.dart';
import 'package:patient/core/services/notification_service.dart' show kDemoMode;
import 'package:patient/presentation/child_mood/child_mode_sounds.dart';
import 'package:patient/presentation/poly_missions/cubit/poly_missions_service.dart';
import 'package:patient/presentation/poly_missions/data/poly_coins_repository.dart';
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
  static const int _dailyMissionLimit = 3;
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

    // Restore the saved conversation language (defaults to English).
    final savedLang = SharedPrefHelper.getString('pm_language_$_childId');
    if (savedLang.isNotEmpty && savedLang != state.language) {
      emit(state.copyWith(language: savedLang));
    }

    _localDiscussed = DiscussedTasksCache.load(_childId);
    // Show the local mirror instantly, then reconcile with Firestore so the
    // total is consistent across devices.
    final savedCoins = PolyCoinsRepository.instance.localCoins(_childId);
    if (savedCoins > 0) emit(state.copyWith(totalCoins: savedCoins));
    _syncCoins();

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
      // Eligible missions = completed, non-game tasks (any due date). Served
      // first-completed-first so the daily batch behaves like a FIFO line.
      _allTasks = all.where((t) => t.isCompleted && !t.isGameTask).toList()
        ..sort(_byCompletionOrder);

      debugPrint('🎯 ── Poly Missions: task → mission build ──');
      debugPrint('🎯 fetched ${all.length} tasks, '
          '${_allTasks.length} eligible (completed & not a game)');
      debugPrint('🎯 discussed (drained) so far: $_localDiscussed');
      debugPrint('🎯 FIFO order (by completedAt):');
      for (final t in _allTasks) {
        final when = t.completedAt?.toIso8601String() ??
            '${t.assignedDate.toIso8601String()} (assigned-fallback)';
        final drained = _localDiscussed.contains(t.taskId) ? ' [drained]' : '';
        debugPrint('🎯   #${t.taskId} "${t.title}" completed=$when$drained');
      }

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
        debugPrint("🎯 restored today's frozen batch: "
            '${_currentBatch.map((t) => '#${t.taskId}').toList()} '
            '(saved ids: $_todaysBatchIds)');
      } else {
        debugPrint('🎯 no saved batch for today — building fresh');
      }

      // Fill any open slots up to the daily cap with the next undiscussed
      // tasks (FIFO), preserving missions already shown today and their order.
      // Covers a fresh day, first launch, mid-day completions, and a batch
      // that shrank because a task became ineligible.
      final beforeTopUp = _currentBatch.length;
      _topUpBatch();
      debugPrint('🎯 batch after top-up (cap $_dailyMissionLimit): '
          '${_currentBatch.map((t) => '#${t.taskId} ${t.title}').toList()} '
          '(was $beforeTopUp slot(s) before top-up)');
      _todaysBatchIds = _currentBatch.map((t) => t.taskId).toList();
      if (_currentBatch.isNotEmpty) _saveDailyBatch();

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

  /// Fills the current batch up to the daily cap with the next undiscussed
  /// eligible tasks (FIFO), without disturbing missions already shown today
  /// or their order. Never exceeds [_dailyMissionLimit] distinct missions.
  void _topUpBatch() {
    if (_currentBatch.length >= _dailyMissionLimit) {
      debugPrint('🎯 top-up skipped — batch already full '
          '(${_currentBatch.length}/$_dailyMissionLimit)');
      return;
    }
    final inBatch = _currentBatch.map((t) => t.taskId).toSet();
    for (final task in _allTasks) {
      if (_currentBatch.length >= _dailyMissionLimit) break;
      if (inBatch.contains(task.taskId)) continue;
      if (_localDiscussed.contains(task.taskId)) continue;
      _currentBatch.add(task);
      inBatch.add(task.taskId);
      debugPrint('🎯 top-up filled slot ${_currentBatch.length} '
          'with #${task.taskId} "${task.title}"');
    }
  }

  /// FIFO line order — earliest completion first (assignedDate as fallback
  /// when an API record has no completedAt timestamp).
  int _byCompletionOrder(TaskModel a, TaskModel b) {
    final aWhen = a.completedAt ?? a.assignedDate;
    final bWhen = b.completedAt ?? b.assignedDate;
    return aWhen.compareTo(bWhen);
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
    // The specialist's task brief — used for GPT context and the report,
    // not spoken aloud.
    final brief = task.description.trim().isNotEmpty
        ? task.description
        : task.title;

    PolyMissionsService.instance.startMission(
      missionIndex: task.taskId,
      label: task.title,
      question: brief,
      memory: _childMemory,
    );

    emit(state.copyWith(
      phase: PmPhase.focus,
      currentIndex: index,
      polyIsTalking: true,
      clearPraise: true,
    ));

    // Spoken flow: greet and name the task, then ask a reflective question
    // that gets the child talking about what was hard or what they enjoyed.
    _greetThenAsk(_greeting(task.title), _reflectiveQuestion(task.title));
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
      debugPrint('🎯 mission completed → draining task #$taskId '
          '"${_currentBatch[state.currentIndex!].title}" '
          '(will not return as a mission). Discussed now: $_localDiscussed');
    }

    // Persist earned coins — atomic Firestore increment + local mirror.
    final newCoins = state.totalCoins + 10;
    debugPrint('🪙 awarding +10 coins: ${state.totalCoins} → $newCoins '
        '(childId $_childId)');
    PolyCoinsRepository.instance.addCoins(_childId, 10, state.totalCoins);

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
    final lang = state.language;
    // Step 1 — warm greeting naming the task.
    await PolyMissionsService.instance.speakAndWait(greeting, lang: lang);
    if (isClosed || state.phase != PmPhase.focus) return;

    // Step 2 — reflective question that gets the child talking about what was
    // hard or what they enjoyed.
    await PolyMissionsService.instance.speakAndWait(question, lang: lang);
    if (isClosed) return;

    if (state.phase == PmPhase.focus) {
      emit(state.copyWith(polyIsTalking: false));
    }
  }

  // ── STT ───────────────────────────────────────────────────────────────────

  Future<void> _ensureSttReady() async {
    if (_sttReady) return;
    try {
      _sttReady = await _stt.initialize(
        onError: _onSttError,
        onStatus: _onSttStatus,
      );
    } catch (e) {
      // Never let a speech-engine init failure crash the app.
      debugPrint('⚠️ Speech recognition init failed: $e');
      _sttReady = false;
    }
  }

  void _listenStt() async {
    // DEMO / simulator-safe path: the iOS Simulator's microphone + speech stack
    // (AVAudioEngine / SFSpeechRecognizer) is unreliable and can hard-crash the
    // app. In demo mode we skip native speech recognition entirely and seed a
    // canned transcript so the mission flow still works for screen recording.
    if (kDemoMode) {
      _transcript = state.language == 'ar'
          ? 'المهمة كانت حلوة بس صعبة شوية، وفرحت إني خلصتها'
          : 'The task was fun but a little hard, and I felt happy I finished it';
      return;
    }
    try {
      await _ensureSttReady();
      if (!_sttReady || _stopping || isClosed) return;
      await _stt.listen(
        onResult: _onSttResult,
        localeId: state.language == 'ar' ? 'ar-EG' : 'en-US',
        listenFor: const Duration(seconds: 60),
      );
    } catch (e) {
      // Swallow native speech errors — recording simply yields no transcript,
      // and the analyze step already falls back gracefully.
      debugPrint('⚠️ Speech recognition unavailable: $e');
    }
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
        language: state.language,
      );
    } catch (e) {
      debugPrint('❌ OpenAI error: $e');
      final idx = state.currentIndex;
      response = idx != null
          ? _fallbackFor(idx)
          : (state.language == 'ar' ? 'برافو عليك! 🌟' : 'Great job! 🌟');
    }

    if (isClosed) return;
    emit(state.copyWith(
      phase: PmPhase.response,
      currentPraise: response,
      polyIsTalking: true,
    ));

    await PolyMissionsService.instance.speakAndWait(response, lang: state.language);

    if (isClosed) return;
    if (state.phase == PmPhase.response) {
      emit(state.copyWith(polyIsTalking: false));
    }
  }

  // ── Language ──────────────────────────────────────────────────────────────

  /// Toggles the conversation language between English and Egyptian Arabic
  /// and persists the choice per child.
  void toggleLanguage() {
    final next = state.language == 'ar' ? 'en' : 'ar';
    SharedPrefHelper.setData('pm_language_$_childId', next);
    debugPrint('🌐 language → $next');
    emit(state.copyWith(language: next));
  }

  // ── Coins ─────────────────────────────────────────────────────────────────

  /// Reconciles the in-memory coin total with the cross-device Firestore value.
  Future<void> _syncCoins() async {
    debugPrint('🪙 syncing coins for childId $_childId '
        '(local shown: ${state.totalCoins})');
    final coins = await PolyCoinsRepository.instance.fetchCoins(_childId);
    if (!isClosed && coins != state.totalCoins) {
      debugPrint('🪙 reconciled coins: ${state.totalCoins} → $coins '
          '(Firestore is source of truth)');
      emit(state.copyWith(totalCoins: coins));
    } else {
      debugPrint('🪙 coins already in sync at $coins');
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

  /// Warm greeting naming the picked task, in the active language.
  String _greeting(String title) {
    if (state.language == 'ar') {
      return _childName.isNotEmpty
          ? 'أهلاً يا $_childName! اخترت $title.'
          : 'اخترت $title.';
    }
    return _childName.isNotEmpty
        ? 'Hi $_childName! You picked $title.'
        : 'You picked $title.';
  }

  /// A warm, reflective question about a task the child just completed. Varies
  /// by task title so repeated visits do not feel scripted, and always invites
  /// the child to share what was hard or what they enjoyed.
  String _reflectiveQuestion(String title) {
    final questions = state.language == 'ar'
        ? <String>[
            'إيه أصعب حاجة في $title؟',
            'إنت عملت $title! كان فيه جزء صعب؟',
            'لما عملت $title، إيه أكتر جزء عجبك؟',
            'احكيلي عن $title. إيه اللي كان صعب وإيه اللي كان حلو؟',
          ]
        : <String>[
            'What was the hardest part of $title for you?',
            'You did $title! Was any part of it tricky?',
            'When you did $title, what part did you like the most?',
            'Tell me about $title. What felt hard, and what felt fun?',
          ];
    return questions[title.hashCode.abs() % questions.length];
  }

  String _fallbackFor(int i) {
    if (state.language == 'ar') {
      return i < _currentBatch.length
          ? 'مجهود حلو في ${_currentBatch[i].title}! إنت بتعمل كويس جداً! 🌟'
          : 'برافو عليك! 🌟';
    }
    return i < _currentBatch.length
        ? 'Great effort with ${_currentBatch[i].title}! You are doing really well! 🌟'
        : 'Great job! 🌟';
  }

  @override
  Future<void> close() {
    _recTimer?.cancel();
    _stt.cancel();
    PolyMissionsService.instance.stopAudio();
    return super.close();
  }
}
