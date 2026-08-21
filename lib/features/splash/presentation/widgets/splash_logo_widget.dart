import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';

class SplashLogoWidget extends StatelessWidget {
  const SplashLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSize.size80,
          height: AppSize.size80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppBorderRadius.borderRadius24,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: AppSize.size20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.grid_4x4_rounded,
              size: AppSize.size44,
              color: AppColors.white,
            ),
          ),
        ),
        AppGaps.gap20,
        Text(
          'MAA STITCH VIEWER',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        AppGaps.gap6,
        Text(
          'Embroidery CAD Inspection Suite',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        AppGaps.gap24,
        const SizedBox(
          width: AppSize.size24,
          height: AppSize.size24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            strokeWidth: 2.5,
          ),
        ),
      ],
    );
  }
}
