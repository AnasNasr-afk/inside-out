import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:patient/core/theme/app_tokens.dart';

class PmAllDone extends StatefulWidget {
  final int coinsEarned;
  final int totalCoins;
  final VoidCallback onContinue;

  const PmAllDone({
    super.key,
    required this.coinsEarned,
    required this.totalCoins,
    required this.onContinue,
  });

  @override
  State<PmAllDone> createState() => _PmAllDoneState();
}

class _PmAllDoneState extends State<PmAllDone> with TickerProviderStateMixin {
  late final AnimationController _confettiCtrl;
  late final AnimationController _popCtrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  static const _colors = [
    Color(0xFF14D9C4),
    Color(0xFF8A6BFF),
    Color(0xFFFFC93C),
    Color(0xFFFF5B72),
    Color(0xFFFFFFFF),
    Color(0xFF6BE4FF),
  ];

  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();

    final rng = math.Random(42);
    _particles = List.generate(60, (i) => _Particle.random(rng, _colors));

    _confettiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();

    _popCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _scale = CurvedAnimation(parent: _popCtrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _popCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    _popCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: FadeTransition(
        opacity: _fade,
        child: Stack(
          children: [
            // Blurred dark backdrop
            Container(color: const Color(0xCC1A1040)),

            // Confetti rain
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _confettiCtrl,
                builder: (_, __) => CustomPaint(
                  painter: _ConfettiPainter(
                    particles: _particles,
                    progress: _confettiCtrl.value,
                  ),
                ),
              ),
            ),

            // Centre card
            Center(
              child: ScaleTransition(
                scale: _scale,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 36),
                  padding: const EdgeInsets.fromLTRB(28, 34, 28, 28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D1F6E),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66000000),
                        blurRadius: 40,
                        offset: Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Star burst
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            colors: [Color(0xFFFFC93C), Color(0xFFFF8C00)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFC93C)
                                  .withValues(alpha: 0.50),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                      const SizedBox(height: 22),

                      Text(
                        'Amazing!',
                        style: T.sectionHeader().copyWith(
                          fontSize: 28,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You finished all your missions today!',
                        style: T.navLabel().copyWith(
                          fontSize: 15,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Coins pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 11),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC93C).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color:
                                const Color(0xFFFFC93C).withValues(alpha: 0.40),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFC93C),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '+${widget.coinsEarned} stars  ·  ${widget.totalCoins} total',
                              style: T.badge().copyWith(
                                fontSize: 14,
                                color: const Color(0xFFFFC93C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Continue button
                      GestureDetector(
                        onTap: widget.onContinue,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          decoration: BoxDecoration(
                            color: const Color(0xFF14D9C4),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF14D9C4)
                                    .withValues(alpha: 0.45),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'See you tomorrow!',
                                style: T.sectionHeader().copyWith(
                                  color: const Color(0xFF06342F),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.nights_stay_rounded,
                                color: Color(0xFF06342F),
                                size: 22,
                              ),
                            ],
                          ),
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
    );
  }
}

// ── Particle model ─────────────────────────────────────────────────────────────

class _Particle {
  final double x;        // 0..1 horizontal start
  final double yOffset;  // 0..1 stagger offset so not all start at top together
  final double speed;    // relative fall speed
  final double size;
  final Color color;
  final double rotation; // initial rotation radians
  final bool isRect;     // rect or circle

  const _Particle({
    required this.x,
    required this.yOffset,
    required this.speed,
    required this.size,
    required this.color,
    required this.rotation,
    required this.isRect,
  });

  factory _Particle.random(math.Random rng, List<Color> colors) {
    return _Particle(
      x: rng.nextDouble(),
      yOffset: rng.nextDouble(),
      speed: 0.5 + rng.nextDouble() * 0.5,
      size: 5 + rng.nextDouble() * 8,
      color: colors[rng.nextInt(colors.length)],
      rotation: rng.nextDouble() * math.pi * 2,
      isRect: rng.nextBool(),
    );
  }
}

// ── Confetti painter ───────────────────────────────────────────────────────────

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress; // 0..1 looping

  const _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      // Each particle starts at its yOffset and falls at its speed.
      final t = ((progress * p.speed + p.yOffset) % 1.0);
      final x = p.x * size.width +
          math.sin(t * math.pi * 2 + p.yOffset * 6) * 20;
      final y = t * (size.height + 30) - 20;

      final paint = Paint()
        ..color = p.color.withValues(alpha: (1 - t * 0.6).clamp(0, 1))
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation + t * math.pi * 3);

      if (p.isRect) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.5,
          ),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, p.size * 0.45, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
