import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/gen/assets.gen.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF211E40).withValues(alpha: 0.10),
            blurRadius: 28.r,
            offset: Offset(0, 8.h),
          ),
          BoxShadow(
            color: const Color(0xFF7C5CFF).withValues(alpha: 0.08),
            blurRadius: 12.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Item(icon: Assets.icons.icHome,          label: 'Explore', active: selectedIndex == 0, onTap: () { HapticFeedback.lightImpact(); onTap(0); }),
          _Item(icon: Assets.icons.icTasks,         label: 'Tasks',   active: selectedIndex == 1, onTap: () { HapticFeedback.lightImpact(); onTap(1); }),
          _Item(icon: Assets.icons.icNotifications, label: 'Alerts',  active: selectedIndex == 2, onTap: () { HapticFeedback.lightImpact(); onTap(2); }),
          _Item(icon: Assets.icons.icProfile,       label: 'Profile', active: selectedIndex == 3, onTap: () { HapticFeedback.lightImpact(); onTap(3); }),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final dynamic icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Item({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  static const _violet = Color(0xFF7C5CFF);
  static const _grey   = Color(0xFF9A98B6);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: active ? 16.0.w : 13.0.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: active ? _violet : Colors.transparent,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon.svg(
              width: 22.0.w,
              height: 22.0.h,
              colorFilter: ColorFilter.mode(
                active ? Colors.white : _grey,
                BlendMode.srcIn,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOutCubic,
              child: active
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 7.w),
                        Text(
                          label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
