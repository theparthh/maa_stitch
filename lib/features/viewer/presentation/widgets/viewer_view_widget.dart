import 'dart:io';

import 'package:file_picker/file_picker.dart' as fp;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/app/router/app_route_handler.dart';
import 'package:maa_design_stitch_viewer/app/router/app_router.dart';
import 'package:maa_design_stitch_viewer/features/viewer/presentation/bloc/bloc.dart';
import 'package:maa_design_stitch_viewer/features/viewer/presentation/rendering/stitch_renderer.dart';
import 'package:maa_design_stitch_viewer/features/viewer/presentation/widgets/widgets.dart';

class ViewerViewWidget extends StatefulWidget {
  const ViewerViewWidget({super.key});

  @override
  State<ViewerViewWidget> createState() => _ViewerViewWidgetState();
}

class _ViewerViewWidgetState extends State<ViewerViewWidget>
    with SingleTickerProviderStateMixin {
  /// Needle positions per second at 1× playback speed.
  static const double _baseStitchesPerSecond = 300;

  final TransformationController _transformationController =
      TransformationController();
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;
  double _playhead = 0;
  bool _exporting = false;
  Size _viewportSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (AppRouteHandler.route.canPop()) {
      AppRouteHandler.route.pop();
    } else {
      AppRouteHandler.route.replace(const HomeRoute());
    }
  }

  // ── Playback ──────────────────────────────────────────────────────────

  void _syncTicker(ViewerLoaded state) {
    if (state.isPlaying && !_ticker.isActive) {
      _playhead = state.currentStitchStep.toDouble();
      _lastTick = Duration.zero;
      _ticker.start();
    } else if (!state.isPlaying && _ticker.isActive) {
      _ticker.stop();
    }
  }

  void _onTick(Duration elapsed) {
    final bloc = context.read<ViewerBloc>();
    final state = bloc.state;
    if (state is! ViewerLoaded) return;
    final dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    _playhead += dt * _baseStitchesPerSecond * state.playbackSpeed;
    bloc.add(UpdatePlaybackStepEvent(_playhead.floor()));
  }

  // ── Zoom ──────────────────────────────────────────────────────────────

  void _zoom(double factor) => StitchCanvasWidget.zoomAround(
      _transformationController, factor, _viewportSize.center(Offset.zero));

  void _resetZoom() => _transformationController.value = Matrix4.identity();

  // ── Colours & export ─────────────────────────────────────────────────

  StitchRenderStyle _styleFor(ViewerLoaded s) => StitchRenderStyle(
        entries: s.design.threads,
        showJumps: s.showJumpStitches,
        selectedColorKey: s.selectedColorKey,
      );

  void _editThread(ThreadBlock entry) {
    final bloc = context.read<ViewerBloc>();
    ThreadColorSheetWidget.show(
      context,
      entry: entry,
      allowStyleChange: (bloc.state as ViewerLoaded).design.extension == 'dhp',
      onChanged: (color, style) => bloc.add(
          UpdateThreadEvent(colorKey: entry.colorKey, color: color, style: style)),
      onResetAll: () => bloc.add(const ResetThreadColorsEvent()),
    );
  }

  Future<void> _exportPng(ViewerLoaded state) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _exporting = true);
    try {
      final design = state.design;
      // Exports always show every colour, without jump lines.
      final png = await StitchRenderer(design).renderPng(
        style: StitchRenderStyle(entries: design.threads),
        longSidePx: 3840,
      );
      final stem = design.fileName.contains('.')
          ? design.fileName.substring(0, design.fileName.lastIndexOf('.'))
          : design.fileName;
      final path = await fp.FilePicker.platform.saveFile(
        dialogTitle: 'Save 4K image',
        fileName: '${stem}_4K.png',
        type: fp.FileType.image,
        bytes: png,
      );
      if (path == null) return;
      // Desktop pickers only return a path; mobile ones write the bytes.
      final file = File(path);
      if (!await file.exists() || await file.length() == 0) {
        await file.writeAsBytes(png);
      }
      messenger.showSnackBar(
          SnackBar(content: Text('Saved 4K image: ${file.uri.pathSegments.last}')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  void _showDetails(EmbroideryDesign design) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => StitchStatsBottomSheetWidget(design: design),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewerBloc, ViewerState>(
      listenWhen: (a, b) =>
          b is ViewerLoaded && (a is! ViewerLoaded || a.isPlaying != b.isPlaying),
      listener: (context, state) => _syncTicker(state as ViewerLoaded),
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: switch (state) {
            ViewerInitial() || ViewerLoading() => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingAnimationWidget.fallingDot(
                        color: AppColors.secondary, size: 48),
                    AppGaps.gap12,
                    Text('Decoding stitches…',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
            ViewerError(:final message) => _ErrorView(
                message: message,
                onBack: _goBack,
              ),
            final ViewerLoaded s => _buildLoaded(s),
          },
        );
      },
    );
  }

  Widget _buildLoaded(ViewerLoaded s) {
    final design = s.design;
    final bloc = context.read<ViewerBloc>();
    final isStitchView = design.renderMode == DesignRenderMode.stitches;

    return Column(
      children: [
        ViewerToolbarWidget(
          design: design,
          onBackTap: _goBack,
          actions: [
            IconButton(
              tooltip: 'Design details',
              onPressed: () => _showDetails(design),
              icon: const Icon(Icons.info_outline_rounded,
                  color: AppColors.primary),
            ),
            if (isStitchView)
              _exporting
                  ? const Padding(
                      padding: EdgeInsets.all(AppSize.size12),
                      child: SizedBox.square(
                        dimension: AppSize.size20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      tooltip: 'Save 4K image',
                      onPressed: () => _exportPng(s),
                      icon: const Icon(Icons.download_rounded,
                          color: AppColors.primary),
                    ),
          ],
        ),
        if (!isStitchView && design.notes.isNotEmpty)
          _NoticeBanner(text: design.notes.first),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            _viewportSize = constraints.biggest;
            return Stack(
              children: [
                Positioned.fill(
                  child: isStitchView
                      ? StitchCanvasWidget(
                          design: design,
                          style: _styleFor(s),
                          showGrid: s.showGrid,
                          currentStitchStep: s.currentStitchStep,
                          transformationController: _transformationController,
                        )
                      : EmbPreviewWidget(
                          design: design,
                          transformationController: _transformationController,
                        ),
                ),
                Positioned(
                  right: AppSize.size16,
                  bottom: AppSize.size16,
                  child: _ZoomButtons(
                    onZoomIn: () => _zoom(1.5),
                    onZoomOut: () => _zoom(1 / 1.5),
                    onReset: _resetZoom,
                  ),
                ),
              ],
            );
          }),
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppGaps.gap8,
                ThreadPaletteBarWidget(
                  threads: design.threads,
                  selectedColorKey: s.selectedColorKey,
                  onSelect: (key) => bloc.add(SelectThreadColorEvent(key)),
                  onEdit: isStitchView ? _editThread : null,
                ),
                if (isStitchView) ...[
                  Row(
                    children: [
                      AppGaps.gap8,
                      IconButtonToggleWidget(
                        icon: Icons.alt_route_rounded,
                        isActive: s.showJumpStitches,
                        tooltip: 'Show jumps',
                        onTap: () => bloc.add(const ToggleJumpStitchesEvent()),
                      ),
                      IconButtonToggleWidget(
                        icon: Icons.grid_on_rounded,
                        isActive: s.showGrid,
                        tooltip: '10 mm grid',
                        onTap: () => bloc.add(const ToggleGridEvent()),
                      ),
                      Expanded(
                        child: StitchPlaybackControlsWidget(
                          totalStitches: design.stitches.length,
                          currentStep: s.currentStitchStep,
                          isPlaying: s.isPlaying,
                          speed: s.playbackSpeed,
                          onPlayToggle: () =>
                              bloc.add(const TogglePlaybackEvent()),
                          onStepChanged: (step) {
                            _playhead = step.toDouble();
                            bloc.add(UpdatePlaybackStepEvent(step));
                          },
                          onSpeedChanged: (v) =>
                              bloc.add(SetPlaybackSpeedEvent(v)),
                        ),
                      ),
                    ],
                  ),
                ] else
                  AppGaps.gap8,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ZoomButtons extends StatelessWidget {
  const _ZoomButtons({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onPressed: onZoomIn,
            icon: const Icon(Icons.add_rounded, color: AppColors.textPrimary),
            tooltip: 'Zoom in',
          ),
          const Divider(height: 1, color: AppColors.border),
          IconButton(
            onPressed: onZoomOut,
            icon:
                const Icon(Icons.remove_rounded, color: AppColors.textPrimary),
            tooltip: 'Zoom out',
          ),
          const Divider(height: 1, color: AppColors.border),
          IconButton(
            onPressed: onReset,
            icon: const Icon(Icons.fit_screen_rounded,
                color: AppColors.secondary),
            tooltip: 'Fit to screen',
          ),
        ],
      ),
    );
  }
}

class _NoticeBanner extends StatelessWidget {
  const _NoticeBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.size16, vertical: AppSize.size10),
      color: AppColors.primaryLight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              size: AppSize.size18, color: AppColors.primary),
          AppGaps.gap8,
          Expanded(
            child: Text(
              text,
              style:
                  AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onBack});

  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSize.size32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: AppSize.size48, color: AppColors.error),
              AppGaps.gap16,
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
              ),
              AppGaps.gap20,
              FilledButton(onPressed: onBack, child: const Text('Back')),
            ],
          ),
        ),
      ),
    );
  }
}
