import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/app_colors.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';

abstract class UserFilesData {
  static const String _basePath =
      '/Users/theparth/Desktop/maa_design_stitch_viewer';

  static List<EmbroideryDesign> getUserDesigns() {
    return [
      // ─────────────────────── DST FILES ───────────────────────
      EmbroideryDesign(
        id: 'dst_14501',
        fileName: '14501.DST',
        filePath: '$_basePath/DST/14501.DST',
        extension: 'dst',
        totalStitches: 38420,
        colorChangeCount: 12,
        widthMm: 240.0,
        heightMm: 480.0,
        threadColors: AppColors.defaultThreadPalette,
        stitches: const [],
        lastOpened: DateTime.utc(2026, 10, 1),
        description: 'Tajima DST Embroidery – V-Neck Floral Design',
        previewImagePath: 'assets/images/DST_1.jpeg',
      ),
      EmbroideryDesign(
        id: 'dst_14505',
        fileName: '14505.DST',
        filePath: '$_basePath/DST/14505.DST',
        extension: 'dst',
        totalStitches: 44870,
        colorChangeCount: 15,
        widthMm: 240.0,
        heightMm: 480.0,
        threadColors: AppColors.defaultThreadPalette,
        stitches: const [],
        lastOpened: DateTime.utc(2026, 10, 1),
        description: 'Tajima DST Embroidery – Neck & Border Stitch Pattern',
        previewImagePath: 'assets/images/DST_2.jpeg',
      ),
      // ─────────────────────── DHP FILES ───────────────────────
      EmbroideryDesign(
        id: 'dhp_11006',
        fileName: '11006.DHP',
        filePath: '$_basePath/DHP/11006.DHP',
        extension: 'dhp',
        totalStitches: 62340,
        colorChangeCount: 18,
        widthMm: 260.0,
        heightMm: 900.0,
        threadColors: _dhpPalette,
        stitches: const [],
        lastOpened: DateTime.utc(2026, 10, 1),
        description: 'Dahao DHP – MAA-11006 Full Kurti Embroidery Set',
        previewImagePath: 'assets/images/DHP_2.jpeg',
      ),
      EmbroideryDesign(
        id: 'dhp_11011',
        fileName: '11011.DHP',
        filePath: '$_basePath/DHP/11011.DHP',
        extension: 'dhp',
        totalStitches: 75890,
        colorChangeCount: 22,
        widthMm: 260.0,
        heightMm: 900.0,
        threadColors: _dhpPalette,
        stitches: const [],
        lastOpened: DateTime.utc(2026, 10, 1),
        description: 'Dahao DHP – MAA-11011 Full Kurti Embroidery Set',
        previewImagePath: 'assets/images/DHP_3.jpeg',
      ),
      // ─────────────────────── EMB FILES ───────────────────────
      EmbroideryDesign(
        id: 'emb_670',
        fileName: '670.EMB',
        filePath: '$_basePath/EMB/670.EMB',
        extension: 'emb',
        totalStitches: 54131,
        colorChangeCount: 18,
        widthMm: 260.0,
        heightMm: 520.0,
        threadColors: _emb670Palette,
        stitches: const [],
        lastOpened: DateTime.utc(2026, 10, 1),
        description: 'Wilcom EMB – Paisley Green Neck Embroidery',
        previewImagePath: 'assets/images/EMB_1.jpeg',
      ),
      EmbroideryDesign(
        id: 'emb_721',
        fileName: '721.EMB',
        filePath: '$_basePath/EMB/721.EMB',
        extension: 'emb',
        totalStitches: 41200,
        colorChangeCount: 8,
        widthMm: 240.0,
        heightMm: 720.0,
        threadColors: _emb721Palette,
        stitches: const [],
        lastOpened: DateTime.utc(2026, 10, 1),
        description: 'Wilcom EMB – Turquoise & Gold Neck Border Design',
        previewImagePath: 'assets/images/EMB_3.jpeg',
      ),
      EmbroideryDesign(
        id: 'emb_726',
        fileName: '726.EMB',
        filePath: '$_basePath/EMB/726.EMB',
        extension: 'emb',
        totalStitches: 68400,
        colorChangeCount: 24,
        widthMm: 240.0,
        heightMm: 520.0,
        threadColors: _emb726Palette,
        stitches: const [],
        lastOpened: DateTime.utc(2026, 10, 1),
        description: 'Wilcom EMB – Green Chikankari Neck & Body Design',
        previewImagePath: 'assets/images/EMB_2.jpeg',
      ),
    ];
  }

  // ── EMB 670 Thread Palette (Paisley Green) ──
  static const List<Color> _emb670Palette = [
    Color(0xff2e7d32), // Emerald Green
    Color(0xff8bc34a), // Light Green / Lime
    Color(0xfffbc02d), // Warm Yellow / Gold
    Color(0xff795548), // Golden Brown / Copper
    Color(0xfff8bbd0), // Soft Pink
    Color(0xffffffff), // White
    Color(0xff00bcd4), // Aqua / Turquoise
    Color(0xffc2185b), // Dark Magenta
  ];

  // ── EMB 721 Thread Palette (Chikankari Green) ──
  static const List<Color> _emb721Palette = [
    Color(0xff1b5e20), // Deep Green
    Color(0xff388e3c), // Medium Green
    Color(0xff66bb6a), // Light Green
    Color(0xffa5d6a7), // Pale Green
    Color(0xffe8f5e9), // Near White Green
  ];

  // ── EMB 726 Thread Palette (Turquoise & Gold) ──
  static const List<Color> _emb726Palette = [
    Color(0xff00bcd4), // Cyan / Turquoise
    Color(0xff26c6da), // Light Cyan
    Color(0xfffdd835), // Yellow / Gold
    Color(0xffe53935), // Red / Pink
    Color(0xff43a047), // Green
    Color(0xfff48fb1), // Pink
    Color(0xff1565c0), // Deep Blue
    Color(0xffffe082), // Light Gold
  ];

  // ── DHP Thread Palette ──
  static const List<Color> _dhpPalette = [
    Color(0xffc62828), // Deep Red
    Color(0xff2e7d32), // Emerald Green
    Color(0xff1565c0), // Navy Blue
    Color(0xffad1457), // Magenta / Pink
    Color(0xfff9a825), // Amber / Gold
    Color(0xff00838f), // Teal
    Color(0xff6a1b9a), // Purple
    Color(0xffffffff), // White
  ];
}
