import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart'; // Make sure this path matches your file structure

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true, // Forces modern Material 3 design specs
      scaffoldBackgroundColor: AppColors.cream,

      // Modern Material 3 structural color definitions
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF4A5E6D), // Your main button/accent color
        secondary: AppColors.babyBlue, // Selection outlines / active chips
        surface: Colors.white, // Card backgrounds
        background: AppColors.cream, // Page backgrounds
        onPrimary: Colors.white, // Text on top of primary buttons
        onSurface: AppColors.textPrimary, // Primary text color
      ),

      // Binds custom Poppins and Nunito properties to global text engines
      textTheme: AppTextStyles.textTheme,

      // Universal Card Layout Specs
      cardTheme: const CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),

      // Global App Bar configurations
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0, // Prevents App Bar coloring change on scroll
        iconTheme: IconThemeData(color: AppColors.textPrimary, size: 22),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),

      // Component-Specific Themes clean up UI clutter throughout the app
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A5E6D),
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
