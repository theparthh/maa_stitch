import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';

class StitchCanvasWidget extends StatelessWidget {
  const StitchCanvasWidget({
    super.key,
    required this.design,
    required this.showJumpStitches,
    required this.showGrid,
    required this.showStitchPoints,
    required this.selectedColorIndex,
    required this.currentStitchStep,
    required this.transformationController,
  });

  final EmbroideryDesign design;
  final bool showJumpStitches;
  final bool showGrid;
  final bool showStitchPoints;
  final int? selectedColorIndex;
  final int currentStitchStep;
  final TransformationController transformationController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return InteractiveViewer(
              transformationController: transformationController,
              boundaryMargin: const EdgeInsets.all(2000),
              minScale: 0.1,
              maxScale: 40.0,
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: _buildContent(constraints),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BoxConstraints constraints) {
    final availableW = constraints.maxWidth.isFinite && constraints.maxWidth > 0
        ? constraints.maxWidth
        : 400.0;
    final availableH = constraints.maxHeight.isFinite && constraints.maxHeight > 0
        ? constraints.maxHeight
        : 700.0;

    final designW = design.widthMm > 0 ? design.widthMm : 240.0;
    final designH = design.heightMm > 0 ? design.heightMm : 480.0;
    final aspect = designW / designH;

    // Full HD viewport-aware sizing: fits design completely on initial open
    final maxAllowedW = availableW * 0.94;
    final maxAllowedH = availableH * 0.85;

    double displayW;
    double displayH;
    if (maxAllowedW / maxAllowedH < aspect) {
      displayW = maxAllowedW;
      displayH = displayW / aspect;
    } else {
      displayH = maxAllowedH;
      displayW = displayH * aspect;
    }

    displayW = max(displayW, 300.0);
    displayH = max(displayH, 300.0);

    if (design.previewImagePath != null &&
        design.previewImagePath!.isNotEmpty) {
      final isAsset = design.previewImagePath!.startsWith('assets/');
      return Container(
        width: displayW,
        height: displayH,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: isAsset
            ? Image.asset(
                design.previewImagePath!,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              )
            : Image.file(
                File(design.previewImagePath!),
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
      );
    }

    if (design.previewImageBytes != null &&
        design.previewImageBytes!.isNotEmpty) {
      return Container(
        width: displayW,
        height: displayH,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.memory(
          design.previewImageBytes!,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      );
    }

    return Container(
      width: displayW,
      height: displayH,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(displayW, displayH),
        painter: _EmbroideryStitchPainter(
          design: design,
          showJumpStitches: showJumpStitches,
          showGrid: showGrid,
          showStitchPoints: showStitchPoints,
          selectedColorIndex: selectedColorIndex,
          currentStitchStep: currentStitchStep,
        ),
      ),
    );
  }
}

class _EmbroideryStitchPainter extends CustomPainter {
  _EmbroideryStitchPainter({
    required this.design,
    required this.showJumpStitches,
    required this.showGrid,
    required this.showStitchPoints,
    required this.selectedColorIndex,
    required this.currentStitchStep,
  });

  final EmbroideryDesign design;
  final bool showJumpStitches;
  final bool showGrid;
  final bool showStitchPoints;
  final int? selectedColorIndex;
  final int currentStitchStep;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    if (design.stitches.isEmpty) return;

    // 1. Calculate auto-center offset so design is centered on canvas
    double minX = 1e9, maxX = -1e9, minY = 1e9, maxY = -1e9;
    for (final p in design.stitches) {
      minX = min(minX, p.x);
      maxX = max(maxX, p.x);
      minY = min(minY, p.y);
      maxY = max(maxY, p.y);
    }
    final midX = (minX + maxX) / 2.0;
    final midY = (minY + maxY) / 2.0;

    final stitchW = max((maxX - minX).abs(), 1.0);
    final stitchH = max((maxY - minY).abs(), 1.0);
    final scale = min((size.width * 0.90) / stitchW, (size.height * 0.90) / stitchH);

    final centerShift = center - Offset(midX * scale, midY * scale);

    // 2. Draw Grid Overlay
    if (showGrid) {
      _drawGrid(canvas, size, center);
    }

    // 3. Render Stitch Lines
    final limit = min(currentStitchStep, design.stitches.length);

    StitchPoint? prevPoint;

    for (int i = 0; i < limit; i++) {
      final p = design.stitches[i];
      final currentOffset = centerShift + Offset(p.x * scale, p.y * scale);

      if (prevPoint != null) {
        final prevOffset =
            centerShift + Offset(prevPoint.x * scale, prevPoint.y * scale);
        final colorIndex = p.colorIndex % AppColors.defaultThreadPalette.length;
        final color = AppColors.defaultThreadPalette[colorIndex];

        final isColorSelected =
            selectedColorIndex == null || selectedColorIndex == colorIndex;

        final dxMm = (p.x - prevPoint.x).abs();
        final dyMm = (p.y - prevPoint.y).abs();
        final isTransit = p.type == StitchType.jump || dxMm > 12.1 || dyMm > 12.1;

        if (isTransit) {
          if (showJumpStitches && isColorSelected) {
            _drawDashedLine(
              canvas,
              prevOffset,
              currentOffset,
              Paint()
                ..color = AppColors.textMuted.withValues(alpha: 0.3)
                ..strokeWidth = 0.8
                ..style = PaintingStyle.stroke,
            );
          }
        } else if (p.type == StitchType.normal) {
          final threadPaint = Paint()
            ..color = isColorSelected ? color : color.withValues(alpha: 0.12)
            ..strokeWidth = isColorSelected ? 2.2 : 1.0
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..style = PaintingStyle.stroke;

          canvas.drawLine(prevOffset, currentOffset, threadPaint);
        }

        if (showStitchPoints && isColorSelected) {
          final dotPaint = Paint()
            ..color = AppColors.textPrimary.withValues(alpha: 0.8)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(currentOffset, 1.5, dotPaint);
        }
      }

      prevPoint = p;
    }
  }

  void _drawGrid(Canvas canvas, Size size, Offset center) {
    final gridPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.25)
      ..strokeWidth = 0.8;

    final majorGridPaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.2)
      ..strokeWidth = 1.2;

    const step = 20.0; // 20px grid lines

    for (double x = 0; x < size.width; x += step) {
      final isMajor = ((x - center.dx).abs() % (step * 5)) < 1;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        isMajor ? majorGridPaint : gridPaint,
      );
    }

    for (double y = 0; y < size.height; y += step) {
      final isMajor = ((y - center.dy).abs() % (step * 5)) < 1;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        isMajor ? majorGridPaint : gridPaint,
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    final distance = (p2 - p1).distance;
    if (distance == 0) return;

    final dx = (p2.dx - p1.dx) / distance;
    final dy = (p2.dy - p1.dy) / distance;

    double start = 0;
    while (start < distance) {
      final x1 = p1.dx + dx * start;
      final y1 = p1.dy + dy * start;
      final x2 = p1.dx + dx * min(start + dashWidth, distance);
      final y2 = p1.dy + dy * min(start + dashWidth, distance);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      start += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _EmbroideryStitchPainter oldDelegate) {
    return oldDelegate.design != design ||
        oldDelegate.showJumpStitches != showJumpStitches ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.showStitchPoints != showStitchPoints ||
        oldDelegate.selectedColorIndex != selectedColorIndex ||
        oldDelegate.currentStitchStep != currentStitchStep;
  }
}
