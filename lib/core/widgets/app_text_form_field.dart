import 'package:flutter/material.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final String labelText;
  final bool? isObscureText;
  final Color? backgroundColor;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final Function(String?) validator;

  // ── Design tokens from screenshot ──────────────────────
  static const _hintColor       = Color(0xFF83859C);
  static const _borderColor     = Color(0xFFC7C8D2);
  static const _labelColor      = Color(0xFF545563);
  static const _focusedBorder   = Color(0xFF6366F1); // primary purple — predicted
  static const _errorColor      = Color(0xFFE53935); // standard red — predicted
  static const _fillColor       = Color(0xFFFFFFFF); // pure white from screenshot
  static const _inputTextColor  = Color(0xFF1F2033); // near black — predicted from label family
  static const _disabledBorder  = Color(0xFFE8E9F0); // lighter than border — predicted

  const AppTextFormField({
    super.key,
    this.prefixIcon,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    this.suffixIcon,
    this.hintText,
    this.isObscureText,
    this.backgroundColor,
    this.controller,
    required this.validator,
    this.inputType,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label above the field ───────────────────────
        Text(
          labelText,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: _labelColor,
            letterSpacing: 0.1.sp,
          ),
        ),
        SizedBox(height: 8.h),

        // ── Input field ─────────────────────────────────
        TextFormField(
          keyboardType: inputType ?? TextInputType.text,
          controller: controller,
          obscureText: isObscureText ?? false,
          style: inputTextStyle ??
              TextStyle(
                fontSize: 16.sp,
                color: _inputTextColor,
                fontWeight: FontWeight.w400,
              ),
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: hintStyle ??
                TextStyle(
                  fontSize: 16.sp,
                  color: _hintColor,
                  fontWeight: FontWeight.w400,
                ),

            // ── No floating label — label is above ──────
            floatingLabelBehavior: FloatingLabelBehavior.never,
            label: null,

            // ── Padding — tall like screenshot ──────────
            isDense: false,
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 18.h,
                ),

            // ── Fill ────────────────────────────────────
            filled: true,
            fillColor: backgroundColor ?? _fillColor,

            // ── Borders ─────────────────────────────────
            enabledBorder: enabledBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _borderColor,
                    width: 1.2.w,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
            focusedBorder: focusedBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _focusedBorder,
                    width: 1.5.w,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _errorColor,
                width: 1.2.w,
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _errorColor,
                width: 1.5.w,
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _disabledBorder,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          validator: (value) => validator(value),
        ),
      ],
    );
  }
}