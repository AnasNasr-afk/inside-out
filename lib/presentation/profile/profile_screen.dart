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
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = TaskCubit.get(context).parentChildData;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
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

            // ── Child hero card ───────────────────────────────────────
            _ChildHeroCard(userData: userData),
            SizedBox(height: 16.h),

            // ── Care team ─────────────────────────────────────────────
            Text(
              'Care Team',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 10.h),
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
                SizedBox(width: 12.w),
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
            SizedBox(height: 20.h),

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
            SizedBox(height: 16.h),
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
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
            child: Row(
              children: [
                Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF3DE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mood_rounded,
                    color: Color(0xFF3B6D11),
                    size: 32.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData?.childName ?? 'Child Name',
                        style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${userData?.age ?? 0} years old',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3DE),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Child',
                    style: TextStyle(
                      fontSize: 12.sp,
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
              padding: EdgeInsets.symmetric(
                  horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20.r)),
                border: Border(
                    top: BorderSide(
                        color: Color(0xFFE5E7EB), width: 0.5.w)),
              ),
              child: Row(
                children: [
                  Icon(Icons.psychology_outlined,
                      size: 15.sp, color: Color(0xFF9CA3AF)),
                  SizedBox(width: 8.w),
                  Text(
                    'Case: ',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      userData?.description ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
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
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8.r,
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
                width: 40.w,
                height: 40.h,
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
                            fontSize: 14.sp,
                          ),
                        ),
                      )
                    : Icon(icon, color: iconColor, size: 20.sp),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
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
                fontSize: 11.sp,
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
                        child: CircularProgressIndicator(strokeWidth: 2.w),
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
