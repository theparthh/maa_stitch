import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/features/viewer/viewer.dart';

part 'viewer_event.dart';
part 'viewer_state.dart';

class ViewerBloc extends Bloc<ViewerEvent, ViewerState> {
  ViewerBloc({required this.repository}) : super(const ViewerInitial()) {
    on<LoadViewerEvent>(_onLoad);
    on<ToggleJumpStitchesEvent>(_onToggleJumpStitches);
    on<ToggleGridEvent>(_onToggleGrid);
    on<ToggleStitchPointsEvent>(_onToggleStitchPoints);
    on<SelectThreadColorEvent>(_onSelectThreadColor);
    on<SetPlaybackSpeedEvent>(_onSetPlaybackSpeed);
    on<TogglePlaybackEvent>(_onTogglePlayback);
    on<UpdatePlaybackStepEvent>(_onUpdatePlaybackStep);
  }

  final ViewerRepository repository;

  Future<void> _onLoad(
    LoadViewerEvent event,
    Emitter<ViewerState> emit,
  ) async {
    emit(const ViewerLoading());
    try {
      final design = await repository.parseDesignFile(event.filePath);
      emit(ViewerLoaded(
        design: design,
        showJumpStitches: true,
        showGrid: true,
        showStitchPoints: false,
        selectedColorIndex: null,
        isPlaying: false,
        playbackSpeed: 1.0,
        currentStitchStep: design.totalStitches,
      ));
    } catch (e) {
      emit(ViewerError(e.toString()));
    }
  }

  void _onToggleJumpStitches(
    ToggleJumpStitchesEvent event,
    Emitter<ViewerState> emit,
  ) {
    if (state is ViewerLoaded) {
      final current = state as ViewerLoaded;
      emit(current.copyWith(showJumpStitches: !current.showJumpStitches));
    }
  }

  void _onToggleGrid(
    ToggleGridEvent event,
    Emitter<ViewerState> emit,
  ) {
    if (state is ViewerLoaded) {
      final current = state as ViewerLoaded;
      emit(current.copyWith(showGrid: !current.showGrid));
    }
  }

  void _onToggleStitchPoints(
    ToggleStitchPointsEvent event,
    Emitter<ViewerState> emit,
  ) {
    if (state is ViewerLoaded) {
      final current = state as ViewerLoaded;
      emit(current.copyWith(showStitchPoints: !current.showStitchPoints));
    }
  }

  void _onSelectThreadColor(
    SelectThreadColorEvent event,
    Emitter<ViewerState> emit,
  ) {
    if (state is ViewerLoaded) {
      final current = state as ViewerLoaded;
      if (event.colorIndex == null ||
          current.selectedColorIndex == event.colorIndex) {
        emit(current.copyWith(selectedColorIndexProvider: () => false));
      } else {
        emit(current.copyWith(selectedColorIndex: event.colorIndex));
      }
    }
  }

  void _onSetPlaybackSpeed(
    SetPlaybackSpeedEvent event,
    Emitter<ViewerState> emit,
  ) {
    if (state is ViewerLoaded) {
      final current = state as ViewerLoaded;
      emit(current.copyWith(playbackSpeed: event.speed));
    }
  }

  void _onTogglePlayback(
    TogglePlaybackEvent event,
    Emitter<ViewerState> emit,
  ) {
    if (state is ViewerLoaded) {
      final current = state as ViewerLoaded;
      final newIsPlaying = !current.isPlaying;
      int nextStep = current.currentStitchStep;
      if (newIsPlaying &&
          current.currentStitchStep >= current.design.totalStitches) {
        nextStep = 0;
      }
      emit(current.copyWith(
          isPlaying: newIsPlaying, currentStitchStep: nextStep));
    }
  }

  void _onUpdatePlaybackStep(
    UpdatePlaybackStepEvent event,
    Emitter<ViewerState> emit,
  ) {
    if (state is ViewerLoaded) {
      final current = state as ViewerLoaded;
      emit(current.copyWith(currentStitchStep: event.step));
    }
  }
}
