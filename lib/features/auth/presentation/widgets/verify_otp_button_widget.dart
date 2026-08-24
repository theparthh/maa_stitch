import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';

class VerifyOtpButtonWidget extends StatelessWidget {
  const VerifyOtpButtonWidget({
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
    return Container(
      width: double.infinity,
      height: AppSize.size54,
      decoration: BoxDecoration(
        gradient: isEnabled && !isLoading
            ? const LinearGradient(
                colors: [
                  AppColors.primaryDark,
                  AppColors.primary,
                  AppColors.secondary,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isLoading
            ? AppColors.primaryLight
            : (!isEnabled ? AppColors.surfaceLight : null),
        border: isLoading
            ? Border.all(
                color: AppColors.secondary.withValues(alpha: 0.3),
                width: AppSize.size1_5,
              )
            : null,
        borderRadius: AppBorderRadius.borderRadius16,
        boxShadow: isEnabled && !isLoading
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: AppSize.size16,
                  offset: const Offset(0, AppSize.size6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: AppBorderRadius.borderRadius16,
          child: Center(
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.fallingDot(
                        color: AppColors.secondary,
                        size: AppSize.size32,
                      ),
                      AppGaps.gap12,
                      Text(
                        'Verifying Code...',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Verify & Continue',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: isEnabled ? AppColors.white : AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                      AppGaps.gap8,
                      Icon(
                        Icons.check_circle_rounded,
                        size: AppSize.size20,
                        color: isEnabled ? AppColors.white : AppColors.textMuted,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
