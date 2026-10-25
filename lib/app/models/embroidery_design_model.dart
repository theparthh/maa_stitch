import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/models/stitch_point_model.dart';
import 'package:maa_design_stitch_viewer/app/models/thread_block_model.dart';

/// How much of the design the viewer can actually show.
enum DesignRenderMode {
  /// Real decoded needle positions are available (DST, DHP).
  stitches,

  /// Only an embedded preview image is available (EMB: Wilcom encrypts the
  /// stitch data, so only the TrueView thumbnail + metadata can be read).
  previewOnly,
}

class EmbroideryDesign extends Equatable {
  const EmbroideryDesign({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.extension,
    required this.formatName,
    required this.renderMode,
    required this.totalStitches,
    required this.colorChangeCount,
    required this.jumpCount,
    required this.trimCount,
    required this.sequinCount,
    required this.widthMm,
    required this.heightMm,
    required this.bounds,
    required this.threads,
    required this.stitches,
    required this.lastOpened,
    this.description,
    this.notes = const [],
    this.previewImageBytes,
    this.previewImagePath,
  });

  final String id;
  final String fileName;
  final String filePath;
  final String extension; // 'dst', 'emb', 'dhp'
  final String formatName;
  final DesignRenderMode renderMode;
  final int totalStitches;
  final int colorChangeCount;
  final int jumpCount;
  final int trimCount;
  final int sequinCount;
  final double widthMm;
  final double heightMm;

  /// Bounding box of [stitches] in millimetres (empty for preview-only).
  final Rect bounds;

  /// Colour entries (needles / devices / DST colour blocks). Stitches refer
  /// to them by [StitchPoint.colorIndex].
  final List<ThreadBlock> threads;
  final List<StitchPoint> stitches;
  final DateTime lastOpened;
  final String? description;

  /// Human-readable caveats shown in the viewer (e.g. EMB limitations).
  final List<String> notes;
  final Uint8List? previewImageBytes;

  /// Optional same-name image next to the file (e.g. `670.jpg` for `670.EMB`).
  final String? previewImagePath;

  bool get hasStitches => stitches.isNotEmpty;

  /// Colours in block order, convenient for painters.
  List<Color> get threadColors => [for (final t in threads) t.color];

  // `stitches` and `previewImageBytes` are compared by identity: comparing
  // 50k points element-by-element on every bloc emit froze playback.
  @override
  List<Object?> get props => [
        id,
        filePath,
        extension,
        renderMode,
        totalStitches,
        widthMm,
        heightMm,
        threads,
        identityHashCode(stitches),
        identityHashCode(previewImageBytes),
        previewImagePath,
      ];

  EmbroideryDesign copyWith({
    List<ThreadBlock>? threads,
    DateTime? lastOpened,
  }) {
    return EmbroideryDesign(
      id: id,
      fileName: fileName,
      filePath: filePath,
      extension: extension,
      formatName: formatName,
      renderMode: renderMode,
      totalStitches: totalStitches,
      colorChangeCount: colorChangeCount,
      jumpCount: jumpCount,
      trimCount: trimCount,
      sequinCount: sequinCount,
      widthMm: widthMm,
      heightMm: heightMm,
      bounds: bounds,
      threads: threads ?? this.threads,
      stitches: stitches,
      lastOpened: lastOpened ?? this.lastOpened,
      description: description,
      notes: notes,
      previewImageBytes: previewImageBytes,
      previewImagePath: previewImagePath,
    );
  }
}
