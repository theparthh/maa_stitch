import 'dart:typed_data';

import 'package:maa_design_stitch_viewer/app/core/theme/app_colors.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/app/services/embroidery/decoded_design_builder.dart';
import 'package:maa_design_stitch_viewer/app/services/embroidery/embroidery_decode_exception.dart';

/// Dahao `.DHP` design-source files.
///
/// Reverse-engineered layout (all little-endian int32):
/// * Magic `.DHP`, then a serialized list of design objects.
/// * Object header: `[byteSize, 100, 0, id, left, top, right, bottom, …]`
///   with the needle number 7 words before a `0x0303`/`0x0404` marker
///   (word 17 normally, word 10 for group objects without a bbox).
/// * Each object's generated stitches live in a tag-3 section:
///   `[3, sectionBytes, subBlockCount]` followed by sub-blocks
///   `[length, type, ?, ?, ?]` + `(length - 20) / 12` records `(x, y, flags)`.
///   type 0/2 = stitches, 1 = travel (jump), 7 = centre guide line.
/// * Coordinates are 0.01 mm with +Y up.
/// * Record flags select the machine device for that needle position:
///   0 = needle thread, a high byte (e.g. `0x01000045`) = bead/cord line,
///   a low code (6, 8, 0x100, 0x1000 …) = a sequin head. Checked against the
///   Dahao screenshots: dashed bead outlines, sequin rows at a fixed 3 mm
///   pitch and single sequin dots line up with these codes.
///
/// Thread and device colours are machine settings, not stored in the file,
/// so they get defaults the user can change (saved per design).
abstract class DhpDecoder {
  static const List<int> magic = [0x2E, 0x44, 0x48, 0x50]; // ".DHP"

  static bool looksLikeDhp(Uint8List bytes) {
    if (bytes.length < 256) return false;
    for (var i = 0; i < 4; i++) {
      if (bytes[i] != magic[i]) return false;
    }
    return true;
  }

  static EmbroideryDesign decode(
    Uint8List bytes, {
    required String fileName,
    required String filePath,
  }) {
    if (!looksLikeDhp(bytes)) {
      throw const EmbroideryDecodeException(
          'This is not a Dahao DHP design (missing ".DHP" signature).');
    }
    final data = ByteData.sublistView(bytes);
    final wordCount = bytes.length ~/ 4;
    int w(int i) => data.getInt32(i * 4, Endian.little);

    final objects = _findObjects(w, wordCount, bytes.length);
    final sections = _findSections(data, w, wordCount, bytes.length);
    if (sections.isEmpty) {
      throw const EmbroideryDecodeException(
          'No stitch data found in this DHP file. Open it in the Dahao '
          'software, generate stitches and save it again.');
    }

    var deviceCount = 0;
    final builder = DecodedDesignBuilder(entryFactory: (key) {
      if (key > 0) {
        return ThreadBlock(
          color: AppColors.needleColor(key),
          colorKey: key,
          label: 'Needle $key',
        );
      }
      final code = -key;
      final isBead = code >= 1 << 24;
      final n = isBead ? 0 : deviceCount++;
      return ThreadBlock(
        color: isBead ? AppColors.beadDefault : AppColors.sequinColor(code, n),
        colorKey: key,
        label: isBead ? 'Bead / cord line' : 'Sequin device ${n + 1}',
        style: isBead ? ThreadStyle.bead : ThreadStyle.sequin,
      );
    });

    // Sections and objects are both in file order; walk them together and
    // keep a stack of open objects so nested group children win.
    final stack = <_DhpObject>[];
    var objIndex = 0;
    var needle = 1;
    int? lastNeedle;
    for (final section in sections) {
      while (objIndex < objects.length &&
          objects[objIndex].start <= section.offset) {
        final o = objects[objIndex++];
        while (stack.isNotEmpty && stack.last.end <= o.start) {
          stack.removeLast();
        }
        stack.add(o);
      }
      while (stack.isNotEmpty && stack.last.end <= section.offset) {
        stack.removeLast();
      }
      for (var i = stack.length - 1; i >= 0; i--) {
        final n = stack[i].needle;
        if (n != null) {
          needle = n;
          break;
        }
      }

      var penDown = false;
      for (final sub in section.subBlocks) {
        final isStitch = sub.type == 0 || sub.type == 2;
        final isTravel = sub.type == 1;
        if (!isStitch && !isTravel) continue; // e.g. type 7 guide line
        if (isStitch && needle != lastNeedle) {
          if (lastNeedle != null) builder.colorChange();
          lastNeedle = needle;
        }
        for (var r = 0; r < sub.count; r++) {
          final o = sub.recordOffset + r * 12;
          final x = data.getInt32(o, Endian.little) / 100.0;
          final y = -data.getInt32(o + 4, Endian.little) / 100.0;
          if (isTravel) {
            builder.jump(x, y);
            penDown = false;
            continue;
          }
          // Move to the first needle position before sewing from it.
          if (!penDown) builder.jump(x, y);
          penDown = true;
          builder.stitch(
              x, y, _entryKey(data.getUint32(o + 8, Endian.little), needle));
        }
      }
    }

    if (!builder.hasStitches) {
      throw const EmbroideryDecodeException(
          'This DHP file contains no stitches.');
    }

    return builder.build(
      fileName: fileName,
      filePath: filePath,
      extension: 'dhp',
      formatName: 'Dahao DHP',
      notes: const [
        'DHP files store needles and sequin/bead devices but not their '
            'colours. Tap a colour to match your machine — it is saved for '
            'this design.',
      ],
    );
  }

