import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/features/viewer/presentation/widgets/stat_item_widget.dart';

class StitchStatsBottomSheetWidget extends StatelessWidget {
  const StitchStatsBottomSheetWidget({super.key, required this.design});

  final EmbroideryDesign design;

  @override
  Widget build(BuildContext context) {
    final jumpCount = design.stitches.where((s) => s.type == StitchType.jump).length;
    final normalCount = design.stitches.where((s) => s.type == StitchType.normal).length;
    final estimatedThreadMeters = (normalCount * 4.5) / 1000.0; // ~4.5mm per stitch avg

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
          Text(
            'Embroidery Design Statistics',
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          AppGaps.gap4,
          Text(
            design.fileName,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          AppGaps.gap20,
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: AppSize.size12,
            mainAxisSpacing: AppSize.size12,
            childAspectRatio: 2.2,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StatItemWidget(
                title: 'Total Stitches',
                value: '${design.totalStitches}',
                icon: Icons.architecture_rounded,
              ),
              StatItemWidget(
                title: 'Color Changes',
                value: '${design.colorChangeCount}',
                icon: Icons.palette_outlined,
              ),
              StatItemWidget(
                title: 'Width × Height',
                value: '${design.widthMm.toStringAsFixed(1)} × ${design.heightMm.toStringAsFixed(1)} mm',
                icon: Icons.aspect_ratio_rounded,
              ),
              StatItemWidget(
                title: 'Jump Needle Count',
                value: '$jumpCount jumps',
                icon: Icons.alt_route_rounded,
              ),
              StatItemWidget(
                title: 'Normal Stitches',
                value: '$normalCount',
                icon: Icons.grain_rounded,
              ),
              StatItemWidget(
                title: 'Estimated Thread',
                value: '${estimatedThreadMeters.toStringAsFixed(2)} meters',
                icon: Icons.linear_scale_rounded,
              ),
            ],
          ),
          AppGaps.gap24,
          SizedBox(
            width: double.infinity,
            height: AppSize.size48,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.borderRadius12,
                ),
                elevation: 0,
              ),
              child: const Text('CLOSE'),
            ),
          ),
        ],
      ),
    );
  }
}
