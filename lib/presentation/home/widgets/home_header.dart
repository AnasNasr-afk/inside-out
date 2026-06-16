import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../gen/assets.gen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key,
    required this.greeting,
    required this.displayName,
    required this.parentInitial,
    required this.onAvatarTap,
    required this.onChatTap,
  });
  final String greeting;
  final String displayName;
  final String parentInitial;
  final VoidCallback onAvatarTap;
  final VoidCallback onChatTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Row(
        children: [
          // Avatar — taps to Profile
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                boxShadow: T.cardShadow,
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF7C5CFF), // 0%
                    Color(0xFF9B7BFF), // 100%
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  parentInitial,
                  style: T.sectionHeader()
                      .copyWith(
                      color: Colors.white,
                      fontSize: 18.sp),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                greeting,
                style: T.caption().copyWith(color: T.muted, fontSize: 13.sp),
              ),
              Text(
                displayName,
                style: T.screenTitle().copyWith(
                    fontSize: 22.sp,
                    letterSpacing: -0.4,
                  color: T.ink
                ),
              ),
            ],
          ),
          const Spacer(),
          // Chat shortcut
          GestureDetector(
            onTap: onChatTap,
            child: Container(
              width: 50.w,
              height: 50.h,

              decoration: BoxDecoration(
                color: const Color(0xFFECEAF6),
                shape: BoxShape.rectangle,
                boxShadow: T.cardShadow,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: Assets.icons.icChat.svg(
                  width: 37.w,
                  height: 37.h,
                  color:T.primary
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}