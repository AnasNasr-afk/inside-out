import 'package:flutter/material.dart';
import 'package:patient/gen/assets.gen.dart';
import 'package:patient/presentation/home/widgets/quick_actions_row.dart';

import 'daily_activities_card.dart';
import 'overall_score_card.dart';

class HomeContent extends StatelessWidget {

  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome Back',
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 2, 2, 2))),

          Row(
            children: [
              const Text("Anas",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 2, 2, 2))),
              const Spacer(),

              /// KEEP UI — just comment logic
              GestureDetector(
                onTap: () {
                  // TODO: navigate to ChatScreen
                },
                child: Assets.icons.icChat.svg(width: 40, height: 40),
              ),
            ],
          ),

          const SizedBox(height: 20),
          ///Child's Name
          const MoodCheckInCard(childName: 'Anas',),

          const SizedBox(height: 20),

          const QuickActionsRow(),

          const SizedBox(height: 20),

          DailyActivitiesPreviewCard(onSeeAll: () {

          },),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}