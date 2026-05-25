import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:patient/ai_avatar/providers/tasks_provider.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/networking/repositories/tasks_repo.dart';

class AiBearScreen extends ConsumerStatefulWidget {
  const AiBearScreen({super.key});

  @override
  ConsumerState<AiBearScreen> createState() => _AiBearScreenState();
}

class _AiBearScreenState extends ConsumerState<AiBearScreen> {
  String _version = '';
  String _childName = '';

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
      final dismissedIds = dismissedStr.isEmpty
          ? <int>{}
          : dismissedStr.split(',').map(int.parse).toSet();
      final filteredTasks = dismissedIds.isEmpty
          ? tasks
          : tasks.where((t) => !dismissedIds.contains(t.taskId)).toList();

      final activeTasks = filteredTasks.where((t) => t.isCompleted).toList();
      final contextSummary = activeTasks.isEmpty
          ? ''
          : 'Specialist tasks: ${activeTasks.map((t) => t.description.isNotEmpty ? '${t.title} (${t.description})' : t.title).join(' | ')}';

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

  Future<void> _generateAndPrintReport(SessionState session) async {
    final task = session.selectedTask;
    if (task == null || task.taskId == -1 || session.transcript.isEmpty) return;
    try {
      final report = await ref.read(openAIRepostitoryProvider).generateReport(
            taskTitle: task.title,
            taskDescription: task.description,
            transcript: session.transcript,
          );
      debugPrint(
        '\n📋 ══════════════════════════════════\n'
        '$report\n'
        '──────────────────────────────────\n'
        'TRANSCRIPT: ${session.transcript}\n'
        '══════════════════════════════════\n',
      );
      // TODO: submit report to backend once endpoint is ready
      // final childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);
      // if (childId > 0) {
      //   await SessionRepository().submitReport(SessionReportRequestModel(
      //     childId: childId,
      //     taskId: task.taskId,
      //     taskTitle: task.title,
      //     report: report,
      //   ));
      // }
    } catch (e) {
      debugPrint('❌ Report generation failed: $e');
    }
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

    return Scaffold(
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
                onPressed: () {
                  ref.read(sessionStateControllerProvider.notifier).reset();
                  Navigator.of(context).maybePop();
                },
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
    );
  }

  void _handleDone(SessionState session) {
    final task = session.selectedTask;
    if (task != null && task.taskId != -1) {
      // Generate report with the full accumulated transcript before resetting
      _generateAndPrintReport(session);

      final current = ref.read(tasksProvider);
      ref.read(tasksProvider.notifier).state =
          current.where((t) => t.taskId != task.taskId).toList();
      _persistDismissedTaskId(task.taskId);
    }
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
