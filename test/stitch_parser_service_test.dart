import 'package:flutter_test/flutter_test.dart';
import 'package:maa_design_stitch_viewer/app/services/file_type_detector.dart';
import 'package:maa_design_stitch_viewer/app/services/stitch_parser_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FileTypeDetector', () {
    test('detects embroidery files accurately', () {
      expect(FileTypeDetector.detect('test.emb'), FileType.embroidery);
      expect(FileTypeDetector.detect('test.dst'), FileType.embroidery);
      expect(FileTypeDetector.detect('test.dhp'), FileType.embroidery);
      expect(FileTypeDetector.detect('test.png'), FileType.image);
      expect(FileTypeDetector.detect('test.txt'), FileType.text);
    });
  });

  group('StitchParserService EMB Resolution', () {
    test('resolves HD companion images dynamically for EMB files', () async {
      final service = StitchParserService();

      final d726 = await service.parseFile('EMB/726.EMB');
      expect(d726.previewImagePath, isNotNull);
      expect(d726.previewImagePath, contains('EMB_2.jpeg'));
      expect(d726.widthMm, greaterThan(0));
      expect(d726.heightMm, greaterThan(0));

      final d721 = await service.parseFile('EMB/721.EMB');
      expect(d721.previewImagePath, isNotNull);
      expect(d721.previewImagePath, contains('EMB_3.jpeg'));

      final d670 = await service.parseFile('EMB/670.EMB');
      expect(d670.previewImagePath, isNotNull);
      expect(d670.previewImagePath, contains('EMB_1.jpeg'));
    });

    test('resolves DHP and DST files dynamically', () async {
      final service = StitchParserService();

      for (final p in ['DHP/11006.DHP', 'DHP/11011.DHP', 'DST/14501.DST', 'DST/14505.DST']) {
        final d = await service.parseFile(p);
        expect(d.totalStitches, greaterThan(0));
        expect(d.fileName, isNotEmpty);
      }
    });
  });
}
