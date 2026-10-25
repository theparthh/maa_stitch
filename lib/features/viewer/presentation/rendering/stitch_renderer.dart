import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';

/// Visual options that change what the stitches look like.
@immutable
class StitchRenderStyle {
  const StitchRenderStyle({
    required this.entries,
    this.showJumps = false,
    this.selectedColorKey,
  });

  /// Colour + style per entry (same order as [EmbroideryDesign.threads]).
  final List<ThreadBlock> entries;
  final bool showJumps;

  /// When set, other entries are dimmed.
  final int? selectedColorKey;

  @override
  bool operator ==(Object other) =>
      other is StitchRenderStyle &&
      other.showJumps == showJumps &&
      other.selectedColorKey == selectedColorKey &&
      listEquals(other.entries, entries);

  @override
  int get hashCode =>
      Object.hash(showJumps, selectedColorKey, Object.hashAll(entries));
}

/// Draws decoded stitches in millimetre space with a realistic look:
/// raised glossy thread, beaded bead/cord lines and shaded sequin discs.
///
/// Full chunks of [chunkSize] stitches are recorded once into [ui.Picture]s
/// and replayed, so panning, zooming and playback stay smooth for 50k+
/// stitch designs.
class StitchRenderer {
  StitchRenderer(this.design);

  final EmbroideryDesign design;

  static const int chunkSize = 2000;

  /// Embroidery thread is ~0.4 mm but spreads when sewn; 0.5 mm makes
  /// loose satin read as solid, as it does on fabric.
  static const double threadWidthMm = 0.5;

  /// Dahao beads are roughly this wide.
  static const double beadWidthMm = 1.3;

  final Map<int, ui.Picture> _chunks = {};
  StitchRenderStyle? _cachedStyle;
  double? _cachedWidthMm;

  int get length => design.stitches.length;

  /// Thread width for a given on-screen scale: real width when zoomed in,
  /// never thinner than ~1 physical pixel so the design does not fade out.
  static double strokeWidthFor(double pixelsPerMm) =>
      max(threadWidthMm, 1.0 / max(pixelsPerMm, 1e-6));

  /// Paints stitches `[0, limit)` onto [canvas], which must already be in
  /// millimetre space. [pixelsPerMm] is the final on-screen scale.
  void paint(
    Canvas canvas, {
    required StitchRenderStyle style,
    required double pixelsPerMm,
    int? limit,
  }) {
    final end = min(limit ?? length, length);
    final widthMm = _bucketWidth(strokeWidthFor(pixelsPerMm));
    if (style != _cachedStyle || widthMm != _cachedWidthMm) {
      dispose();
      _cachedStyle = style;
      _cachedWidthMm = widthMm;
    }

    final fullChunks = end ~/ chunkSize;
    for (var c = 0; c < fullChunks; c++) {
      final picture = _chunks.putIfAbsent(c, () {
        final recorder = ui.PictureRecorder();
        _paintRange(Canvas(recorder), c * chunkSize, (c + 1) * chunkSize,
            style, widthMm);
        return recorder.endRecording();
      });
      canvas.drawPicture(picture);
    }
    if (end > fullChunks * chunkSize) {
      _paintRange(canvas, fullChunks * chunkSize, end, style, widthMm);
    }
  }

