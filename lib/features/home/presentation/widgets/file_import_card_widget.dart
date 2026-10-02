import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';

class FileImportCardWidget extends StatelessWidget {
  const FileImportCardWidget({
    super.key,
    required this.onImportTap,
  });

  final VoidCallback onImportTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSize.size20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppBorderRadius.borderRadius20,
        border: Border.all(color: AppColors.border, width: AppSize.size1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: AppSize.size16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSize.size12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.folder_open_rounded,
                  color: AppColors.secondary,
                  size: AppSize.size28,
                ),
              ),
              AppGaps.gap12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Open Embroidery File',
                      style: AppTextStyles.h3
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    AppGaps.gap2,
                    Text(
                      'Supports Tajima (.dst), Wilcom (.emb), DHP (.dhp)',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppGaps.gap16,
          SizedBox(
            width: double.infinity,
            height: AppSize.size48,
            child: ElevatedButton.icon(
              onPressed: onImportTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.borderRadius12,
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.file_open_rounded),
              label: Text(
                'BROWSE DEVICE STORAGE',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
