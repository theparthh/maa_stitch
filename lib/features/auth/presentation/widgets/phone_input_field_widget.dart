import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';
import 'package:maa_design_stitch_viewer/features/auth/domain/domain.dart';
import 'package:maa_design_stitch_viewer/features/auth/presentation/widgets/country_code_picker_widget.dart';

class PhoneInputFieldWidget extends StatelessWidget {
  const PhoneInputFieldWidget({
    super.key,
    required this.selectedCountry,
    required this.countries,
    required this.phoneNumber,
    required this.onPhoneChanged,
    required this.onCountrySelected,
    this.errorMessage,
  });

  final CountryCodeModel selectedCountry;
  final List<CountryCodeModel> countries;
  final String phoneNumber;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<CountryCodeModel> onCountrySelected;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage != null && errorMessage!.isNotEmpty;

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
                  : (phoneNumber.length == selectedCountry.phoneLength
                      ? AppColors.primary
                      : AppColors.border),
              width: hasError || phoneNumber.length == selectedCountry.phoneLength
                  ? AppSize.size1_5
                  : AppSize.size1,
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
          padding: const EdgeInsets.all(AppSize.size6),
          child: Row(
            children: [
              CountryCodePickerWidget(
                selectedCountry: selectedCountry,
                countries: countries,
                onCountrySelected: onCountrySelected,
              ),
              AppGaps.gap8,
              Expanded(
                child: TextFormField(
                  initialValue: phoneNumber,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(selectedCountry.phoneLength),
                  ],
                  style: AppTextStyles.h3.copyWith(
                    letterSpacing: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter ${selectedCountry.phoneLength} digits',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 0,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSize.size8,
                      vertical: AppSize.size10,
                    ),
                    suffixIcon: phoneNumber.isNotEmpty
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
