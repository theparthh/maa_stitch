import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Luxury Dark Blue & Crisp White Palette
  static const Color primary = Color(0xff0f2b5c); // Deep Navy Dark Blue
  static const Color primaryDark = Color(0xff091836); // Midnight Dark Blue
  static const Color secondary = Color(0xff1d4ed8); // Royal Blue Accent
  static const Color blue = Color(0xff2563eb); // Vivid Blue
  static const Color blueLight = Color(0xff38bdf8); // Sky Cyan Accent
  
  // Standard Tokens
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xff94a3b8);
  static const Color transparent = Colors.transparent;
  static const Color red = Color(0xffef4444);
  static const Color green = Color(0xff1d4ed8); // Mapped to Dark Blue

  // Light Theme Semantic Tokens
  static const Color background = Color(0xfff8fafc);
  static const Color surface = Color(0xffffffff);
  static const Color surfaceCard = Color(0xffffffff);
  static const Color surfaceLight = Color(0xfff1f5f9);
  static const Color primaryLight = Color(0xffeff6ff);

  // Borders & Dividers
  static const Color border = Color(0xffe2e8f0);
  static const Color borderLight = Color(0xffcbd5e1);
  static const Color borderFocused = Color(0xff0f2b5c);

  // Text Typography Colors
  static const Color textPrimary = Color(0xff091836);
  static const Color textSecondary = Color(0xff334155);
  static const Color textMuted = Color(0xff64748b);
  static const Color textWhite = Color(0xffffffff);

  // States
  static const Color error = Color(0xffef4444);
  static const Color errorLight = Color(0xfffef2f2);
  static const Color success = Color(0xff1d4ed8); // Royal Blue

  // PIN Input
  static const Color pinBorder = Color(0xffcbd5e1);
  static const Color pinBorderFocused = Color(0xff0f2b5c);
  static const Color pinBg = Color(0xfff8fafc);

  // Embroidery Thread Color Palette Defaults (Dark Blue, Steel & Multi-tone Threads)
  static const List<Color> defaultThreadPalette = [
    Color(0xff0f2b5c), // Midnight Navy
    Color(0xff1d4ed8), // Royal Blue
    Color(0xff0284c7), // Ocean Blue
    Color(0xff38bdf8), // Sky Blue
    Color(0xffd97706), // Amber Gold
    Color(0xffdc2626), // Crimson Red
    Color(0xff9333ea), // Deep Violet
    Color(0xff0891b2), // Turquoise
    Color(0xffeab308), // Bright Yellow
    Color(0xff091836), // Midnight Black
    Color(0xffea580c), // Sunset Orange
    Color(0xffec4899), // Hot Pink
    Color(0xff4f46e5), // Indigo Silk
    Color(0xff78350f), // Warm Chocolate
    Color(0xffb91c1c), // Ruby Garnet
    Color(0xff64748b), // Slate Grey
  ];
}
