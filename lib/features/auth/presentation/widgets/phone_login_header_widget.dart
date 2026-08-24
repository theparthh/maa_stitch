import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';

class PhoneLoginHeaderWidget extends StatelessWidget {
  const PhoneLoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Brand Logo Container with Glow & Gradient
        Hero(
          tag: 'auth_brand_icon',
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: AppSize.size80,
                height: AppSize.size80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
              ),
              Container(
                width: AppSize.size72,
                height: AppSize.size72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryDark,
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppBorderRadius.borderRadius24,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: AppSize.size20,
                      offset: const Offset(0, AppSize.size10),
                    ),
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.2),
                      blurRadius: AppSize.size10,
                      offset: const Offset(0, AppSize.size4),
                    ),
                  ],
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.grid_4x4_rounded,
                        size: AppSize.size32,
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                      Positioned(
                        right: AppSize.size14,
                        bottom: AppSize.size14,
                        child: Container(
                          width: AppSize.size8,
                          height: AppSize.size8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.blueLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        AppGaps.gap20,

        // Title
        Text(
          'Welcome to View Stitch',
          style: AppTextStyles.h2.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        AppGaps.gap8,

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSize.size16),
          child: Text(
            'Enter your 10-digit mobile number to receive your secure verification code.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
