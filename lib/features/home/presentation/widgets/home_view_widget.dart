import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/router/app_route_handler.dart';
import 'package:maa_design_stitch_viewer/app/router/app_router.dart';
import 'package:maa_design_stitch_viewer/features/home/presentation/bloc/bloc.dart';
import 'package:maa_design_stitch_viewer/features/home/presentation/widgets/home_header_widget.dart';

class HomeViewWidget extends StatelessWidget {
  const HomeViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoaded && state.openedFilePath != null) {
          AppRouteHandler.route
              .push(ViewerRoute(filePath: state.openedFilePath!));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: switch (state) {
              HomeInitial() || HomeLoading() => Center(
                  child: LoadingAnimationWidget.fallingDot(
                    color: AppColors.secondary,
                    size: 48,
                  ),
                ),
              HomeError(:final message) => Center(
                  child: Text(
                    message,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              HomeLoaded() => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.size20,
                    vertical: AppSize.size20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const HomeHeaderWidget(),
                      AppGaps.gap20,
                      // Main Hero Action Card (File Opener)
                      Container(
                        padding: const EdgeInsets.all(AppSize.size24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: AppBorderRadius.borderRadius24,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: AppSize.size20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(AppSize.size12),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.white.withValues(alpha: 0.12),
                                    borderRadius:
                                        AppBorderRadius.borderRadius16,
                                  ),
                                  child: const Icon(
                                    Icons.folder_open_rounded,
                                    color: AppColors.white,
                                    size: AppSize.size32,
                                  ),
                                ),
                                Row(
                                  children: [
                                    _buildFormatBadgeDark('.DST'),
                                    AppGaps.gap6,
                                    _buildFormatBadgeDark('.EMB'),
                                    AppGaps.gap6,
                                    _buildFormatBadgeDark('.DHP'),
                                  ],
                                ),
                              ],
                            ),
                            AppGaps.gap20,
                            Text(
                              'Inspect Any Embroidery File',
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppGaps.gap8,
                            Text(
                              'Render stitch coordinates, visualize thread color changes, and simulate real-time needle playback directly on your device.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.white.withValues(alpha: 0.8),
                                height: 1.4,
                              ),
                            ),
                            AppGaps.gap24,
                            SizedBox(
                              width: double.infinity,
                              height: AppSize.size52,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  context
                                      .read<HomeBloc>()
                                      .add(const PickFileHomeEvent());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  foregroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        AppBorderRadius.borderRadius14,
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(
                                  Icons.file_upload_outlined,
                                  color: AppColors.primary,
                                  size: AppSize.size22,
                                ),
                                label: Text(
                                  'OPEN EMBROIDERY FILE',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppGaps.gap16,
                      // ── Reference Files Card ──
                      const _ReferenceFilesCard(),
                    ],
                  ),
                ),
            },
          ),
        );
      },
    );
  }

  Widget _buildFormatBadgeDark(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.size8,
        vertical: AppSize.size4,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: AppBorderRadius.borderRadius8,
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ReferenceFilesCard extends StatelessWidget {
  const _ReferenceFilesCard();

  /// Base directory — the project/app root where reference folders live.
  /// Stored in one place; no folder names are referenced here.
  static const String _baseDir =
      '/Users/theparth/Desktop/maa_design_stitch_viewer';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppBorderRadius.borderRadius20,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: AppSize.size16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: AppBorderRadius.borderRadius20,
        child: InkWell(
          onTap: () {
            AppRouteHandler.route.push(
              FolderBrowserRoute(
                baseDirectoryPath: _baseDir,
                title: 'Reference Files',
              ),
            );
          },
          borderRadius: AppBorderRadius.borderRadius20,
          child: Padding(
            padding: const EdgeInsets.all(AppSize.size20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSize.size14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppBorderRadius.borderRadius16,
                  ),
                  child: const Icon(
                    Icons.folder_special_rounded,
                    color: AppColors.white,
                    size: AppSize.size28,
                  ),
                ),
                AppGaps.gap16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reference Files',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppGaps.gap4,
                      Text(
                        'Browse design files, images & output references',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                AppGaps.gap8,
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: AppSize.size24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
