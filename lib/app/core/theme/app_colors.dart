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

  // Embroidery Thread Color Palette Defaults (Exact Commercial Embroidery Match)
  static const List<Color> defaultThreadPalette = [
    Color(0xff5036b1), // 0: Royal Sapphire Blue (Top-Right Flowers)
    Color(0xff539943), // 1: Emerald Leaf Green (Top-Left Flowers)
    Color(0xffc82323), // 2: Crimson Red (Vines, Leaves & Border)
    Color(0xff00bcd4), // 3: Vibrant Cyan / Turquoise (Pearls & Discs)
    Color(0xffece23c), // 4: Warm Gold / Yellow (Inner Dots)
    Color(0xffa72d9e), // 5: Royal Purple / Magenta (V-Neck Collar)
    Color(0xffe91e63), // 6: Rose Pink
    Color(0xffea580c), // 7: Sunset Orange
    Color(0xff0f2b5c), // 8: Deep Midnight Navy
    Color(0xff8e24aa), // 9: Deep Violet
    Color(0xff00897b), // 10: Teal Green
    Color(0xfffdd835), // 11: Sunflower Yellow
    Color(0xff4f46e5), // 12: Indigo Silk
    Color(0xff78350f), // 13: Warm Chocolate
    Color(0xffb91c1c), // 14: Ruby Garnet
    Color(0xff64748b), // Slate Grey
  ];
}
