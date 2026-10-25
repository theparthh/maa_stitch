import 'dart:io' show zlib;
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/app/services/embroidery/embroidery_decode_exception.dart';
import 'package:maa_design_stitch_viewer/app/services/embroidery/ole_compound_file.dart';

/// Wilcom `.EMB` (an OLE compound file).
///
/// The stitch/object data (`DesignDocument` stream) is encrypted by Wilcom
/// and cannot be decoded without Wilcom software. What *is* readable:
/// * `WilcomDesignInformationDDD` — an OLE property set with the real stitch
///   count, trims, size, sequins and the thread list (names + RGB colours).
/// * `TRUEVIEW_ICON` — a zlib-compressed 256×256 JPEG TrueView preview.
abstract class EmbReader {
  static const _infoStream = '\u0005WilcomDesignInformationDDD';

  static EmbroideryDesign read(
    Uint8List bytes, {
    required String fileName,
    required String filePath,
    String? companionImagePath,
  }) {
    final OleCompoundFile ole;
    try {
      ole = OleCompoundFile.parse(bytes);
    } on FormatException {
      throw const EmbroideryDecodeException(
          'This EMB file is damaged or is not a Wilcom design.');
    }

    final info = _readPropertySet(ole.stream(_infoStream));
    final preview = _inflateAfterHeader(ole.stream('TRUEVIEW_ICON')) ??
        _inflateAfterHeader(ole.stream('DESIGN_ICON'));
    if (info.isEmpty && preview == null) {
      throw const EmbroideryDecodeException(
          'Could not read this EMB file (no design information or preview).');
    }

    int intOf(String key) => (info[key] is num) ? (info[key] as num).round() : 0;
    // Wilcom stores extents in 0.01 mm.
    final widthMm = intOf('design width') / 100.0;
    final heightMm = intOf('design height') / 100.0;
    final threads = _parseThreads(info['threads']);

    return EmbroideryDesign(
      id: '${filePath.hashCode}',
      fileName: fileName,
      filePath: filePath,
      extension: 'emb',
      formatName: 'Wilcom EMB',
      renderMode: DesignRenderMode.previewOnly,
      totalStitches: intOf('number of stitches'),
      colorChangeCount: intOf('number of colour changes'),
      jumpCount: 0,
      trimCount: intOf('number of trims'),
      sequinCount: intOf('sequins'),
      widthMm: widthMm,
      heightMm: heightMm,
      bounds: Rect.zero,
      threads: threads,
      stitches: const [],
      lastOpened: DateTime.now(),
      description: info['embroidery machine name'] is String
          ? 'Machine format: ${info['embroidery machine name']}'
          : null,
      notes: [
        'Wilcom encrypts the stitch data inside EMB files, so no app other '
            'than Wilcom can draw the real stitches. Showing the preview '
            'image stored in the file, with the real stitch count, size and '
            'thread list.',
        'For a full HD stitch view, export the design from Wilcom as DST '
            '(File → Export Machine File) and open that.',
      ],
      previewImageBytes: preview,
      previewImagePath: companionImagePath,
    );
  }

  /// Stream payloads start with a 4-byte length, then zlib data.
  static Uint8List? _inflateAfterHeader(Uint8List? data) {
    if (data == null || data.length < 6) return null;
    for (final offset in const [4, 0, 8]) {
      if (offset + 2 > data.length || data[offset] != 0x78) continue;
      try {
        return Uint8List.fromList(zlib.decode(data.sublist(offset)));
      } catch (_) {}
    }
    return null;
  }

  /// `threads` is tab-separated rows:
  /// `index, code, , stitches, length, code, name, chart, ?, BGR colour`.
  static List<ThreadBlock> _parseThreads(Object? raw) {
    if (raw is! String) return const [];
    final blocks = <ThreadBlock>[];
    final keys = <String, int>{};
    for (final line in raw.split('\n')) {
      final cols = line.split('\t');
      if (cols.length < 10) continue;
      final bgr = int.tryParse(cols[9]);
      if (bgr == null) continue;
      final name = cols[6].trim();
      final chart = cols[7].trim();
      final code = cols[5].trim();
      final color = Color(0xFF000000 |
          ((bgr & 0xFF) << 16) |
          (bgr & 0xFF00) |
          ((bgr >> 16) & 0xFF));
      final identity = '$name|$chart|$code|$bgr';
      final key = keys.putIfAbsent(identity, () => keys.length);
      blocks.add(ThreadBlock(
        color: color,
        colorKey: key,
        label: name.isEmpty ? 'Color ${blocks.length + 1}' : name,
        stitchCount: int.tryParse(cols[3]) ?? 0,
        threadName: [
          if (chart.isNotEmpty && chart != 'Default') chart,
          if (code.isNotEmpty) '#$code',
        ].join(' '),
        isColorFromFile: true,
      ));
    }
    return blocks;
  }

  /// Parses an MS-OLEPS property set (first section) into name → value,
  /// using the section's dictionary for property names.
  static Map<String, Object> _readPropertySet(Uint8List? d) {
    final out = <String, Object>{};
    if (d == null || d.length < 48) return out;
    try {
      final bd = ByteData.sublistView(d);
      final sec = bd.getUint32(44, Endian.little);
      final count = bd.getUint32(sec + 4, Endian.little);
      final offsets = <int, int>{};
      for (var i = 0; i < min(count, 4096); i++) {
        offsets[bd.getUint32(sec + 8 + 8 * i, Endian.little)] =
            bd.getUint32(sec + 12 + 8 * i, Endian.little);
      }
      final names = <int, String>{};
      final dictOffset = offsets[0];
      if (dictOffset != null) {
        var p = sec + dictOffset;
        final n = bd.getUint32(p, Endian.little);
        p += 4;
        for (var i = 0; i < min(n, 4096); i++) {
          final id = bd.getUint32(p, Endian.little);
          final len = bd.getUint32(p + 4, Endian.little);
          p += 8;
          names[id] = String.fromCharCodes(
              d.sublist(p, p + len).where((c) => c != 0));
          p += len;
        }
      }
      offsets.forEach((id, off) {
        if (id < 2) return;
        final value = _readValue(bd, d, sec + off);
        if (value != null) out[names[id] ?? '$id'] = value;
      });
    } catch (_) {
      // Partial results are still useful.
    }
    return out;
  }

  static Object? _readValue(ByteData bd, Uint8List d, int p) {
    final vt = bd.getUint16(p, Endian.little);
    p += 4;
    switch (vt) {
      case 2:
        return bd.getInt16(p, Endian.little);
      case 3:
        return bd.getInt32(p, Endian.little);
      case 4:
        return bd.getFloat32(p, Endian.little);
      case 5:
        return bd.getFloat64(p, Endian.little);
      case 19:
        return bd.getUint32(p, Endian.little);
      case 30:
        final len = bd.getUint32(p, Endian.little);
        return String.fromCharCodes(
            d.sublist(p + 4, p + 4 + len).where((c) => c != 0));
      case 31:
        final len = bd.getUint32(p, Endian.little);
        final chars = <int>[];
        for (var i = 0; i < len; i++) {
          final c = bd.getUint16(p + 4 + 2 * i, Endian.little);
          if (c != 0) chars.add(c);
        }
        return String.fromCharCodes(chars);
      default:
        return null;
    }
  }
}
