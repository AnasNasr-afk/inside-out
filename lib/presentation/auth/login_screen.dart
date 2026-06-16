import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/cubits/auth_cubit/auth_cubit.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/core/widgets/app_text_form_field.dart';

import '../../core/cubits/auth_cubit/auth_listener.dart';
import '../../core/routing/routes.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_password_field.dart';
import 'widgets/auth_primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);

    return Scaffold(
      backgroundColor: T.appBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 28.h),
          child: Form(
            key: cubit.formLoginKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),

                // ── Header ──────────────────────────────
                const AuthHeader(
                  title: 'Welcome back',
                  subtitle: 'Sign in to continue your journey.',
                ),
                SizedBox(height: 36.h),

                // ── Email ───────────────────────────────
                AppTextFormField(
                  controller: cubit.emailLoginController,
                  labelText: 'Email Address',
                  hintText: 'john@example.com',
                  inputType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.mail_outline_rounded,
                      color: T.muted, size: 20.sp),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18.h),

                // ── Password ────────────────────────────
                AuthPasswordField(
                  controller: cubit.passwordLoginController,
                  hintText: 'Enter your password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 14.h),

                // ── Forgot password ─────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // navigate to forgot password screen
                    },
                    child: Text(
                      'Forgot Password?',
                      style: T.caption().copyWith(
                        color: T.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28.h),

                // ── Sign in button ──────────────────────
                BlocConsumer<AuthCubit, AuthStates>(
                  listener: (context, state) {
                    if (state is LoginSuccessState) {
                      Navigator.pushReplacementNamed(
                          context, Routes.homeScreen);
                    }
                    if (state is LoginErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return AuthPrimaryButton(
                      label: 'Sign In',
                      isLoading: state is LoginLoadingState,
                      onPressed: () => AuthCubit.get(context).login(),
                    );
                  },
                ),
                SizedBox(height: 24.h),

                // ── Sign up link ────────────────────────
                Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account?  ",
                          style: T.body().copyWith(color: T.mutedDeep),
                        ),
                        TextSpan(
                          text: 'Sign Up',
                          style: T.body().copyWith(
                            color: T.primary,
                            fontWeight: FontWeight.w800,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(
                                context, Routes.signupScreen),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
