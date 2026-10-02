import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';

class DesignCardWidget extends StatelessWidget {
  const DesignCardWidget({
    super.key,
    required this.design,
    required this.onTap,
  });

  final EmbroideryDesign design;
  final VoidCallback onTap;

  Color _getBadgeColor(String ext) {
    switch (ext.toLowerCase()) {
      case 'dst':
        return AppColors.primary;
      case 'emb':
        return AppColors.secondary;
      case 'dhp':
        return AppColors.blueLight;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = _getBadgeColor(design.extension);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppBorderRadius.borderRadius16,
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: AppBorderRadius.borderRadius16,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppBorderRadius.borderRadius16,
          child: Padding(
            padding: const EdgeInsets.all(AppSize.size16),
            child: Row(
              children: [
                // Design Icon Thumbnail Container
                Container(
                  width: AppSize.size64,
                  height: AppSize.size64,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: AppBorderRadius.borderRadius12,
                    border:
                        Border.all(color: badgeColor.withValues(alpha: 0.4)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.grid_4x4_rounded,
                          color: badgeColor,
                          size: AppSize.size24,
                        ),
                        AppGaps.gap2,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.size6,
                            vertical: AppSize.size2,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: AppBorderRadius.borderRadius4,
                          ),
                          child: Text(
                            design.extension.toUpperCase(),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: AppFontSize.fontSize10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppGaps.gap16,
                // Design Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        design.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppGaps.gap4,
                      Row(
                        children: [
                          Icon(
                            Icons.polyline_rounded,
                            size: AppSize.size14,
                            color: AppColors.secondary,
                          ),
                          AppGaps.gap4,
                          Text(
                            '${design.totalStitches} stitches',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          AppGaps.gap12,
                          Icon(
                            Icons.palette_outlined,
                            size: AppSize.size14,
                            color: AppColors.blue,
                          ),
                          AppGaps.gap4,
                          Text(
                            '${design.colorChangeCount} colors',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      AppGaps.gap4,
                      Text(
                        'Dimensions: ${design.widthMm.toStringAsFixed(1)} × ${design.heightMm.toStringAsFixed(1)} mm',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                AppGaps.gap8,
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textMuted,
                  size: AppSize.size16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
