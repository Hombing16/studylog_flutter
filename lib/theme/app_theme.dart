import 'package:flutter/material.dart';

class StudyLogColors {
  static const Color background = Color(0xFFF5F6F8);
  static const Color creamWarm = Color(0xFFFDF8F2);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color charcoal = Color(0xFF1C1917);
  static const Color charcoalSoft = Color(0xFF292524);
  static const Color orange = Color(0xFFEA580C);
  static const Color orangeBright = Color(0xFFF97316);
  static const Color orangeSoft = Color(0xFFFFEDD5);
  static const Color orangeAvatarBg = Color(0xFFFED7AA);
  static const Color textPrimary = Color(0xFF18181B);
  static const Color textSecondary = Color(0xFF52525B);
  static const Color textMuted = Color(0xFFA1A1AA);
  static const Color borderSubtle = Color(0xFFE4E4E7);
  static const Color success = Color(0xFF15803D);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color danger = Color(0xFFDC2626);
}

class StudyLogTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: StudyLogColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: StudyLogColors.orangeBright,
        primary: StudyLogColors.orangeBright,
        surface: StudyLogColors.surfaceWhite,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: StudyLogColors.background,
        foregroundColor: StudyLogColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: StudyLogColors.charcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
