import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';

class PhoneInputFieldWidget extends StatelessWidget {
  const PhoneInputFieldWidget({
    super.key,
    required this.phoneNumber,
    required this.onPhoneChanged,
    this.errorMessage,
    this.enabled = true,
  });

  final String phoneNumber;
  final ValueChanged<String> onPhoneChanged;
  final String? errorMessage;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage != null && errorMessage!.isNotEmpty;
    final isComplete = phoneNumber.length == 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: AppTextStyles.labelLarge,
        ),
        AppGaps.gap8,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppBorderRadius.borderRadius16,
            border: Border.all(
              color: hasError
                  ? AppColors.error
                  : (isComplete ? AppColors.primary : AppColors.border),
              width: hasError || isComplete ? AppSize.size1_5 : AppSize.size1,
            ),
            boxShadow: [
              BoxShadow(
                color: hasError
                    ? AppColors.error.withValues(alpha: 0.08)
                    : AppColors.black.withValues(alpha: 0.03),
                blurRadius: AppSize.size12,
                offset: const Offset(0, AppSize.size4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.size12,
            vertical: AppSize.size4,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSize.size8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: AppBorderRadius.borderRadius10,
                ),
                child: const Icon(
                  Icons.phone_rounded,
                  size: AppSize.size18,
                  color: AppColors.primary,
                ),
              ),
              AppGaps.gap12,
              Expanded(
                child: TextFormField(
                  initialValue: phoneNumber,
                  enabled: enabled,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter 10-digit mobile number',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 0,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSize.size10,
                    ),
                    suffixIcon: phoneNumber.isNotEmpty && enabled
                        ? IconButton(
                            icon: const Icon(
                              Icons.cancel_rounded,
                              color: AppColors.textMuted,
                              size: AppSize.size18,
                            ),
                            onPressed: () => onPhoneChanged(''),
                          )
                        : null,
                  ),
                  onChanged: onPhoneChanged,
                ),
              ),
            ],
          ),
        ),
        if (hasError) ...[
          AppGaps.gap8,
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: AppSize.size16,
                color: AppColors.error,
              ),
              AppGaps.gap6,
              Expanded(
                child: Text(
                  errorMessage!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
