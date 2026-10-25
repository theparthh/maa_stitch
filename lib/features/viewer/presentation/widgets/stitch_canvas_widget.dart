import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/features/viewer/presentation/rendering/stitch_renderer.dart';

/// Pan/zoom vector view of decoded stitches.
///
/// The design is fitted to the viewport and drawn in millimetre space, so it
/// stays sharp at any zoom (up to [maxZoom]× the fitted size).
class StitchCanvasWidget extends StatefulWidget {
  const StitchCanvasWidget({
    super.key,
    required this.design,
    required this.style,
    required this.showGrid,
    required this.currentStitchStep,
    required this.transformationController,
  });

  final EmbroideryDesign design;
  final StitchRenderStyle style;
  final bool showGrid;
  final int currentStitchStep;
  final TransformationController transformationController;

  static const double maxZoom = 80;
  static const double fitPadding = 24;

  /// Zooms by [factor] keeping [focalPoint] (viewport coords) fixed.
  static void zoomAround(
    TransformationController controller,
    double factor,
    Offset focalPoint,
  ) {
    final current = controller.value.getMaxScaleOnAxis();
    final target = (current * factor).clamp(1.0, maxZoom);
    final f = target / current;
    controller.value = Matrix4.identity()
      ..translateByDouble(focalPoint.dx, focalPoint.dy, 0, 1)
      ..scaleByDouble(f, f, 1, 1)
      ..translateByDouble(-focalPoint.dx, -focalPoint.dy, 0, 1)
      ..multiply(controller.value);
  }

  @override
  State<StitchCanvasWidget> createState() => _StitchCanvasWidgetState();
}

class _StitchCanvasWidgetState extends State<StitchCanvasWidget> {
  late StitchRenderer _renderer = StitchRenderer(widget.design);
  Offset _doubleTapPosition = Offset.zero;

  @override
  void didUpdateWidget(covariant StitchCanvasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Colour edits produce a new design object with the same stitches.
    if (!identical(oldWidget.design.stitches, widget.design.stitches)) {
      _renderer.dispose();
      _renderer = StitchRenderer(widget.design);
    }
  }

  @override
  void dispose() {
    _renderer.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    final c = widget.transformationController;
    if (c.value.getMaxScaleOnAxis() > 1.05) {
      c.value = Matrix4.identity();
    } else {
      StitchCanvasWidget.zoomAround(c, 4, _doubleTapPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          return GestureDetector(
            onDoubleTapDown: (d) => _doubleTapPosition = d.localPosition,
            onDoubleTap: _onDoubleTap,
            child: InteractiveViewer(
              transformationController: widget.transformationController,
              minScale: 1,
              maxScale: StitchCanvasWidget.maxZoom,
              boundaryMargin: EdgeInsets.all(size.shortestSide * 0.5),
              child: SizedBox.fromSize(
                size: size,
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _StitchPainter(
                      renderer: _renderer,
                      style: widget.style,
                      showGrid: widget.showGrid,
                      limit: widget.currentStitchStep,
                      transform: widget.transformationController,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StitchPainter extends CustomPainter {
  _StitchPainter({
    required this.renderer,
    required this.style,
    required this.showGrid,
    required this.limit,
    required this.transform,
  }) : super(repaint: transform);

  final StitchRenderer renderer;
  final StitchRenderStyle style;
  final bool showGrid;
  final int limit;
  final TransformationController transform;

  @override
  void paint(Canvas canvas, Size size) {
    final b = renderer.design.bounds;
    if (b.width <= 0 && b.height <= 0) return;
    const pad = StitchCanvasWidget.fitPadding;
    final fit = min(
      (size.width - pad * 2) / max(b.width, 1),
      (size.height - pad * 2) / max(b.height, 1),
    );
    final zoom = transform.value.getMaxScaleOnAxis();
    final dpr = WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    canvas.save();
    canvas.translate(
      (size.width - b.width * fit) / 2 - b.left * fit,
      (size.height - b.height * fit) / 2 - b.top * fit,
    );
    canvas.scale(fit);

    if (showGrid) _drawGrid(canvas, b, fit * zoom);

    renderer.paint(
      canvas,
      style: style,
      pixelsPerMm: fit * zoom * dpr,
      limit: limit,
    );

    final stitches = renderer.design.stitches;
    if (limit > 0 && limit < stitches.length) {
      _drawNeedle(canvas, stitches[limit - 1], fit * zoom);
    }
    canvas.restore();
  }

  /// 10 mm grid with a stronger line every 50 mm.
  void _drawGrid(Canvas canvas, Rect b, double pxPerMm) {
    final area = b.inflate(20);
    final minor = Paint()
      ..color = AppColors.border.withValues(alpha: 0.6)
      ..strokeWidth = 1 / pxPerMm;
    final major = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.25)
      ..strokeWidth = 1.5 / pxPerMm;
    for (var x = (area.left / 10).floorToDouble() * 10; x <= area.right; x += 10) {
      canvas.drawLine(Offset(x, area.top), Offset(x, area.bottom),
          x.round() % 50 == 0 ? major : minor);
    }
    for (var y = (area.top / 10).floorToDouble() * 10; y <= area.bottom; y += 10) {
      canvas.drawLine(Offset(area.left, y), Offset(area.right, y),
          y.round() % 50 == 0 ? major : minor);
    }
  }

  /// Crosshair at the current needle position during playback.
  void _drawNeedle(Canvas canvas, StitchPoint p, double pxPerMm) {
    final r = 9 / pxPerMm;
    final paint = Paint()
      ..color = AppColors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 / pxPerMm;
    final c = Offset(p.x, p.y);
    canvas.drawCircle(c, r, paint);
    canvas.drawLine(c - Offset(r * 1.6, 0), c + Offset(r * 1.6, 0), paint);
    canvas.drawLine(c - Offset(0, r * 1.6), c + Offset(0, r * 1.6), paint);
  }

  @override
  bool shouldRepaint(covariant _StitchPainter old) =>
      old.renderer != renderer ||
      old.style != style ||
      old.showGrid != showGrid ||
      old.limit != limit;
}
