import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/ai_avatar/data/openai_repository.dart';
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
import 'package:patient/ai_avatar/providers/wheel_tasks_provider.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/ai_avatar/data/session_repository.dart';
import 'package:patient/ai_avatar/utils/input_preprocessor.dart';
import 'package:patient/core/models/task_model.dart';

class AiBearScreen extends ConsumerStatefulWidget {
  const AiBearScreen({super.key});

  @override
  ConsumerState<AiBearScreen> createState() => _AiBearScreenState();
}

class _AiBearScreenState extends ConsumerState<AiBearScreen> {
  String _version = '';
  String _childName = '';
  int _childId = 0;

  // ── Per-session metrics (task sessions only) ───────────────────────────────
  DateTime? _sessionStartTime;
  int _turnCount = 0;
  final List<String> _emotionsPerTurn = [];
  final StringBuffer _fullTranscript = StringBuffer();

  @override
  void initState() {
    super.initState();
    _getAppVersion();
    _init();
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

  Future<void> _init() async {
    final name = SharedPrefHelper.getString(SharedPrefKeys.childName);
    final age = SharedPrefHelper.getInt(SharedPrefKeys.childAge);
    final medicalCase = SharedPrefHelper.getString(SharedPrefKeys.childCase);
    final childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);

    setState(() {
      _childName = name;
      _childId = childId;
    });

    // Yield past the current build frame before writing to providers
    await Future.value();
    if (!mounted) return;

    ref.read(childProfileProvider.notifier).state = ChildProfile(
      name: name,
      age: age,
      medicalCase: medicalCase,
    );

    ref.read(wheelTasksProvider.notifier).load(childId);
  }

  // ── Task selection ─────────────────────────────────────────────────────────

  /// Called by SpinWheelWidget when the child confirms their selection.
  void _onTaskSelected(TaskModel task) {
    final repo = ref.read(openAIRepostitoryProvider);
    repo.clearHistory();

    if (task.taskId != -1 && task.description.isNotEmpty) {
      repo.primeWithTaskContext(
        taskTitle: task.title,
        taskDescription: task.description,
      );
    }

    ref.read(taskContextProvider.notifier).state = task.taskId == -1
        ? ''
        : 'Specialist task: ${task.title}'
            '${task.description.isNotEmpty ? " — ${task.description}" : ""}';

    ref.read(sessionStateControllerProvider.notifier).selectTask(
          task,
          childName: _childName,
        );
  }

  // ── Session phase handlers ─────────────────────────────────────────────────

  void _handleGreeting(SessionState session) {
    final task = session.selectedTask;
    final isFreeForm = task?.taskId == -1;

    // Reset metrics at the start of every task session
    if (!isFreeForm) {
      _sessionStartTime = DateTime.now();
      _turnCount = 0;
      _emotionsPerTurn.clear();
      _fullTranscript.clear();
    }

    final lang = ref.read(animationStateControllerProvider).language;
    final firstName = _childName.trim().split(' ').firstOrNull ?? '';

    ref.read(openAIResponseControllerProvider.notifier).speakDirect(
          _buildGreeting(firstName, lang, isFreeForm, task?.title ?? ''),
        );
  }

  String _buildGreeting(
      String firstName, String lang, bool isFreeForm, String taskTitle) {
    switch (lang) {
      case 'ar':
        if (isFreeForm) {
          return firstName.isEmpty
              ? 'أهلاً! أنا بولي. عاوز تتكلم في إيه النهارده؟'
              : 'أهلاً $firstName! أنا بولي. عاوز تتكلم في إيه؟';
        }
        return firstName.isEmpty
            ? 'أهلاً! اخترت $taskTitle. قولي إيه اللي صعب عليك فيه.'
            : 'أهلاً $firstName! اخترت $taskTitle. قولي إيه اللي صعب عليك فيه.';
      case 'jp':
        if (isFreeForm) {
          return firstName.isEmpty
              ? 'こんにちは！私はポリです。今日は何について話したいですか？'
              : 'こんにちは、$firstName！私はポリです。何について話したいですか？';
        }
        return firstName.isEmpty
            ? 'こんにちは！$taskTitleを選びました。何が難しいか教えてください。'
            : 'こんにちは、$firstName！$taskTitleを選びました。難しいところを教えてください。';
      default:
        if (isFreeForm) {
          return firstName.isEmpty
              ? 'Hi! I am Poly. What do you want to talk about today?'
              : 'Hi $firstName! I am Poly. What do you want to talk about today?';
        }
        return firstName.isEmpty
            ? 'Hi! You picked $taskTitle. Tell me what feels hard about it.'
            : 'Hi $firstName! You picked $taskTitle. Tell me what feels hard about it.';
    }
  }

  void _handleProcessing(SessionState session) {
    if (session.transcript.isEmpty) return;

    // Accumulate metrics for task sessions
    if (session.selectedTask?.taskId != -1) {
      _turnCount++;
      _emotionsPerTurn.add(InputPreprocessor.classifyEmotion(session.transcript));
      if (_fullTranscript.isNotEmpty) _fullTranscript.write(' ');
      _fullTranscript.write(session.transcript);
    }

    ref.read(openAIResponseControllerProvider.notifier).getResponse(session.transcript);
  }

