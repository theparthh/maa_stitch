import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';

class OtpTimerResendWidget extends StatelessWidget {
  const OtpTimerResendWidget({
    super.key,
    required this.timerSeconds,
    required this.canResend,
    required this.onResendTap,
  });

  final int timerSeconds;
  final bool canResend;
  final VoidCallback onResendTap;

  String _formatTimer(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: canResend
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive code? ",
                  style: AppTextStyles.bodyMedium,
                ),
                TextButton(
                  onPressed: onResendTap,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.size8,
                      vertical: AppSize.size4,
                    ),
                  ),
                  child: Text(
                    'Resend Code',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.timer_outlined,
                  size: AppSize.size18,
                  color: AppColors.textMuted,
                ),
                AppGaps.gap6,
                Text(
                  'Resend code in ',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  _formatTimer(timerSeconds),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
    );
  }
}