  /// Positive keys are needles; negative keys are devices (minus the code).
  static int _entryKey(int flags, int needle) {
    if (flags >> 24 != 0) return -((flags >> 24) << 24);
    final code = flags & 0xFFFF;
    return code == 0 ? needle : -code;
  }

  static List<_DhpObject> _findObjects(
      int Function(int) w, int wordCount, int byteLength) {
    final out = <_DhpObject>[];
    for (var i = 46; i + 40 < wordCount; i++) {
      if (w(i + 1) != 100 || w(i + 2) != 0) continue;
      final size = w(i);
      if (size <= 64 || size > 4000000 || i * 4 + size > byteLength) continue;
      // Locate the 0x0303 / 0x0404 marker; the needle sits 7 words before it.
      int? needle;
      for (var k = 10; k < 32; k++) {
        final v = w(i + k);
        if (v > 0 && v <= 0x1010 && (v & 0xFF) == (v >> 8) && v != 0) {
          final n = w(i + k - 7);
          if (n >= 1 && n <= 32) needle = n;
          break;
        }
      }
      out.add(_DhpObject(start: i * 4, end: i * 4 + size, needle: needle));
    }
    return out;
  }

  static List<_DhpSection> _findSections(
      ByteData data, int Function(int) w, int wordCount, int byteLength) {
    final out = <_DhpSection>[];
    var i = 0;
    while (i + 3 < wordCount) {
      if (w(i) == 3) {
        final total = w(i + 1);
        final count = w(i + 2);
        final start = i * 4;
        if (count > 0 &&
            count < 5000 &&
            total >= 32 &&
            start + total <= byteLength) {
          final subs = _parseSubBlocks(data, start + 12, count, start + total);
          if (subs != null) {
            out.add(_DhpSection(offset: start, subBlocks: subs));
            i += total ~/ 4;
            continue;
          }
        }
      }
      i++;
    }
    return out;
  }

  /// Parses sub-blocks until [end]. The stored count is sometimes lower than
  /// the real number of sub-blocks, so the byte length is authoritative.
  /// Returns null unless the sub-blocks tile `[offset, end)` exactly.
  static List<_DhpSubBlock>? _parseSubBlocks(
      ByteData data, int offset, int minCount, int end) {
    final subs = <_DhpSubBlock>[];
    var p = offset;
    while (p < end) {
      if (p + 20 > end) return null;
      final length = data.getInt32(p, Endian.little);
      final type = data.getInt32(p + 4, Endian.little);
      if (length < 20 || (length - 20) % 12 != 0 || p + length > end) {
        return null;
      }
      if (type < 0 || type > 64) return null;
      final n = (length - 20) ~/ 12;
      for (var r = 0; r < n; r++) {
        final o = p + 20 + r * 12;
        if (data.getInt32(o, Endian.little).abs() > 500000 ||
            data.getInt32(o + 4, Endian.little).abs() > 500000) {
          return null;
        }
      }
      subs.add(_DhpSubBlock(type: type, recordOffset: p + 20, count: n));
      p += length;
    }
    return subs.length >= minCount ? subs : null;
  }
}

class _DhpObject {
  const _DhpObject({required this.start, required this.end, this.needle});
  final int start;
  final int end;
  final int? needle;
}

class _DhpSection {
  const _DhpSection({required this.offset, required this.subBlocks});
  final int offset;
  final List<_DhpSubBlock> subBlocks;
}

class _DhpSubBlock {
  const _DhpSubBlock(
      {required this.type, required this.recordOffset, required this.count});
  final int type;
  final int recordOffset;
  final int count;
}
