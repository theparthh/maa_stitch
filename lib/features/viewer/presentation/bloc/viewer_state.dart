part of 'viewer_bloc.dart';

sealed class ViewerState extends Equatable {
  const ViewerState();

  @override
  List<Object?> get props => [];
}

final class ViewerInitial extends ViewerState {
  const ViewerInitial();
}

final class ViewerLoading extends ViewerState {
  const ViewerLoading();
}

final class ViewerLoaded extends ViewerState {
  const ViewerLoaded({
    required this.design,
    required this.showJumpStitches,
    required this.showGrid,
    required this.showStitchPoints,
    required this.selectedColorIndex,
    required this.isPlaying,
    required this.playbackSpeed,
    required this.currentStitchStep,
  });

  final EmbroideryDesign design;
  final bool showJumpStitches;
  final bool showGrid;
  final bool showStitchPoints;
  final int? selectedColorIndex;
  final bool isPlaying;
  final double playbackSpeed;
  final int currentStitchStep;

  @override
  List<Object?> get props => [
        design,
        showJumpStitches,
        showGrid,
        showStitchPoints,
        selectedColorIndex,
        isPlaying,
        playbackSpeed,
        currentStitchStep,
      ];

  ViewerLoaded copyWith({
    EmbroideryDesign? design,
    bool? showJumpStitches,
    bool? showGrid,
    bool? showStitchPoints,
    int? selectedColorIndex,
    bool Function()? selectedColorIndexProvider,
    bool? isPlaying,
    double? playbackSpeed,
    int? currentStitchStep,
  }) {
    return ViewerLoaded(
      design: design ?? this.design,
      showJumpStitches: showJumpStitches ?? this.showJumpStitches,
      showGrid: showGrid ?? this.showGrid,
      showStitchPoints: showStitchPoints ?? this.showStitchPoints,
      selectedColorIndex: selectedColorIndexProvider != null
          ? (selectedColorIndexProvider() ? selectedColorIndex : null)
          : (selectedColorIndex ?? this.selectedColorIndex),
      isPlaying: isPlaying ?? this.isPlaying,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      currentStitchStep: currentStitchStep ?? this.currentStitchStep,
    );
  }
}

final class ViewerError extends ViewerState {
  const ViewerError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
