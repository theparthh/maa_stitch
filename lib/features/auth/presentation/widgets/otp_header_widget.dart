import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';

class OtpHeaderWidget extends StatelessWidget {
  const OtpHeaderWidget({
    super.key,
    required this.phoneNumber,
    required this.onChangeNumberTap,
  });

  final String phoneNumber;
  final VoidCallback onChangeNumberTap;

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
              Icons.mark_email_read_rounded,
              size: AppSize.size40,
              color: AppColors.primary,
            ),
          ),
        ),
        AppGaps.gap24,
        Text(
          'Verification Code',
          style: AppTextStyles.h1,
          textAlign: TextAlign.center,
        ),
        AppGaps.gap8,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Code sent to ',
              style: AppTextStyles.bodyMedium,
            ),
            Text(
              phoneNumber,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            AppGaps.gap4,
            IconButton(
              onPressed: onChangeNumberTap,
              icon: const Icon(
                Icons.edit_rounded,
                size: AppSize.size18,
                color: AppColors.primary,
              ),
              tooltip: 'Edit phone number',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }
}
