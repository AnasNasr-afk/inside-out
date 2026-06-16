import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/widgets/app_text_form_field.dart';
import 'package:patient/core/cubits/auth_cubit/auth_cubit.dart';
import 'package:patient/core/theme/theme.dart';

import '../../core/cubits/auth_cubit/auth_listener.dart';
import '../../core/routing/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Form(
              key: cubit.formLoginKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // ── Header ──────────────────────────────
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 27.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "Sign in to continue",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF83859C),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // ── Email ───────────────────────────────
                  AppTextFormField(
                    controller: cubit.emailLoginController,
                    labelText: "Email Address",
                    hintText: "john@example.com",
                    inputType: TextInputType.emailAddress,
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

                  SizedBox(height: 20.h),

                  // ── Password ────────────────────────────
                  AppTextFormField(
                    controller: cubit.passwordLoginController,
                    labelText: "Password",
                    hintText: "Enter your password",
                    isObscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 12.h),

                  // ── Forgot password ─────────────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // navigate to forgot password screen
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // ── Login button ────────────────────────
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
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        onPressed: state is LoginLoadingState
                            ? null
                            : () => AuthCubit.get(context).login(),
                        child: state is LoginLoadingState
                            ? const CircularProgressIndicator(
                            color: Colors.white)
                            : Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 24.h),

                  // ── Divider ─────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          "or continue with",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // ── Google Sign In ──────────────────────
                  BlocConsumer<AuthCubit, AuthStates>(
                    listener: (context, state) {
                      if (state is GoogleSignInSuccessState) {
                        Navigator.pushReplacementNamed(
                            context, Routes.homeScreen);
                      }
                      if (state is GoogleSignInErrorState) {
                        if (state.error != 'sign-in-cancelled') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error)),
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      return OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          side: BorderSide(
                            color: Color(0xFFC7C8D2),
                            width: 1.2.w,
                          ),
                        ),
                        // onPressed: state is GoogleSignInLoadingState
                        //     ? null
                        //     : () => AuthCubit.get(context).signInWithGoogle(),
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, Routes.homeScreen);
                        },
                        child: state is GoogleSignInLoadingState
                            ? const CircularProgressIndicator(
                            color: AppTheme.primaryColor)
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google_logo.png',
                              height: 20.h,
                              width: 20.w,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.g_mobiledata_rounded,
                                size: 24.sp,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "Continue with Google",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF545563),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 24.h),

                  // ── Sign up link ────────────────────────
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              decoration: TextDecoration.underline,
                              height: 1.5.h,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                    context, Routes.signupScreen);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}