import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';
import 'package:maa_design_stitch_viewer/features/auth/domain/domain.dart';

class CountryCodePickerWidget extends StatelessWidget {
  const CountryCodePickerWidget({
    super.key,
    required this.selectedCountry,
    required this.countries,
    required this.onCountrySelected,
  });

  final CountryCodeModel selectedCountry;
  final List<CountryCodeModel> countries;
  final ValueChanged<CountryCodeModel> onCountrySelected;

  void _showCountryBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: AppBorderRadius.radius24,
        ),
      ),
      backgroundColor: AppColors.surface,
      builder: (modalContext) {
        return Padding(
          padding: const EdgeInsets.all(AppSize.size20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Country',
                    style: AppTextStyles.h3,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(modalContext),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              AppGaps.gap16,
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: countries.length,
                  separatorBuilder: (_, index) => const Divider(
                    color: AppColors.border,
                    height: AppSize.size1,
                  ),
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    final isSelected = country.code == selectedCountry.code;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSize.size12,
                        vertical: AppSize.size4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppBorderRadius.borderRadius12,
                      ),
                      tileColor: isSelected
                          ? AppColors.primaryLight
                          : AppColors.transparent,
                      leading: Text(
                        country.flagEmoji,
                        style: const TextStyle(fontSize: AppFontSize.fontSize24),
                      ),
                      title: Text(
                        country.countryName,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      trailing: Text(
                        country.code,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        onCountrySelected(country);
                        Navigator.pop(modalContext);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showCountryBottomSheet(context),
      borderRadius: AppBorderRadius.borderRadius12,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.size12,
          vertical: AppSize.size12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppBorderRadius.borderRadius12,
          border: Border.all(
            color: AppColors.border,
            width: AppSize.size1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedCountry.flagEmoji,
              style: const TextStyle(fontSize: AppFontSize.fontSize18),
            ),
            AppGaps.gap6,
            Text(
              selectedCountry.code,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            AppGaps.gap4,
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: AppSize.size20,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
