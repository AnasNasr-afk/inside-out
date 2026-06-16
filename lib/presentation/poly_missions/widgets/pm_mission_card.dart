import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/presentation/poly_missions/widgets/pm_mission.dart';

class PmMissionCard extends StatefulWidget {
  final PolyMission mission;
  final bool isDone;
  final VoidCallback onTap;

  const PmMissionCard({
    super.key,
    required this.mission,
    required this.isDone,
    required this.onTap,
  });

  @override
  State<PmMissionCard> createState() => _PmMissionCardState();
}

class _PmMissionCardState extends State<PmMissionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ringCtrl;
  late final Animation<double> _ringScale;
  late final Animation<double> _ringOpacity;

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );
    _ringScale = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut),
    );
    _ringOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut),
    );
    if (!widget.isDone) _ringCtrl.repeat();
  }

  @override
  void didUpdateWidget(PmMissionCard old) {
    super.didUpdateWidget(old);
    if (widget.isDone) {
      _ringCtrl.stop();
    } else if (!_ringCtrl.isAnimating) {
      _ringCtrl.repeat();
    }
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isDone ? null : widget.onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: widget.isDone ? 0.7 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: widget.isDone
                ? Colors.white.withValues(alpha: 0.50)
                : Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: Colors.transparent, width: 3.w),
            boxShadow: [
              BoxShadow(
                color: const Color(0x4D281959),
                blurRadius: 22.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(8.w, 15.h, 8.w, 13.h),
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              // Pulsing ring (undone only) — extends 4px outside the card
              if (!widget.isDone)
                Positioned(
                  top: -4.h,
                  left: -4.w,
                  right: -4.w,
                  bottom: -4.h,
                  child: AnimatedBuilder(
                    animation: _ringCtrl,
                    builder: (_, __) => Transform.scale(
                      scale: _ringScale.value,
                      child: Opacity(
                        opacity: _ringOpacity.value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.55),
                              width: 2.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon tile
                  Container(
                    width: 46.w,
                    height: 46.h,
                    decoration: BoxDecoration(
                      color: widget.mission.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Icon(
                      widget.mission.icon,
                      size: 24.sp,
                      color: widget.mission.deepColor,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Label — single line, no wrap
                  Text(
                    widget.mission.label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: T.caption().copyWith(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2B2360),
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 5.h),

                  // Reward or done label
                  widget.isDone
                      ? Text(
                          '✓ Done',
                          style: T.badge().copyWith(
                            color: const Color(0xFF0E8F82),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 11.sp,
                              color: widget.mission.deepColor,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '+10',
                              style: T.badge().copyWith(
                                color: widget.mission.deepColor,
                              ),
                            ),
                          ],
                        ),
                ],
              ),

              // Done check badge
              if (widget.isDone)
                Positioned(
                  top: -4.h,
                  right: -4.w,
                  child: Container(
                    width: 22.w,
                    height: 22.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFF14B2A0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 13.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
