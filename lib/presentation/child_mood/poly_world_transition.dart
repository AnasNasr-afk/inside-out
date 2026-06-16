import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'child_mode_screen.dart';
import 'child_mode_sounds.dart';

/// Plays the 3.2 s "game mode" entry sequence, then pushes [ChildModeScreen].
/// Usage:  PolyWorldTransition.show(context, childName: '...', frontendId: '...');
class PolyWorldTransition {
  static void show(
    BuildContext context, {
    required String childName,
    required String frontendId,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _TransitionView(
        childName: childName,
        // Called first — pushes the screen while the overlay still covers it.
        onNavigate: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChildModeScreen(frontendId: frontendId),
            ),
          );
        },
        // Called after the overlay fades out — safe to remove now.
        onRemove: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

// ── Main animated view ────────────────────────────────────────────────────────

class _TransitionView extends StatefulWidget {
  final String childName;
  final VoidCallback onNavigate;
  final VoidCallback onRemove;

  const _TransitionView({
    required this.childName,
    required this.onNavigate,
    required this.onRemove,
  });

  @override
  State<_TransitionView> createState() => _TransitionViewState();
}

class _TransitionViewState extends State<_TransitionView>
    with TickerProviderStateMixin {
  // Master controller — 3.2 s drives portal + all reveal/celebrate elements
  late final AnimationController _main;

  // Continuous loops
  late final AnimationController _rays;   // god-rays rotation, 16 s
  late final AnimationController _rings;  // pulsing rings, 2.4 s
  late final AnimationController _bob;    // Poly bear bob, 2.6 s

  // Fade-out overlay after navigate
  late final AnimationController _fade;

  // Derived animations
  late final Animation<double> _portal;
  late final Animation<double> _flash;
  late final Animation<double> _shock;
  late final Animation<double> _mascotScale;
  late final Animation<double> _mascotOpacity;
  late final Animation<double> _titleSlide;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _badgeScale;
  late final Animation<double> _badgeRotate;
  late final Animation<double> _badgeOpacity;
  late final Animation<double> _subtitleOpacity;
  late final Animation<double> _overlayFade;

  // Phase booleans (set by timers)
  bool _showReveal = false;
  bool _showCelebrate = false;

  // Stars and confetti (generated once)
  late final List<_Particle> _stars;
  late final List<_Confetti> _confetti;

  final _sounds = ChildModeSounds.instance;
  final List<Timer> _timers = [];

  // Cached per-layout values — computed once on first build.
  Offset? _portalOrigin;
  double? _maxRadius;

  @override
  void initState() {
    super.initState();
    final rng = math.Random(13);

    _stars = List.generate(26, (_) => _Particle(rng));
    _confetti = List.generate(34, (_) => _Confetti(rng));

    // Main controller: 0→3200 ms
    _main = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // Loops
    _rays  = AnimationController(vsync: this, duration: const Duration(seconds: 16))..repeat();
    _rings = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat();
    _bob   = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600))..repeat();

