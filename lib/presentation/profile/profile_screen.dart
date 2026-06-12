import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/core/models/responses/parent_child_response_model.dart';
import 'package:patient/presentation/profile/widgets/menu_item.dart';
import 'package:patient/presentation/profile/widgets/person_row.dart';
import 'package:url_launcher/url_launcher.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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

            // ── Child hero card ───────────────────────────────────────
            _ChildHeroCard(userData: userData),
            const SizedBox(height: 16),

            // ── Care team ─────────────────────────────────────────────
            Text(
              'Care Team',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _CareTeamCard(
                  icon: Icons.person_rounded,
                  avatarColor: AppTheme.orange.withValues(alpha: 0.15),
                  iconColor: AppTheme.orange,
                  badgeLabel: 'Parent',
                  badgeColor: AppTheme.orange.withValues(alpha: 0.1),
                  badgeTextColor: AppTheme.orange,
                  name: userData?.parentName ?? 'Parent',
                  detail: userData?.parentEmail ?? '',
                  initials: getInitials(userData?.parentName ?? ''),
                )),
                const SizedBox(width: 12),
                Expanded(child: _CareTeamCard(
                  icon: Icons.medical_services_rounded,
                  avatarColor: const Color(0xFFE0F2FE),
                  iconColor: const Color(0xFF0369A1),
                  badgeLabel: 'Specialist',
                  badgeColor: const Color(0xFFE0F2FE),
                  badgeTextColor: const Color(0xFF0369A1),
                  name: userData?.specialistName.isNotEmpty == true
                      ? userData!.specialistName
                      : 'Not assigned',
                  detail: userData?.specialistEmail ?? '',
                )),
              ],
            ),
            const SizedBox(height: 20),

            // ── Menu items ────────────────────────────────────────────
            MenuItem(
              label: 'Help & FAQ',
              onTap: () => Navigator.pushNamed(context, Routes.helpFaqScreen),
            ),
            MenuItem(
              label: 'Terms & Conditions',
              onTap: () => _launchUrl('https://anasnasr-afk.github.io/inside-out/terms.html'),
            ),
            MenuItem(
              label: 'Privacy Policy',
              onTap: () => _launchUrl('https://anasnasr-afk.github.io/inside-out/privacy.html'),
            ),
            MenuItem(
              label: 'About App',
              onTap: () => Navigator.pushNamed(context, Routes.aboutAppScreen),
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

// ── Child hero card ────────────────────────────────────────────────────────────

class _ChildHeroCard extends StatelessWidget {
  const _ChildHeroCard({required this.userData});
  final ParentChildResponseModel? userData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF3DE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mood_rounded,
                    color: Color(0xFF3B6D11),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData?.childName ?? 'Child Name',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${userData?.age ?? 0} years old',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3DE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Child',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3B6D11),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (userData?.description.isNotEmpty == true)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(
                    top: BorderSide(
                        color: Color(0xFFE5E7EB), width: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.psychology_outlined,
                      size: 15, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 8),
                  Text(
                    'Case: ',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      userData?.description ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF374151),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Care team compact card ─────────────────────────────────────────────────────

class _CareTeamCard extends StatelessWidget {
  const _CareTeamCard({
    required this.icon,
    required this.avatarColor,
    required this.iconColor,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.name,
    required this.detail,
    this.initials,
  });

  final IconData icon;
  final Color avatarColor;
  final Color iconColor;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;
  final String name;
  final String detail;
  final String? initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: avatarColor,
                  shape: BoxShape.circle,
                ),
                child: initials != null
                    ? Center(
                        child: Text(
                          initials!,
                          style: TextStyle(
                            color: iconColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Icon(icon, color: iconColor, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (detail.isNotEmpty)
            Text(
              detail,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: const Color(0xFF9CA3AF),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

// ── URL launcher ──────────────────────────────────────────────────────────────

Future<void> _launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// ── Logout dialog ──────────────────────────────────────────────────────────────

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
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
            content: Text(
              'Are you sure you want to log out?',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(color: const Color(0xFF6B7280)),
                ),
              ),
              TextButton(
                onPressed: state is LogoutLoadingState
                    ? null
                    : () => authCubit.logout(),
                child: state is LogoutLoadingState
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
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
