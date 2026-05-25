import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/ai_avatar/providers/session_state_controller.dart';
import 'package:patient/ai_avatar/providers/tasks_provider.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/core/models/task_model.dart';

const _kWheelDiameter = 240.0;
const _kWheelRadius = _kWheelDiameter / 2;

class SpinWheelWidget extends ConsumerStatefulWidget {
  const SpinWheelWidget({super.key, required this.childName});
  final String childName;

  @override
  ConsumerState<SpinWheelWidget> createState() => _SpinWheelWidgetState();
}

class _SpinWheelWidgetState extends ConsumerState<SpinWheelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  double _restAngle = 0.0;
  double _spinStart = 0.0;
  double _spinEnd = 0.0;

  double _lastDragAngle = 0.0;
  double _angularVelocity = 0.0;
  bool _isDragging = false;

  bool _isSpinning = false;
  bool _showResult = false;
  int _selectedIndex = 0;

  double get _displayAngle {
    if (!_isSpinning) return _restAngle;
    final t = Curves.easeOutQuart.transform(_ctrl.value);
    return _spinStart + (_spinEnd - _spinStart) * t;
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this)
      ..addListener(() {
        if (_isSpinning) setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && _isSpinning) {
          _restAngle = _spinEnd;
          final labels = _buildLabels();
          HapticFeedback.heavyImpact();
          setState(() {
            _isSpinning = false;
            _showResult = true;
            _selectedIndex = _calcSelected(labels);
          });
        }
      });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<String> _buildLabels() {
    final tasks = ref.read(tasksProvider);
    final active = tasks.where((t) => t.isCompleted).toList();
    return [
      ...active.map((t) {
        final title = t.title;
        return title.length > 12 ? '${title.substring(0, 10)}..' : title;
      }),
      'Talk\nto Poly',
    ];
  }

  List<TaskModel> _activeTasks() =>
      ref.read(tasksProvider).where((t) => t.isCompleted).toList();

  int _calcSelected(List<String> labels) {
    final n = labels.length;
    final segAngle = 2 * pi / n;
    final raw = (-_restAngle / segAngle).floor() % n;
    return (raw + n) % n;
  }

  void _spin(List<String> labels) {
    if (_isSpinning) return;
    HapticFeedback.mediumImpact();
    final rng = Random();
    _spinStart = _restAngle;
    _spinEnd = _restAngle +
        ((5 + rng.nextInt(6)) * 2 * pi + rng.nextDouble() * 2 * pi);
    _ctrl
      ..duration = Duration(milliseconds: 3200 + rng.nextInt(1400))
      ..reset()
      ..forward();
    setState(() {
      _isSpinning = true;
      _showResult = false;
    });
  }

  // ── Gesture ────────────────────────────────────────────────────────────────

  double _touchAngle(Offset pos) =>
      atan2(pos.dy - _kWheelRadius, pos.dx - _kWheelRadius);

  void _onPanStart(DragStartDetails d) {
    if (_isSpinning) return;
    _isDragging = true;
    _angularVelocity = 0;
    _lastDragAngle = _touchAngle(d.localPosition);
    setState(() => _showResult = false);
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (!_isDragging || _isSpinning) return;
    final current = _touchAngle(d.localPosition);
    var delta = current - _lastDragAngle;
    if (delta > pi) delta -= 2 * pi;
    if (delta < -pi) delta += 2 * pi;
    _angularVelocity = delta;
    _lastDragAngle = current;
    setState(() => _restAngle += delta);
  }

  void _onPanEnd(DragEndDetails _, List<String> labels) {
    if (!_isDragging) return;
    _isDragging = false;
    if (_angularVelocity.abs() > 0.02) {
      _spin(labels);
    } else {
      HapticFeedback.selectionClick();
      setState(() {
        _showResult = true;
        _selectedIndex = _calcSelected(labels);
      });
    }
    _angularVelocity = 0;
  }

  // ── Continue / Try Again ───────────────────────────────────────────────────

  void _onContinue() {
    final active = _activeTasks();
    final task = _selectedIndex >= active.length
        ? TaskModel(
            taskId: -1,
            title: 'Talk to Poly',
            description: '',
            assignedDate: DateTime.now(),
            dueDate: DateTime.now(),
            plannedDays: 0,
            actualDays: 0,
            isCompleted: false,
            punctualityStatus: 'Pending',
          )
        : active[_selectedIndex];
    ref
        .read(sessionStateControllerProvider.notifier)
        .selectTask(task, childName: widget.childName);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(tasksLoadingProvider);
    if (isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 12),
          Text(
            'Loading tasks...',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    final tasks = ref.watch(tasksProvider);
    final active = tasks.where((t) => t.isCompleted).toList();

    if (active.isEmpty) {
      return _NoTasksView(
        onTap: () => ref.read(sessionStateControllerProvider.notifier).selectTask(
          TaskModel(
            taskId: -1,
            title: 'Talk to Poly',
            description: '',
            assignedDate: DateTime.now(),
            dueDate: DateTime.now(),
            plannedDays: 0,
            actualDays: 0,
            isCompleted: false,
            punctualityStatus: 'Pending',
          ),
          childName: widget.childName,
        ),
      );
    }

    // Truncated labels for the wheel segments (space-constrained)
    final labels = [
      ...active.map((t) {
        final title = t.title;
        return title.length > 12 ? '${title.substring(0, 10)}..' : title;
      }),
      'Talk\nto Poly',
    ];
    // Full titles for the result card
    final fullLabels = [
      ...active.map((t) => t.title),
      'Talk to Poly',
    ];

    // Build Poppins style here so the painter can use it without BuildContext
    final labelStyle = GoogleFonts.poppins(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      height: 1.2,
      shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _kWheelDiameter,
          height: _kWheelDiameter + 26,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              const Positioned(
                top: 0,
                child: _PointerArrow(),
              ),
              Positioned(
                top: 24,
                child: GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: (d) => _onPanEnd(d, labels),
                  child: CustomPaint(
                    size: const Size(_kWheelDiameter, _kWheelDiameter),
                    painter: _WheelPainter(
                      labels: labels,
                      angle: _displayAngle,
                      selectedIndex: _showResult ? _selectedIndex : -1,
                      labelStyle: labelStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) =>
              FadeTransition(opacity: anim, child: child),
          child: _showResult
              ? _ResultCard(
                  key: const ValueKey('result'),
                  label: fullLabels[_selectedIndex],
                  onContinue: _onContinue,
                  onTryAgain: () => _spin(labels),
                )
              : _SpinButton(
                  key: const ValueKey('spin'),
                  isSpinning: _isSpinning,
                  onTap: () => _spin(labels),
                ),
        ),
      ],
    );
  }
}

