import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/cubits/task_cubit/task_cubit.dart';
import 'package:patient/core/cubits/task_cubit/task_listener.dart';
import 'package:patient/core/models/task_model.dart';
import 'package:patient/presentation/games/color_match_game.dart';
import 'package:patient/presentation/games/emotion_game.dart';
import 'package:patient/presentation/games/memory_game.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key, required this.task});

  final TaskModel task;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late bool _markedDone;
  bool _isSubmitting = false;
  bool _showAppBarTitle = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _markedDone = widget.task.isCompleted;
    _scrollController.addListener(() {
      final show = _scrollController.offset > 72;
      if (show != _showAppBarTitle) setState(() => _showAppBarTitle = show);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showParentNoteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ParentNoteSheet(
        onSubmit: (note) {
          Navigator.pop(context);
          TaskCubit.get(context).completeTask(widget.task.taskId, note);
        },
      ),
    );
  }

  Future<void> _launchGame() async {
    final task = widget.task;
    final Widget gameScreen = switch (task.gameType) {
      'memory_cards' => MemoryGame(taskId: task.taskId),
      'color_match' => ColorMatchGame(taskId: task.taskId),
      'emotion_match' => EmotionGame(taskId: task.taskId),
      _ => const SizedBox.shrink(),
    };

    final completed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => gameScreen),
    );

    if (completed == true && mounted) {
      setState(() => _markedDone = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return BlocListener<TaskCubit, TaskStates>(
      listenWhen: (_, s) =>
          s is TaskCompleteLoadingState ||
          s is TaskCompleteSuccessState ||
          s is TaskCompleteErrorState,
      listener: (context, state) {
        if (state is TaskCompleteLoadingState) {
          setState(() => _isSubmitting = true);
        } else if (state is TaskCompleteSuccessState) {
          setState(() {
            _markedDone = true;
            _isSubmitting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Task marked as completed!'),
              backgroundColor: Color(0xFF14D9C4),
            ),
          );
        } else if (state is TaskCompleteErrorState) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFDC2626),
            ),
          );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) Navigator.pop(context, _markedDone);
        },
        child: Scaffold(
        backgroundColor: const Color(0xFFFBFAFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFBFAFF),
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context, _markedDone),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFECEAF6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Color(0xFF211E40),
              ),
            ),
          ),
          // ── Fades in once title scrolls out of view ──
          title: AnimatedOpacity(
            opacity: _showAppBarTitle ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 180),
            child: Text(
              task.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF211E40),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: AnimatedOpacity(
              opacity: _showAppBarTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 180),
              child: Container(height: 1, color: const Color(0xFFECEAF6)),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Overline + hero title ────────────────
                    const Text(
                      'TASK DETAIL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Color(0xFF8B89A6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: Color(0xFF211E40),
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Status: pill or completion banner ───
                    if (_markedDone)
                      _CompletionBanner(task: task)
                    else
                      _StatusPill(task: task),

                    const SizedBox(height: 32),

                    // ── Description ─────────────────────────
                    const _SectionLabel('Description'),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F2FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: task.isGameTask && task.description.isEmpty
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.sports_esports_rounded,
                                  size: 18,
                                  color: Color(0xFF7C5CFF),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Tap "Play ${task.gameDisplayName}" below to start the game.',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.6,
                                      color: Color(0xFF7C5CFF),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              task.description.isEmpty
                                  ? 'No description provided for this task.'
                                  : task.description,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.7,
                                color: task.description.isEmpty
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF374151),
                              ),
                            ),
                    ),
                    const SizedBox(height: 28),

                    // ── Timeline ────────────────────────────
                    const _SectionLabel('Timeline'),
                    const SizedBox(height: 16),
                    _VisualTimeline(task: task, markedDone: _markedDone),
                  ],
                ),
              ),
            ),

            // ── Bottom action ────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(24, 12, 24, bottomPadding + 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFECEAF6))),
              ),
              child: _markedDone
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF17E2CD), Color(0xFF0FBDAD)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF14D9C4).withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Task completed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )
                  : widget.task.isGameTask
                      ? _PlayGameButton(
                          gameName: widget.task.gameDisplayName,
                          onTap: _launchGame,
                        )
                      : GestureDetector(
                          onTap: _isSubmitting ? null : _showParentNoteSheet,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C5CFF),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7C5CFF)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: _isSubmitting
                                ? const Center(
                                    child: SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_rounded,
                                          color: Colors.white, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Mark as Done',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
            ),
          ],
        ),
      ),
        ),
    );
  }

  static String fmtDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}

