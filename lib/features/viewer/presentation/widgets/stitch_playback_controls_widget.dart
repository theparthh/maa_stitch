import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';

/// Play/pause, scrub slider (with step counter underneath) and speed menu.
/// Compact enough to sit beside the view toggles on a 360 px wide phone.
class StitchPlaybackControlsWidget extends StatelessWidget {
  const StitchPlaybackControlsWidget({
    super.key,
    required this.totalStitches,
    required this.currentStep,
    required this.isPlaying,
    required this.speed,
    required this.onPlayToggle,
    required this.onStepChanged,
    required this.onSpeedChanged,
  });

  final int totalStitches;
  final int currentStep;
  final bool isPlaying;
  final double speed;
  final VoidCallback onPlayToggle;
  final ValueChanged<int> onStepChanged;
  final ValueChanged<double> onSpeedChanged;

  static const List<double> speeds = [1, 2, 5, 10, 25, 50];

  @override
  Widget build(BuildContext context) {
    final max = totalStitches > 0 ? totalStitches.toDouble() : 1.0;
    return Row(
      children: [
        IconButton(
          onPressed: onPlayToggle,
          tooltip: isPlaying ? 'Pause' : 'Play stitch by stitch',
          icon: Icon(
            isPlaying
                ? Icons.pause_circle_filled_rounded
                : Icons.play_circle_fill_rounded,
            color: AppColors.primary,
            size: AppSize.size36,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.border,
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withValues(alpha: 0.15),
                  trackHeight: AppSize.size4,
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: AppSize.size14),
                ),
                child: Slider(
                  value: currentStep.toDouble().clamp(0, max),
                  max: max,
                  onChanged: (v) => onStepChanged(v.round()),
                ),
              ),
              Text(
                '$currentStep / $totalStitches',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: AppFontSize.fontSize10,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<double>(
          initialValue: speed,
          onSelected: onSpeedChanged,
          color: AppColors.surface,
          tooltip: 'Playback speed',
          itemBuilder: (_) => [
            for (final s in speeds)
              PopupMenuItem<double>(
                value: s,
                child: Text('${s.toStringAsFixed(0)}× speed'),
              ),
          ],
          child: Container(
            margin: const EdgeInsets.only(right: AppSize.size12),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.size8, vertical: AppSize.size4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: AppBorderRadius.borderRadius8,
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Text(
              '${speed.toStringAsFixed(0)}×',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
