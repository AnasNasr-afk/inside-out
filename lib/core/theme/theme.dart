import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6366F1);

  static const Color secondaryColor = Color(0xFF7A86F8);
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Color(0xFF1F2937);
  static const Color subtitleColor = Color(0xFF6B7280);
  static const Color orange = Color(0xFFF0956A);
  static const Color hoverColor = Color(0xFF83859C);

  // Spin-wheel segment palette — change here to retheme the whole wheel
  static const List<Color> wheelColors = [
    Color(0xFFE53935), // red
    Color(0xFFF57C00), // orange
    Color(0xFFFFB300), // amber
    Color(0xFF2E7D32), // green
    Color(0xFF1565C0), // blue
    Color(0xFF6A1B9A), // purple
    Color(0xFFAD1457), // pink
    Color(0xFF00838F), // teal
  ];

  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16.sp,
          color: textColor,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14.sp,
          color: subtitleColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        iconTheme: const IconThemeData(color: textColor),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: const WidgetStatePropertyAll(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        ),
        side: BorderSide(
          color: const Color.fromRGBO(139, 139, 139, 1),
          width: 1.w,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: const Color.fromRGBO(99, 102, 241, 0.15),
        linearMinHeight: 6.h,
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: backgroundColor,
      ),
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(primaryColor),
        minimumSize: WidgetStatePropertyAll(Size(double.infinity, 56.h)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.r),
          ),
        ),
      )),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: TextStyle(
          fontSize: 16.sp,
          color: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          fillColor: Colors.yellowAccent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}
