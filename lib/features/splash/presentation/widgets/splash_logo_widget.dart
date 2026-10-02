import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';

class SplashLogoWidget extends StatelessWidget {
  const SplashLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Hero(
          tag: 'app_brand_logo',
          child: Image.asset(
            AppAssets.appLogo,
            width: AppSize.size140,
            height: AppSize.size140,
            fit: BoxFit.contain,
          ),
        ),
        AppGaps.gap24,
        Text(
          'VIEW STITCH',
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
        LoadingAnimationWidget.fallingDot(
          color: AppColors.secondary,
          size: AppSize.size36,
        ),
      ],
    );
  }
}
