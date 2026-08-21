import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileHandlerService {
  /// Open device file picker for embroidery extensions (.dst, .emb, .dhp)
  Future<String?> pickEmbroideryFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['dst', 'emb', 'dhp', 'DST', 'EMB', 'DHP'],
      );

      if (result != null && result.files.isNotEmpty) {
        final path = result.files.single.path;
        if (path != null && await File(path).exists()) {
          return path;
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
