import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2579B0);
  static const Color gradientStart = Color(0xFF1F6A99);
  static const Color gradientEnd = Color(0xFF3391CC);
  static const Color fadedPrimaryBackground = Color(0xFFE6F2F9);
  static const Color pageBackground = fadedPrimaryBackground;
  static const Color cardBackground = Colors.white;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

