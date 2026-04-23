import 'package:flutter/material.dart';
import '../../../routing/routes.dart';
import 'google_signin_button.dart';
import 'email_signin_button.dart';

class AuthButtonsSection extends StatelessWidget {
  const AuthButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: EmailSignInButton(
            onPressed: () {

            },
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: GoogleSignInButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, Routes.homeScreen),
          ),
        ),
      ],
    );
  }
}