    // Fade-out
    _fade = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _overlayFade = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _fade, curve: Curves.easeIn));

    // ── Derived animations (fractions of 3200 ms) ──────────────────────────

    // Portal: 0→850 ms  cubic-bezier(.7,0,.2,1)
    _portal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0, 850 / 3200, curve: Cubic(0.7, 0, 0.2, 1)),
      ),
    );

    // Flash: 520→1220 ms
    _flash = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.92), weight: 26),
      TweenSequenceItem(tween: Tween(begin: 0.92, end: 0.0), weight: 74),
    ]).animate(CurvedAnimation(
      parent: _main,
      curve: const Interval(520 / 3200, 1220 / 3200),
    ));

    // Shockwave: 520→1520 ms  scale .3→3.4
    _shock = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _main,
      curve: const Interval(520 / 3200, 1520 / 3200, curve: Curves.easeOut),
    ));

    // Mascot entrance: 520→1370 ms  scale 0.2→1.18→0.94→1
    final mascotInterval = CurvedAnimation(
      parent: _main,
      curve: const Interval(520 / 3200, 1370 / 3200),
    );
    _mascotScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.2, end: 1.18)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.18, end: 0.94)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 26,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.94, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 24,
      ),
    ]).animate(mascotInterval);
    _mascotOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(520 / 3200, 620 / 3200),
      ),
    );

    // Title: 670→1270 ms  translateY 30→0 + opacity
    _titleSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(670 / 3200, 1270 / 3200, curve: Curves.easeOut),
      ),
    );
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(670 / 3200, 870 / 3200),
      ),
    );



    // PLAYTIME! badge: 1500→2050 ms  scale 2→0.88→1, rotate -14→5→-3 deg
    // Note: must NOT use an overshooting curve here — TweenSequence asserts
    // its input t ∈ [0,1]. Bounce is encoded in the tween values themselves.
    final badgeInterval = CurvedAnimation(
      parent: _main,
      curve: const Interval(1500 / 3200, 2050 / 3200, curve: Curves.easeOut),
    );
    _badgeScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 2.0, end: 0.88), weight: 62),
      TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.0), weight: 38),
    ]).animate(badgeInterval);
    _badgeRotate = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -14.0, end: 5.0), weight: 62),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: -3.0), weight: 38),
    ]).animate(badgeInterval);
    _badgeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(1500 / 3200, 1580 / 3200),
      ),
    );

    // Subtitle: 1700→2300 ms
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(1700 / 3200, 2300 / 3200, curve: Curves.easeOut),
      ),
    );

    // ── Start ──────────────────────────────────────────────────────────────
    // Animation starts immediately — no waiting for audio init.
    // Sounds are pre-warmed by the home screen; play them best-effort.
    _main.forward();
    _sounds.init().then((_) {
      if (mounted) _sounds.playWhoosh();
    });

    _timers.addAll([
      Timer(const Duration(milliseconds: 520), () {
        if (mounted) {
          setState(() => _showReveal = true);
          _sounds.playThud();
        }
      }),
      Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() => _showCelebrate = true);
          _sounds.playChime();
          _sounds.playSparkle();
        }
      }),
      Timer(const Duration(milliseconds: 3150), () {
        if (!mounted) return;
        // Push the screen NOW while the overlay still covers everything —
        // the child mode screen loads underneath, no home-screen flash.
        widget.onNavigate();
        _fade.forward().then((_) {
          if (mounted) widget.onRemove();
        });
      }),
    ]);
  }

  @override
  void dispose() {
    for (final t in _timers) t.cancel();
    _main.dispose();
    _rays.dispose();
    _rings.dispose();
    _bob.dispose();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Cache portal geometry — only computed once (size doesn't change).
    _portalOrigin ??= Offset(size.width * 0.84, size.height * 0.60);
    _maxRadius ??= _computeMaxRadius(_portalOrigin!, size);
    final origin = _portalOrigin!;
    final maxR = _maxRadius!;

    return AnimatedBuilder(
      animation: Listenable.merge([_main, _rays, _rings, _bob, _fade]),
      builder: (context, _) {
        // Screen-shake during celebrate phase (~420 ms)
        final mainT = _main.value;
        final shakeT = ((mainT - 1500 / 3200) / (420 / 3200)).clamp(0.0, 1.0);
        final shakeX = shakeT < 1.0
            ? math.sin(shakeT * math.pi * 8) * 5.0 * (1.0 - shakeT)
            : 0.0;

        return Opacity(
          opacity: _overlayFade.value,
          child: Transform.translate(
            offset: Offset(shakeX, 0),
            child: ClipPath(
              clipper: _PortalClipper(_portal.value, origin, maxR),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0.68, 0.2),
                    radius: 1.4,
                    colors: [Color(0xFF9B7FFF), Color(0xFF7C5CFF), Color(0xFF5A3ED9)],
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ── God-rays ─────────────────────────────────────────
                    if (_showReveal) _buildGodRays(size),

                    // ── Pulsing rings ─────────────────────────────────────
                    if (_showReveal) ...[
                      _buildRing(_rings.value, 0.0, size),
                      _buildRing(_rings.value, 0.5, size),
                    ],

                    // ── Stars + confetti — single canvas pass ─────────────
                    if (_showReveal || _showCelebrate)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ParticlesPainter(
                            mainT: _main.value,
                            stars: _stars,
                            confetti: _confetti,
                            showReveal: _showReveal,
                            showCelebrate: _showCelebrate,
                          ),
                        ),
                      ),

                    // ── Flash ─────────────────────────────────────────────
                    if (_showReveal)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            color: Colors.white.withValues(alpha: _flash.value),
                          ),
                        ),
                      ),

                    // ── Shockwave ring ────────────────────────────────────
                    if (_showReveal) _buildShockwave(size),

                    // ── Poly bear + title ─────────────────────────────────
                    if (_showReveal) _buildMascotAndTitle(size),

                    // ── PLAYTIME! badge + subtitle ────────────────────────
                    if (_showCelebrate) _buildBadgeAndSubtitle(size),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Sub-builders ───────────────────────────────────────────────────────────

  Widget _buildGodRays(Size size) {
    return Positioned(
      left: size.width / 2 - 180,
      top: size.height * 0.22 - 180,
      child: Transform.rotate(
        angle: _rays.value * 2 * math.pi,
        child: SizedBox(
          width: 360,
          height: 360,
          child: CustomPaint(painter: _RaysPainter()),
        ),
      ),
    );
  }

  Widget _buildRing(double t, double offset, Size size) {
    final phase = (t + offset) % 1.0;
    final scale = 0.45 + phase * (2.4 - 0.45);
    final opacity = (1.0 - phase).clamp(0.0, 0.5);
    return Center(
      child: Transform.translate(
        offset: Offset(0, -size.height * 0.10),
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: opacity),
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShockwave(Size size) {
    final scale = 0.3 + _shock.value * (3.4 - 0.3);
    final opacity = (0.8 * (1.0 - _shock.value)).clamp(0.0, 0.8);
    return Center(
      child: Transform.translate(
        offset: Offset(0, -size.height * 0.10),
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: opacity),
                width: 5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMascotAndTitle(Size size) {
    return Positioned(
      left: 0,
      right: 0,
      top: size.height * 0.12,
      child: Column(
        children: [
          // Poly bear
          Opacity(
            opacity: _mascotOpacity.value,
            child: Transform.scale(
              scale: _mascotScale.value,
              child: Transform.translate(
                offset: Offset(0, math.sin(_bob.value * 2 * math.pi) * -12),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      center: Alignment(-0.24, -0.36),
                      radius: 1.0,
                      colors: [
                        Colors.white,
                        Color(0xFFE8F8F5),
                        Color(0xFFCFEFE9),
                      ],
                      stops: [0.0, 0.60, 1.0],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x4D14786E),
                        blurRadius: 44,
                        offset: Offset(0, 22),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.sentiment_satisfied_alt_rounded,
                    size: 76,
                    color: Color(0xFF0E8F82),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Title "POLY'S WORLD" — gold gradient + star decorators
          Opacity(
            opacity: _titleOpacity.value,
            child: Transform.translate(
              offset: Offset(0, _titleSlide.value),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('✦',
                          style: TextStyle(
                              fontSize: 18, color: Color(0xFFFFC93C))),
                      const SizedBox(width: 10),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFFFFE87A),
                            Color(0xFFFFD740),
                          ],
                          stops: [0.0, 0.55, 1.0],
                        ).createShader(bounds),
                        child: Text(
                          "POLY'S WORLD",
                          style: GoogleFonts.nunito(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                color: Color(0x80280A6E),
                                blurRadius: 20,
                                offset: Offset(0, 6),
                              ),
                              Shadow(
                                color: Color(0x40FFD740),
                                blurRadius: 30,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('✦',
                          style: TextStyle(
                              fontSize: 18, color: Color(0xFFFFC93C))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Curved ribbon underline
                  Container(
                    width: 180,
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xAAFFD740),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeAndSubtitle(Size size) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: size.height * 0.20,
      child: Column(
        children: [
          // PLAYTIME! badge
          Opacity(
            opacity: _badgeOpacity.value,
            child: Transform.rotate(
              angle: _badgeRotate.value * math.pi / 180,
              child: Transform.scale(
                scale: _badgeScale.value,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC93C),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x80FFAA14),
                        blurRadius: 24,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 17, color: Color(0xFF5A3A00)),
                      const SizedBox(width: 8),
                      Text(
                        'PLAYTIME!',
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          color: const Color(0xFF5A3A00),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Subtitle
          Opacity(
            opacity: _subtitleOpacity.value,
            child: Text(
              'Ready to play, ${widget.childName}?',
              style: GoogleFonts.nunito(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Utilities ──────────────────────────────────────────────────────────────

  double _computeMaxRadius(Offset origin, Size size) {
    return [
      Offset(0, 0),
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ].map((c) => (c - origin).distance).reduce(math.max);
  }
}

// ── Portal clipper ─────────────────────────────────────────────────────────────

class _PortalClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset origin;
  final double maxRadius;

  const _PortalClipper(this.fraction, this.origin, this.maxRadius);

  @override
  Path getClip(Size size) => Path()
    ..addOval(
      Rect.fromCircle(center: origin, radius: maxRadius * fraction),
    );

  @override
  bool shouldReclip(_PortalClipper old) => old.fraction != fraction;
}

// ── God-rays painter ───────────────────────────────────────────────────────────

class _RaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;
    const rayCount = 17; // 360/21 ≈ 17 rays
    for (int i = 0; i < rayCount; i++) {
      final startAngle = i * (2 * math.pi / rayCount);
      final endAngle = startAngle + (7 * math.pi / 180); // 7 deg ray
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: size.width / 2),
          startAngle,
          endAngle - startAngle,
          false,
        )
        ..close();
      paint.color = Colors.white.withValues(alpha: 0.18);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Particle data ──────────────────────────────────────────────────────────────

const _palette = [
  Color(0xFFFFC93C),
  Color(0xFF14D9C4),
  Color(0xFFFF5B72),
  Color(0xFF5BD17A),
  Color(0xFF4CA9F5),
  Colors.white,
];

class _Particle {
  final double cosA;
  final double sinA;
  final double maxDist;
  final Color color;

  _Particle(math.Random rng) : this._init(rng.nextDouble() * 2 * math.pi, rng);

  _Particle._init(double angle, math.Random rng)
      : cosA    = math.cos(angle),
        sinA    = math.sin(angle),
        maxDist = 60 + rng.nextDouble() * 110,
        color   = _palette[rng.nextInt(_palette.length)];
}

class _Confetti {
  final double x;
  final double rotations;
  final double w;
  final double h;
  final bool round;
  final Color color;

  _Confetti(math.Random rng)
      : x = rng.nextDouble(),
        rotations = 2 + rng.nextDouble() * 5,
        w = 6 + rng.nextDouble() * 6,
        h = 8 + rng.nextDouble() * 8,
        round = rng.nextBool(),
        color = _palette[rng.nextInt(_palette.length)];
}

// ── Particles painter — draws all stars + confetti in one canvas pass ──────────

class _ParticlesPainter extends CustomPainter {
  final double mainT;
  final List<_Particle> stars;
  final List<_Confetti> confetti;
  final bool showReveal;
  final bool showCelebrate;

  _ParticlesPainter({
    required this.mainT,
    required this.stars,
    required this.confetti,
    required this.showReveal,
    required this.showCelebrate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    if (showReveal) {
      final p = ((mainT - 520 / 3200) / (800 / 3200)).clamp(0.0, 1.0);
      final opacity =
          p < 0.18 ? p / 0.18 : (1.0 - p).clamp(0.0, 1.0);
      final cy = size.height * 0.28;
      final cx = size.width / 2;
      for (final s in stars) {
        final dist = s.maxDist * p;
        paint.color = s.color.withValues(alpha: opacity);
        canvas.drawCircle(Offset(cx + dist * s.cosA, cy + dist * s.sinA), 5, paint);
      }
    }

    if (showCelebrate) {
      final p = ((mainT - 1500 / 3200) / (1700 / 3200)).clamp(0.0, 1.0);
      final opacity = (p < 0.12 ? p / 0.12 : 0.95).clamp(0.0, 1.0);
      for (final c in confetti) {
        final y = -30.0 + p * (size.height + 100);
        final rotation = p * c.rotations * 2 * math.pi;
        paint.color = c.color.withValues(alpha: opacity);
        canvas.save();
        canvas.translate(c.x * size.width, y);
        canvas.rotate(rotation);
        final rect = Rect.fromCenter(
            center: Offset.zero, width: c.w, height: c.h);
        if (c.round) {
          canvas.drawOval(rect, paint);
        } else {
          canvas.drawRRect(RRect.fromRectXY(rect, 2, 2), paint);
        }
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter old) =>
      old.mainT != mainT ||
      old.showReveal != showReveal ||
      old.showCelebrate != showCelebrate;
}
