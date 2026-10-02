import 'dart:io';

/// Categorizes a file by its extension into a known [FileType].
enum FileType {
  image,
  text,
  embroidery,
  unknown,
}

/// Reusable file-type detection service.
/// All extension checks are centralized here — never scattered in UI code.
abstract class FileTypeDetector {
  static const _imageExtensions = {
    'png', 'jpg', 'jpeg', 'webp', 'gif', 'bmp', 'tiff', 'tif',
  };
  static const _embroideryExtensions = {
    'emb', 'dst', 'dhp', 'pes', 'jef', 'exp', 'xxx', 'pec', 'vp3', 'hus',
  };
  static const _textExtensions = {
    'txt', 'md', 'log', 'csv', 'json', 'xml', 'yaml', 'yml',
  };

  /// Detect the [FileType] from a file path or name.
  static FileType detect(String path) {
    final ext = _extension(path);
    if (_imageExtensions.contains(ext)) return FileType.image;
    if (_embroideryExtensions.contains(ext)) return FileType.embroidery;
    if (_textExtensions.contains(ext)) return FileType.text;
    return FileType.unknown;
  }

  /// Returns the lowercase extension without the leading dot, e.g. 'png'.
  static String _extension(String path) {
    final name = path.split(Platform.pathSeparator).last;
    final parts = name.split('.');
    if (parts.length < 2) return '';
    return parts.last.toLowerCase();
  }

  /// Human-readable extension label, e.g. 'PNG'.
  static String extensionLabel(String path) {
    final ext = _extension(path);
    return ext.isEmpty ? 'FILE' : ext.toUpperCase();
  }

  /// Returns the icon data appropriate for the detected file type.
  static String iconLabel(FileType type) {
    switch (type) {
      case FileType.image:
        return 'image';
      case FileType.embroidery:
        return 'embroidery';
      case FileType.text:
        return 'text';
      case FileType.unknown:
        return 'unknown';
    }
  }
}
