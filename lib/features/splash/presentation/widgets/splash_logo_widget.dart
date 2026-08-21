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
            color: AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: AppBorderRadius.borderRadius20,
          ),
          child: const Center(
            child: Icon(
              Icons.grid_4x4_rounded,
              size: AppSize.size40,
              color: AppColors.secondary,
            ),
          ),
        ),
        AppGaps.gap16,
        Text(
          'MAA STITCH VIEWER',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppGaps.gap24,
        const SizedBox(
          width: AppSize.size24,
          height: AppSize.size24,
          child: CircularProgressIndicator(
            color: AppColors.secondary,
            strokeWidth: 2.5,
          ),
        ),
      ],
    );
  }
}