// ── Section label ──────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF7C5CFF),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF211E40),
          ),
        ),
      ],
    );
  }
}

// ── Status pill (pending / overdue only) ───────────────────────────────────────

class _StatusPill extends StatelessWidget {
  final TaskModel task;

  const _StatusPill({required this.task});

  @override
  Widget build(BuildContext context) {
    final bool overdue = task.isOverdue;
    final Color fg =
        overdue ? const Color(0xFFDC2626) : const Color(0xFFB45309);
    final Color bg =
        overdue ? const Color(0xFFFFE4E4) : const Color(0xFFFEF3C7);
    final IconData icon = overdue
        ? Icons.warning_amber_rounded
        : Icons.hourglass_empty_rounded;
    final String label = overdue ? 'Overdue' : 'Pending';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: fg),
          ),
        ],
      ),
    );
  }
}

// ── Completion banner ──────────────────────────────────────────────────────────

class _CompletionBanner extends StatelessWidget {
  final TaskModel task;

  const _CompletionBanner({required this.task});

  @override
  Widget build(BuildContext context) {
    final String dateText = task.completedAt != null
        ? 'Completed on ${_TaskDetailsScreenState.fmtDate(task.completedAt!)}'
        : 'Marked as completed';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE2FBF6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFB6F0E6),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF14D9C4),
            ),
            child: const Icon(Icons.check_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Task Completed',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0E8F82),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateText,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF0FA697),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Visual timeline ────────────────────────────────────────────────────────────

class _VisualTimeline extends StatelessWidget {
  final TaskModel task;
  final bool markedDone;

  const _VisualTimeline({required this.task, required this.markedDone});

  @override
  Widget build(BuildContext context) {
    final Color dueColor = markedDone
        ? const Color(0xFF14D9C4)
        : task.isOverdue
            ? const Color(0xFFDC2626)
            : const Color(0xFF7C5CFF);

    final String dueLabel = markedDone
        ? 'Completed'
        : task.isOverdue
            ? 'Overdue since'
            : 'Due';

    final String dueDate = markedDone
        ? (task.completedAt != null
            ? _TaskDetailsScreenState.fmtDate(task.completedAt!)
            : _TaskDetailsScreenState.fmtDate(DateTime.now()))
        : task.formattedDueDate;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Dot + connector column ────────────
        SizedBox(
          width: 16,
          child: Column(
            children: [
              const SizedBox(height: 3),
              Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF7C5CFF),
                ),
              ),
              Container(
                width: 2,
                height: 36,
                color: const Color(0xFFE5E7EB),
              ),
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: markedDone ? dueColor : Colors.white,
                  border: Border.all(color: dueColor, width: 2),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // ── Label + date column ───────────────
        Expanded(
          child: Column(
            children: [
              // Assigned
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Assigned',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    task.formattedAssignedDate,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF211E40),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // Due / Completed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dueLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: dueColor,
                    ),
                  ),
                  Text(
                    dueDate,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: dueColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Play game button ───────────────────────────────────────────────────────────

class _PlayGameButton extends StatelessWidget {
  const _PlayGameButton({required this.gameName, required this.onTap});

  final String gameName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF14D9C4), Color(0xFF0FA697)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF14D9C4).withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_esports_rounded,
                color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(
              'Play $gameName',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Parent note sheet ──────────────────────────────────────────────────────────

class _ParentNoteSheet extends StatefulWidget {
  const _ParentNoteSheet({required this.onSubmit});

  final void Function(String note) onSubmit;

  @override
  State<_ParentNoteSheet> createState() => _ParentNoteSheetState();
}

class _ParentNoteSheetState extends State<_ParentNoteSheet> {
  final _controller = TextEditingController();
  bool _showError = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final note = _controller.text.trim();
    if (note.isEmpty) {
      setState(() => _showError = true);
      return;
    }
    widget.onSubmit(note);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Parent's Note",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF211E40),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Share what was challenging and what went well during this task.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
            onChanged: (_) {
              if (_showError) setState(() => _showError = false);
            },
            decoration: InputDecoration(
              hintText:
                  'e.g. "She struggled with pronunciation but loved the pictures..."',
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 13,
              ),
              errorText:
                  _showError ? 'Please write a note before submitting.' : null,
              filled: true,
              fillColor: const Color(0xFFF4F2FB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _showError
                      ? const Color(0xFFDC2626)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _showError
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF7C5CFF),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C5CFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
