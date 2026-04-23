import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../games/games_screen.dart';
import '../home/widgets/therapy_goal_card.dart';

/// ── Change this to your real password or fetch from provider ─────────────────
const String _parentPassword = '1234';

class ChildModeScreen extends StatelessWidget {
  const ChildModeScreen({super.key});

  /// Shows the password dialog and pops the screen only if correct.
  Future<void> _requestExitPassword(BuildContext context) async {
    final controller = TextEditingController();
    bool hasError = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 32),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lock icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F0FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        size: 28,
                        color: Color(0xFF5C5CFF),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    const Text(
                      'Parent should enter\npassword to exit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password field
                    TextField(
                      controller: controller,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 6,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                          color: Colors.grey.shade400,
                        ),
                        errorText: hasError ? 'Incorrect password' : null,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                              color: Color(0xFF5C5CFF), width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                      onSubmitted: (_) => _checkPassword(
                        controller.text,
                        dialogContext,
                        context,
                        setDialogState,
                            () => hasError = true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C5CFF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => _checkPassword(
                          controller.text,
                          dialogContext,
                          context,
                          setDialogState,
                              () => hasError = true,
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Cancel button
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _checkPassword(
      String input,
      BuildContext dialogContext,
      BuildContext screenContext,
      StateSetter setDialogState,
      VoidCallback markError,
      ) {
    if (input == _parentPassword) {
      Navigator.of(dialogContext).pop(); // close dialog
      Navigator.of(screenContext).pop(); // exit child mode
    } else {
      setDialogState(markError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Intercept hardware back button
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) _requestExitPassword(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => _requestExitPassword(context),
          ),
          title: const Text('Child Mode'),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: TherapyGoalCard(
                        title: 'Online',
                        subtitle: 'Tasks',
                        illustration: Assets.illustrations.i9nGoals,
                        backgroundColor: const Color(0xFFF9F3E3),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // GestureDetector(
                    //   onTap: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //         const DailyActivitiesScreen()),
                    //   ),
                    //   child: TherapyGoalCard(
                    //     title: 'Daily',
                    //     subtitle: 'Activities',
                    //     illustration: Assets.illustrations.i9nActivities,
                    //     backgroundColor: const Color(0xFFFEF4F0),
                    //     imageOnLeft: true,
                    //   ),
                    // ),
                    // const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GamesScreen()),
                      ),
                      child: TherapyGoalCard(
                        title: 'Games',
                        subtitle: '',
                        illustration: Assets.illustrations.i9nActivities,
                        backgroundColor: const Color(0xFFE8F5E9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}