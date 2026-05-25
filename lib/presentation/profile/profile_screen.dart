import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/presentation/profile/widgets/circular_usage_indicator.dart';
import 'package:patient/presentation/profile/widgets/menu_item.dart';
import 'package:patient/presentation/profile/widgets/person_row.dart';

import '../../core/cubits/auth_cubit/auth_cubit.dart';
import '../../core/cubits/auth_cubit/auth_listener.dart';
import '../../core/cubits/task_cubit/task_cubit.dart';
import '../../core/routing/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = TaskCubit.get(context).parentChildData;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
              ),
              child: Column(
                children: [
                  PersonRow(
                    initials: getInitials(userData?.parentName ?? ''),
                    avatarColor: AppTheme.orange,
                    avatarTextColor: Colors.white,
                    name: userData?.parentName ?? 'Parent Name',
                    subtitle: userData?.parentEmail ?? 'Email',
                    badgeLabel: 'Parent',
                    badgeColor: AppTheme.orange.withValues(alpha: 0.1),
                    badgeTextColor: AppTheme.orange,
                  ),

                  DetailRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: userData?.parentPhone ?? "000-000-0000"),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        const Expanded(
                            child: Divider(height: 1, thickness: 0.5)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text('linked child',
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: const Color(0xFF9CA3AF))),
                        ),
                        const Expanded(
                            child: Divider(height: 1, thickness: 0.5)),
                      ],
                    ),
                  ),

                  // ── Child row ─────────────────────────────────────────
                  PersonRow(
                    icon: Icons.mood_rounded,
                    avatarColor: const Color(0xFFEAF3DE),
                    avatarTextColor: const Color(0xFF3B6D11),
                    name: userData?.childName ?? 'Child Name',
                    subtitle: '${userData?.age ?? 0} years old',
                    badgeLabel: 'Child',
                    badgeColor: const Color(0xFFEAF3DE),
                    badgeTextColor: const Color(0xFF3B6D11),
                  ),

                  // ── Child details ─────────────────────────────────────
                  DetailRow(
                      icon: Icons.psychology_outlined,
                      label: 'Case',
                      value: userData?.description ?? 'ADS'),
                  // DetailRow(icon: Icons.badge_outlined, label: 'Child Age', value: '#${userData?.age ?? ''}'),

                  // ── Connected footer ──────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      border: Border(
                          top:
                              BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: userData?.parentName ?? 'Parent',
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: ' is caring for ',
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF6B7280)),
                              ),
                              TextSpan(
                                text: userData?.childName ?? 'Child',
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            MenuItem(
              label: 'About Us',
              onTap: () {},
            ),
            MenuItem(
              label: 'Terms & Conditions',
              onTap: () {},
            ),
            MenuItem(
              label: 'Privacy Policy',
              onTap: () {},
            ),
            MenuItem(
              label: 'Contact Support',
              onTap: () {},
            ),
            MenuItem(
              label: 'Log Out',
              isDestructive: true,
              onTap: () => _showLogoutDialog(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Logout Dialog ───────────────────────────────────────────

void _showLogoutDialog(BuildContext context) {
  final authCubit = AuthCubit.get(context);

  showDialog(
    context: context,
    builder: (dialogContext) => BlocProvider.value(
      value: authCubit,
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (listenerContext, state) {
          if (state is LogoutSuccessState) {
            Navigator.of(dialogContext).pop();

            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.loginScreen,
              (route) => false,
            );
          }
        },
        builder: (builderContext, state) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Log Out',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              'Are you sure you want to log out?',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
            actions: [
              // ── Cancel ───────────────────────────────
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),

              // ── Logout ───────────────────────────────
              TextButton(
                onPressed: state is LogoutLoadingState
                    ? null
                    : () {
                        authCubit.logout();
                      },
                child: state is LogoutLoadingState
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Log Out',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFEF4444),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
