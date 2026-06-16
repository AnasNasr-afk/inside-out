import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/presentation/poly_missions/cubit/poly_missions_cubit.dart';

class PmControlArea extends StatefulWidget {
  final PmPhase phase;
  final bool polyIsTalking;
  final bool allDone;
  final VoidCallback onStartRec;
  final VoidCallback onStopRec;
  final VoidCallback onNext;
  final int recSeconds;

  const PmControlArea({
    super.key,
    required this.phase,
    required this.polyIsTalking,
    required this.allDone,
    required this.onStartRec,
    required this.onStopRec,
    required this.onNext,
    required this.recSeconds,
  });

  @override
  State<PmControlArea> createState() => _PmControlAreaState();
}

class _PmControlAreaState extends State<PmControlArea>
    with TickerProviderStateMixin {
  late final AnimationController _micRingCtrl;
  late final AnimationController _waveCtrl;
  late final AnimationController _dotsCtrl;

  @override
  void initState() {
    super.initState();
    _micRingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _dotsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _micRingCtrl.dispose();
    _waveCtrl.dispose();
    _dotsCtrl.dispose();
    super.dispose();
  }

  String _formatTime(int s) =>
      '${(s ~/ 60).toString().padLeft(1, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: switch ((widget.phase, widget.polyIsTalking)) {
        (PmPhase.pick, _) ||
        (PmPhase.celebration, _) =>
          const SizedBox.shrink(key: ValueKey('pick')),
        (PmPhase.focus, true) ||
        (PmPhase.response, true) =>
          _buildPolyTalking(),
        (PmPhase.focus, _) => _buildMicButton(),
        (PmPhase.recording, _) => _buildRecording(),
        (PmPhase.analyzing, _) => _buildAnalyzing(),
        (PmPhase.response, _) => _buildResponseActions(),
      },
    );
  }

  // ── Poly is talking indicator ───────────────────────────────────────────────
  Widget _buildPolyTalking() {
    return Container(
      key: const ValueKey('poly-talking'),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Waveform(ctrl: _waveCtrl, color: const Color(0xFF8A6BFF)),
          const SizedBox(width: 12),
          Text(
            'Poly is speaking…',
            style: T.badge().copyWith(fontSize: 14.5, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ── Mic button ─────────────────────────────────────────────────────────────
  Widget _buildMicButton() {
    return Column(
      key: const ValueKey('focus-mic'),
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _micRingCtrl,
          builder: (_, child) {
            final scale = 1.0 + 0.35 * _micRingCtrl.value;
            final opacity = (1.0 - _micRingCtrl.value).clamp(0.0, 1.0);
            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0x998A6BFF),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                child!,
              ],
            );
          },
          child: _MicCircle(onTap: widget.onStartRec),
        ),
        const SizedBox(height: 10),
        Text(
          'Tap to answer Poly',
          style: T.navLabel().copyWith(fontSize: 13.5, color: Colors.white),
        ),
      ],
    );
  }

  // ── Recording bar + stop ───────────────────────────────────────────────────
  Widget _buildRecording() {
    return Column(
      key: const ValueKey('recording'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _micRingCtrl,
                builder: (_, __) => Opacity(
                  opacity: 0.4 + 0.6 * math.sin(_micRingCtrl.value * math.pi),
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5B72),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _formatTime(widget.recSeconds),
                style: T.badge().copyWith(
                  fontSize: 14,
                  color: Colors.white,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 10),
              _Waveform(ctrl: _waveCtrl, color: Colors.white),
            ],
          ),
        ),
        const SizedBox(height: 13),
        GestureDetector(
          onTap: widget.onStopRec,
          child: Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: const Color(0xFFFF5B72),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF5B72).withValues(alpha: 0.55),
                  blurRadius: 30,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: const Icon(Icons.stop_rounded, color: Colors.white, size: 34),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Tap to stop',
          style: T.navLabel().copyWith(fontSize: 13.5, color: Colors.white),
        ),
      ],
    );
  }

  // ── Analyzing pill ─────────────────────────────────────────────────────────
  Widget _buildAnalyzing() {
    return Container(
      key: const ValueKey('analyzing'),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BouncingDots(ctrl: _dotsCtrl),
          const SizedBox(width: 11),
          Text(
            'Poly is thinking…',
            style: T.badge().copyWith(fontSize: 14.5, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ── Response actions: re-record + next ─────────────────────────────────────
  Widget _buildResponseActions() {
    return Column(
      key: const ValueKey('response-actions'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // "Record again" ghost button
        GestureDetector(
          onTap: widget.onStartRec,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mic_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Record again',
                  style: T.navLabel()
                      .copyWith(fontSize: 13.5, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // "Next mission" filled button
        GestureDetector(
          onTap: widget.onNext,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF14D9C4),
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF14D9C4).withValues(alpha: 0.50),
                  blurRadius: 30,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.allDone ? 'All done!' : 'Next mission',
                  style: T.sectionHeader().copyWith(
                    color: const Color(0xFF06342F),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF06342F),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Mic circle ─────────────────────────────────────────────────────────────────

class _MicCircle extends StatelessWidget {
  final VoidCallback onTap;
  const _MicCircle({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8A6BFF), Color(0xFF6A4BF0)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C5CFF).withValues(alpha: 0.50),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: const Icon(Icons.mic_rounded, color: Colors.white, size: 32),
      ),
    );
  }
}

// ── Waveform ───────────────────────────────────────────────────────────────────

class _Waveform extends StatelessWidget {
  final AnimationController ctrl;
  final Color color;
  const _Waveform({required this.ctrl, required this.color});

  static const _heights = [6.0, 14.0, 20.0, 16.0, 22.0, 12.0, 18.0, 10.0, 8.0];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < _heights.length; i++) ...[
              Container(
                width: 4,
                height: _heights[i] *
                    (0.4 +
                        0.6 *
                            math
                                .sin(ctrl.value * math.pi + i * 1.3)
                                .abs()),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (i < _heights.length - 1) const SizedBox(width: 3),
            ],
          ],
        );
      },
    );
  }
}

// ── Bouncing dots ──────────────────────────────────────────────────────────────

class _BouncingDots extends StatelessWidget {
  final AnimationController ctrl;
  const _BouncingDots({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < 3; i++) ...[
              Transform.translate(
                offset: Offset(
                  0,
                  -6 *
                      math
                          .sin((ctrl.value * math.pi * 2) - (i * 0.4))
                          .clamp(0.0, 1.0),
                ),
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              if (i < 2) const SizedBox(width: 5),
            ],
          ],
        );
      },
    );
  }
}
