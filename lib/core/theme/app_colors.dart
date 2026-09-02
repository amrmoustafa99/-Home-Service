import 'package:flutter/material.dart';

/// Central color palette for the application (green-and-white theme).
///
/// All screens must reuse these constants instead of declaring raw colors.
class AppColors {
  AppColors._();

  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFFA5D6A7);
  static const Color primaryContainer = Color(0xFFE8F5E9);

  static const Color scaffoldBackground = Color(0xFFF9FBFA);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color border = Color(0xFFE2E8F0);
  static const Color lightGrey = Color(0xFFEFF1F0);
  static const Color avatarBackground = Color(0xFFE5E9E7);

  static const Color error = Color(0xFFDC2626);
}