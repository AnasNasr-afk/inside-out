import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_tokens.dart';

/// Full-width gradient call-to-action used for Sign In / Create Account.
/// Shows a spinner while [isLoading] and ignores taps in that state.
class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: isLoading ? 0.85 : 1,
        child: Container(
          width: double.infinity,
          height: 56.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [T.primary, Color(0xFF9B7BFF)],
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: T.primaryCta,
          ),
          child: isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.4,
                  ),
                )
              : Text(
                  label,
                  style: T.sectionHeader().copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
        ),
      ),
    );
  }
}
