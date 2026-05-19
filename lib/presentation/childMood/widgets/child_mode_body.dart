import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../../games/games_screen.dart';
import '../../home/widgets/therapy_goal_card.dart';

class ChildModeBody extends StatelessWidget {
  const ChildModeBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Online Tasks card ───────────────────────────────
        GestureDetector(
          onTap: () {
            // TODO: navigate to online tasks screen
          },
          child: TherapyGoalCard(
            title: 'Online',
            subtitle: 'Tasks',
            illustration: Assets.illustrations.i9nGoals,
            backgroundColor: const Color(0xFFF9F3E3),
          ),
        ),

        const SizedBox(height: 15),

        // ── Games card ──────────────────────────────────────
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GamesScreen()),
          ),
          child: TherapyGoalCard(
            title: 'Games',
            subtitle: '',
            illustration: Assets.illustrations.i9nActivities,
            backgroundColor: const Color(0xFFE8F5E9),
          ),
        ),
      ],
    );
  }
}
