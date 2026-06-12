import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/ai_avatar/data/openai_repository.dart';
import 'package:patient/ai_avatar/data/session_repository.dart';
import 'package:patient/ai_avatar/data/session_report_cache.dart';
import 'package:patient/ai_avatar/presentation/animation_screen.dart';
import 'package:patient/ai_avatar/presentation/flag_switch.dart';
import 'package:patient/ai_avatar/presentation/speech_to_text.dart';
import 'package:patient/ai_avatar/presentation/spin_wheel_widget.dart';
import 'package:patient/ai_avatar/presentation/text_to_speech_cloud.dart';
import 'package:patient/ai_avatar/providers/animation_state_controller.dart';
import 'package:patient/ai_avatar/providers/openai_response_controller.dart';
import 'package:patient/ai_avatar/providers/session_state_controller.dart';
import 'package:patient/ai_avatar/providers/child_profile_provider.dart';
import 'package:patient/ai_avatar/providers/task_context_provider.dart';
import 'package:patient/ai_avatar/providers/tasks_provider.dart';
import 'package:patient/ai_avatar/utils/input_preprocessor.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/networking/repositories/tasks_repo.dart';

enum _SubmissionStatus { none, submitting, success, failed }

class AiBearScreen extends ConsumerStatefulWidget {
  const AiBearScreen({super.key});

  @override
  ConsumerState<AiBearScreen> createState() => _AiBearScreenState();
}

class _AiBearScreenState extends ConsumerState<AiBearScreen> {
  String _version = '';
  String _childName = '';

  // ── Per-session metrics ────────────────────────────────────────────────────
  DateTime? _sessionStartTime;
  int _turnCount = 0;
  final List<String> _emotionsPerTurn = [];
  final StringBuffer _fullTranscript = StringBuffer();
  Future<void>? _pendingCacheWrite;
  _SubmissionStatus _submissionStatus = _SubmissionStatus.none;

  @override
  void initState() {
    super.initState();
    _getAppVersion();
    _loadChildData();
  }

