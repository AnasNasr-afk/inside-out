
import 'package:flutter/material.dart';
import 'package:patient/presentation/on_boarding/widgets/auth_buttons_section.dart';
import 'package:patient/presentation/on_boarding/widgets/onboarding_carousel.dart';
import 'widgets/welcome_header.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          WelcomeHeader(),
          Expanded(
            child: Stack(
              children: [
                OnboardingCarousel(),
                AuthButtonsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
