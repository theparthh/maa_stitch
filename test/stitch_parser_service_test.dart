import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/app/services/file_type_detector.dart';
import 'package:maa_design_stitch_viewer/app/services/stitch_parser_service.dart';

/// Decodes the reference files in the repo's DST/, DHP/ and EMB/ folders.
/// Expected values come from the files' own headers / metadata and from an
/// independent Python implementation of the same layouts.
EmbroideryDesign decode(String path) => StitchParserService.decodeBytes(
      File(path).readAsBytesSync(),
      fileName: path.split('/').last,
      filePath: path,
    );

ThreadBlock entry(EmbroideryDesign d, int key) =>
    d.threads.firstWhere((t) => t.colorKey == key);

void main() {
  group('FileTypeDetector', () {
    test('detects embroidery files accurately', () {
      expect(FileTypeDetector.detect('test.emb'), FileType.embroidery);
      expect(FileTypeDetector.detect('test.dst'), FileType.embroidery);
      expect(FileTypeDetector.detect('test.dhp'), FileType.embroidery);
      expect(FileTypeDetector.detect('test.png'), FileType.image);
      expect(FileTypeDetector.detect('test.txt'), FileType.text);
    });
  });

  group('format detection', () {
    test('uses file content, not the extension', () {
      final dhp = File('DHP/11006.DHP').readAsBytesSync();
      expect(StitchParserService.detectFormat(dhp, 'renamed.dst'),
          EmbroideryFormat.dhp);
      final emb = File('EMB/670.EMB').readAsBytesSync();
      expect(StitchParserService.detectFormat(emb, 'x.dhp'),
          EmbroideryFormat.emb);
    });

    test('rejects unsupported files with a readable error', () {
      expect(
        () => StitchParserService.decodeBytes(
            Uint8List.fromList(List.filled(600, 7)),
            fileName: 'notes.txt',
            filePath: 'notes.txt'),
        throwsA(isA<EmbroideryDecodeException>()),
      );
    });
  });

  group('DST', () {
    test('14501 matches its Tajima header', () {
      final d = decode('DST/14501.DST');
      // Header: ST 39769 records (incl. END), CO 5, +X/-X 1516, +Y 3659.
      // Colour-change records are needle moves, so they count as jumps.
      expect(d.totalStitches + d.jumpCount, 39769 - 1);
      expect(d.colorChangeCount, 5);
      expect(d.threads, hasLength(6));
      expect(d.widthMm, closeTo(303.2, 0.05));
      expect(d.heightMm, closeTo(365.9, 0.05));
      expect(d.renderMode, DesignRenderMode.stitches);
    });

    test('14505 is not mirrored (header: +X 0, -X 2879, +Y 4655)', () {
      final d = decode('DST/14505.DST');
      // Header extents are rounded by the writer, hence the 0.15 mm slack.
      expect(d.bounds.left, closeTo(-287.9, 0.15));
      expect(d.bounds.right, closeTo(0.0, 0.15));
      // +Y is up in DST, so the design extends to negative screen Y.
      expect(d.bounds.top, closeTo(-465.5, 0.15));
      expect(d.bounds.bottom, closeTo(0.0, 0.15));
      expect(d.colorChangeCount, 5);
    });
  });

  group('DHP', () {
    test('11006 decodes stitches, sequins and needles', () {
      final d = decode('DHP/11006.DHP');
      expect(d.totalStitches, 24873);
      expect(d.widthMm, closeTo(403.55, 0.01));
      expect(d.heightMm, closeTo(1286.17, 0.01));
      final needles = {for (final t in d.threads) if (t.colorKey > 0) t.colorKey};
      expect(needles, {1, 2});
      // Device stitches: bead lines + sequin rows + single sequins.
      expect(entry(d, -(1 << 24)).style, ThreadStyle.bead);
      expect(entry(d, -(1 << 24)).stitchCount, 2242);
      expect(entry(d, -6).style, ThreadStyle.sequin);
      expect(entry(d, -6).stitchCount, 2648);
      expect(entry(d, -8).stitchCount, 359);
    });

    test('11011 decodes stitches, sequins and needles', () {
      final d = decode('DHP/11011.DHP');
      expect(d.totalStitches, 22958);
      expect(d.widthMm, closeTo(341.34, 0.01));
      expect(d.heightMm, closeTo(1042.19, 0.01));
      final needles = {for (final t in d.threads) if (t.colorKey > 0) t.colorKey};
      expect(needles, containsAll([1, 2, 3, 4, 5, 6]));
      expect(entry(d, -(1 << 24)).stitchCount, 2007);
      expect(entry(d, -0x100).stitchCount, 4325);
      expect(entry(d, -0x1000).stitchCount, 910);
      expect(entry(d, -6).stitchCount, 1882);
      expect(d.sequinCount, greaterThan(7000));
    });
  });

  group('EMB', () {
    test('670 reads real metadata, threads and TrueView preview', () {
      final d = decode('EMB/670.EMB');
      expect(d.renderMode, DesignRenderMode.previewOnly);
      expect(d.totalStitches, 52216);
      expect(d.sequinCount, 633);
      expect(d.trimCount, 16);
      expect(d.widthMm, closeTo(561.33, 0.01));
      expect(d.heightMm, closeTo(1105.0, 0.01));
      expect(d.threads.first.label, 'Brown');
      expect(d.threads.first.color.toARGB32(), 0xFF996633);
      expect(d.threads.map((t) => t.label).toSet(),
          {'Brown', 'Yellow', 'Dark Green'});
      // 256x256 JPEG
      expect(d.previewImageBytes!.sublist(0, 3), [0xFF, 0xD8, 0xFF]);
    });

    test('each EMB reports its own numbers (not a shared template)', () {
      final counts = {
        for (final f in ['670', '721', '726'])
          f: decode('EMB/$f.EMB').totalStitches,
      };
      expect(counts, {'670': 52216, '721': 90600, '726': 58156});
      final d726 = decode('EMB/726.EMB');
      expect(d726.threads.single.label, 'Dark Green');
      expect(d726.colorChangeCount, 0);
    });
  });
}