  Future<void> _getAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() => _version = 'v${info.version}+${info.buildNumber}');
    } catch (_) {
      if (!mounted) return;
      setState(() => _version = 'v1.0.0+1');
    }
  }

  Future<void> _loadChildData() async {
    final name = SharedPrefHelper.getString(SharedPrefKeys.childName);
    final age  = SharedPrefHelper.getInt(SharedPrefKeys.childAge);
    final medicalCase = SharedPrefHelper.getString(SharedPrefKeys.childCase);

    if (name.isNotEmpty && mounted) {
      setState(() => _childName = name);
    }

    // Yield past the current build frame before writing to providers
    await Future.value();
    if (!mounted) return;

    ref.read(childProfileProvider.notifier).state = ChildProfile(
      name: name,
      age: age,
      medicalCase: medicalCase,
    );

    debugPrint('👤 Child profile: $name, age $age, case "$medicalCase"');

    try {
      final childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);
      if (childId <= 0) {
        ref.read(tasksLoadingProvider.notifier).state = false;
        return;
      }

      final tasks = await TaskRepository().getTasks(childId);
      if (!mounted) return;

      // Filter out tasks the child already dismissed locally
      final dismissedKey = '${SharedPrefKeys.completedTaskIdsPrefix}$childId';
      final dismissedStr = SharedPrefHelper.getString(dismissedKey);
      var dismissedIds = dismissedStr.isEmpty
          ? <int>{}
          : dismissedStr.split(',').map(int.parse).toSet();

      // Remove stale dismissed IDs that no longer exist in backend
      final backendTaskIds = tasks.map((t) => t.taskId).toSet();
      final validDismissed = dismissedIds.intersection(backendTaskIds);
      if (validDismissed.length != dismissedIds.length) {
        dismissedIds = validDismissed;
        SharedPrefHelper.setData(
          dismissedKey,
          validDismissed.isEmpty ? '' : validDismissed.map((id) => id.toString()).join(','),
        );
        debugPrint('🧹 Cleaned stale dismissed task IDs');
      }

      final filteredTasks = dismissedIds.isEmpty
          ? tasks
          : tasks.where((t) => !dismissedIds.contains(t.taskId)).toList();

      final activeTasks = filteredTasks.where((t) => t.isCompleted).toList();
      final contextSummary = activeTasks.isEmpty
          ? ''
          : 'Specialist tasks: ${activeTasks.map((t) => t.description.isNotEmpty ? '${t.title} (${t.description})' : t.title).join(' | ')}';

      // Retry: if wheel is already empty but a previous submission failed, retry now
      if (filteredTasks.isEmpty && await SessionReportCache.hasReports(childId)) {
        debugPrint('🔄 Wheel empty on open with cached reports — retrying submission');
        _submitCachedReports();
      }

      ref.read(tasksProvider.notifier).state = filteredTasks;
      ref.read(taskContextProvider.notifier).state = contextSummary;
      ref.read(tasksLoadingProvider.notifier).state = false;
      debugPrint('📋 Tasks loaded (${tasks.length}): $contextSummary');
    } catch (e) {
      ref.read(tasksLoadingProvider.notifier).state = false;
      debugPrint('📋 Tasks unavailable: $e');
    }
  }

  // ── Session orchestration ──────────────────────────────────────────────────

  void _handleGreeting(SessionState session) {
    final task = session.selectedTask;
    if (task == null) return;

    _sessionStartTime = DateTime.now();
    _turnCount = 0;
    _emotionsPerTurn.clear();
    _fullTranscript.clear();

    final repo = ref.read(openAIRepostitoryProvider);
    repo.clearHistory();

    if (task.taskId != -1 && task.description.isNotEmpty) {
      repo.primeWithTaskContext(
        taskTitle: task.title,
        taskDescription: task.description,
      );
    }

    final lang = ref.read(animationStateControllerProvider).language;
    final firstName = session.childName.isNotEmpty
        ? session.childName.trim().split(' ').first
        : '';
    final greeting = _buildGreeting(task, firstName, lang);
    ref.read(openAIResponseControllerProvider.notifier).speakDirect(greeting);
  }

  String _buildGreeting(task, String firstName, String lang) {
    final isFreeForm = task.taskId == -1;
    switch (lang) {
      case 'ar':
        if (isFreeForm) {
          return firstName.isEmpty
              ? 'أهلاً! أنا بولي. عاوز تتكلم في إيه النهارده؟'
              : 'أهلاً $firstName! أنا بولي. عاوز تتكلم في إيه؟';
        }
        return firstName.isEmpty
            ? 'أهلاً! اخترت ${task.title}. قولي إيه اللي صعب عليك فيه.'
            : 'أهلاً $firstName! اخترت ${task.title}. قولي إيه اللي صعب عليك فيه.';
      case 'jp':
        if (isFreeForm) {
          return firstName.isEmpty
              ? 'こんにちは！私はポリです。今日は何について話したいですか？'
              : 'こんにちは、$firstName！私はポリです。何について話したいですか？';
        }
        return firstName.isEmpty
            ? 'こんにちは！${task.title}を選びました。何が難しいか教えてください。'
            : 'こんにちは、$firstName！${task.title}を選びました。難しいところを教えてください。';
      default:
        if (isFreeForm) {
          return firstName.isEmpty
              ? 'Hi! I am Poly. What do you want to talk about today?'
              : 'Hi $firstName! I am Poly. What do you want to talk about today?';
        }
        return firstName.isEmpty
            ? 'Hi! You picked ${task.title}. Tell me what feels hard about it.'
            : 'Hi $firstName! You picked ${task.title}. Tell me what feels hard about it.';
    }
  }

  void _handleProcessing(SessionState session) {
    final task = session.selectedTask;
    if (task == null || session.transcript.isEmpty) return;

    if (task.taskId != -1) {
      _turnCount++;
      _emotionsPerTurn.add(InputPreprocessor.classifyEmotion(session.transcript));
      if (_fullTranscript.isNotEmpty) _fullTranscript.write(' ');
      _fullTranscript.write(session.transcript);
    }

    final taskContext = task.taskId == -1
        ? ''
        : 'Specialist task: ${task.title}${task.description.isNotEmpty ? " — ${task.description}" : ""}';

    ref.read(taskContextProvider.notifier).state = taskContext;
    ref.read(openAIResponseControllerProvider.notifier).getResponse(session.transcript);
  }

  Future<void> _handleResponded(SessionState session) async {
    // Brief "Well done!" moment for task sessions, instant for free-form
    final isFreeForm = session.selectedTask?.taskId == -1;
    if (!isFreeForm) {
      await Future.delayed(const Duration(milliseconds: 1200));
    }

    if (mounted) {
      ref.read(sessionStateControllerProvider.notifier).startListening();
    }
  }

  Future<void> _appendTaskReport({
    required SessionState session,
    required int durationSeconds,
    required int turnCount,
    required List<String> emotionsPerTurn,
    required String fullTranscript,
  }) async {
    final task = session.selectedTask;
    if (task == null || task.taskId == -1 || fullTranscript.isEmpty) return;

    final childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);
    if (childId <= 0) return;

    try {
      final wordCount = fullTranscript.trim().split(RegExp(r'\s+')).length;
      final reportLine = await ref.read(openAIRepostitoryProvider).generateReport(
            taskId: task.taskId,
            taskTitle: task.title,
            taskDescription: task.description,
            transcript: fullTranscript,
            durationSeconds: durationSeconds,
            turnCount: turnCount,
            emotionsPerTurn: emotionsPerTurn,
            wordCount: wordCount,
          );
      await SessionReportCache.append(childId, reportLine);
      debugPrint('📋 Report cached — task ${task.taskId}');
    } catch (e) {
      debugPrint('❌ Report caching failed: $e');
    }
  }

  Future<void> _submitCachedReports() async {
    final childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);
    if (childId <= 0) return;

    final reports = await SessionReportCache.loadAll(childId);
    if (reports.isEmpty) return;

    try {
      await SessionRepository().saveAvatarReport(
        childId: childId,
        avatarReport: reports.join(' '),
      );
      await SessionReportCache.clear(childId);
      debugPrint('✅ Avatar report submitted (${reports.length} tasks)');
      if (mounted) {
        setState(() => _submissionStatus = _SubmissionStatus.success);
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _submissionStatus = _SubmissionStatus.none);
        });
      }
    } catch (e) {
      debugPrint('❌ Report submission failed, kept in cache: $e');
      if (mounted) setState(() => _submissionStatus = _SubmissionStatus.failed);
    }
  }

  // Awaits the pending cache write then submits — called when wheel hits zero.
  Future<void> _submitWhenReady() async {
    await _pendingCacheWrite;
    if (mounted) setState(() => _submissionStatus = _SubmissionStatus.submitting);
    await _submitCachedReports();
  }

  Future<void> _submitAndPop() async {
    ref.read(sessionStateControllerProvider.notifier).reset();
    if (mounted) Navigator.of(context).pop();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionStateControllerProvider);

    ref.listen(sessionStateControllerProvider, (previous, next) {
      if (previous?.phase == next.phase) return;
      switch (next.phase) {
        case SessionPhase.greeting:
          _handleGreeting(next);
        case SessionPhase.processing:
          _handleProcessing(next);
        case SessionPhase.responded:
          _handleResponded(next);
        default:
          break;
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _submitAndPop();
      },
      child: Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      body: Stack(
        children: [
          const TextToSpeechCloud(
            child: AnimationScreen(),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: const FlagSwitch(),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: Material(
              color: Colors.black.withValues(alpha: 0.35),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                tooltip: 'Back',
                onPressed: _submitAndPop,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _version,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (_submissionStatus != _SubmissionStatus.none)
            Positioned(
              bottom: 120,
              left: 24,
              right: 24,
              child: _SubmissionBanner(status: _submissionStatus),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildBottomArea(session),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  void _handleDone(SessionState session) {
    final task = session.selectedTask;
    if (task != null && task.taskId != -1) {
      final duration = _sessionStartTime != null
          ? DateTime.now().difference(_sessionStartTime!).inSeconds
          : 0;

      _pendingCacheWrite = _appendTaskReport(
        session: session,
        durationSeconds: duration,
        turnCount: _turnCount,
        emotionsPerTurn: List.from(_emotionsPerTurn),
        fullTranscript: _fullTranscript.toString(),
      );

      final current = ref.read(tasksProvider);
      final remaining = current.where((t) => t.taskId != task.taskId).toList();
      ref.read(tasksProvider.notifier).state = remaining;
      _persistDismissedTaskId(task.taskId);

      // Option G: spin wheel just hit zero → all tasks discussed → submit
      if (remaining.isEmpty) {
        debugPrint('🎯 Spin wheel empty — submitting full report');
        _submitWhenReady();
      }
    }

    _sessionStartTime = null;
    _turnCount = 0;
    _emotionsPerTurn.clear();
    _fullTranscript.clear();
    ref.read(sessionStateControllerProvider.notifier).reset();
  }

  void _persistDismissedTaskId(int taskId) {
    final childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);
    final key = '${SharedPrefKeys.completedTaskIdsPrefix}$childId';
    final existing = SharedPrefHelper.getString(key);
    final ids = existing.isEmpty ? <String>[] : existing.split(',');
    if (!ids.contains(taskId.toString())) {
      ids.add(taskId.toString());
      SharedPrefHelper.setData(key, ids.join(','));
    }
  }

  Widget _buildBottomArea(SessionState session) {
    final isFreeForm = session.selectedTask?.taskId == -1;
    switch (session.phase) {
      case SessionPhase.idle:
        return SpinWheelWidget(childName: _childName);
      case SessionPhase.listening:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.bottomCenter,
              child: STTWidget(),
            ),
            const SizedBox(height: 14),
            _EndSessionButton(
              label: isFreeForm ? 'End chat' : 'Done',
              onTap: () => _handleDone(session),
            ),
          ],
        );
      case SessionPhase.greeting:
        return _phaseLabel(
          'Poly is talking…',
          icon: Icons.volume_up_rounded,
          color: AppTheme.primaryColor,
        );
      case SessionPhase.processing:
        return _phaseLabel(
          'Poly is thinking…',
          icon: Icons.hourglass_top_rounded,
          color: AppTheme.orange,
        );
      case SessionPhase.responded:
        return isFreeForm
            ? _phaseLabel(
                'Poly is talking…',
                icon: Icons.volume_up_rounded,
                color: AppTheme.primaryColor,
              )
            : _phaseLabel(
                'Well done!',
                icon: Icons.star_rounded,
                color: const Color(0xFF2E7D32),
              );
    }
  }

  Widget _phaseLabel(String text, {required IconData icon, required Color color}) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withValues(alpha: 0.7), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmissionBanner extends StatelessWidget {
  const _SubmissionBanner({required this.status});
  final _SubmissionStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, message, color) = switch (status) {
      _SubmissionStatus.submitting => (
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
          'Sending report…',
          const Color(0xFF1565C0),
        ),
      _SubmissionStatus.success => (
          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
          'Report sent!',
          const Color(0xFF2E7D32),
        ),
      _SubmissionStatus.failed => (
          const Icon(Icons.error_rounded, color: Colors.white, size: 18),
          'Could not send report — will retry next time',
          const Color(0xFFC62828),
        ),
      _SubmissionStatus.none => (
          const SizedBox.shrink(),
          '',
          Colors.transparent,
        ),
    };

    return AnimatedOpacity(
      opacity: status == _SubmissionStatus.none ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 250),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EndSessionButton extends StatelessWidget {
  const _EndSessionButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
