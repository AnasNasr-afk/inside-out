import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cubits/auth_cubit/auth_cubit.dart';
import '../../../core/cubits/auth_cubit/auth_listener.dart';
import '../../../gen/assets.gen.dart';
import '../../../core/routing/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});



  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is GoogleSignInSuccessState) {
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        }

        if (state is GoogleSignInErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthStates>(
        builder: (context, state) {
          bool isLoading = state is GoogleSignInLoadingState;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => AuthCubit.get(context).signInWithGoogle(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  elevation: 2,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.logos.lgGoogle.svg(width: 40.w, height: 40.h),
                    SizedBox(width: 10.w),
                    Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}