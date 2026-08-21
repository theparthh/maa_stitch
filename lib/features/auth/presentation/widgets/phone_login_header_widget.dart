import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';

class PhoneLoginHeaderWidget extends StatelessWidget {
  const PhoneLoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: 'auth_brand_icon',
          child: Container(
            width: AppSize.size72,
            height: AppSize.size72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppBorderRadius.borderRadius24,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: AppSize.size20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.grid_4x4_rounded,
                size: AppSize.size36,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        AppGaps.gap20,
        Text(
          'Welcome to Maa Stitch',
          style: AppTextStyles.h2.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        AppGaps.gap8,
        Text(
          'Enter your 10-digit phone number to receive a 6-digit verification code.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.35,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
