import 'package:flutter/material.dart';
import 'package:patient/presentation/child_mood/widgets/child_mode_body.dart';

import '../../core/networking/repositories/auth_repo.dart';


// ═══════════════════════════════════════════════════════════
// ChildModeScreen
// ═══════════════════════════════════════════════════════════
// Responsibilities:
//   - Renders the child-facing home (Tasks + Games cards)
//   - Intercepts all exit attempts (back button + app bar)
//   - Delegates password verification to _ExitPasswordDialog
//   - Delegates API calls to AuthRepository
// ═══════════════════════════════════════════════════════════

class ChildModeScreen extends StatelessWidget {
  const ChildModeScreen({super.key, required this.frontendId}); // ← add this
  final String frontendId;
  // ── Single entry-point for all exit attempts ──────────────
  Future<void> _requestExitPassword(BuildContext context) async {
    final verified = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>  _ExitPasswordDialog(userId: frontendId), // ← pass it
    );

    // Only pop the screen if the dialog explicitly returned true
    if (verified == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
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
        body: const ChildModeBody(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// _ChildModeBody — extracted to keep build() clean
// ═══════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════
// _ExitPasswordDialog
// ═══════════════════════════════════════════════════════════
// Responsibilities:
//   - Owns the password text field and its state
//   - Calls AuthRepository.verifyParentPassword() for validation
//   - Returns true via Navigator.pop(true) on success
//   - Returns nothing (null) on cancel
//   - Handles loading and error states internally
// ═══════════════════════════════════════════════════════════
class _ExitPasswordDialog extends StatefulWidget {
  const _ExitPasswordDialog({required this.userId}); // ← add this
  final String userId;

  @override
  State<_ExitPasswordDialog> createState() => _ExitPasswordDialogState();
}

class _ExitPasswordDialogState extends State<_ExitPasswordDialog> {
  final _controller = TextEditingController();
  final _authRepository = AuthRepository();

  bool _isLoading = false;
  String? _errorText;

  // ── Design constants ──────────────────────────────────────
  static const _purple = Color(0xFF5C5CFF);
  static const _purpleBg = Color(0xFFF0F0FF);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Verify password via API ───────────────────────────────
  Future<void> _verify() async {
    final input = _controller.text.trim();

    if (input.isEmpty) {
      setState(() => _errorText = 'Please enter the password');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final isValid = await _authRepository.verifyParentPassword(
          widget.userId, // ← use it here
          input);

      if (!mounted) return;

      if (isValid) {
        Navigator.of(context).pop(true); // ✅ success — exit child mode
      } else {
        setState(() => _errorText = 'Incorrect password');
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorText = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LockIcon(color: _purple, bgColor: _purpleBg),
            const SizedBox(height: 16),
            _DialogTitle(),
            const SizedBox(height: 20),
            _PasswordField(
              controller: _controller,
              errorText: _errorText,
              accentColor: _purple,
              onSubmitted: (_) => _isLoading ? null : _verify(),
            ),
            const SizedBox(height: 16),
            _ConfirmButton(
              isLoading: _isLoading,
              accentColor: _purple,
              onPressed: _verify,
            ),
            const SizedBox(height: 8),
            _CancelButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Dialog sub-widgets — each owns exactly one visual concern
// ═══════════════════════════════════════════════════════════

class _LockIcon extends StatelessWidget {
  const _LockIcon({required this.color, required this.bgColor});
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(Icons.lock_outline_rounded, size: 28, color: color),
    );
  }
}

class _DialogTitle extends StatelessWidget {
  const _DialogTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Parent should enter\npassword to exit',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        height: 1.4,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.errorText,
    required this.accentColor,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String? errorText;
  final Color accentColor;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
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
        errorText: errorText,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
          borderSide: BorderSide(color: accentColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      onSubmitted: onSubmitted,
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({
    required this.isLoading,
    required this.accentColor,
    required this.onPressed,
  });

  final bool isLoading;
  final Color accentColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : const Text(
          'Confirm',
          style:
          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'Cancel',
        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
      ),
    );
  }
}