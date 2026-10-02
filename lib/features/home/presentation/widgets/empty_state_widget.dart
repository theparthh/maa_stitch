import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key, required this.onResetFilter});

  final VoidCallback onResetFilter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSize.size32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.manage_search_rounded,
              size: AppSize.size64,
              color: AppColors.textMuted,
            ),
            AppGaps.gap16,
            Text(
              'No Designs Found',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
            ),
            AppGaps.gap8,
            Text(
              'No embroidery files match your active search or extension filter.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            AppGaps.gap20,
            OutlinedButton(
              onPressed: onResetFilter,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondary,
                side: const BorderSide(color: AppColors.secondary),
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.borderRadius12,
                ),
              ),
              child: const Text('Reset All Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
