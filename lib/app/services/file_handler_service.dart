import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileHandlerService {
  /// Open device file picker for embroidery extensions (.dst, .emb, .dhp)
  Future<String?> pickEmbroideryFile() async {
    try {
      // FileType.any: Android cannot filter .DHP/.EMB by MIME type, so a
      // custom filter would grey them out. Unsupported files get a clear
      // error from the parser instead.
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
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
