import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';

class OtpPinInputWidget extends StatelessWidget {
  const OtpPinInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.onCompleted,
    this.errorMessage,
    this.enabled = true,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final String? errorMessage;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage != null && errorMessage!.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Invisible input field catching touch and keyboard events across the whole width
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: enabled,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  onChanged: (val) {
                    onChanged(val);
                    if (val.length == 6 && onCompleted != null) {
                      onCompleted!(val);
                    }
                  },
                ),
              ),
            ),
            // Visible 6 responsive styled PIN boxes
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final currentText = value.text;
                final isFocused = focusNode.hasFocus;

                return GestureDetector(
                  onTap: () {
                    if (enabled) {
                      focusNode.requestFocus();
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      final digit =
                          index < currentText.length ? currentText[index] : '';
                      final isBoxFocused =
                          isFocused && index == currentText.length.clamp(0, 5);
                      final isFilled = digit.isNotEmpty;

                      Color borderColor = AppColors.border;
                      Color bgColor = AppColors.surface;

                      if (hasError) {
                        borderColor = AppColors.error;
                        bgColor = AppColors.errorLight;
                      } else if (isBoxFocused) {
                        borderColor = AppColors.secondary;
                      } else if (isFilled) {
                        borderColor =
                            AppColors.secondary.withValues(alpha: 0.6);
                        bgColor = AppColors.primaryLight.withValues(alpha: 0.5);
                      }

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppSize.size3,
                          ),
                          height: AppSize.size50,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: AppBorderRadius.borderRadius12,
                            border: Border.all(
                              color: borderColor,
                              width: isBoxFocused || hasError
                                  ? AppSize.size2
                                  : AppSize.size1_5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isBoxFocused
                                    ? AppColors.secondary
                                        .withValues(alpha: 0.15)
                                    : AppColors.black.withValues(alpha: 0.03),
                                blurRadius: isBoxFocused
                                    ? AppSize.size8
                                    : AppSize.size4,
                                offset: const Offset(0, AppSize.size2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              digit,
                              style: AppTextStyles.h2.copyWith(
                                color: hasError
                                    ? AppColors.error
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ],
        ),
        if (hasError) ...[
          AppGaps.gap12,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.size14,
              vertical: AppSize.size8,
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
                  size: AppSize.size16,
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
