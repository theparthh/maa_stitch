// Pumps the real viewer UI with each reference file at phone size and saves
// screenshots; layout overflows fail the test. Opt-in because it downloads
// the app's Google Fonts:  RENDER_OUT=/some/dir flutter test test/tools
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/app/services/stitch_parser_service.dart';
import 'package:maa_design_stitch_viewer/features/viewer/viewer.dart';

class _FileRepository implements ViewerRepository {
  @override
  Future<EmbroideryDesign> parseDesignFile(String filePath) async =>
      StitchParserService.decodeBytes(File(filePath).readAsBytesSync(),
          fileName: filePath.split('/').last, filePath: filePath);

  @override
  EmbroideryDesign applySavedThreadColors(EmbroideryDesign design) => design;

  @override
  Future<void> saveThreadColors(EmbroideryDesign design) async {}

  @override
  Future<void> clearThreadColors(EmbroideryDesign design) async {}
}

void main() {
  final outDir = Platform.environment['RENDER_OUT'];
  setUpAll(() {
    // flutter_test blocks HTTP; allow it so the real fonts are used, and
    // give google_fonts a cache folder.
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized()
        .defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (_) async => Directory.systemTemp.path,
        );
  });

  for (final path in [
    'DST/14501.DST',
    'DHP/11011.DHP',
    'EMB/670.EMB',
  ]) {
    testWidgets('viewer shows $path', skip: outDir == null, (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      // Download the app fonts on the real clock before pumping; loads
      // started under the fake clock would never finish.
      await tester.runAsync(() async {
        for (final w in FontWeight.values) {
          GoogleFonts.inter(fontWeight: w);
          GoogleFonts.outfit(fontWeight: w);
        }
        await GoogleFonts.pendingFonts();
      });

      final boundaryKey = GlobalKey();
      final bloc = ViewerBloc(repository: _FileRepository())
        ..add(LoadViewerEvent(path));
      for (var i = 0; i < 50 && bloc.state is! ViewerLoaded; i++) {
        await tester.pump();
      }
      await tester.pumpWidget(RepaintBoundary(
        key: boundaryKey,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BlocProvider.value(value: bloc, child: const ViewerViewWidget()),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 100));
      expect(bloc.state, isA<ViewerLoaded>());
      final design = (bloc.state as ViewerLoaded).design;
      if (design.renderMode == DesignRenderMode.stitches) {
        expect(find.byType(StitchCanvasWidget), findsOneWidget);
        expect(find.byType(StitchPlaybackControlsWidget), findsOneWidget);
      } else {
        expect(find.byType(EmbPreviewWidget), findsOneWidget);
      }
      expect(find.byType(ThreadPaletteBarWidget), findsOneWidget);

      // Image decoding (EMB preview) also needs the real clock.
      if (design.previewImageBytes != null) {
        await tester.runAsync(() => precacheImage(
            MemoryImage(design.previewImageBytes!),
            tester.element(find.byType(EmbPreviewWidget))));
        await tester.pump();
      }
      await tester.runAsync(() async {
        final boundary = boundaryKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        File('$outDir/screen_${path.split('/').last}.png')
            .writeAsBytesSync(bytes!.buffer.asUint8List());
      });
      // Awaiting close() stalls under the test's fake-async clock.
      unawaited(bloc.close());
    });
  }
}
