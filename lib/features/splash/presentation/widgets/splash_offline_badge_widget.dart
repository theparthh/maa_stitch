import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';

class SplashOfflineBadgeWidget extends StatelessWidget {
  const SplashOfflineBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.size16, vertical: AppSize.size8),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: AppBorderRadius.borderRadius20,
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.15),
            width: AppSize.size1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSize.size8,
            height: AppSize.size8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          AppGaps.gap8,
          Text(
            '100% Offline • High Performance Engine',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
