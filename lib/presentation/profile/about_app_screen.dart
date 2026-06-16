import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _version = 'v${info.version}+${info.buildNumber}');
    } catch (_) {
      if (mounted) setState(() => _version = 'v1.0.0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          children: [
            // ── Logo / Icon ───────────────────────────────────────────
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_rounded,
                size: 52.sp,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Inside Out',
              style: GoogleFonts.poppins(
                fontSize: 26.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            ),
            if (_version.isNotEmpty)
              Text(
                _version,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            SizedBox(height: 8.h),
            Text(
              'A therapy companion for children',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: const Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 36.h),

            // ── Info cards ────────────────────────────────────────────
            const _InfoCard(
              icon: Icons.favorite_rounded,
              iconColor: Color(0xFFE91E63),
              iconBg: Color(0xFFFCE4EC),
              title: 'Our Mission',
              body:
                  'Inside Out helps children with autism, Down syndrome, and speech difficulties practice their therapy tasks in a safe, encouraging, and engaging way through Poly — their AI companion bear.',
            ),
            SizedBox(height: 12.h),
            _InfoCard(
              icon: Icons.smart_toy_rounded,
              iconColor: AppTheme.primaryColor,
              iconBg: AppTheme.primaryColor.withValues(alpha: 0.1),
              title: 'Meet Poly',
              body:
                  'Poly is a warm AI bear powered by GPT-4o. Poly listens to children, gives simple practical tips, and speaks in their language — English, Arabic, or Japanese.',
            ),
            SizedBox(height: 12.h),
            const _InfoCard(
              icon: Icons.shield_rounded,
              iconColor: Color(0xFF059669),
              iconBg: Color(0xFFD1FAE5),
              title: 'Privacy & Safety',
              body:
                  'Your child\'s data is encrypted and only shared with your linked specialist. We are committed to keeping every session private and secure.',
            ),
            SizedBox(height: 36.h),

            // ── Footer ────────────────────────────────────────────────
            Text(
              '© 2026 Inside Out. All rights reserved.',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: const Color(0xFFD1D5DB),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  body,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: const Color(0xFF6B7280),
                    height: 1.5.h,
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
