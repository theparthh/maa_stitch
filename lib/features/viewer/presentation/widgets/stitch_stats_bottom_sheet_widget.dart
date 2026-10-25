import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/features/viewer/presentation/widgets/stat_item_widget.dart';
import 'package:maa_design_stitch_viewer/features/viewer/presentation/widgets/thread_palette_bar_widget.dart';

/// Design facts, all read from the file (nothing estimated or invented).
class StitchStatsBottomSheetWidget extends StatelessWidget {
  const StitchStatsBottomSheetWidget({super.key, required this.design});

  final EmbroideryDesign design;

  @override
  Widget build(BuildContext context) {
    final isEmb = design.renderMode == DesignRenderMode.previewOnly;
    final entries = ThreadPaletteBarWidget.uniqueEntries(design.threads);
    final stats = <(String, String, IconData)>[
      ('Format', design.formatName, Icons.description_outlined),
      ('Stitches', _n(design.totalStitches), Icons.architecture_rounded),
      (
        'Size (W × H)',
        '${design.widthMm.toStringAsFixed(1)} × ${design.heightMm.toStringAsFixed(1)} mm',
        Icons.aspect_ratio_rounded
      ),
      ('Colour changes', _n(design.colorChangeCount), Icons.palette_outlined),
      if (!isEmb) ('Jumps', _n(design.jumpCount), Icons.alt_route_rounded),
      ('Trims', _n(design.trimCount), Icons.content_cut_rounded),
      if (design.sequinCount > 0)
        ('Sequins', _n(design.sequinCount), Icons.circle_outlined),
      (
        isEmb ? 'Threads' : 'Needles / devices',
        '${entries.length}',
        Icons.linear_scale_rounded
      ),
    ];

    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
      padding: EdgeInsets.fromLTRB(AppSize.size24, AppSize.size12,
          AppSize.size24, AppSize.size24 + MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: AppBorderRadius.radius24),
      ),
      child: SingleChildScrollView(
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
            Text(
              'Design details',
              style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            AppGaps.gap4,
            Text(
              [design.fileName, if (design.description != null) design.description!]
                  .join(' · '),
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            AppGaps.gap20,
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: AppSize.size12,
              mainAxisSpacing: AppSize.size12,
              childAspectRatio: 2.2,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final (title, value, icon) in stats)
                  StatItemWidget(title: title, value: value, icon: icon),
              ],
            ),
            AppGaps.gap20,
            Text(
              isEmb ? 'Thread sequence (from file)' : 'Colours',
              style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            AppGaps.gap8,
            for (final t in isEmb ? design.threads : entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSize.size4),
                child: Row(
                  children: [
                    ThreadSwatch(entry: t, size: AppSize.size20),
                    AppGaps.gap10,
                    Expanded(
                      child: Text(
                        [t.label, if (t.threadName?.isNotEmpty == true) t.threadName!]
                            .join(' · '),
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                    Text(
                      _n(t.stitchCount),
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            for (final note in design.notes) ...[
              AppGaps.gap12,
              Text(
                note,
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _n(int v) => v.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}
