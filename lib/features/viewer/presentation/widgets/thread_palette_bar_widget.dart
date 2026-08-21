import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';

class ThreadPaletteBarWidget extends StatelessWidget {
  const ThreadPaletteBarWidget({
    super.key,
    required this.design,
    required this.selectedColorIndex,
    required this.onColorSelected,
  });

  final EmbroideryDesign design;
  final int? selectedColorIndex;
  final ValueChanged<int?> onColorSelected;

  @override
  Widget build(BuildContext context) {
    final colors = design.threadColors.isNotEmpty
        ? design.threadColors
        : AppColors.defaultThreadPalette;

    return Container(
      height: AppSize.size56,
      padding: const EdgeInsets.symmetric(horizontal: AppSize.size16, vertical: AppSize.size8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onColorSelected(null),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSize.size10, vertical: AppSize.size6),
              decoration: BoxDecoration(
                color: selectedColorIndex == null ? AppColors.secondary : AppColors.surfaceLight,
                borderRadius: AppBorderRadius.borderRadius12,
                border: Border.all(
                  color: selectedColorIndex == null ? AppColors.secondary : AppColors.border,
                ),
              ),
              child: Text(
                'ALL (${colors.length})',
                style: AppTextStyles.caption.copyWith(
                  color: selectedColorIndex == null ? AppColors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          AppGaps.gap12,
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              separatorBuilder: (context, index) => AppGaps.gap8,
              itemBuilder: (context, index) {
                final color = colors[index];
                final isSelected = selectedColorIndex == index;
                return GestureDetector(
                  onTap: () => onColorSelected(index),
                  child: Container(
                    width: AppSize.size36,
                    height: AppSize.size36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.textPrimary : AppColors.border,
                        width: isSelected ? AppSize.size3 : AppSize.size1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.6),
                                blurRadius: AppSize.size8,
                                spreadRadius: AppSize.size2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            size: AppSize.size18,
                            color: AppColors.black,
                          )
                        : Center(
                            child: Text(
                              '${index + 1}',
                              style: AppTextStyles.caption.copyWith(
                                color: color.computeLuminance() > 0.5
                                    ? AppColors.black
                                    : AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
