import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';

/// Horizontal list of the design's colours. Tap isolates a colour,
/// long-press (or the edit badge) opens the colour editor.
class ThreadPaletteBarWidget extends StatelessWidget {
  const ThreadPaletteBarWidget({
    super.key,
    required this.threads,
    required this.selectedColorKey,
    required this.onSelect,
    this.onEdit,
  });

  final List<ThreadBlock> threads;
  final int? selectedColorKey;
  final ValueChanged<int> onSelect;
  final ValueChanged<ThreadBlock>? onEdit;

  /// One chip per colour key, with stitch counts summed.
  static List<ThreadBlock> uniqueEntries(List<ThreadBlock> threads) {
    final byKey = <int, ThreadBlock>{};
    for (final t in threads) {
      final existing = byKey[t.colorKey];
      byKey[t.colorKey] = existing == null
          ? t
          : existing.copyWith(stitchCount: existing.stitchCount + t.stitchCount);
    }
    return byKey.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final entries = uniqueEntries(threads);
    return SizedBox(
      height: AppSize.size56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSize.size12),
        itemCount: entries.length,
        separatorBuilder: (_, __) => AppGaps.gap8,
        itemBuilder: (context, i) {
          final t = entries[i];
          final selected = selectedColorKey == t.colorKey;
          final dimmed = selectedColorKey != null && !selected;
          return GestureDetector(
            onTap: () => onSelect(t.colorKey),
            onLongPress: onEdit == null ? null : () => onEdit!(t),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: dimmed ? 0.45 : 1,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                    AppSize.size6, AppSize.size6, AppSize.size10, AppSize.size6),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryLight : AppColors.surface,
                  borderRadius: AppBorderRadius.borderRadiusFull,
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ThreadSwatch(entry: t, size: AppSize.size28),
                    AppGaps.gap6,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.label,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${t.stitchCount}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                            fontSize: AppFontSize.fontSize10,
                          ),
                        ),
                      ],
                    ),
                    if (onEdit != null) ...[
                      AppGaps.gap4,
                      InkWell(
                        onTap: () => onEdit!(t),
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(AppSize.size2),
                          child: Icon(Icons.edit_rounded,
                              size: AppSize.size14, color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Colour dot that also hints at the draw style (thread / bead / sequin).
class ThreadSwatch extends StatelessWidget {
  const ThreadSwatch({super.key, required this.entry, required this.size});

  final ThreadBlock entry;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = entry.color;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.4, -0.4),
          colors: [Color.lerp(c, Colors.white, 0.4)!, c],
        ),
        border: Border.all(color: Color.lerp(c, Colors.black, 0.35)!),
      ),
      child: switch (entry.style) {
        ThreadStyle.thread => null,
        ThreadStyle.bead =>
          Icon(Icons.more_horiz_rounded, size: size * 0.7, color: Colors.white),
        ThreadStyle.sequin => Center(
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(c, Colors.black, 0.5),
              ),
            ),
          ),
      },
    );
  }
}
