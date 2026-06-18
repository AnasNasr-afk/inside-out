import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_tokens.dart';

/// Brand header shared by the login and signup screens — the app icon
/// in a soft badge, followed by a title and a short subtitle.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: T.card,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: T.border),
            boxShadow: T.cardShadow,
          ),
          child: Image.asset(
            'assets/illustrations/appIconLightMode.png',
            height: 44.h,
          ),
        ),
        SizedBox(height: 26.h),
        Text(title, style: T.screenTitle()),
        SizedBox(height: 8.h),
        Text(subtitle, style: T.body().copyWith(color: T.mutedDeep)),
      ],
    );
  }
}
