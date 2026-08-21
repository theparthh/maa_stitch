import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Palette
  static const Color primary = Color(0xff1e3a8a);
  static const Color secondary = Color(0xff16a34a);

  // Standard Token Palette
  static const Color blue = Color(0xff2563eb);
  static const Color white = Colors.white;
  static const Color red = Color(0xffef4444);
  static const Color black = Colors.black;
  static const Color green = Color(0xff16a34a);
  static const Color grey = Color(0xff94a3b8);
  static const Color transparent = Colors.transparent;

  // Semantic Design Tokens - Light Theme
  static const Color background = Color(0xfff8fafc);
  static const Color surface = Color(0xffffffff);
  static const Color surfaceCard = Color(0xffffffff);
  static const Color surfaceLight = Color(0xfff1f5f9);

  static const Color border = Color(0xffe2e8f0);
  static const Color borderLight = Color(0xffcbd5e1);

  static const Color textPrimary = Color(0xff0f172a);
  static const Color textSecondary = Color(0xff475569);
  static const Color textMuted = Color(0xff64748b);

  static const Color error = Color(0xffef4444);
  static const Color errorLight = Color(0xfffef2f2);
  static const Color success = Color(0xff16a34a);
  static const Color primaryLight = Color(0xffeff6ff);
  static const Color pinBorder = Color(0xffcbd5e1);
  static const Color pinBorderFocused = Color(0xff1e3a8a);
  static const Color pinBg = Color(0xfff8fafc);

  // Embroidery Thread Color Palette Defaults (16 Vibrant Madeira/Isacord Colors)
  static const List<Color> defaultThreadPalette = [
    Color(0xff16a34a), // Emerald Green
    Color(0xff2563eb), // Royal Blue
    Color(0xffd97706), // Amber Gold
    Color(0xffdc2626), // Crimson Red
    Color(0xff9333ea), // Deep Violet
    Color(0xff0891b2), // Ocean Turquoise
    Color(0xffeab308), // Bright Yellow
    Color(0xff0f172a), // Midnight Black
    Color(0xffea580c), // Sunset Orange
    Color(0xffec4899), // Hot Pink
    Color(0xff059669), // Forest Jade
    Color(0xff4f46e5), // Indigo Silk
    Color(0xff84cc16), // Lime Thread
    Color(0xff78350f), // Warm Chocolate
    Color(0xff0284c7), // Sky Blue
    Color(0xffb91c1c), // Ruby Garnet
  ];
}
