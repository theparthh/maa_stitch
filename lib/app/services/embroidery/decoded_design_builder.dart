import 'dart:math';
import 'dart:ui';

import 'package:maa_design_stitch_viewer/app/models/models.dart';

/// Accumulates decoded needle positions into an [EmbroideryDesign].
///
/// Decoders feed points in sewing order, tagging each stitch with an entry
/// key (needle, device or colour block). The builder assigns entry indexes,
/// tracks bounds (stitches only — jumps may travel off-design) and stats.
class DecodedDesignBuilder {
  DecodedDesignBuilder({required this.entryFactory});

  /// Creates the colour entry the first time a key is used.
  final ThreadBlock Function(int key) entryFactory;

  final List<StitchPoint> _points = [];
  final Map<int, int> _entryIndex = {};
  final List<ThreadBlock> _entries = [];
  final List<int> _entryCounts = [];
  int _colorChanges = 0;
  int _jumps = 0;
  int _trims = 0;
  int _jumpRun = 0;
  int _lastEntry = 0;
  double _minX = double.infinity, _minY = double.infinity;
  double _maxX = double.negativeInfinity, _maxY = double.negativeInfinity;

  int _indexFor(int key) => _entryIndex.putIfAbsent(key, () {
        _entries.add(entryFactory(key));
        _entryCounts.add(0);
        return _entries.length - 1;
      });

  /// Records a thread change at the current needle position.
  void colorChange() {
    _colorChanges++;
    if (_points.isEmpty) return;
    final last = _points.last;
    _points.add(StitchPoint(
      x: last.x,
      y: last.y,
      type: StitchType.colorChange,
      colorIndex: last.colorIndex,
    ));
  }

  void stitch(double x, double y, int key) {
    final index = _indexFor(key);
    _lastEntry = index;
    if (_jumpRun >= 2) _trims++; // machines cut on a run of jumps
    _jumpRun = 0;
    _points.add(StitchPoint(
        x: x, y: y, type: StitchType.normal, colorIndex: index));
    _entryCounts[index]++;
    if (x < _minX) _minX = x;
    if (x > _maxX) _maxX = x;
    if (y < _minY) _minY = y;
    if (y > _maxY) _maxY = y;
  }

  void jump(double x, double y) {
    _points.add(StitchPoint(
        x: x, y: y, type: StitchType.jump, colorIndex: _lastEntry));
    _jumps++;
    _jumpRun++;
  }

  bool get hasStitches => _entryCounts.any((c) => c > 0);

  EmbroideryDesign build({
    required String fileName,
    required String filePath,
    required String extension,
    required String formatName,
    String? description,
    List<String> notes = const [],
  }) {
    if (_jumpRun >= 2) _trims++;
    _jumpRun = 0;
    final diameters = _estimateSequinDiameters();
    final threads = [
      for (var i = 0; i < _entries.length; i++)
        _entries[i].copyWith(
          stitchCount: _entryCounts[i],
          sequinDiameterMm: diameters[i],
        ),
    ];
    final bounds = hasStitches
        ? Rect.fromLTRB(_minX, _minY, _maxX, _maxY)
        : Rect.zero;
    var stitchCount = 0, sequinCount = 0;
    for (var i = 0; i < threads.length; i++) {
      stitchCount += _entryCounts[i];
      if (threads[i].style == ThreadStyle.sequin) sequinCount += _entryCounts[i];
    }
    return EmbroideryDesign(
      id: '${filePath.hashCode}',
      fileName: fileName,
      filePath: filePath,
      extension: extension,
      formatName: formatName,
      renderMode: DesignRenderMode.stitches,
      totalStitches: stitchCount,
      colorChangeCount: _colorChanges,
      jumpCount: _jumps,
      trimCount: _trims,
      sequinCount: sequinCount,
      widthMm: bounds.width,
      heightMm: bounds.height,
      bounds: bounds,
      threads: threads,
      stitches: List.unmodifiable(_points),
      lastOpened: DateTime.now(),
      description: description,
      notes: notes,
    );
  }

  /// Sequins in a row sit edge to edge, so the typical gap between
  /// consecutive drops of one device is its sequin size (sold in 0.5 mm
  /// steps). Isolated sequins fall back to 3 mm.
  List<double> _estimateSequinDiameters() {
    final gaps = [for (final _ in _entries) <double>[]];
    StitchPoint? last;
    for (final p in _points) {
      if (p.type != StitchType.normal) {
        last = null;
        continue;
      }
      if (last != null && last.colorIndex == p.colorIndex) {
        final d = sqrt(pow(p.x - last.x, 2) + pow(p.y - last.y, 2));
        if (d > 1 && d < 12) gaps[p.colorIndex].add(d);
      }
      last = p;
    }
    return [
      for (final g in gaps) g.length < 5 ? 3.0 : _roundedMedian(g),
    ];
  }

  static double _roundedMedian(List<double> values) {
    values.sort();
    final median = values[values.length ~/ 2];
    return ((median * 2).round() / 2).clamp(2.5, 5.0);
  }
}