// ── Wheel Painter ─────────────────────────────────────────────────────────────

class _WheelPainter extends CustomPainter {
  const _WheelPainter({
    required this.labels,
    required this.angle,
    required this.selectedIndex,
    required this.labelStyle,
  });

  final List<String> labels;
  final double angle;
  final int selectedIndex; // -1 means no selection shown
  final TextStyle labelStyle;

  bool get _hasResult => selectedIndex >= 0;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2 - 2;
    final segAngle = 2 * pi / labels.length;
    final fontSize =
        labels.length <= 4 ? 15.0 : labels.length <= 6 ? 13.5 : 12.0;
    final arcRect = Rect.fromCircle(center: Offset.zero, radius: r);

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle);

    for (int i = 0; i < labels.length; i++) {
      final start = -pi / 2 + i * segAngle;
      final isSelected = i == selectedIndex;
      final baseColor = AppTheme.wheelColors[i % AppTheme.wheelColors.length];
      // Dim non-selected segments when a result is showing
      final fillColor = _hasResult && !isSelected
          ? Color.lerp(baseColor, Colors.black, 0.45)!
          : baseColor;

      canvas.drawArc(arcRect, start, segAngle, true, Paint()..color = fillColor);

      // Separator lines
      canvas.drawArc(
        arcRect,
        start,
        segAngle,
        true,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );

      // Gold highlight border on winning segment
      if (isSelected) {
        canvas.drawArc(
          arcRect,
          start,
          segAngle,
          true,
          Paint()
            ..color = const Color(0xFFFFD700)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5.0,
        );
      }

      // Radial text
      canvas.save();
      canvas.rotate(start + segAngle / 2);
      canvas.translate(r * 0.58, 0);
      canvas.rotate(pi / 2);

      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: labelStyle.copyWith(fontSize: fontSize),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 2,
      )..layout(maxWidth: r * 0.52);

      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    // Hub
    canvas.drawCircle(
      Offset.zero,
      22,
      Paint()
        ..color = Colors.black26
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(Offset.zero, 20, Paint()..color = Colors.white);
    canvas.drawCircle(
        Offset.zero, 14, Paint()..color = AppTheme.primaryColor);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_WheelPainter old) =>
      old.angle != angle ||
      old.selectedIndex != selectedIndex ||
      old.labels.length != labels.length;
}

// ── Fixed pointer arrow ───────────────────────────────────────────────────────

class _PointerArrow extends StatelessWidget {
  const _PointerArrow();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(36, 28),
      painter: _ArrowPainter(),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, size.height) // tip
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    // Drop shadow
    canvas.drawPath(
      path.shift(const Offset(0, 3)),
      Paint()
        ..color = Colors.black38
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // White fill
    canvas.drawPath(path, Paint()..color = Colors.white);

    // Theme-coloured outline
    canvas.drawPath(
      path,
      Paint()
        ..color = AppTheme.primaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_ArrowPainter _) => false;
}

// ── Result card ───────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    super.key,
    required this.label,
    required this.onContinue,
    required this.onTryAgain,
  });
  final String label;
  final VoidCallback onContinue;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.50),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Accent strip
          Container(
            height: 4,
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You picked',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onTryAgain,
                        icon: const Icon(Icons.refresh_rounded, size: 17),
                        label: Text(
                          'Try again',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.35)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onContinue,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                        label: Text(
                          "Let's go",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── No tasks view ─────────────────────────────────────────────────────────────

class _NoTasksView extends StatelessWidget {
  const _NoTasksView({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'No tasks yet',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
          label: Text(
            'Talk to Poly',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 6,
          ),
        ),
      ],
    );
  }
}

// ── Spin button ───────────────────────────────────────────────────────────────

class _SpinButton extends StatelessWidget {
  const _SpinButton(
      {super.key, required this.isSpinning, required this.onTap});
  final bool isSpinning;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: isSpinning ? null : onTap,
          icon: Icon(Icons.casino_rounded, size: isSpinning ? 20 : 24),
          label: Text(
            isSpinning ? 'Spinning...' : '  Spin!  ',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor:
                AppTheme.primaryColor.withValues(alpha: 0.4),
            disabledForegroundColor: Colors.white54,
            padding:
                const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 6,
          ),
        ),
        if (!isSpinning)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              'or drag the wheel to spin',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white60,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }
}
