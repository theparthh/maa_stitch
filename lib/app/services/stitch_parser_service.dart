import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/app/services/embroidery/dhp_decoder.dart';
import 'package:maa_design_stitch_viewer/app/services/embroidery/dst_decoder.dart';
import 'package:maa_design_stitch_viewer/app/services/embroidery/emb_reader.dart';
import 'package:maa_design_stitch_viewer/app/services/embroidery/embroidery_decode_exception.dart';
import 'package:maa_design_stitch_viewer/app/services/embroidery/ole_compound_file.dart';

export 'package:maa_design_stitch_viewer/app/services/embroidery/embroidery_decode_exception.dart';

enum EmbroideryFormat { dst, dhp, emb, unknown }

class StitchParserService {
  static const supportedExtensions = {'dst', 'dhp', 'emb'};

  /// Reads and decodes [filePath]. Throws [EmbroideryDecodeException] with a
  /// user-facing message when the file cannot be shown.
  Future<EmbroideryDesign> parseFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw const EmbroideryDecodeException('File not found.');
    }
    final bytes = await file.readAsBytes();
    final fileName = filePath.split(Platform.pathSeparator).last;
    final companion = await _findCompanionImage(file);

    // Decoding a 10 MB DHP takes long enough to drop frames; keep it off the
    // UI isolate.
    return Isolate.run(() => decodeBytes(
          bytes,
          fileName: fileName,
          filePath: filePath,
          companionImagePath: companion,
        ));
  }

  /// Pure decoder entry point (also used directly by tests).
  static EmbroideryDesign decodeBytes(
    Uint8List bytes, {
    required String fileName,
    required String filePath,
    String? companionImagePath,
  }) {
    if (bytes.isEmpty) {
      throw const EmbroideryDecodeException('The file is empty.');
    }
    switch (detectFormat(bytes, fileName)) {
      case EmbroideryFormat.dst:
        return DstDecoder.decode(bytes, fileName: fileName, filePath: filePath);
      case EmbroideryFormat.dhp:
        return DhpDecoder.decode(bytes, fileName: fileName, filePath: filePath);
      case EmbroideryFormat.emb:
        return EmbReader.read(bytes,
            fileName: fileName,
            filePath: filePath,
            companionImagePath: companionImagePath);
      case EmbroideryFormat.unknown:
        throw EmbroideryDecodeException(
            '"$fileName" is not a supported embroidery file. '
            'Supported formats: DST, DHP, EMB.');
    }
  }

  /// Detects by file content first (files are often renamed), then extension.
  static EmbroideryFormat detectFormat(Uint8List bytes, String fileName) {
    if (DhpDecoder.looksLikeDhp(bytes)) return EmbroideryFormat.dhp;
    if (OleCompoundFile.hasSignature(bytes)) return EmbroideryFormat.emb;
    if (DstDecoder.looksLikeDst(bytes)) return EmbroideryFormat.dst;
    final ext = fileName.contains('.')
        ? fileName.split('.').last.toLowerCase()
        : '';
    // Some DST writers leave the "LA:" label blank.
    if (ext == 'dst' && bytes.length > DstDecoder.headerSize) {
      return EmbroideryFormat.dst;
    }
    return EmbroideryFormat.unknown;
  }

  /// A same-name image beside the file, e.g. `670.jpg` for `670.EMB`.
  /// Only exact name matches are used — never guessed by folder position.
  Future<String?> _findCompanionImage(File file) async {
    final name = file.uri.pathSegments.last;
    final dot = name.lastIndexOf('.');
    if (dot <= 0) return null;
    final stem = name.substring(0, dot);
    for (final ext in const ['jpg', 'jpeg', 'png', 'webp', 'JPG', 'JPEG', 'PNG']) {
      final candidate = File('${file.parent.path}${Platform.pathSeparator}$stem.$ext');
      if (await candidate.exists()) return candidate.path;
    }
    return null;
  }
}