  Future<void> _handleResponded(SessionState session) async {
    final isFreeForm = session.selectedTask?.taskId == -1;
    if (!isFreeForm) {
      await Future.delayed(const Duration(milliseconds: 1200));
    }
    if (mounted) {
      ref.read(sessionStateControllerProvider.notifier).startListening();
    }
  }

  /// Called when the child taps "Done" (task session) or "End chat" (free-form).
  Future<void> _handleDone(SessionState session) async {
    ref.read(taskContextProvider.notifier).state = '';

    final task = session.selectedTask;

    if (task != null && task.taskId != -1 && _childId > 0) {
      debugPrint('✅ Done — task: ${task.taskId} | turns: $_turnCount | transcript: "${_fullTranscript.toString().trim()}"');

      if (_fullTranscript.isNotEmpty) {
        final duration = _sessionStartTime != null
            ? DateTime.now().difference(_sessionStartTime!).inSeconds
            : 0;
        final wordCount =
            _fullTranscript.toString().trim().split(RegExp(r'\s+')).length;

        try {
          // Step 1 — generate structured report text via OpenAI
          final report = await ref.read(openAIRepostitoryProvider).generateReport(
                taskId: task.taskId,
                taskTitle: task.title,
                taskDescription: task.description,
                transcript: _fullTranscript.toString(),
                durationSeconds: duration,
                turnCount: _turnCount,
                emotionsPerTurn: List.from(_emotionsPerTurn),
                wordCount: wordCount,
              );
          debugPrint('📊 Report generated → $report');

          // Step 2 — persist to backend so the specialist can view it
          await SessionRepository().saveAvatarReport(
            childId: _childId,
            avatarReport: report,
          );
          debugPrint('✅ Report saved to backend');
        } catch (e) {
          // Either step failed — reset session but keep task on wheel so
          // the parent can retry next time
          debugPrint('❌ Report save failed: $e');
          _resetMetrics();
          ref.read(taskContextProvider.notifier).state = '';
          ref.read(sessionStateControllerProvider.notifier).reset();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not save report. The task will stay on the wheel — please try again.'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 4),
              ),
            );
          }
          return;
        }
      } else {
        debugPrint('⚠️ No transcript — dismissing without report');
      }

      _resetMetrics();

      // Dismiss task from wheel (optimistic update + SharedPrefs persist)
      await ref.read(wheelTasksProvider.notifier).dismiss(task.taskId, _childId);
      if (!mounted) return;

      ref.read(sessionStateControllerProvider.notifier).reset();
    } else {
      // Free-form — go back to idle (wheel visible)
      ref.read(sessionStateControllerProvider.notifier).reset();
    }
  }

  void _resetMetrics() {
    _sessionStartTime = null;
    _turnCount = 0;
    _emotionsPerTurn.clear();
    _fullTranscript.clear();
  }

  Future<void> _exitScreen() async {
    ref.read(sessionStateControllerProvider.notifier).reset();
    ref.read(taskContextProvider.notifier).state = '';
    if (mounted) Navigator.of(context).pop();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionStateControllerProvider);

    // Keep wheelTasksProvider alive while this screen is open, even when
    // SpinWheelWidget is not in the tree (task session is active).
    // Without this, autoDispose fires the moment the wheel hides, and
    // _handleDone would read null remaining tasks → always auto-starts free-form.
    ref.listen(wheelTasksProvider, (_, __) {});

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
        if (!didPop) _exitScreen();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFD6E2EA),
        body: Stack(
          children: [
            const TextToSpeechCloud(child: AnimationScreen()),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8.h,
              right: 12.w,
              child: const FlagSwitch(),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8.h,
              left: 8.w,
              child: Material(
                color: Colors.black.withValues(alpha: 0.35),
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  tooltip: 'Back',
                  onPressed: _exitScreen,
                ),
              ),
            ),
            Positioned(
              bottom: 16.h,
              left: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  _version,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildBottomArea(session),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomArea(SessionState session) {
    switch (session.phase) {
      case SessionPhase.idle:
        return SpinWheelWidget(onTaskSelected: _onTaskSelected);
      case SessionPhase.listening:
        final isFreeForm = session.selectedTask?.taskId == -1;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.bottomCenter,
              child: STTWidget(),
            ),
            SizedBox(height: 14.h),
            _SessionButton(
              label: isFreeForm ? 'End chat' : 'Done',
              onTap: () => _handleDone(session),
            ),
          ],
        );
      case SessionPhase.greeting:
      case SessionPhase.responded:
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
    }
  }

  Widget _phaseLabel(String text,
      {required IconData icon, required Color color}) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: color.withValues(alpha: 0.7), width: 1.5.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Done / End-chat button ────────────────────────────────────────────────────

class _SessionButton extends StatelessWidget {
  const _SessionButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.5), width: 1.5.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline_rounded,
                color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
