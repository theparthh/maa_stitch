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
            width: AppSize.size80,
            height: AppSize.size80,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: AppBorderRadius.borderRadius24,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
                width: AppSize.size1_5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: AppSize.size20,
                  offset: const Offset(0, AppSize.size8),
                ),
              ],
            ),
            child: const Icon(
              Icons.phone_android_rounded,
              size: AppSize.size40,
              color: AppColors.primary,
            ),
          ),
        ),
        AppGaps.gap24,
        Text(
          'Welcome Back',
          style: AppTextStyles.h1,
          textAlign: TextAlign.center,
        ),
        AppGaps.gap8,
        Text(
          'Enter your phone number to receive a 4-digit verification code.',
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
