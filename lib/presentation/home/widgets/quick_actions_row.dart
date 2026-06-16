import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/presentation/appointments/appointment_list_screen.dart';
import 'package:patient/presentation/child_mood/child_mode_screen.dart';
import 'package:patient/presentation/home/widgets/quick_action_button.dart';

import '../../../core/routing/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Synchronous now — no setState, no initState ─────────
    final userId = SharedPrefHelper.getString('userId');
    final frontendId = SharedPrefHelper.getInt('frontendId');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: QuickActionButton(
                icon: Icons.bar_chart_outlined,
                label: 'Reports',
                onTap: () => Navigator.pushNamed(context, Routes.reportScreen),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: QuickActionButton(
                icon: Icons.child_care_outlined,
                label: 'Child Mode',
                onTap: () {
                  if (userId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please log in again.')),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChildModeScreen(frontendId: frontendId.toString()),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: QuickActionButton(
                icon: Icons.calendar_month_rounded,
                label: 'Appointments',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AppointmentListScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}