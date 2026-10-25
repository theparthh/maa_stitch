import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// How stitches of an entry are drawn.
enum ThreadStyle {
  /// Normal needle thread.
  thread,

  /// Bead / cord device: drawn as a dashed, beaded line.
  bead,

  /// Sequin device: a disc is dropped at every needle position.
  sequin,
}

/// One colour entry of a design: a needle thread (DHP, DST colour block)
/// or a Dahao device such as a sequin head.
class ThreadBlock extends Equatable {
  const ThreadBlock({
    required this.color,
    required this.colorKey,
    required this.label,
    this.style = ThreadStyle.thread,
    this.sequinDiameterMm = 3.0,
    this.stitchCount = 0,
    this.threadName,
    this.isColorFromFile = false,
  });

  final Color color;

  /// Stable id used to save the user's colour choice:
  /// needle number or device code for DHP, block index for DST.
  final int colorKey;

  /// e.g. "Needle 3", "Sequin device 6", "Dark Green".
  final String label;
  final ThreadStyle style;

  /// Disc size when [style] is [ThreadStyle.sequin].
  final double sequinDiameterMm;
  final int stitchCount;
  final String? threadName;

  /// True when the colour came from the file itself (EMB thread list),
  /// false when it is a default the user can change.
  final bool isColorFromFile;

  ThreadBlock copyWith({
    Color? color,
    ThreadStyle? style,
    double? sequinDiameterMm,
    int? stitchCount,
  }) =>
      ThreadBlock(
        color: color ?? this.color,
        colorKey: colorKey,
        label: label,
        style: style ?? this.style,
        sequinDiameterMm: sequinDiameterMm ?? this.sequinDiameterMm,
        stitchCount: stitchCount ?? this.stitchCount,
        threadName: threadName,
        isColorFromFile: isColorFromFile,
      );

  @override
  List<Object?> get props => [
        color,
        colorKey,
        label,
        style,
        sequinDiameterMm,
        stitchCount,
        threadName,
        isColorFromFile,
      ];
}
