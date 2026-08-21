import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';

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

  static const List<double> speeds = [1.0, 2.0, 5.0, 10.0];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.size16, vertical: AppSize.size8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.95),
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onPlayToggle,
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                  color: AppColors.secondary,
                  size: AppSize.size36,
                ),
              ),
              AppGaps.gap8,
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.secondary,
                    inactiveTrackColor: AppColors.border,
                    thumbColor: AppColors.secondary,
                    overlayColor: AppColors.secondary.withValues(alpha: 0.2),
                    trackHeight: AppSize.size4,
                  ),
                  child: Slider(
                    value: currentStep.toDouble().clamp(0, totalStitches.toDouble()),
                    min: 0,
                    max: totalStitches.toDouble() > 0 ? totalStitches.toDouble() : 1.0,
                    onChanged: (val) => onStepChanged(val.toInt()),
                  ),
                ),
              ),
              AppGaps.gap8,
              Text(
                '$currentStep / $totalStitches',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppGaps.gap12,
              // Speed Multiplier Dropdown / Toggle
              PopupMenuButton<double>(
                initialValue: speed,
                onSelected: onSpeedChanged,
                color: AppColors.surface,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSize.size8, vertical: AppSize.size4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppBorderRadius.borderRadius8,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    '${speed.toStringAsFixed(0)}x',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                itemBuilder: (_) => speeds.map((s) {
                  return PopupMenuItem<double>(
                    value: s,
                    child: Text('${s.toStringAsFixed(0)}x Speed'),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
