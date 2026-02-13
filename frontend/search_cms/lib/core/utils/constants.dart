import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// The getIt package shortcut
final getIt = GetIt.instance;

// ===== UI Tokens (Login / Global) taken from the Figma Make (Yousif)=====
class AppColors {
  static const background = Color(0xFFF9FAFB); // gray-50
  static const cardBorder = Color(0xFFE5E7EB); // gray-200
  static const inputBorder = Color(0xFFD1D5DB); // gray-300

  static const primaryBlue = Color(0xFF1E40AF);
  static const primaryBlueHover = Color(0xFF1E3A8A);

  static const mutedText = Color(0xFF6B7280); // gray-500
  static const mainText = Color(0xFF111827); // gray-900

  static const danger = Color(0xFFEF4444);
}

class AppDimens {
  // Tokens taken from Figma Make file 
  static const cardRadius = 8.0; // rounded-lg
  static const fieldRadius = 6.0; // rounded-md

  static const cardMaxWidth = 448.0; // 28rem
  static const cardPadding = 32.0; // p-8
  static const controlHeight = 48.0; // h-12

  static const gap24 = 24.0;
  static const gap8 = 8.0;
}
