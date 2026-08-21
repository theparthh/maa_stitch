import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/app_colors.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/app_font_size.dart';

abstract class AppTextStyles {
  static TextStyle get h1 => GoogleFonts.outfit(
        fontSize: AppFontSize.fontSize32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get h2 => GoogleFonts.outfit(
        fontSize: AppFontSize.fontSize24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.25,
      );

  static TextStyle get h3 => GoogleFonts.outfit(
        fontSize: AppFontSize.fontSize20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: AppFontSize.fontSize16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: AppFontSize.fontSize14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: AppFontSize.fontSize12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.4,
      );

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: AppFontSize.fontSize14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: AppFontSize.fontSize10,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
        letterSpacing: 0.5,
      );
}
