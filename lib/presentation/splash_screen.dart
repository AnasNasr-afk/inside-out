import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/helpers/shared_pref.dart';
import '../core/helpers/shared_pref_keys.dart';
import '../core/theme/theme.dart';
import '../gen/assets.gen.dart';
import '../core/routing/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Small delay for splash visibility
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final userId = SharedPrefHelper.getString(SharedPrefKeys.userId);

    if (userId.isNotEmpty) {
      // ✅ Already logged in → go home
      Navigator.pushReplacementNamed(context, Routes.homeScreen);
    } else {
      // ❌ Not logged in → go to auth
      Navigator.pushReplacementNamed(context, Routes.onboardingScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.logos.lgNeurotrack.svg(width: 100),
            const SizedBox(height: 20),
            Text(
              "InsideOut",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
