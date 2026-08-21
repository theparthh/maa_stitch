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
                Icons.mark_email_read_rounded,
                size: AppSize.size36,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        AppGaps.gap20,
        Text(
          'Verification Code',
          style: AppTextStyles.h2.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        AppGaps.gap8,
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSize.size6,
          runSpacing: AppSize.size4,
          children: [
            Text(
              '6-digit code sent to',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSize.size8, vertical: AppSize.size2),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: AppBorderRadius.borderRadius6,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Text(
                phoneNumber,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            GestureDetector(
              onTap: onChangeNumberTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSize.size2),
                child: const Icon(
                  Icons.edit_rounded,
                  size: AppSize.size16,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
