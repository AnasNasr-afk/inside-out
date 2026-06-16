import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/presentation/child_mood/child_mode_sounds.dart';
import 'package:patient/presentation/child_mood/widgets/child_mode_body.dart';

import '../../core/networking/repositories/auth_repo.dart';

class ChildModeScreen extends StatefulWidget {
  const ChildModeScreen({super.key, required this.frontendId});
  final String frontendId;

  @override
  State<ChildModeScreen> createState() => _ChildModeScreenState();
}

class _ChildModeScreenState extends State<ChildModeScreen>
    with TickerProviderStateMixin {
  // Coin counter: 0 → 120 over ~1.5 s
  late final AnimationController _coinCtrl;
  late final Animation<int> _coinAnim;

  // Floating circles bob
  late final AnimationController _floatCtrl;
  late final Animation<double> _float1;
  late final Animation<double> _float2;

  late final String _childName;

  @override
  void initState() {
    super.initState();
    final raw = SharedPrefHelper.getString(SharedPrefKeys.childName)
        .split(' ')
        .first
        .toUpperCase();
    _childName = raw.isEmpty ? 'FRIEND' : raw;

    // Coin tally — read persisted total from Poly Missions.
    final childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);
    final totalCoins = SharedPrefHelper.getInt('pm_coins_$childId');

    _coinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _coinAnim = IntTween(begin: 0, end: totalCoins).animate(
      CurvedAnimation(parent: _coinCtrl, curve: Curves.easeOut),
    );
    _coinCtrl.forward();

    // Float circles — different speeds, slight offset
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _float1 = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.linear));
    _float2 = Tween<double>(begin: 0.8, end: 0.8 + 2 * math.pi)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.linear));
  }

  @override
  void dispose() {
    _coinCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  Future<void> _requestExitPassword(BuildContext context) async {
    final verified = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ExitPasswordDialog(userId: widget.frontendId),
    );
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
        body: AnimatedBuilder(
          animation: Listenable.merge([_coinCtrl, _floatCtrl]),
          builder: (context, _) {
            final bob1 = math.sin(_float1.value) * 7.0;
            final bob2 = math.sin(_float2.value) * 9.0;
            return Stack(
              children: [
                // ── Gradient background ────────────────────────────────
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF1ECFF), Color(0xFFE7F6F3)],
                    ),
                  ),
                ),

                // ── Floating violet circle (top-right) ─────────────────
                Positioned(
                  top: -40 + bob1,
                  right: -40,
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      color: const Color(0x1A7C5CFF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // ── Floating mint circle (bottom-left) ─────────────────
                Positioned(
                  bottom: 40 + bob2,
                  left: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0x1F14D9C4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // ── Content ────────────────────────────────────────────
                SafeArea(
                  child: Column(
                    children: [
                      _Header(
                        childName: _childName,
                        coins: _coinAnim.value,
                        onBack: () => _requestExitPassword(context),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                          child: ChildModeBody(
                            onTileTap: () => ChildModeSounds.instance.playTap(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String childName;
  final int coins;
  final VoidCallback onBack;

  const _Header({
    required this.childName,
    required this.coins,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          // Back chip
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.70),
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF211E40).withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 24,
                color: Color(0xFF211E40),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Poly's World",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: const Color(0xFF211E40),
                  ),
                ),
                Text(
                  'Hi $childName!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF7C5CFF),
                  ),
                ),
              ],
            ),
          ),
          // Coin counter pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF211E40).withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 17, color: Color(0xFFFFC93C)),
                const SizedBox(width: 6),
                Text(
                  '$coins',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF211E40),
                    fontFeatures: const [FontFeature.tabularFigures()],
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

class _ExitPasswordDialog extends StatefulWidget {
  const _ExitPasswordDialog({required this.userId});
  final String userId;

  @override
  State<_ExitPasswordDialog> createState() => _ExitPasswordDialogState();
}

class _ExitPasswordDialogState extends State<_ExitPasswordDialog> {
  final _controller = TextEditingController();
  final _authRepository = AuthRepository();

  bool _isLoading = false;
  String? _errorText;

  static const _violet = Color(0xFF7C5CFF);
  static const _ink = Color(0xFF211E40);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      final isValid =
          await _authRepository.verifyParentPassword(widget.userId, input);
      if (!mounted) return;
      if (isValid) {
        Navigator.of(context).pop(true);
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
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF1ECFF), Color(0xFFE7F6F3)],
          ),
          boxShadow: [
            BoxShadow(
              color: _violet.withValues(alpha: 0.18),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Decorative circles — mirrors the screen background
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    color: Color(0x1A7C5CFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -24,
                left: -24,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0x1F14D9C4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lock icon — violet gradient circle
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF9B7FFF), Color(0xFF7C5CFF)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _violet.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      'Parent Exit',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Enter your password to leave child mode',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _ink.withValues(alpha: 0.55),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Password field — white card style
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _ink.withValues(alpha: 0.07),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        textAlign: TextAlign.center,
                        autofocus: true,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 6,
                          color: _ink,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                            color: _ink.withValues(alpha: 0.30),
                          ),
                          errorText: _errorText,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: _violet, width: 1.5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: Color(0xFFFF5B72)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: Color(0xFFFF5B72), width: 1.5),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onSubmitted: (_) => _isLoading ? null : _verify(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Confirm button — violet gradient
                    GestureDetector(
                      onTap: _isLoading ? null : _verify,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: _isLoading
                              ? null
                              : const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF9B7FFF),
                                    Color(0xFF7C5CFF),
                                  ],
                                ),
                          color: _isLoading
                              ? Color(0xFFD4CAFF)
                              : null,
                          boxShadow: _isLoading
                              ? null
                              : [
                                  BoxShadow(
                                    color: _violet.withValues(alpha: 0.40),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Confirm',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Cancel
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _ink.withValues(alpha: 0.40),
                        ),
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
