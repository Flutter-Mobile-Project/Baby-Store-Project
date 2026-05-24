import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      // 1. Core Colors & Background
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.babyBlue,

      // 2. Typography
      fontFamily: 'Nunito', // Sets the default body font

      cardTheme: const CardThemeData(
        elevation: 0,
        color: Colors.white,
        // Wait! Since it requires CardThemeData, the shape property stays the same.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      // 4. Global App Bar Styling
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontFamily: 'Poppins', // Heading font from your spec
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
