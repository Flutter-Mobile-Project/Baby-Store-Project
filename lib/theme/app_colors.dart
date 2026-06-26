import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFFF6F8FF);
  static const Color babyBlue = Color(0xFF89CFF0);
  static const Color cream = Color(0xFFFFF8E7);
  static const Color textPrimary = Color(0xFF0A0A0A);
  static const Color textSecondary = Color(0xFF6B6B6B);

  static const Color babyPink = Color(0xFFEFDAE6);
  // static const Color mint = Color(0xFFDFF7E2);
  static const Color mint = Color(0xFFE0F2FE);
  static const Color mintLight = Color(0xFFE2F3EB);
  static const Color beige = Color(0xFFF2EEDE);

  static const primary = Color(0xFFFFB6C1); // ✅ ADD THIS
  // Added Design Specifics
  static const Color badgeBlue = Color(
    0xFFD6EBFF,
  ); // Used for "Platinum Member" and Registry icons
  static const Color logoutBg = Color(
    0xFFFDF2ED,
  ); // Muted red/pink tint for sign-out button background
  static const Color logoutText = Color(
    0xFFC04434,
  ); // Deep red tone for the sign-out text/icon
}
