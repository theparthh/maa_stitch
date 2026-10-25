enum StitchType {
  normal,
  jump,
  colorChange,
  trim,
  end,
}

/// A single needle position in millimetres (+X right, +Y down).
///
/// Intentionally not `Equatable`: designs hold 50k+ points and value-equality
/// on every state change made the viewer slow.
class StitchPoint {
  const StitchPoint({
    required this.x,
    required this.y,
    required this.type,
    this.colorIndex = 0,
  });

  final double x;
  final double y;
  final StitchType type;

  /// Index into [EmbroideryDesign.threads]; the entry's style says whether
  /// this position is thread, a bead line or a dropped sequin.
  final int colorIndex;
}
