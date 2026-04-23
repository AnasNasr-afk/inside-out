import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/presentation/appointments/appointment_list_screen.dart';
import 'package:patient/presentation/childMood/child_mode_screen.dart';
import 'package:patient/presentation/home/widgets/quick_action_button.dart';

import '../../../routing/routes.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickActionButton(
                icon: Icons.bar_chart_outlined,
                label: 'Reports',
                onTap: () {
                  Navigator.pushNamed(context, Routes.reportScreen);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QuickActionButton(
                icon: Icons.child_care_outlined,
                label: 'Child Mode',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChildModeScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QuickActionButton(
                icon: Icons.calendar_month_rounded,
                label: 'Appointments',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppointmentListScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
