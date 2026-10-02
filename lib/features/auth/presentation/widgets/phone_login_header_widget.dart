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
          child: Image.asset(
            AppAssets.appLogo,
            width: AppSize.size80,
            height: AppSize.size80,
            fit: BoxFit.contain,
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
