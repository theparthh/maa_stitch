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

/// Highlights one colour entry (by [ThreadBlock.colorKey]); null shows all.
final class SelectThreadColorEvent extends ViewerEvent {
  const SelectThreadColorEvent(this.colorKey);

  final int? colorKey;

  @override
  List<Object?> get props => [colorKey];
}

/// Changes the colour and/or style of every entry with [colorKey].
final class UpdateThreadEvent extends ViewerEvent {
  const UpdateThreadEvent({required this.colorKey, this.color, this.style});

  final int colorKey;
  final Color? color;
  final ThreadStyle? style;

  @override
  List<Object?> get props => [colorKey, color, style];
}

final class ResetThreadColorsEvent extends ViewerEvent {
  const ResetThreadColorsEvent();
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
