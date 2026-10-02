import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          AppAssets.appLogo,
          width: AppSize.size48,
          height: AppSize.size48,
          fit: BoxFit.contain,
        ),
        AppGaps.gap12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'VIEW STITCH',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimary,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              AppGaps.gap2,
              Text(
                'Embroidery CAD Inspection Suite',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
