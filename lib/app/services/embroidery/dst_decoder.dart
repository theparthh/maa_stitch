import 'dart:typed_data';

import 'package:maa_design_stitch_viewer/app/core/theme/app_colors.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/app/services/embroidery/decoded_design_builder.dart';
import 'package:maa_design_stitch_viewer/app/services/embroidery/embroidery_decode_exception.dart';

/// Tajima `.DST`: 512-byte ASCII header followed by 3-byte balanced-ternary
/// stitch records (units 0.1 mm, +Y up). DST stores no thread colours.
abstract class DstDecoder {
  static const int headerSize = 512;

  static bool looksLikeDst(Uint8List bytes) {
    if (bytes.length < headerSize + 3) return false;
    return bytes[0] == 0x4C && bytes[1] == 0x41 && bytes[2] == 0x3A; // "LA:"
  }

  static EmbroideryDesign decode(
    Uint8List bytes, {
    required String fileName,
    required String filePath,
  }) {
    if (bytes.length < headerSize + 3) {
      throw const EmbroideryDecodeException(
          'File is too small to be a Tajima DST design.');
    }

    final header = String.fromCharCodes(
        bytes.sublist(0, headerSize).map((b) => b < 32 || b > 126 ? 10 : b));
    final label = RegExp(r'LA:([^\n]*)').firstMatch(header)?.group(1)?.trim();

    final builder = DecodedDesignBuilder(
      entryFactory: (block) => ThreadBlock(
        color: AppColors.defaultThreadPalette[
            block % AppColors.defaultThreadPalette.length],
        colorKey: block,
        label: 'Color ${block + 1}',
      ),
    );

    var x = 0.0, y = 0.0;
    var block = 0;
    var sawEnd = false;

    for (var i = headerSize; i + 2 < bytes.length; i += 3) {
      final b0 = bytes[i], b1 = bytes[i + 1], b2 = bytes[i + 2];
      if ((b2 & 0xF3) == 0xF3) {
        sawEnd = true;
        break;
      }
      x += _dx(b0, b1, b2) / 10.0;
      y -= _dy(b0, b1, b2) / 10.0; // DST +Y is up, screen +Y is down.

      if ((b2 & 0xC3) == 0xC3) {
        builder.colorChange();
        block++;
        builder.jump(x, y);
      } else if ((b2 & 0x83) == 0x83) {
        builder.jump(x, y);
      } else {
        builder.stitch(x, y, block);
      }
    }

    if (!builder.hasStitches) {
      throw const EmbroideryDecodeException(
          'No stitches found. The DST file may be empty or corrupt.');
    }

    return builder.build(
      fileName: fileName,
      filePath: filePath,
      extension: 'dst',
      formatName: 'Tajima DST',
      description: label?.isNotEmpty == true ? 'Label: $label' : null,
      notes: [
        'DST files do not store thread colours. Tap a colour to set the '
            'real thread — it is saved for this design.',
        if (!sawEnd) 'File ended without an END record (it may be truncated).',
      ],
    );
  }

  static int _dx(int b0, int b1, int b2) {
    var v = 0;
    if (b0 & 0x01 != 0) v += 1;
    if (b0 & 0x02 != 0) v -= 1;
    if (b0 & 0x04 != 0) v += 9;
    if (b0 & 0x08 != 0) v -= 9;
    if (b1 & 0x01 != 0) v += 3;
    if (b1 & 0x02 != 0) v -= 3;
    if (b1 & 0x04 != 0) v += 27;
    if (b1 & 0x08 != 0) v -= 27;
    if (b2 & 0x04 != 0) v += 81;
    if (b2 & 0x08 != 0) v -= 81;
    return v;
  }

  static int _dy(int b0, int b1, int b2) {
    var v = 0;
    if (b0 & 0x80 != 0) v += 1;
    if (b0 & 0x40 != 0) v -= 1;
    if (b0 & 0x20 != 0) v += 9;
    if (b0 & 0x10 != 0) v -= 9;
    if (b1 & 0x80 != 0) v += 3;
    if (b1 & 0x40 != 0) v -= 3;
    if (b1 & 0x20 != 0) v += 27;
    if (b1 & 0x10 != 0) v -= 27;
    if (b2 & 0x20 != 0) v += 81;
    if (b2 & 0x10 != 0) v -= 81;
    return v;
  }
}
