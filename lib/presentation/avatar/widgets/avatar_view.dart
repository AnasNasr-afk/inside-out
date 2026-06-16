import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cubits/avatar_cubit/avatar_cubit.dart';
import '../../../core/cubits/avatar_cubit/avatar_states.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarView extends StatelessWidget {
  const AvatarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvatarCubit, AvatarState>(
      builder: (context, state) {
        return Container(
          height: 250.h,
          width: 250.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: Text(
              state.emotion.toUpperCase(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}