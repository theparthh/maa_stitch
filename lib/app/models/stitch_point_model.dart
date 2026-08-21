import 'package:equatable/equatable.dart';

enum StitchType {
  normal,
  jump,
  colorChange,
  trim,
  end,
}

class StitchPoint extends Equatable {
  const StitchPoint({
    required this.x,
    required this.y,
    required this.type,
    this.colorIndex = 0,
  });

  final double x;
  final double y;
  final StitchType type;
  final int colorIndex;

  @override
  List<Object?> get props => [x, y, type, colorIndex];
}
