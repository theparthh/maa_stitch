import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';

/// Reusable empty state widget for the reference files feature.
class RefEmptyStateWidget extends StatelessWidget {
  const RefEmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onReset,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSize.size32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppSize.size64, color: AppColors.textMuted),
            AppGaps.gap16,
            Text(
              title,
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            AppGaps.gap8,
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onReset != null) ...[
              AppGaps.gap20,
              OutlinedButton(
                onPressed: onReset,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  side: const BorderSide(color: AppColors.secondary),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.borderRadius12,
                  ),
                ),
                child: const Text('Clear Search'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
