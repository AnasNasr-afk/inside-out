import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class T {
  // ── Brand ─────────────────────────────────────────────────────────────────
  static const Color primary     = Color(0xFF7C5CFF);
  static const Color primaryDark = Color(0xFF6A4BF0);
  static const Color primaryTint = Color(0xFFEDE9FF);
  static const Color primarySoft = Color(0xFFF4F2FB);

  // Success / mint
  static const Color mint        = Color(0xFF14D9C4);
  static const Color mintDeep    = Color(0xFF0FA697);
  static const Color mintTint    = Color(0xFFE2FBF6);
  static const Color mintBorder  = Color(0xFFB6F0E6);

  // Accent / coral (sparing)
  static const Color coral       = Color(0xFFFF5B72);
  static const Color coralTint   = Color(0xFFFFE7EC);

  // Warn / gold
  static const Color gold        = Color(0xFFFFC93C);
  static const Color goldTint    = Color(0xFFFFF3D4);
  static const Color goldText    = Color(0xFFA9750E);

  // Text
  static const Color ink         = Color(0xFF211E40);
  static const Color muted       = Color(0xFF8B89A6);
  static const Color mutedDeep   = Color(0xFF6E6B8C);

  // Surfaces
  static const Color appBg       = Color(0xFFFBFAFF);
  static const Color card        = Color(0xFFFFFFFF);
  static const Color border      = Color(0xFFECEAF4);

  // ── Shadows ───────────────────────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
    BoxShadow(color: const Color(0x0D211E40), blurRadius: 18.r, offset: Offset(0.w, 6.h)),
  ];
  static List<BoxShadow> get navShadow => [
    BoxShadow(color: const Color(0x29211E40), blurRadius: 36.r, offset: Offset(0.w, 16.h)),
  ];
  static List<BoxShadow> primaryCta = [
    BoxShadow(
      color: primary.withValues(alpha: 0.38),
      blurRadius: 24.r,
      offset: Offset(0, 12.h),
    ),
  ];

  // ── Typography (Plus Jakarta Sans) ───────────────────────────────────────
  static TextStyle screenTitle() => GoogleFonts.plusJakartaSans(
        fontSize: 28.sp, fontWeight: FontWeight.w800, letterSpacing: -0.6, color: ink);

  static TextStyle sectionHeader() => GoogleFonts.plusJakartaSans(
        fontSize: 17.sp, fontWeight: FontWeight.w800, letterSpacing: -0.2, color: ink);

  static TextStyle cardTitle() => GoogleFonts.plusJakartaSans(
        fontSize: 15.sp, fontWeight: FontWeight.w700, color: ink);

  static TextStyle body() => GoogleFonts.plusJakartaSans(
        fontSize: 15.sp, fontWeight: FontWeight.w500, height: 1.5, color: ink);

  static TextStyle caption() => GoogleFonts.plusJakartaSans(
        fontSize: 12.sp, fontWeight: FontWeight.w600, color: muted);

  static TextStyle badge() => GoogleFonts.plusJakartaSans(
        fontSize: 11.sp, fontWeight: FontWeight.w800);

  static TextStyle navLabel() => GoogleFonts.plusJakartaSans(
        fontSize: 11.sp, fontWeight: FontWeight.w700);

  static TextStyle bigNumeral() => GoogleFonts.plusJakartaSans(
        fontSize: 34.sp, fontWeight: FontWeight.w800, letterSpacing: -1.0);
}
