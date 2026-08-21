import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';

class ViewerToolbarWidget extends StatelessWidget {
  const ViewerToolbarWidget({
    super.key,
    required this.design,
    required this.onBackTap,
  });

  final EmbroideryDesign design;
  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.size16,
        vertical: AppSize.size12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: AppSize.size8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: onBackTap,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
            ),
            AppGaps.gap8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.size6,
                          vertical: AppSize.size2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppBorderRadius.borderRadius4,
                        ),
                        child: Text(
                          '.${design.extension.toUpperCase()}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      AppGaps.gap8,
                      Text(
                        '${design.totalStitches} Stitches',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
