import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';

class IconButtonToggleWidget extends StatelessWidget {
  const IconButtonToggleWidget({
    super.key,
    required this.icon,
    required this.isActive,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.transparent,
        borderRadius: AppBorderRadius.borderRadius8,
      ),
      child: IconButton(
        onPressed: onTap,
        tooltip: tooltip,
        icon: Icon(
          icon,
          color: isActive ? AppColors.primary : AppColors.textMuted,
          size: AppSize.size20,
        ),
      ),
    );
  }
}
