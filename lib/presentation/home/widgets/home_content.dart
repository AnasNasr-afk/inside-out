import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/cubits/task_cubit/task_cubit.dart';
import 'package:patient/core/cubits/task_cubit/task_listener.dart';
import 'package:patient/gen/assets.gen.dart';
import 'package:patient/presentation/home/widgets/quick_actions_row.dart';

import '../../../core/routing/routes.dart';
import 'avatar_widget.dart';
import 'daily_activities_card.dart';
import 'mood_check_in_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeContent extends StatelessWidget {
  final VoidCallback onSeeAllTasks;

  const HomeContent({
    super.key,
    required this.onSeeAllTasks,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskStates>(
      builder: (context, state) {
        final cubit = TaskCubit.get(context);

        final userData = cubit.parentChildData;

        final displayName =
        userData?.parentName.isNotEmpty == true
            ? userData!.parentName.split(' ').first
            : 'Parent';

        final displayChild =
        userData?.childName.isNotEmpty == true
            ? userData!.childName
            : 'Your Child';

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            12,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Color.fromARGB(
                    255,
                    2,
                    2,
                    2,
                  ),
                ),
              ),

              Row(
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(
                        255,
                        2,
                        2,
                        2,
                      ),
                    ),
                  ),

                  const Spacer(),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.chatScreen,
                      );
                    },
                    child: Assets.icons.icChat.svg(
                      width: 40.w,
                      height: 40.h,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              MoodCheckInCard(
                childName: displayChild,
              ),

              SizedBox(height: 20.h),

              const AvatarWidget(),

              SizedBox(height: 20.h),

              const QuickActionsRow(),

              SizedBox(height: 20.h),

              DailyActivitiesPreviewCard(
                onSeeAll: onSeeAllTasks,
              ),

              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }
}