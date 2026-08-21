import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/router/app_route_handler.dart';
import 'package:maa_design_stitch_viewer/app/router/app_router.dart';
import 'package:maa_design_stitch_viewer/features/home/presentation/bloc/bloc.dart';

class HomeViewWidget extends StatelessWidget {
  const HomeViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoaded && state.openedFilePath != null) {
          AppRouteHandler.route.push(ViewerRoute(filePath: state.openedFilePath!));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: switch (state) {
              HomeInitial() || HomeLoading() => const Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                ),
              HomeError(:final message) => Center(
                  child: Text(message, style: const TextStyle(color: AppColors.red)),
                ),
              HomeLoaded() => Padding(
                  padding: const EdgeInsets.all(AppSize.size24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(AppSize.size20),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.grid_on_rounded,
                          size: 64,
                          color: AppColors.secondary,
                        ),
                      ),
                      AppGaps.gap20,
                      Text(
                        'MAA STITCH VIEWER',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      AppGaps.gap8,
                      Text(
                        'Directly open and inspect embroidery stitch files',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppGaps.gap16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildFormatBadge('.DST', AppColors.secondary),
                          AppGaps.gap8,
                          _buildFormatBadge('.EMB', AppColors.blue),
                          AppGaps.gap8,
                          _buildFormatBadge('.DHP', AppColors.red),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSize.size24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppBorderRadius.borderRadius24,
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.05),
                              blurRadius: AppSize.size16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSize.size14),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.1),
                                borderRadius: AppBorderRadius.borderRadius12,
                              ),
                              child: const Icon(
                                Icons.folder_open_rounded,
                                size: 36,
                                color: AppColors.secondary,
                              ),
                            ),
                            AppGaps.gap16,
                            Text(
                              'Open Embroidery File',
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppGaps.gap4,
                            Text(
                              'Select any .dst, .emb, or .dhp file from device file manager',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                            AppGaps.gap20,
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  context.read<HomeBloc>().add(const PickFileHomeEvent());
                                },
                                icon: const Icon(Icons.file_upload_rounded, color: AppColors.white),
                                label: Text(
                                  'BROWSE FILE MANAGER',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  padding: const EdgeInsets.symmetric(vertical: AppSize.size16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppBorderRadius.borderRadius12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
            },
          ),
        );
      },
    );
  }

  Widget _buildFormatBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.size10,
        vertical: AppSize.size4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppBorderRadius.borderRadius8,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
