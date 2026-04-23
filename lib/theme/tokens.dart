import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const blue = Color(0xFF3AABDF);
  static const blueLight = Color(0xFFE8F5FC);
  static const blueDark = Color(0xFF1A3A4A);
  static const orange = Color(0xFFF6A800);
  static const orangeLight = Color(0xFFFFF5E0);
  static const orangeDark = Color(0xFF3A2A00);
  static const success = Color(0xFF22C55E);
  static const successLight = Color(0xFFDCFCE7);
  static const successDark = Color(0xFF0A2A15);
  static const danger = Color(0xFFEF4444);
  static const dangerLight = Color(0xFFFEE2E2);
  static const dangerDark = Color(0xFF2A0A0A);

  // Light theme
  static const lightBg = Color(0xFFF4F6F8);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceAlt = Color(0xFFF0F4F8);
  static const lightBorder = Color(0xFFE5EAF0);
  static const lightText = Color(0xFF1A1A1A);
  static const lightTextSub = Color(0xFF6B7280);
  static const lightTextMuted = Color(0xFF9CA3AF);
  static const lightNav = Color(0xFFFFFFFF);

  // Dark theme
  static const darkBg = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkSurfaceAlt = Color(0xFF2A2A2A);
  static const darkBorder = Color(0xFF333333);
  static const darkText = Color(0xFFFFFFFF);
  static const darkTextSub = Color(0xFF9CA3AF);
  static const darkTextMuted = Color(0xFF6B7280);
  static const darkNav = Color(0xFF1E1E1E);
}

class AppRadius {
  static const sm = Radius.circular(8);
  static const md = Radius.circular(12);
  static const lg = Radius.circular(16);
  static const xl = Radius.circular(20);
  static const round = Radius.circular(999);

  static BorderRadius bSm = BorderRadius.all(sm);
  static BorderRadius bMd = BorderRadius.all(md);
  static BorderRadius bLg = BorderRadius.all(lg);
  static BorderRadius bXl = BorderRadius.all(xl);
  static BorderRadius bRound = BorderRadius.all(round);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.blue,
        secondary: AppColors.orange,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightText,
      ),
      fontFamily: 'Helvetica Neue',
      textTheme: _textTheme(AppColors.lightText, AppColors.lightTextSub),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.blue,
        secondary: AppColors.orange,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkText,
      ),
      fontFamily: 'Helvetica Neue',
      textTheme: _textTheme(AppColors.darkText, AppColors.darkTextSub),
    );
  }

  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: primary),
      headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: primary),
      titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primary),
      bodyMedium: TextStyle(fontSize: 13, color: primary),
      bodySmall: TextStyle(fontSize: 11, color: secondary),
    );
  }
}
