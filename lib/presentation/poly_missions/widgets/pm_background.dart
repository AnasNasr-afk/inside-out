import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PmBackground extends StatefulWidget {
  const PmBackground({super.key});

  @override
  State<PmBackground> createState() => _PmBackgroundState();
}

class _PmBackgroundState extends State<PmBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  static final _stars = List.generate(20, (i) {
    final rng = math.Random(i * 17 + 3);
    return _StarData(
      x: 0.03 + rng.nextDouble() * 0.94,
      y: 0.04 + rng.nextDouble() * 0.50,
      radius: (1.0 + rng.nextDouble() * 1.5).r,
      phase: rng.nextDouble() * math.pi * 2,
      speed: 2.0 + rng.nextDouble() * 2.5,
    );
  });

  static final _snow = List.generate(14, (i) {
    final rng = math.Random(i * 23 + 11);
    return _SnowData(
      x: rng.nextDouble(),
      radius: (1.5 + rng.nextDouble() * 2.0).r,
      phase: rng.nextDouble(),
      duration: 7.0 + rng.nextDouble() * 6.0,
      drift: (rng.nextDouble() - 0.5) * 40.w,
    );
  });

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = _ctrl.value;
        final a1 = math.sin(t * math.pi * 2 * (20 / 11)) * size.width * 0.06;
        final a2 = math.sin(t * math.pi * 2 * (20 / 14) + math.pi) * size.width * 0.06;

        return Stack(
          children: [
            // ── Gradient ─────────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.38, 0.64, 1.0],
                  colors: [
                    Color(0xFF2B2360),
                    Color(0xFF4A3A9C),
                    Color(0xFF6E5BC9),
                    Color(0xFF3FA8C9),
                  ],
                ),
              ),
            ),

            // ── Aurora ribbon 1 ───────────────────────────────────────
            Positioned(
              top: size.height * 0.16,
              left: -size.width * 0.14 + a1,
              width: size.width * 1.30,
              height: 120.h,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 26.r, sigmaY: 26.r),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0x809B7BFF),
                        Color(0x733FE0CE),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Aurora ribbon 2 ───────────────────────────────────────
            Positioned(
              top: size.height * 0.28,
              left: -size.width * 0.14 + a2,
              width: size.width * 1.30,
              height: 90.h,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 22.r, sigmaY: 22.r),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0x663FE0CE),
                        Color(0x667C5CFF),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Stars + snow ──────────────────────────────────────────
            Positioned.fill(
              child: CustomPaint(
                painter: _ScenePainter(t: t, stars: _stars, snow: _snow),
              ),
            ),

            // ── Ground mound (moon surface) ───────────────────────────
            Positioned(
              left: -size.width * 0.12,
              bottom: 0,
              width: size.width * 1.24,
              height: 225.h,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(1200.r)),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFEAF4F8), Color(0xFFC6DCEA)],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(1200.r)),
                      child: CustomPaint(painter: _MoonCraterPainter()),
                    ),
                  ),
                ],
              ),
            ),

            // ── Glow behind Poly ─────────────────────────────────────
            Positioned(
              bottom: 100.h,
              left: size.width / 2 - 150.w,
              width: 300.w,
              height: 300.h,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x80FFFFFF),
                      Color(0x29BEEAFF),
                      Colors.transparent,
                    ],
                    stops: [0, 0.45, 0.70],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Data classes ───────────────────────────────────────────────────────────────

class _StarData {
  final double x, y, radius, phase, speed;
  const _StarData({
    required this.x,
    required this.y,
    required this.radius,
    required this.phase,
    required this.speed,
  });
}

class _SnowData {
  final double x, radius, phase, duration, drift;
  const _SnowData({
    required this.x,
    required this.radius,
    required this.phase,
    required this.duration,
    required this.drift,
  });
}

// ── Moon surface painter ───────────────────────────────────────────────────────

class _MoonCraterPainter extends CustomPainter {
  // Fixed craters: (xFraction, yFraction, radius)
  static const _craters = [
    (0.12, 0.28, 18.0),
    (0.30, 0.18, 12.0),
    (0.50, 0.30, 22.0),
    (0.68, 0.20, 15.0),
    (0.84, 0.32, 10.0),
    (0.22, 0.48, 8.0),
    (0.60, 0.44, 7.0),
    (0.76, 0.50, 5.0),
    (0.40, 0.38, 5.5),
  ];

  // Small pebble dots: (xFraction, yFraction, radius)
  static const _dots = [
    (0.08, 0.42, 2.5), (0.18, 0.60, 2.0), (0.28, 0.35, 1.8),
    (0.37, 0.55, 2.2), (0.46, 0.48, 1.5), (0.55, 0.62, 2.0),
    (0.63, 0.36, 1.8), (0.72, 0.58, 2.5), (0.80, 0.44, 1.6),
    (0.88, 0.52, 2.0), (0.93, 0.38, 1.5), (0.15, 0.70, 1.8),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rimPaint = Paint()..style = PaintingStyle.stroke;
    final fillPaint = Paint()..style = PaintingStyle.fill;

    for (final (xf, yf, rRaw) in _craters) {
      final r = rRaw.r;
      final c = Offset(xf * size.width, yf * size.height);

      // Crater floor (slightly deeper tone)
      fillPaint.color = const Color(0xFFD4E6EF);
      canvas.drawCircle(c, r, fillPaint);

      // Shadow rim
      rimPaint
        ..color = const Color(0xFFB0C8D6)
        ..strokeWidth = r * 0.28;
      canvas.drawCircle(c, r * 0.85, rimPaint);

      // Highlight arc (top-left, as if lit from upper-left)
      rimPaint
        ..color = const Color(0xCCFFFFFF)
        ..strokeWidth = r * 0.18;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r * 0.72),
        math.pi * 0.95,
        math.pi * 0.75,
        false,
        rimPaint,
      );
    }

    // Small pebble dots
    for (final (xf, yf, rRaw) in _dots) {
      final r = rRaw.r;
      fillPaint.color = const Color(0xFFBDD4DF);
      canvas.drawCircle(Offset(xf * size.width, yf * size.height), r, fillPaint);
    }
  }

  @override
  bool shouldRepaint(_MoonCraterPainter old) => false;
}

// ── Scene painter ──────────────────────────────────────────────────────────────

class _ScenePainter extends CustomPainter {
  final double t;
  final List<_StarData> stars;
  final List<_SnowData> snow;

  const _ScenePainter({
    required this.t,
    required this.stars,
    required this.snow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final s in stars) {
      final cycle = t * 20 / s.speed;
      final opacity = 0.25 + 0.75 * (math.sin(cycle * math.pi * 2 + s.phase) + 1) / 2;
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(s.x * size.width, s.y * size.height), s.radius, paint);
    }

    for (final f in snow) {
      final cycles = 20 / f.duration;
      final progress = ((t * cycles) + f.phase) % 1.0;
      final y = progress * (size.height + 20.h) - 20.h;
      final x = f.x * size.width + f.drift * progress;
      paint.color = Colors.white.withValues(alpha: 0.75);
      canvas.drawCircle(Offset(x, y), f.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ScenePainter old) => old.t != t;
}
