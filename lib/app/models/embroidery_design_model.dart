import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/models/stitch_point_model.dart';

class EmbroideryDesign extends Equatable {
  const EmbroideryDesign({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.extension,
    required this.totalStitches,
    required this.colorChangeCount,
    required this.widthMm,
    required this.heightMm,
    required this.threadColors,
    required this.stitches,
    required this.lastOpened,
    this.description,
  });

  final String id;
  final String fileName;
  final String filePath;
  final String extension; // 'dst', 'emb', 'dhp'
  final int totalStitches;
  final int colorChangeCount;
  final double widthMm;
  final double heightMm;
  final List<Color> threadColors;
  final List<StitchPoint> stitches;
  final DateTime lastOpened;
  final String? description;

  @override
  List<Object?> get props => [
        id,
        fileName,
        filePath,
        extension,
        totalStitches,
        colorChangeCount,
        widthMm,
        heightMm,
        threadColors,
        stitches,
        lastOpened,
        description,
      ];

  EmbroideryDesign copyWith({
    String? id,
    String? fileName,
    String? filePath,
    String? extension,
    int? totalStitches,
    int? colorChangeCount,
    double? widthMm,
    double? heightMm,
    List<Color>? threadColors,
    List<StitchPoint>? stitches,
    DateTime? lastOpened,
    String? description,
  }) {
    return EmbroideryDesign(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      extension: extension ?? this.extension,
      totalStitches: totalStitches ?? this.totalStitches,
      colorChangeCount: colorChangeCount ?? this.colorChangeCount,
      widthMm: widthMm ?? this.widthMm,
      heightMm: heightMm ?? this.heightMm,
      threadColors: threadColors ?? this.threadColors,
      stitches: stitches ?? this.stitches,
      lastOpened: lastOpened ?? this.lastOpened,
      description: description ?? this.description,
    );
  }
}
