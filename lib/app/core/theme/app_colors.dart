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

  // Default colours for DST colour blocks (DST stores no colours).
  static const List<Color> defaultThreadPalette = [
    Color(0xffc62828), // Red
    Color(0xff2e7d32), // Green
    Color(0xff1e3a8a), // Royal Blue
    Color(0xffd81b60), // Magenta
    Color(0xffe6b800), // Gold Yellow
    Color(0xff00acc1), // Turquoise
    Color(0xff6a1b9a), // Purple
    Color(0xffef6c00), // Orange
    Color(0xff5d4037), // Brown
    Color(0xff616161), // Grey
    Color(0xffec407a), // Pink
    Color(0xff00796b), // Teal
    Color(0xff283593), // Indigo
    Color(0xff827717), // Olive
    Color(0xff212121), // Black
  ];

  /// Default for Dahao bead / cord lines.
  static const Color beadDefault = Color(0xffe0592a);

  // Needle defaults chosen to match Dahao's own screen colours for the
  // reference designs (needle 1 green satin, needle 2 red, …).
  static const List<Color> _needleDefaults = [
    Color(0xff2e7d32), // 1 Green
    Color(0xffc62828), // 2 Red
    Color(0xff1e3a8a), // 3 Royal Blue
    Color(0xffef6c00), // 4 Orange
    Color(0xffd81b60), // 5 Magenta
    Color(0xff6a1b9a), // 6 Purple
    Color(0xff00acc1), // 7 Turquoise
    Color(0xffe6b800), // 8 Gold Yellow
    Color(0xff5d4037), // 9 Brown
    Color(0xff616161), // 10 Grey
    Color(0xffec407a), // 11 Pink
    Color(0xff00796b), // 12 Teal
  ];

  /// Default colour for Dahao needle [needle] (1-based).
  static Color needleColor(int needle) =>
      _needleDefaults[(needle - 1).abs() % _needleDefaults.length];

  // Device codes seen in Dahao files and the colours Dahao showed for them.
  static const Map<int, Color> _sequinByCode = {
    6: Color(0xffb8c4cc), // silver rows
    8: Color(0xff1e3fd0), // single blue sequins
    0x100: Color(0xff1e3fd0), // blue
    0x1000: Color(0xffe91e8c), // pink
  };

  static const List<Color> _sequinDefaults = [
    Color(0xff1e3fd0), // Royal blue
    Color(0xffe91e8c), // Pink
    Color(0xffb8c4cc), // Silver
    Color(0xffd4af37), // Gold
    Color(0xff7b1fa2), // Purple
  ];

  /// Default colour for a sequin device with flag [code], the [n]th seen.
  static Color sequinColor(int code, int n) =>
      _sequinByCode[code] ?? _sequinDefaults[n % _sequinDefaults.length];

  /// Swatches offered in the thread colour picker.
  static const List<Color> threadSwatches = [
    Color(0xffffffff), Color(0xfff5f0e1), Color(0xffbdbdbd), Color(0xff757575),
    Color(0xff212121), Color(0xff000000), Color(0xfffff176), Color(0xffffd600),
    Color(0xffe6b800), Color(0xffffa000), Color(0xffef6c00), Color(0xffff7043),
    Color(0xffff8a80), Color(0xffe53935), Color(0xffc62828), Color(0xff8e0000),
    Color(0xfff8bbd0), Color(0xfff06292), Color(0xffec407a), Color(0xffd81b60),
    Color(0xffad1457), Color(0xffce93d8), Color(0xffab47bc), Color(0xff6a1b9a),
    Color(0xffb39ddb), Color(0xff5e35b1), Color(0xff283593), Color(0xff1e3a8a),
    Color(0xff1565c0), Color(0xff42a5f5), Color(0xff90caf9), Color(0xff00acc1),
    Color(0xff80deea), Color(0xff00796b), Color(0xff4db6ac), Color(0xffa5d6a7),
    Color(0xff66bb6a), Color(0xff2e7d32), Color(0xff1b5e20), Color(0xffc0ca33),
    Color(0xff827717), Color(0xffd7ccc8), Color(0xffa1887f), Color(0xff6d4c41),
    Color(0xff5d4037), Color(0xff3e2723), Color(0xffd4af37), Color(0xffc0c0c0),
  ];
}
