import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/app/services/services.dart';
import 'package:maa_design_stitch_viewer/features/viewer/viewer.dart';

part 'viewer_event.dart';
part 'viewer_state.dart';

class ViewerBloc extends Bloc<ViewerEvent, ViewerState> {
  ViewerBloc({required this.repository}) : super(const ViewerInitial()) {
    on<LoadViewerEvent>(_onLoad);
    on<ToggleJumpStitchesEvent>(_onToggleJumpStitches);
    on<ToggleGridEvent>(_onToggleGrid);
    on<SelectThreadColorEvent>(_onSelectThreadColor);
    on<UpdateThreadEvent>(_onUpdateThread);
    on<ResetThreadColorsEvent>(_onResetThreadColors);
    on<SetPlaybackSpeedEvent>(_onSetPlaybackSpeed);
    on<TogglePlaybackEvent>(_onTogglePlayback);
    on<UpdatePlaybackStepEvent>(_onUpdatePlaybackStep);
  }

  final ViewerRepository repository;

  /// Thread entries as decoded, before the user's saved colours.
  List<ThreadBlock> _fileThreads = const [];

  Future<void> _onLoad(
    LoadViewerEvent event,
    Emitter<ViewerState> emit,
  ) async {
    emit(const ViewerLoading());
    try {
      final decoded = await repository.parseDesignFile(event.filePath);
      _fileThreads = decoded.threads;
      final design = repository.applySavedThreadColors(decoded);
      emit(ViewerLoaded(
        design: design,
        showJumpStitches: false,
        showGrid: false,
        selectedColorKey: null,
        isPlaying: false,
        playbackSpeed: 1.0,
        currentStitchStep: design.stitches.length,
      ));
    } on EmbroideryDecodeException catch (e) {
      emit(ViewerError(e.message));
    } catch (e) {
      emit(ViewerError('Could not open this file: $e'));
    }
  }

  void _onToggleJumpStitches(
    ToggleJumpStitchesEvent event,
    Emitter<ViewerState> emit,
  ) {
    if (state case final ViewerLoaded s) {
      emit(s.copyWith(showJumpStitches: !s.showJumpStitches));
    }
  }

  void _onToggleGrid(ToggleGridEvent event, Emitter<ViewerState> emit) {
    if (state case final ViewerLoaded s) {
      emit(s.copyWith(showGrid: !s.showGrid));
    }
  }

  void _onSelectThreadColor(
    SelectThreadColorEvent event,
    Emitter<ViewerState> emit,
  ) {
    if (state case final ViewerLoaded s) {
      final next = s.selectedColorKey == event.colorKey ? null : event.colorKey;
      emit(s.copyWith(selectedColorKey: () => next));
    }
  }

  Future<void> _onUpdateThread(
    UpdateThreadEvent event,
    Emitter<ViewerState> emit,
  ) async {
    if (state case final ViewerLoaded s) {
      final design = s.design.copyWith(threads: [
        for (final t in s.design.threads)
          t.colorKey == event.colorKey
              ? t.copyWith(color: event.color, style: event.style)
              : t,
      ]);
      emit(s.copyWith(design: design));
      await repository.saveThreadColors(design);
    }
  }

  Future<void> _onResetThreadColors(
    ResetThreadColorsEvent event,
    Emitter<ViewerState> emit,
  ) async {
    if (state case final ViewerLoaded s) {
      final design = s.design.copyWith(threads: _fileThreads);
      emit(s.copyWith(design: design));
      await repository.clearThreadColors(design);
    }
  }

  void _onSetPlaybackSpeed(
    SetPlaybackSpeedEvent event,
    Emitter<ViewerState> emit,
  ) {
    if (state case final ViewerLoaded s) {
      emit(s.copyWith(playbackSpeed: event.speed));
    }
  }

  void _onTogglePlayback(
    TogglePlaybackEvent event,
    Emitter<ViewerState> emit,
  ) {
    if (state case final ViewerLoaded s) {
      final playing = !s.isPlaying;
      emit(s.copyWith(
        isPlaying: playing,
        currentStitchStep: playing && s.isComplete ? 0 : s.currentStitchStep,
      ));
    }
  }

  void _onUpdatePlaybackStep(
    UpdatePlaybackStepEvent event,
    Emitter<ViewerState> emit,
  ) {
    if (state case final ViewerLoaded s) {
      final total = s.design.stitches.length;
      final step = event.step.clamp(0, total);
      emit(s.copyWith(
        currentStitchStep: step,
        isPlaying: s.isPlaying && step < total,
      ));
    }
  }
}
