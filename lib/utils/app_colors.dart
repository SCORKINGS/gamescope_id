import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color bgPrimary = Color(0xFF101318);
  static const Color bgSurface = Color(0xFF1D2530);
  static const Color bgElevated = Color(0xFF252E3A);

  // Accents
  static const Color accentLime = Color(0xFFC7F464);
  static const Color accentOrange = Color(0xFFFF7452);

  // Text
  static const Color textPrimary = Color(0xFFF2F4F7);
  static const Color textSecondary = Color(0xFFA7B0BC);
  static const Color textOnAccent = Color(0xFF0D1117);

  // Status
  static const Color error = Color(0xFFF06464);
  static const Color divider = Color(0xFF2A3545);

  // Chip states
  static const Color chipActive = accentLime;
  static const Color chipActiveText = textOnAccent;
  static const Color chipInactive = bgElevated;
  static const Color chipInactiveText = textSecondary;
}
