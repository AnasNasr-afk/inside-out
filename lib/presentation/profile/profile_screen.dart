import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/core/models/responses/parent_child_response_model.dart';
import 'package:patient/presentation/profile/widgets/care_team_card.dart';
import 'package:patient/presentation/profile/widgets/child_card.dart';
import 'package:patient/presentation/profile/widgets/menu_item.dart';
import 'package:patient/presentation/profile/widgets/person_row.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/cubits/auth_cubit/auth_cubit.dart';
import '../../core/cubits/auth_cubit/auth_listener.dart';
import '../../core/cubits/task_cubit/task_cubit.dart';
import '../../core/cubits/task_cubit/task_listener.dart';
import '../../core/routing/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskStates>(
      builder: (context, state) {
        final userData = TaskCubit.get(context).parentChildData;
        return _buildBody(context, userData);
      },
    );
  }

  Widget _buildBody(BuildContext context, ParentChildResponseModel? userData) {
    final navBottom = MediaQuery.of(context).padding.bottom + 96.h;
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, navBottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: GoogleFonts.poppins(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 20.h),
            ChildCard(userData: userData),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: CareTeamCard(
                    avatarColor: T.coralTint,
                    iconColor: T.coral,
                    badgeLabel: 'Parent',
                    badgeColor: T.coralTint,
                    badgeTextColor: T.coral,
                    name: (userData?.parentName.isNotEmpty ?? false)
                        ? userData!.parentName
                        : 'Parent',
                    detail: (userData?.parentEmail.isNotEmpty ?? false)
                        ? userData!.parentEmail
                        : 'Email',
                    initials: getInitials(userData?.parentName ?? ''),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CareTeamCard(
                    iconAsset: 'assets/illustrations/specialistIcon.png',
                    avatarColor: T.primaryTint,
                    iconColor: T.primary,
                    badgeLabel: 'Specialist',
                    badgeColor: T.primaryTint,
                    badgeTextColor: T.primary,
                    name: (userData?.specialistName.isNotEmpty ?? false)
                        ? userData!.specialistName
                        : 'Not assigned',
                    detail: (userData?.specialistEmail.isNotEmpty ?? false)
                        ? userData!.specialistEmail
                        : 'Email',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, Routes.reportScreen),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFFF7E6B),
                      Color(0xFFFF5B72),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Session Reports',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'View all therapy session reports',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bar_chart_rounded,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            MenuItem(
              label: 'Help & FAQ',
              iconPath: 'assets/illustrations/help&FAQIcon.png',
              onTap: () => Navigator.pushNamed(context, Routes.helpFaqScreen),
            ),
            MenuItem(
              label: 'Terms & Conditions',
              iconPath: 'assets/illustrations/termsIcon.png',
              onTap: () => _launchUrl(
                  'https://anasnasr-afk.github.io/inside-out/terms.html'),
            ),
            MenuItem(
              label: 'Privacy Policy',
              iconPath: 'assets/illustrations/privacyIcon.png',
              onTap: () => _launchUrl(
                  'https://anasnasr-afk.github.io/inside-out/privacy.html'),
            ),
            MenuItem(
              label: 'About App',
              iconPath: 'assets/illustrations/aboutAppIcon.png',
              onTap: () => Navigator.pushNamed(context, Routes.aboutAppScreen),
            ),
            MenuItem(
              label: 'Log Out',
              iconPath: 'assets/illustrations/logoutIcon.png',
              isDestructive: true,
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Child hero card ────────────────────────────────────────────────────────────


// ── Care team compact card ─────────────────────────────────────────────────────



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
              borderRadius: BorderRadius.circular(20.r),
            ),
            title: Text(
              'Log Out',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
            content: Text(
              'Are you sure you want to log out?',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
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
                    ? SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
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
