import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/features/home/presentation/widgets/detail_row_widget.dart';

class DesignDetailsSheetWidget extends StatelessWidget {
  const DesignDetailsSheetWidget({
    super.key,
    required this.design,
    required this.onOpenInViewer,
  });

  final EmbroideryDesign design;
  final VoidCallback onOpenInViewer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSize.size24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: AppBorderRadius.radius24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: AppSize.size40,
              height: AppSize.size4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: AppBorderRadius.borderRadius4,
              ),
            ),
          ),
          AppGaps.gap16,
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSize.size12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: AppBorderRadius.borderRadius12,
                ),
                child: const Icon(
                  Icons.architecture_rounded,
                  color: AppColors.secondary,
                  size: AppSize.size32,
                ),
              ),
              AppGaps.gap16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      design.fileName,
                      style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                    ),
                    AppGaps.gap4,
                    Text(
                      'Format: .${design.extension.toUpperCase()} Stitch File',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppGaps.gap24,
          Container(
            padding: const EdgeInsets.all(AppSize.size16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppBorderRadius.borderRadius16,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                DetailRowWidget(
                  icon: Icons.numbers_rounded,
                  label: 'Total Stitches',
                  value: '${design.totalStitches}',
                ),
                const Divider(color: AppColors.border, height: AppSize.size24),
                DetailRowWidget(
                  icon: Icons.palette_outlined,
                  label: 'Color Layers',
                  value: '${design.colorChangeCount} palette changes',
                ),
                const Divider(color: AppColors.border, height: AppSize.size24),
                DetailRowWidget(
                  icon: Icons.aspect_ratio_rounded,
                  label: 'Dimensions',
                  value: '${design.widthMm.toStringAsFixed(1)} mm × ${design.heightMm.toStringAsFixed(1)} mm',
                ),
                const Divider(color: AppColors.border, height: AppSize.size24),
                DetailRowWidget(
                  icon: Icons.sd_card_outlined,
                  label: 'File Location',
                  value: design.filePath,
                ),
              ],
            ),
          ),
          AppGaps.gap24,
          SizedBox(
            width: double.infinity,
            height: AppSize.size48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                onOpenInViewer();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.borderRadius12,
                ),
              ),
              icon: const Icon(Icons.zoom_in_rounded),
              label: Text(
                'OPEN DESIGN IN VIEWER',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
