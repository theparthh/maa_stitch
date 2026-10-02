import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';

/// Reusable error display widget for the reference files feature.
class RefErrorWidget extends StatelessWidget {
  const RefErrorWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSize.size32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: AppSize.size64,
              color: AppColors.error,
            ),
            AppGaps.gap16,
            Text(
              'Something went wrong',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
            ),
            AppGaps.gap8,
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
