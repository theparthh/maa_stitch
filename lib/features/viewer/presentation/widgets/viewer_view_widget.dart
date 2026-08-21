import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/router/app_route_handler.dart';
import 'package:maa_design_stitch_viewer/features/viewer/presentation/bloc/bloc.dart';
import 'package:maa_design_stitch_viewer/features/viewer/presentation/widgets/widgets.dart';

class ViewerViewWidget extends StatefulWidget {
  const ViewerViewWidget({super.key});

  @override
  State<ViewerViewWidget> createState() => _ViewerViewWidgetState();
}

class _ViewerViewWidgetState extends State<ViewerViewWidget> {
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    final matrix = _transformationController.value.clone();
    matrix.multiply(Matrix4.diagonal3Values(1.3, 1.3, 1.0));
    _transformationController.value = matrix;
  }

  void _zoomOut() {
    final matrix = _transformationController.value.clone();
    matrix.multiply(Matrix4.diagonal3Values(0.77, 0.77, 1.0));
    _transformationController.value = matrix;
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewerBloc, ViewerState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: switch (state) {
            ViewerInitial() || ViewerLoading() => const Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
              ),
            ViewerError(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message, style: const TextStyle(color: AppColors.red)),
                    AppGaps.gap16,
                    ElevatedButton(
                      onPressed: () => AppRouteHandler.route.pop(),
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ),
            ViewerLoaded(:final design) => Stack(
                children: [
                  Positioned.fill(
                    child: StitchCanvasWidget(
                      design: design,
                      showJumpStitches: true,
                      showGrid: false,
                      showStitchPoints: false,
                      selectedColorIndex: null,
                      currentStitchStep: design.totalStitches,
                      transformationController: _transformationController,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ViewerToolbarWidget(
                      design: design,
                      onBackTap: () => AppRouteHandler.route.pop(),
                    ),
                  ),
                  Positioned(
                    bottom: AppSize.size24,
                    right: AppSize.size20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppBorderRadius.borderRadius16,
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.08),
                            blurRadius: AppSize.size12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: _zoomIn,
                            icon: const Icon(Icons.add_rounded, color: AppColors.textPrimary),
                            tooltip: 'Zoom In',
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          IconButton(
                            onPressed: _zoomOut,
                            icon: const Icon(Icons.remove_rounded, color: AppColors.textPrimary),
                            tooltip: 'Zoom Out',
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          IconButton(
                            onPressed: _resetZoom,
                            icon: const Icon(Icons.center_focus_strong_rounded, color: AppColors.secondary),
                            tooltip: 'Reset Zoom',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          },
        );
      },
    );
  }
}
