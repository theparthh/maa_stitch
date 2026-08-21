import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';

class SendOtpButtonWidget extends StatelessWidget {
  const SendOtpButtonWidget({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSize.size50,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? (isLoading ? AppColors.primaryLight : AppColors.primary)
              : AppColors.surfaceLight,
          foregroundColor: isEnabled ? AppColors.white : AppColors.textMuted,
          disabledBackgroundColor: AppColors.surfaceLight,
          disabledForegroundColor: AppColors.textMuted,
          elevation: isEnabled && !isLoading ? AppSize.size2 : 0,
          shadowColor: AppColors.primary.withValues(alpha: 0.25),
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.borderRadius14,
            side: isLoading
                ? const BorderSide(color: AppColors.primary, width: AppSize.size1_5)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: AppSize.size22,
                height: AppSize.size22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Verification Code',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: isEnabled ? AppColors.white : AppColors.textMuted,
                      fontSize: AppFontSize.fontSize16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppGaps.gap8,
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: AppSize.size20,
                    color: isEnabled ? AppColors.white : AppColors.textMuted,
                  ),
                ],
              ),
      ),
    );
  }
}
