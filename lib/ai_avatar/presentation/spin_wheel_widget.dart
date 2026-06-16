import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/ai_avatar/providers/wheel_tasks_provider.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/models/task_model.dart';
import 'package:patient/core/theme/theme.dart';

double get _kWheelDiameter => 240.0.w;
double get _kWheelRadius => _kWheelDiameter / 2;

TaskModel _freeFormTask() => TaskModel(
      taskId: -1,
      title: 'Talk to Poly',
      description: '',
      assignedDate: DateTime.now(),
      dueDate: DateTime.now(),
      plannedDays: 0,
      actualDays: 0,
      isCompleted: false,
    );

class SpinWheelWidget extends ConsumerStatefulWidget {
  const SpinWheelWidget({super.key, required this.onTaskSelected});

  /// Called when the child confirms a wheel selection.
  final void Function(TaskModel task) onTaskSelected;

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
    final tasks = ref.read(wheelTasksProvider).valueOrNull ?? [];
    return [
      ...tasks.map((t) {
        final title = t.title;
        return title.length > 12 ? '${title.substring(0, 10)}..' : title;
      }),
      'Talk\nto Poly',
    ];
  }

  List<TaskModel> _activeTasks() =>
      ref.read(wheelTasksProvider).valueOrNull ?? [];

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

  void _onContinue() {
    final active = _activeTasks();
    final task = _selectedIndex >= active.length
        ? _freeFormTask()
        : active[_selectedIndex];
    widget.onTaskSelected(task);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final wheelState = ref.watch(wheelTasksProvider);

    return wheelState.when(
      loading: () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 12.h),
          Text(
            'Loading tasks...',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      error: (_, __) => _ErrorView(
        onRetry: () {
          final childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);
          ref.read(wheelTasksProvider.notifier).load(childId);
        },
      ),
      data: (active) {
        if (active.isEmpty) {
          return _NoTasksView(
            onTap: () => widget.onTaskSelected(_freeFormTask()),
          );
        }

        final labels = [
          ...active.map((t) {
            final title = t.title;
            return title.length > 12 ? '${title.substring(0, 10)}..' : title;
          }),
          'Talk\nto Poly',
        ];
        final fullLabels = [
          ...active.map((t) => t.title),
          'Talk to Poly',
        ];
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
              height: _kWheelDiameter + 26.h,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  const Positioned(top: 0, child: _PointerArrow()),
                  Positioned(
                    top: 24.h,
                    child: GestureDetector(
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: (d) => _onPanEnd(d, labels),
                      child: CustomPaint(
                        size: Size(_kWheelDiameter, _kWheelDiameter),
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
            SizedBox(height: 10.h),
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
      },
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
  final int selectedIndex;
  final TextStyle labelStyle;

  bool get _hasResult => selectedIndex >= 0;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2 - 2.w;
    final segAngle = 2 * pi / labels.length;
    final fontSize = labels.length <= 4
        ? 15.0.sp
        : labels.length <= 6
            ? 13.5.sp
            : 12.0.sp;
    final arcRect = Rect.fromCircle(center: Offset.zero, radius: r);

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle);

    for (int i = 0; i < labels.length; i++) {
      final start = -pi / 2 + i * segAngle;
      final isSelected = i == selectedIndex;
      final baseColor = AppTheme.wheelColors[i % AppTheme.wheelColors.length];
      final fillColor = _hasResult && !isSelected
          ? Color.lerp(baseColor, Colors.black, 0.45)!
          : baseColor;

      canvas.drawArc(arcRect, start, segAngle, true, Paint()..color = fillColor);

      canvas.drawArc(
        arcRect,
        start,
        segAngle,
        true,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5.w,
      );

      if (isSelected) {
        canvas.drawArc(
          arcRect,
          start,
          segAngle,
          true,
          Paint()
            ..color = const Color(0xFFFFD700)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5.0.w,
        );
      }

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

    canvas.drawCircle(
      Offset.zero,
      22.r,
      Paint()
        ..color = Colors.black26
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.r),
    );
    canvas.drawCircle(Offset.zero, 20.r, Paint()..color = Colors.white);
    canvas.drawCircle(Offset.zero, 14.r, Paint()..color = AppTheme.primaryColor);

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
      size: Size(36.w, 28.h),
      painter: _ArrowPainter(),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(
      path.shift(Offset(0, 3.h)),
      Paint()
        ..color = Colors.black38
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.r),
    );
    canvas.drawPath(path, Paint()..color = Colors.white);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppTheme.primaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0.w
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
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.50),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4.h,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You picked',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onTryAgain,
                        icon: Icon(Icons.refresh_rounded, size: 17.sp),
                        label: Text(
                          'Try again',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.35)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r)),
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onContinue,
                        icon: Icon(Icons.arrow_forward_rounded, size: 17.sp),
                        label: Text(
                          "Let's go",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r)),
                          padding: EdgeInsets.symmetric(vertical: 11.h),
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

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Could not load tasks',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: Icon(Icons.refresh_rounded, size: 18.sp),
          label: Text(
            'Retry',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r)),
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
          ),
        ),
      ],
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
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(Icons.chat_bubble_outline_rounded, size: 20.sp),
          label: Text(
            'Talk to Poly',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 14.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r)),
            elevation: 6,
          ),
        ),
      ],
    );
  }
}

// ── Spin button ───────────────────────────────────────────────────────────────

class _SpinButton extends StatelessWidget {
  const _SpinButton({super.key, required this.isSpinning, required this.onTap});
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
          icon: Icon(Icons.casino_rounded, size: isSpinning ? 20.sp : 24.sp),
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
            padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 14.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r)),
            elevation: 6,
          ),
        ),
        if (!isSpinning)
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Text(
              'or drag the wheel to spin',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white60,
                fontSize: 11.sp,
              ),
            ),
          ),
      ],
    );
  }
}
