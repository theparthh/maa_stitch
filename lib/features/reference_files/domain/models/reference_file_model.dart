import 'dart:io';
import 'package:maa_design_stitch_viewer/app/services/file_type_detector.dart';

/// Immutable model representing a single file on disk.
class ReferenceFile {
  const ReferenceFile({
    required this.name,
    required this.path,
    required this.fileType,
    required this.sizeBytes,
    this.lastModified,
  });

  final String name;
  final String path;
  final FileType fileType;
  final int sizeBytes;
  final DateTime? lastModified;

  String get extensionLabel => FileTypeDetector.extensionLabel(path);

  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static ReferenceFile fromFileSystemEntity(FileSystemEntity entity) {
    final stat = entity.statSync();
    final name = entity.path.split(Platform.pathSeparator).last;
    return ReferenceFile(
      name: name,
      path: entity.path,
      fileType: FileTypeDetector.detect(entity.path),
      sizeBytes: stat.size,
      lastModified: stat.modified,
    );
  }
}

/// Immutable model representing a reference folder (one level deep).
class ReferenceFolder {
  const ReferenceFolder({
    required this.name,
    required this.path,
    required this.fileCount,
  });

  final String name;
  final String path;
  final int fileCount;
}
