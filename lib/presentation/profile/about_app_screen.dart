import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:patient/core/theme/theme.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // ── Logo / Icon ───────────────────────────────────────────
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_rounded,
                size: 52,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Inside Out',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            ),
            if (_version.isNotEmpty)
              Text(
                _version,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'A therapy companion for children',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 36),

            // ── Info cards ────────────────────────────────────────────
            const _InfoCard(
              icon: Icons.favorite_rounded,
              iconColor: Color(0xFFE91E63),
              iconBg: Color(0xFFFCE4EC),
              title: 'Our Mission',
              body:
                  'Inside Out helps children with autism, Down syndrome, and speech difficulties practice their therapy tasks in a safe, encouraging, and engaging way through Poly — their AI companion bear.',
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.smart_toy_rounded,
              iconColor: AppTheme.primaryColor,
              iconBg: AppTheme.primaryColor.withValues(alpha: 0.1),
              title: 'Meet Poly',
              body:
                  'Poly is a warm AI bear powered by GPT-4o. Poly listens to children, gives simple practical tips, and speaks in their language — English, Arabic, or Japanese.',
            ),
            const SizedBox(height: 12),
            const _InfoCard(
              icon: Icons.shield_rounded,
              iconColor: Color(0xFF059669),
              iconBg: Color(0xFFD1FAE5),
              title: 'Privacy & Safety',
              body:
                  'Your child\'s data is encrypted and only shared with your linked specialist. We are committed to keeping every session private and secure.',
            ),
            const SizedBox(height: 36),

            // ── Footer ────────────────────────────────────────────────
            Text(
              '© 2026 Inside Out. All rights reserved.',
              style: GoogleFonts.poppins(
                fontSize: 12,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
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