  /// Renders the whole design to PNG with [longSidePx] on the longer side.
  Future<Uint8List> renderPng({
    required StitchRenderStyle style,
    int longSidePx = 3840,
    Color background = Colors.white,
  }) async {
    final b = design.bounds;
    final marginMm = max(b.width, b.height) * 0.03;
    final area = b.inflate(marginMm);
    final scale = longSidePx / max(area.width, area.height);
    final w = (area.width * scale).round();
    final h = (area.height * scale).round();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
        Paint()..color = background);
    canvas.scale(scale);
    canvas.translate(-area.left, -area.top);
    _paintRange(canvas, 0, length, style, strokeWidthFor(scale));
    final image = await recorder.endRecording().toImage(w, h);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data!.buffer.asUint8List();
  }

  void dispose() {
    for (final p in _chunks.values) {
      p.dispose();
    }
    _chunks.clear();
  }

  // Coarse buckets so chunks are re-recorded only on meaningful zoom changes.
  static double _bucketWidth(double w) {
    if (w <= threadWidthMm) return threadWidthMm;
    final step = log(w / threadWidthMm) / log(1.6);
    return threadWidthMm * pow(1.6, step.ceil());
  }

  void _paintRange(
      Canvas canvas, int from, int to, StitchRenderStyle style, double w) {
    final pts = design.stitches;
    final entries = style.entries;
    if (to - from < 1 || entries.isEmpty) return;

    // Consecutive stitches of one entry are batched into a single path.
    Path? path;
    var pathEntry = -1;
    final sequins = <StitchPoint>[];
    Path? jumps;

    void flush() {
      if (path != null && pathEntry >= 0) {
        final e = entries[pathEntry];
        final dimmed = _isDimmed(e, style);
        if (e.style == ThreadStyle.bead) {
          _strokeBeads(canvas, path!, e.color, dimmed, w);
        } else {
          _strokeThread(canvas, path!, e.color, dimmed, w);
        }
      }
      for (final s in sequins) {
        final e = entries[s.colorIndex];
        _drawSequin(canvas, s, e, _isDimmed(e, style), w);
      }
      sequins.clear();
      path = null;
    }

    if (from == 0 &&
        pts.isNotEmpty &&
        pts[0].type == StitchType.normal &&
        entries[pts[0].colorIndex].style == ThreadStyle.sequin) {
      sequins.add(pts[0]);
    }

    for (var i = max(from, 1); i < to; i++) {
      final p = pts[i];
      final prev = pts[i - 1];
      if (p.type == StitchType.normal) {
        if (p.colorIndex != pathEntry) {
          flush();
          pathEntry = p.colorIndex;
        }
        final entryStyle = entries[p.colorIndex].style;
        if (entryStyle == ThreadStyle.sequin) {
          sequins.add(p);
        } else if (prev.type == StitchType.normal) {
          if (entryStyle == ThreadStyle.bead) {
            // Gaps at both ends turn each segment into a separate bead.
            final dx = p.x - prev.x, dy = p.y - prev.y;
            (path ??= Path())
              ..moveTo(prev.x + dx * 0.18, prev.y + dy * 0.18)
              ..lineTo(p.x - dx * 0.18, p.y - dy * 0.18);
          } else {
            (path ??= Path())
              ..moveTo(prev.x, prev.y)
              ..lineTo(p.x, p.y);
          }
        }
      } else if (style.showJumps &&
          p.type == StitchType.jump &&
          (p.x != prev.x || p.y != prev.y)) {
        (jumps ??= Path())
          ..moveTo(prev.x, prev.y)
          ..lineTo(p.x, p.y);
      }
    }
    flush();

    if (jumps != null) {
      canvas.drawPath(
        jumps,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.6
          ..color = const Color(0x8C9E9E9E),
      );
    }
  }

  bool _isDimmed(ThreadBlock e, StitchRenderStyle style) =>
      style.selectedColorKey != null && style.selectedColorKey != e.colorKey;

  static Paint _stroke(Color c, double width) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = c
    ..strokeWidth = width;

  /// Three passes give the raised, glossy look of real thread when zoomed in
  /// while staying a solid colour when zoomed out.
  void _strokeThread(
      Canvas canvas, Path path, Color color, bool dimmed, double w) {
    if (dimmed) {
      canvas.drawPath(path, _stroke(color.withValues(alpha: 0.12), w));
      return;
    }
    canvas.drawPath(path, _stroke(Color.lerp(color, Colors.black, 0.35)!, w));
    canvas.drawPath(path, _stroke(color, w * 0.72));
    canvas.save();
    canvas.translate(-w * 0.12, -w * 0.12);
    canvas.drawPath(
        path,
        _stroke(Color.lerp(color, Colors.white, 0.45)!.withValues(alpha: 0.85),
            w * 0.22));
    canvas.restore();
  }

  /// Bead / cord lines: thicker rounded dashes with a highlight.
  void _strokeBeads(
      Canvas canvas, Path path, Color color, bool dimmed, double w) {
    final bw = max(beadWidthMm, w * 2.2);
    if (dimmed) {
      canvas.drawPath(path, _stroke(color.withValues(alpha: 0.12), bw));
      return;
    }
    canvas.drawPath(path, _stroke(Color.lerp(color, Colors.black, 0.3)!, bw));
    canvas.drawPath(path, _stroke(color, bw * 0.7));
    canvas.save();
    canvas.translate(-bw * 0.12, -bw * 0.12);
    canvas.drawPath(
        path,
        _stroke(Color.lerp(color, Colors.white, 0.5)!.withValues(alpha: 0.8),
            bw * 0.25));
    canvas.restore();
  }

  void _drawSequin(
      Canvas canvas, StitchPoint p, ThreadBlock e, bool dimmed, double w) {
    final color = e.color;
    final c = Offset(p.x, p.y);
    final r = e.sequinDiameterMm / 2;
    if (dimmed) {
      canvas.drawCircle(c, r, Paint()..color = color.withValues(alpha: 0.10));
      return;
    }
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.35),
          colors: [
            Color.lerp(color, Colors.white, 0.55)!,
            color,
            Color.lerp(color, Colors.black, 0.25)!,
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(0.12, w * 0.4)
        ..color = Color.lerp(color, Colors.black, 0.45)!,
    );
    canvas.drawCircle(
        c, r * 0.22, Paint()..color = Color.lerp(color, Colors.black, 0.55)!);
  }
}
