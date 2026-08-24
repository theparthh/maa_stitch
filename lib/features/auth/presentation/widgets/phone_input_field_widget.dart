import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';

class PhoneInputFieldWidget extends StatefulWidget {
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
  State<PhoneInputFieldWidget> createState() => _PhoneInputFieldWidgetState();
}

class _PhoneInputFieldWidgetState extends State<PhoneInputFieldWidget> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.phoneNumber);
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void didUpdateWidget(covariant PhoneInputFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.phoneNumber != _controller.text) {
      _controller.text = widget.phoneNumber;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError =
        widget.errorMessage != null && widget.errorMessage!.isNotEmpty;
    final isComplete = widget.phoneNumber.length == 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mobile Number',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            if (isComplete)
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: AppSize.size16,
                    color: AppColors.secondary,
                  ),
                  AppGaps.gap4,
                  Text(
                    '10 digits',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        ),
        AppGaps.gap8,
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppBorderRadius.borderRadius16,
            border: Border.all(
              color: hasError
                  ? AppColors.error
                  : (_isFocused ? AppColors.secondary : AppColors.border),
              width: hasError || _isFocused ? AppSize.size1_5 : AppSize.size1,
            ),
            boxShadow: [
              if (_isFocused)
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  blurRadius: AppSize.size12,
                  offset: const Offset(0, AppSize.size4),
                )
              else
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.03),
                  blurRadius: AppSize.size8,
                  offset: const Offset(0, AppSize.size2),
                ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.size16,
            vertical: AppSize.size4,
          ),
          child: Row(
            children: [
              // Clean Phone Icon
              Icon(
                Icons.phone_outlined,
                size: AppSize.size20,
                color: _isFocused ? AppColors.secondary : AppColors.textMuted,
              ),

              AppGaps.gap12,

              // Phone Number Input
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: AppTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter 10-digit mobile number',
                    hintStyle: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textMuted.withValues(alpha: 0.6),
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSize.size10,
                    ),
                    suffixIcon: widget.phoneNumber.isNotEmpty && widget.enabled
                        ? IconButton(
                            icon: const Icon(
                              Icons.cancel_rounded,
                              color: AppColors.textMuted,
                              size: AppSize.size20,
                            ),
                            onPressed: () {
                              widget.onPhoneChanged('');
                              _controller.clear();
                            },
                          )
                        : null,
                  ),
                  onChanged: widget.onPhoneChanged,
                ),
              ),
            ],
          ),
        ),

        // Error message row
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
                  widget.errorMessage!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
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
