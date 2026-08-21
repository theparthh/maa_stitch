import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';
import 'package:pinput/pinput.dart';

class OtpPinInputWidget extends StatelessWidget {
  const OtpPinInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onCompleted,
    this.errorMessage,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage != null && errorMessage!.isNotEmpty;

    final defaultPinTheme = PinTheme(
      width: AppSize.size64,
      height: AppSize.size64,
      textStyle: AppTextStyles.h1.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppBorderRadius.borderRadius16,
        border: Border.all(
          color: AppColors.border,
          width: AppSize.size1_5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: AppSize.size12,
            offset: const Offset(0, AppSize.size4),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: AppColors.primary,
          width: AppSize.size2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: AppSize.size16,
            offset: const Offset(0, AppSize.size4),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.primaryLight.withValues(alpha: 0.5),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: AppSize.size1_5,
        ),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.errorLight,
        border: Border.all(
          color: AppColors.error,
          width: AppSize.size2,
        ),
      ),
    );

    return Column(
      children: [
        Pinput(
          length: 4,
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          errorPinTheme: errorPinTheme,
          forceErrorState: hasError,
          animationDuration: const Duration(milliseconds: 200),
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          onChanged: onChanged,
          onCompleted: onCompleted,
        ),
        if (hasError) ...[
          AppGaps.gap16,
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.size16,
              vertical: AppSize.size10,
            ),
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: AppBorderRadius.borderRadius12,
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.3),
                width: AppSize.size1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: AppSize.size18,
                  color: AppColors.error,
                ),
                AppGaps.gap8,
                Flexible(
                  child: Text(
                    errorMessage!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
