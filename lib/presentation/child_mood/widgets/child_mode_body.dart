import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../games/games_screen.dart';
import '../../poly_missions/poly_missions_screen.dart';

class ChildModeBody extends StatefulWidget {
  final VoidCallback? onTileTap;

  /// Fired when the user returns from Poly Missions, so the parent can refresh
  /// coins earned during the session.
  final VoidCallback? onReturnFromMissions;
  const ChildModeBody({super.key, this.onTileTap, this.onReturnFromMissions});

  @override
  State<ChildModeBody> createState() => _ChildModeBodyState();
}

class _ChildModeBodyState extends State<ChildModeBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _anims;

  // delays: 50ms, 160ms; each tile 550ms; total 820ms
  static const _total = 820;
  static const _tileDur = 550;
  static const _delays = [50, 160];
  // Matches spec: cubic-bezier(.2,.85,.25,1.05)
  static const _curve = Cubic(0.2, 0.85, 0.25, 1.05);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _total),
    );
    _anims = _delays.map((d) {
      final start = d / _total;
      final end = ((d + _tileDur) / _total).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: _curve)),
      );
    }).toList();
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _tap(VoidCallback navigate) {
    widget.onTileTap?.call();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => Column(
        children: [
          _TileRise(
            anim: _anims[0],
            child: _Tile(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1ED8C4), Color(0xFF0FB6A6)],
              ),
              shadowColor: const Color(0xFF0FB6A6),
              iconBg: const Color(0x47FFFFFF),
              icon: Icons.sports_esports_rounded,
              iconColor: Colors.white,
              title: 'Games',
              titleColor: const Color(0xFF03342F),
              subtitle: 'Play & learn with Dooby',
              subtitleColor: const Color(0xFF0A5C53),
              playColor: Colors.white,
              onTap: () => _tap(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GamesScreen()),
                ),
              ),
            ),
          ),
          SizedBox(height: 14.h),
          _TileRise(
            anim: _anims[1],
            child: _TalkToPolyTile(
              onTap: () => _tap(
                () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PolyMissionsScreen()),
                  );
                  widget.onReturnFromMissions?.call();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated wrapper — translateY(46→0) + scale(0.94→1) + fade ────────────────

class _TileRise extends StatelessWidget {
  final Animation<double> anim;
  final Widget child;
  const _TileRise({required this.anim, required this.child});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, 46.0.h * (1.0 - anim.value)),
      child: Transform.scale(
        scale: 0.94 + 0.06 * anim.value,
        child: Opacity(
          opacity: anim.value.clamp(0.0, 1.0),
          child: child,
        ),
      ),
    );
  }
}

// ── Generic gradient tile ──────────────────────────────────────────────────────

class _Tile extends StatelessWidget {
  final LinearGradient gradient;
  final Color shadowColor;
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final String subtitle;
  final Color subtitleColor;
  final Color playColor;
  final VoidCallback onTap;

  const _Tile({
    required this.gradient,
    required this.shadowColor,
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.subtitle,
    required this.subtitleColor,
    required this.playColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withValues(alpha: 0.42),
              blurRadius: 30.r,
              offset: Offset(0, 16.h),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.h),
        child: Row(
          children: [
            Container(
              width: 66.w,
              height: 66.h,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(icon, size: 32.sp, color: iconColor),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_arrow_rounded, color: playColor, size: 20.sp),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Talk to Dooby tile — special because of the mint online dot ─────────────────

class _TalkToPolyTile extends StatelessWidget {
  final VoidCallback onTap;
  const _TalkToPolyTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8A6BFF), Color(0xFF6A4BF0)],
          ),
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C5CFF).withValues(alpha: 0.45),
              blurRadius: 30.r,
              offset: Offset(0, 16.h),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.h),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 66.w,
                  height: 66.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.sentiment_satisfied_alt_rounded,
                    size: 32.sp,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  top: -3.h,
                  right: -3.w,
                  child: Container(
                    width: 14.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14D9C4),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF7558E8),
                        width: 2.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Talk to Dooby',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Chat with your buddy · online',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xD1FFFFFF),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
