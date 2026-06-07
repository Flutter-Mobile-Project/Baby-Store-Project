import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextTheme get textTheme {
    return const TextTheme(
      // For main landing/header titles (e.g., Booking screen header)
      displayLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.2,
      ),

      // For subsection headers (e.g., "Our Specialists", "Select Date")
      titleMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),

      // Standard paragraphs, body item info, descriptions
      bodyMedium: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 13,
        color: Colors.black54,
        height: 1.3,
      ),

      // Small secondary descriptive metadata strings (e.g., ratings, dates)
      labelSmall: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 11,
        color: Colors.black38,
      ),
    );
  }
}
