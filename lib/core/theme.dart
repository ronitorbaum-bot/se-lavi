import 'package:flutter/material.dart';

class AppColors {
  // צבעים ראשיים
  static const Color oliveGreen = Color(0xFF6B7C3F);   // ירוק זית
  static const Color sunrise = Color(0xFFE8853A);       // כתום זריחה
  static const Color terracotta = Color(0xFFC1654A);    // טרקוטה
  static const Color cream = Color(0xFFF5F0E8);         // קרם / בז'

  // גוונים נוספים לשימוש פנימי
  static const Color oliveLight = Color(0xFF8FA052);
  static const Color oliveDark = Color(0xFF4A5629);
  static const Color textDark = Color(0xFF2D2A22);
  static const Color textMedium = Color(0xFF5C5648);
  static const Color white = Color(0xFFFFFFFF);
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.oliveGreen,
      secondary: AppColors.sunrise,
      tertiary: AppColors.terracotta,
      surface: AppColors.cream,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.textDark,
    ),
    scaffoldBackgroundColor: AppColors.cream,

    // טיפוגרפיה — טקסט גדול ונוח לקריאה
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      bodyLarge: TextStyle(
        fontSize: 20,
        color: AppColors.textDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        color: AppColors.textMedium,
      ),
      labelLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.oliveGreen,
      foregroundColor: AppColors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
    ),

    // BottomNavigationBar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.oliveGreen,
      unselectedItemColor: AppColors.textMedium,
      selectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 14),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),

    // כפתורים גדולים
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.oliveGreen,
        foregroundColor: AppColors.white,
        minimumSize: const Size(double.infinity, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
