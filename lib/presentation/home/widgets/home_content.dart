import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/businessLogic/task_cubit/task_cubit.dart';
import 'package:patient/core/businessLogic/task_cubit/task_listener.dart';
import 'package:patient/gen/assets.gen.dart';
import 'package:patient/presentation/home/widgets/quick_actions_row.dart';

import '../../../routing/routes.dart';
import 'avatar_widget.dart';
import 'daily_activities_card.dart';
import 'mood_check_in_card.dart';

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
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 16,
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
                    style: const TextStyle(
                      fontSize: 35,
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
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              MoodCheckInCard(
                childName: displayChild,
              ),

              const SizedBox(height: 20),

              const AvatarWidget(),

              const SizedBox(height: 20),

              const QuickActionsRow(),

              const SizedBox(height: 20),

              DailyActivitiesPreviewCard(
                onSeeAll: onSeeAllTasks,
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}