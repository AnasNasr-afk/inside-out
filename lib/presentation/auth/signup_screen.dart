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

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);

    return Scaffold(
      backgroundColor: T.appBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 28.h),
          child: Form(
            key: cubit.formSignupKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),

                // ── Header ──────────────────────────────
                const AuthHeader(
                  title: 'Create account',
                  subtitle: 'Tell us about you and your child.',
                ),
                SizedBox(height: 32.h),

                // ── Parent details ──────────────────────
                AppTextFormField(
                  controller: cubit.fullNameController,
                  labelText: 'Full Name',
                  hintText: 'John Doe',
                  prefixIcon: Icon(Icons.person_outline_rounded,
                      color: T.muted, size: 20.sp),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18.h),
                AppTextFormField(
                  controller: cubit.phoneController,
                  labelText: 'Phone Number',
                  hintText: '+20 100 000 0000',
                  inputType: TextInputType.phone,
                  prefixIcon: Icon(Icons.phone_outlined,
                      color: T.muted, size: 20.sp),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18.h),
                AppTextFormField(
                  controller: cubit.emailSignupController,
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
                AuthPasswordField(
                  controller: cubit.passwordSignupController,
                  hintText: 'Create a password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 26.h),

                // ── Child section label ─────────────────
                Row(
                  children: [
                    Text(
                      'YOUR CHILD',
                      style: T.badge().copyWith(
                        color: T.muted,
                        fontSize: 11.sp,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(child: Container(height: 1, color: T.border)),
                  ],
                ),
                SizedBox(height: 20.h),

                // ── Child details ───────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextFormField(
                        controller: cubit.childNameController,
                        labelText: "Child's name",
                        hintText: 'Sara',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter child's name";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppTextFormField(
                        controller: cubit.childAgeController,
                        labelText: "Child's age",
                        hintText: '6',
                        inputType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter child's age";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                AppTextFormField(
                  controller: cubit.childCaseController,
                  labelText: "Child's case",
                  hintText: 'e.g. Autism, Down syndrome',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter child's case details";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30.h),

                // ── Create account button ───────────────
                BlocConsumer<AuthCubit, AuthStates>(
                  listener: (context, state) {
                    if (state is RegisterSuccessState) {
                      Navigator.pushReplacementNamed(
                          context, Routes.loginScreen);
                    }
                    if (state is RegisterErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return AuthPrimaryButton(
                      label: 'Create Account',
                      isLoading: state is RegisterLoadingState,
                      onPressed: () => AuthCubit.get(context).register(),
                    );
                  },
                ),
                SizedBox(height: 20.h),

                // ── Sign in link ────────────────────────
                Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account?  ',
                          style: T.body().copyWith(color: T.mutedDeep),
                        ),
                        TextSpan(
                          text: 'Sign In',
                          style: T.body().copyWith(
                            color: T.primary,
                            fontWeight: FontWeight.w800,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(
                                context, Routes.loginScreen),
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
