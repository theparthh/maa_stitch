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
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              HomeError(:final message) => Center(
                  child: Text(
                    message,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              HomeLoaded() => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.size20,
                    vertical: AppSize.size20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top App Branding Header
                      Row(
                        children: [
                          Container(
                            width: AppSize.size44,
                            height: AppSize.size44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: AppBorderRadius.borderRadius12,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.25),
                                  blurRadius: AppSize.size10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.grid_4x4_rounded,
                              color: AppColors.white,
                              size: AppSize.size24,
                            ),
                          ),
                          AppGaps.gap12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MAA STITCH VIEWER',
                                  style: AppTextStyles.h3.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    letterSpacing: 0.8,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Professional Studio Edition',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Main Hero Action Card
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
                                    color: AppColors.white.withValues(alpha: 0.12),
                                    borderRadius: AppBorderRadius.borderRadius16,
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
                                  context.read<HomeBloc>().add(const PickFileHomeEvent());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  foregroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppBorderRadius.borderRadius14,
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
