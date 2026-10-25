import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/app/services/stitch_parser_service.dart';
import 'package:maa_design_stitch_viewer/features/viewer/viewer.dart';

class _FakeRepository implements ViewerRepository {
  EmbroideryDesign? saved;
  bool cleared = false;

  @override
  Future<EmbroideryDesign> parseDesignFile(String filePath) async {
    if (!File(filePath).existsSync()) {
      throw const EmbroideryDecodeException('File not found.');
    }
    return StitchParserService.decodeBytes(File(filePath).readAsBytesSync(),
        fileName: filePath.split('/').last, filePath: filePath);
  }

  @override
  EmbroideryDesign applySavedThreadColors(EmbroideryDesign design) => design;

  @override
  Future<void> saveThreadColors(EmbroideryDesign design) async =>
      saved = design;

  @override
  Future<void> clearThreadColors(EmbroideryDesign design) async =>
      cleared = true;
}

Future<ViewerLoaded> _load(ViewerBloc bloc, String path) async {
  bloc.add(LoadViewerEvent(path));
  return await bloc.stream.firstWhere((s) => s is ViewerLoaded) as ViewerLoaded;
}

void main() {
  test('opens fully drawn, playback restarts from 0 and stops at the end',
      () async {
    final bloc = ViewerBloc(repository: _FakeRepository());
    final loaded = await _load(bloc, 'DST/14501.DST');
    final total = loaded.design.stitches.length;
    expect(loaded.currentStitchStep, total);

    bloc.add(const TogglePlaybackEvent());
    var s = await bloc.stream.first as ViewerLoaded;
    expect(s.isPlaying, isTrue);
    expect(s.currentStitchStep, 0);

    bloc.add(UpdatePlaybackStepEvent(total + 50));
    s = await bloc.stream.first as ViewerLoaded;
    expect(s.currentStitchStep, total);
    expect(s.isPlaying, isFalse);
    await bloc.close();
  });

  test('changing a colour updates every block with that key and saves it',
      () async {
    final repo = _FakeRepository();
    final bloc = ViewerBloc(repository: repo);
    final loaded = await _load(bloc, 'DHP/11006.DHP');
    final needle2 = loaded.design.threads.firstWhere((t) => t.colorKey == 2);

    bloc.add(UpdateThreadEvent(
        colorKey: 2, color: const Color(0xff123456), style: ThreadStyle.bead));
    final s = await bloc.stream.first as ViewerLoaded;
    final updated = s.design.threads.firstWhere((t) => t.colorKey == 2);
    expect(updated.color, const Color(0xff123456));
    expect(updated.style, ThreadStyle.bead);
    expect(updated.stitchCount, needle2.stitchCount);
    expect(repo.saved, isNotNull);
    // Stitches are reused, not copied, so the renderer cache stays valid.
    expect(identical(s.design.stitches, loaded.design.stitches), isTrue);

    bloc.add(const ResetThreadColorsEvent());
    final reset = await bloc.stream.first as ViewerLoaded;
    expect(reset.design.threads, loaded.design.threads);
    expect(repo.cleared, isTrue);
    await bloc.close();
  });

  test('a missing or unsupported file shows a readable error', () async {
    final bloc = ViewerBloc(repository: _FakeRepository());
    bloc.add(const LoadViewerEvent('nope/missing.DST'));
    final s = await bloc.stream.firstWhere((s) => s is ViewerError);
    expect((s as ViewerError).message, 'File not found.');
    await bloc.close();
  });
}
