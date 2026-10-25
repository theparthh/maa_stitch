import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/features/viewer/presentation/widgets/thread_palette_bar_widget.dart';

/// Lets the user set the real thread colour / device style of one entry.
class ThreadColorSheetWidget extends StatefulWidget {
  const ThreadColorSheetWidget({
    super.key,
    required this.entry,
    required this.allowStyleChange,
    required this.onChanged,
    required this.onResetAll,
  });

  final ThreadBlock entry;

  /// Only DHP entries can switch between thread / bead / sequin.
  final bool allowStyleChange;
  final void Function(Color color, ThreadStyle style) onChanged;
  final VoidCallback onResetAll;

  static Future<void> show(
    BuildContext context, {
    required ThreadBlock entry,
    required bool allowStyleChange,
    required void Function(Color color, ThreadStyle style) onChanged,
    required VoidCallback onResetAll,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => ThreadColorSheetWidget(
        entry: entry,
        allowStyleChange: allowStyleChange,
        onChanged: onChanged,
        onResetAll: onResetAll,
      ),
    );
  }

  @override
  State<ThreadColorSheetWidget> createState() => _ThreadColorSheetWidgetState();
}

class _ThreadColorSheetWidgetState extends State<ThreadColorSheetWidget> {
  late Color _color = widget.entry.color;
  late ThreadStyle _style = widget.entry.style;

  void _apply({Color? color, ThreadStyle? style}) {
    setState(() {
      _color = color ?? _color;
      _style = style ?? _style;
    });
    widget.onChanged(_color, _style);
  }

  @override
  Widget build(BuildContext context) {
    final preview = widget.entry.copyWith(color: _color, style: _style);
    return Container(
      padding: EdgeInsets.fromLTRB(AppSize.size20, AppSize.size12,
          AppSize.size20, AppSize.size20 + MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: AppBorderRadius.radius24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: AppSize.size40,
              height: AppSize.size4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: AppBorderRadius.borderRadius4,
              ),
            ),
          ),
          AppGaps.gap16,
          Row(
            children: [
              ThreadSwatch(entry: preview, size: AppSize.size40),
              AppGaps.gap12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.entry.label,
                      style: AppTextStyles.h3.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.entry.stitchCount} needle positions',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.allowStyleChange) ...[
            AppGaps.gap16,
            SegmentedButton<ThreadStyle>(
              segments: const [
                ButtonSegment(
                    value: ThreadStyle.thread,
                    label: Text('Thread'),
                    icon: Icon(Icons.gesture_rounded)),
                ButtonSegment(
                    value: ThreadStyle.bead,
                    label: Text('Bead'),
                    icon: Icon(Icons.more_horiz_rounded)),
                ButtonSegment(
                    value: ThreadStyle.sequin,
                    label: Text('Sequin'),
                    icon: Icon(Icons.circle_outlined)),
              ],
              selected: {_style},
              showSelectedIcon: false,
              onSelectionChanged: (s) => _apply(style: s.first),
            ),
          ],
          AppGaps.gap16,
          GridView.count(
            crossAxisCount: 8,
            shrinkWrap: true,
            mainAxisSpacing: AppSize.size8,
            crossAxisSpacing: AppSize.size8,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final c in AppColors.threadSwatches)
                GestureDetector(
                  onTap: () => _apply(color: c),
                  child: Container(
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: c.toARGB32() == _color.toARGB32()
                            ? AppColors.primary
                            : AppColors.border,
                        width: c.toARGB32() == _color.toARGB32() ? 3 : 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          AppGaps.gap16,
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  widget.onResetAll();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.restart_alt_rounded),
                label: const Text('Reset all colours'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
