import 'package:flutter/material.dart';
import '../../../core/routing/routes.dart';
import 'get_started_button.dart';

class AuthButtonsSection extends StatelessWidget {
  const AuthButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: GetStartedButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.loginScreen);
            },
          ),
        ),
      ],
    );
  }
}
