part of 'viewer_bloc.dart';

sealed class ViewerEvent extends Equatable {
  const ViewerEvent();

  @override
  List<Object?> get props => [];
}

final class LoadViewerEvent extends ViewerEvent {
  const LoadViewerEvent(this.filePath);

  final String filePath;

  @override
  List<Object?> get props => [filePath];
}

final class ToggleJumpStitchesEvent extends ViewerEvent {
  const ToggleJumpStitchesEvent();
}

final class ToggleGridEvent extends ViewerEvent {
  const ToggleGridEvent();
}

final class ToggleStitchPointsEvent extends ViewerEvent {
  const ToggleStitchPointsEvent();
}

final class SelectThreadColorEvent extends ViewerEvent {
  const SelectThreadColorEvent(this.colorIndex);

  final int? colorIndex; // null means show all colors

  @override
  List<Object?> get props => [colorIndex];
}

final class SetPlaybackSpeedEvent extends ViewerEvent {
  const SetPlaybackSpeedEvent(this.speed);

  final double speed;

  @override
  List<Object?> get props => [speed];
}

final class TogglePlaybackEvent extends ViewerEvent {
  const TogglePlaybackEvent();
}

final class UpdatePlaybackStepEvent extends ViewerEvent {
  const UpdatePlaybackStepEvent(this.step);

  final int step;

  @override
  List<Object?> get props => [step];
}
