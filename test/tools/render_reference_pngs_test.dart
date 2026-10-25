// Renders every reference design to PNG for visual comparison with the
// *_N.jpeg outputs. Run: RENDER_OUT=/some/dir flutter test test/tools
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/app/services/stitch_parser_service.dart';
import 'package:maa_design_stitch_viewer/features/viewer/presentation/rendering/stitch_renderer.dart';

void main() {
  final outDir = Platform.environment['RENDER_OUT'];

  testWidgets('render reference designs', (tester) async {
    if (outDir == null) return;
    await tester.runAsync(() async {
      for (final path in [
        'DST/14501.DST',
        'DST/14505.DST',
        'DHP/11006.DHP',
        'DHP/11011.DHP',
      ]) {
        final d = StitchParserService.decodeBytes(File(path).readAsBytesSync(),
            fileName: path.split('/').last, filePath: path);
        if (d.renderMode != DesignRenderMode.stitches) continue;
        final png = await StitchRenderer(d).renderPng(
          style: StitchRenderStyle(entries: d.threads),
          longSidePx: int.parse(Platform.environment['RENDER_SIZE'] ?? '2400'),
        );
        File('$outDir/${d.fileName}.png').writeAsBytesSync(png);
      }
    });
  });
}
