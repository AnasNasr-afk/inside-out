import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/presentation/child_mood/child_mode_sounds.dart';
import 'package:patient/presentation/child_mood/widgets/child_mode_body.dart';
import 'package:patient/presentation/poly_missions/data/poly_coins_repository.dart';

import '../../core/networking/repositories/auth_repo.dart';

class ChildModeScreen extends StatefulWidget {
  const ChildModeScreen({super.key, required this.frontendId});
  final String frontendId;

  @override
  State<ChildModeScreen> createState() => _ChildModeScreenState();
}

class _ChildModeScreenState extends State<ChildModeScreen>
    with TickerProviderStateMixin {
  // Coin counter: 0 → total over ~1.5 s
  late final AnimationController _coinCtrl;
  late Animation<int> _coinAnim;
  int _coinsTarget = 0;

  // Floating circles bob
  late final AnimationController _floatCtrl;
  late final Animation<double> _float1;
  late final Animation<double> _float2;

  late final String _childName;
  late final int _childId;

  @override
  void initState() {
    super.initState();
    final raw = SharedPrefHelper.getString(SharedPrefKeys.childName)
        .split(' ')
        .first
        .toUpperCase();
    _childName = raw.isEmpty ? 'FRIEND' : raw;

    // Coin tally — show the local mirror instantly, then reconcile with the
    // cross-device Firestore total and re-animate if it differs.
    _childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);
    _coinsTarget = PolyCoinsRepository.instance.localCoins(_childId);

    _coinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _coinAnim = IntTween(begin: 0, end: _coinsTarget).animate(
      CurvedAnimation(parent: _coinCtrl, curve: Curves.easeOut),
    );
    _coinCtrl.forward();
    _loadRemoteCoins(_childId);

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

  /// Fetches the authoritative cross-device total and re-runs the counter
  /// animation from the locally shown value if it changed.
  Future<void> _loadRemoteCoins(int childId) async {
    debugPrint('🪙 [child-mode] showing local $_coinsTarget, fetching remote…');
    final remote = await PolyCoinsRepository.instance.fetchCoins(childId);
    _animateCoinsTo(remote);
  }

  /// Re-animates the coin counter from the currently shown value to [target].
  void _animateCoinsTo(int target) {
    if (!mounted || target == _coinsTarget) {
      debugPrint('🪙 [child-mode] coins unchanged at $_coinsTarget');
      return;
    }
    debugPrint('🪙 [child-mode] animating coin counter $_coinsTarget → $target');
    setState(() {
      _coinAnim = IntTween(begin: _coinsTarget, end: target).animate(
        CurvedAnimation(parent: _coinCtrl, curve: Curves.easeOut),
      );
      _coinsTarget = target;
    });
    _coinCtrl
      ..reset()
      ..forward();
  }

  /// Called when returning from Poly Missions, where coins may have been
  /// earned. The local mirror is already updated, so re-animate to it
  /// instantly, then reconcile with the cross-device Firestore total.
  void _refreshCoins() {
    debugPrint('🪙 [child-mode] back from missions — refreshing coins');
    _animateCoinsTo(PolyCoinsRepository.instance.localCoins(_childId));
    _loadRemoteCoins(_childId);
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
                  top: -40.h + bob1,
                  right: -40.w,
                  child: Container(
                    width: 170.w,
                    height: 170.h,
                    decoration: BoxDecoration(
                      color: const Color(0x1A7C5CFF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // ── Floating mint circle (bottom-left) ─────────────────
                Positioned(
                  bottom: 40.h + bob2,
                  left: -30.w,
                  child: Container(
                    width: 120.w,
                    height: 120.h,
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
                          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 40.h),
                          child: ChildModeBody(
                            onTileTap: () => ChildModeSounds.instance.playTap(),
                            onReturnFromMissions: _refreshCoins,
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
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
      child: Row(
        children: [
          // Back chip
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.70),
                borderRadius: BorderRadius.circular(13.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF211E40).withValues(alpha: 0.06),
                    blurRadius: 12.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                size: 24.sp,
                color: const Color(0xFF211E40),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Poly's World",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: const Color(0xFF211E40),
                  ),
                ),
                Text(
                  'Hi $childName!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF7C5CFF),
                  ),
                ),
              ],
            ),
          ),
          // Coin counter pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF211E40).withValues(alpha: 0.08),
                  blurRadius: 16.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, size: 17.sp, color: const Color(0xFFFFC93C)),
                SizedBox(width: 6.w),
                Text(
                  '$coins',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.sp,
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
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF1ECFF), Color(0xFFE7F6F3)],
          ),
          boxShadow: [
            BoxShadow(
              color: _violet.withValues(alpha: 0.18),
              blurRadius: 40.r,
              offset: Offset(0, 16.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.r),
          child: Stack(
            children: [
              // Decorative circles — mirrors the screen background
              Positioned(
                top: -30.h,
                right: -30.w,
                child: Container(
                  width: 110.w,
                  height: 110.h,
                  decoration: const BoxDecoration(
                    color: Color(0x1A7C5CFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -24.h,
                left: -24.w,
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: const BoxDecoration(
                    color: Color(0x1F14D9C4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 36.h, 24.w, 28.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lock icon — violet gradient circle
                    Container(
                      width: 68.w,
                      height: 68.h,
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
                            blurRadius: 20.r,
                            offset: Offset(0, 8.h),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.lock_rounded,
                        size: 30.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Title
                    Text(
                      'Parent Exit',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: _ink,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Enter your password to leave child mode',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: _ink.withValues(alpha: 0.55),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Password field — white card style
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: _ink.withValues(alpha: 0.07),
                            blurRadius: 16.r,
                            offset: Offset(0, 4.h),
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
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 6,
                          color: _ink,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                            color: _ink.withValues(alpha: 0.30),
                          ),
                          errorText: _errorText,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 16.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                                color: _violet, width: 1.5.w),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(
                                color: Color(0xFFFF5B72)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                                color: const Color(0xFFFF5B72), width: 1.5.w),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onSubmitted: (_) => _isLoading ? null : _verify(),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Confirm button — violet gradient
                    GestureDetector(
                      onTap: _isLoading ? null : _verify,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
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
                              ? const Color(0xFFD4CAFF)
                              : null,
                          boxShadow: _isLoading
                              ? null
                              : [
                                  BoxShadow(
                                    color: _violet.withValues(alpha: 0.40),
                                    blurRadius: 16.r,
                                    offset: Offset(0, 8.h),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Confirm',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Cancel
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.sp,
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
