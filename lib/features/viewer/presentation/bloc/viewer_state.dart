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
    required this.selectedColorKey,
    required this.isPlaying,
    required this.playbackSpeed,
    required this.currentStitchStep,
  });

  final EmbroideryDesign design;
  final bool showJumpStitches;
  final bool showGrid;
  final int? selectedColorKey;
  final bool isPlaying;
  final double playbackSpeed;

  /// Number of needle positions drawn (== stitches.length when complete).
  final int currentStitchStep;

  bool get isComplete => currentStitchStep >= design.stitches.length;

  @override
  List<Object?> get props => [
        design,
        showJumpStitches,
        showGrid,
        selectedColorKey,
        isPlaying,
        playbackSpeed,
        currentStitchStep,
      ];

  ViewerLoaded copyWith({
    EmbroideryDesign? design,
    bool? showJumpStitches,
    bool? showGrid,
    int? Function()? selectedColorKey,
    bool? isPlaying,
    double? playbackSpeed,
    int? currentStitchStep,
  }) {
    return ViewerLoaded(
      design: design ?? this.design,
      showJumpStitches: showJumpStitches ?? this.showJumpStitches,
      showGrid: showGrid ?? this.showGrid,
      selectedColorKey:
          selectedColorKey != null ? selectedColorKey() : this.selectedColorKey,
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
