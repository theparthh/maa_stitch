import 'package:maa_design_stitch_viewer/app/models/models.dart';

abstract class ViewerRepository {
  /// Decodes the file. Throws `EmbroideryDecodeException` when it cannot be
  /// shown.
  Future<EmbroideryDesign> parseDesignFile(String filePath);

  /// Applies the colours/styles the user saved for this design, if any.
  EmbroideryDesign applySavedThreadColors(EmbroideryDesign design);

  Future<void> saveThreadColors(EmbroideryDesign design);

  Future<void> clearThreadColors(EmbroideryDesign design);
}
