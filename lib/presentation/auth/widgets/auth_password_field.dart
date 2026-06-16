import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/widgets/app_text_form_field.dart';

import '../../../core/theme/app_tokens.dart';

/// Password input built on [AppTextFormField] with a lock prefix and a
/// show/hide visibility toggle.
class AuthPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final Function(String?) validator;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.validator,
    this.labelText = 'Password',
    this.hintText,
  });

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      isObscureText: _obscure,
      validator: widget.validator,
      prefixIcon: Icon(Icons.lock_outline_rounded, color: T.muted, size: 20.sp),
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: Icon(
          _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          color: T.muted,
          size: 20.sp,
        ),
      ),
    );
  }
}
