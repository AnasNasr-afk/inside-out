import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/theme/app_tokens.dart';

import '../../../core/helpers/check_in_helper.dart';

class MoodCheckInCard extends StatefulWidget {
  final String childName;

  const MoodCheckInCard({
    super.key,
    required this.childName,
  });

  @override
  State<MoodCheckInCard> createState() => _MoodCheckInCardState();
}

class _MoodCheckInCardState extends State<MoodCheckInCard>
    with SingleTickerProviderStateMixin {
  int? _selectedIndex;
  int? _prevIndex;

  // Scale-pulse controller — triggers on every mood tap
  late final AnimationController _pulseCtrl;
  late final Animation<double> _scaleAnim;

  static const _moods = [
    (label: 'Great', bright: Color(0xFF14D9C4), dark: Color(0xFF0D2A26), icon: Icons.sentiment_very_satisfied_rounded),
    (label: 'Good',  bright: Color(0xFF5BD17A), dark: Color(0xFF0D2618), icon: Icons.sentiment_satisfied_alt_rounded),
    (label: 'Okay',  bright: Color(0xFFFFC93C), dark: Color(0xFF2A1E08), icon: Icons.sentiment_neutral_rounded),
    (label: 'Low',   bright: Color(0xFFFF8C42), dark: Color(0xFF2A1408), icon: Icons.sentiment_dissatisfied_rounded),
    (label: 'Rough', bright: Color(0xFFFF5B72), dark: Color(0xFF2A0E14), icon: Icons.sentiment_very_dissatisfied_rounded),
  ];

  static const _circleGradients = [
    [Color(0xFF17E2CD), Color(0xFF0FBDAD)], // Great - teal
    [Color(0xFF5BD17A), Color(0xFF3DB85E)], // Good  - green
    [Color(0xFFFFC93C), Color(0xFFE5A800)], // Okay  - gold
    [Color(0xFFFF8C42), Color(0xFFE56D20)], // Low   - orange
    [Color(0xFFFF5B72), Color(0xFFE03550)], // Rough - coral
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.12)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.12, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_pulseCtrl);

    final saved = CheckInHelper.getTodayMood();
    if (saved != null && saved > 0) _selectedIndex = saved - 1;
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _select(int i) async {
    setState(() {
      _prevIndex = _selectedIndex;
      _selectedIndex = i;
    });
    _pulseCtrl.forward(from: 0);
    await CheckInHelper.saveCheckIn(i + 1);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Stack(
        children: [
          Image.asset(
            'assets/illustrations/Background+Shadow.png',
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),

          // ── Content ─────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // Daily check-in
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7.w,
                            height: 7.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFF17E2CD),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Daily check-in',
                            style: T.caption().copyWith(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // 5-day streak
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: T.gold.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            size: 12.sp,
                            color: T.gold,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '5-day streak',
                            style: T.caption().copyWith(
                              color: T.gold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      key: ValueKey(_selectedIndex),
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      builder: (context, t, _) {
                        final from = _circleGradients[_prevIndex ?? _selectedIndex ?? 0];
                        final to   = _circleGradients[_selectedIndex ?? 0];
                        final fromShadow = _moods[_prevIndex ?? _selectedIndex ?? 0].bright;
                        final toShadow   = _moods[_selectedIndex ?? 0].bright;

                        final c1 = Color.lerp(from[0], to[0], t)!;
                        final c2 = Color.lerp(from[1], to[1], t)!;
                        final shadow = Color.lerp(fromShadow, toShadow, t)!;

                        return AnimatedBuilder(
                          animation: _scaleAnim,
                          builder: (context, child) => Transform.scale(
                            scale: _scaleAnim.value,
                            child: child,
                          ),
                          child: Container(
                            width: 70.w,
                            height: 70.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [c1, c2],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: shadow.withValues(alpha: 0.45),
                                  blurRadius: 16.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, anim) => ScaleTransition(
                                scale: anim,
                                child: FadeTransition(opacity: anim, child: child),
                              ),
                              child: Icon(
                                _moods[_selectedIndex ?? 0].icon,
                                key: ValueKey(_selectedIndex),
                                size: 40.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(width: 16.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How is ${widget.childName}\nfeeling today?',
                            style: T.screenTitle().copyWith(
                              color: Colors.white,
                              fontSize: 22.sp,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30.h),

                // ── Mood dots ──────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_moods.length, (i) {
                    final m = _moods[i];
                    final selected = _selectedIndex == i;

                    return GestureDetector(
                      onTap: () => _select(i),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: selected ? m.bright : m.dark,
                              shape: BoxShape.circle,
                            ),
                            child: selected
                                ? Center(
                                    child: Icon(
                                      Icons.check_rounded,
                                      size: 20.sp,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            m.label,
                            style: T.caption().copyWith(
                              fontSize: 12.sp,
                              color: selected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.45),
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
