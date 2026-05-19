import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/appWidgets/app_text_form_field.dart';
import 'package:patient/core/businessLogic/auth_cubit/auth_cubit.dart';
import 'package:patient/core/theme/theme.dart';

import '../../core/businessLogic/auth_cubit/auth_listener.dart';
import '../../routing/routes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: cubit.formSignupKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Personal Details",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    "Tell us a bit about yourself",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AppTextFormField(
                    hintText: "John Doe",

                    controller: cubit.fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                      },
                      labelText: "Full Name"),
                  const SizedBox(
                    height: 20,
                  ),
                  AppTextFormField(
                        controller: cubit.phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                      },
                      labelText: "Phone Number"),
                  const SizedBox(
                    height: 20,
                  ),
                  AppTextFormField(
                        controller: cubit.emailSignupController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                      },
                      labelText: "Email Address"),
                  const SizedBox(
                    height: 20,
                  ),
                  AppTextFormField(
                        controller: cubit.passwordSignupController,
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                  },
                      isObscureText: true,
                      labelText: "Password"),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: AppTextFormField(
                                  controller: cubit.childNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your child\'s name';
                                  }
                                },
                                labelText: "Child's name",
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: AppTextFormField(
                                  controller: cubit.childAgeController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your child\'s age';
                                  }
                                },
                                labelText: "Child's age",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        AppTextFormField(
                          controller: cubit.childCaseController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your child\'s case details';
                            }
                          },
                          labelText: "Child's case",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<AuthCubit, AuthStates>(
                    listener: (context, state) {
                      if (state is RegisterSuccessState) {
                        Navigator.pushReplacementNamed(context, Routes.homeScreen);
                      }
                      if (state is RegisterErrorState) {
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
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: state is RegisterLoadingState
                            ? null
                            : () => AuthCubit.get(context).register(),
                        child: state is RegisterLoadingState
                            ? const CircularProgressIndicator(color: AppTheme.primaryColor)
                            : const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Sign In",
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              decoration: TextDecoration.underline,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                    context, Routes.loginScreen);

                              },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
