import 'package:maa_design_stitch_viewer/app/models/models.dart';

abstract class HomeRepository {
  Future<List<EmbroideryDesign>> getSampleAndRecentDesigns();
  Future<String?> pickEmbroideryFile();
  Future<EmbroideryDesign> parseDesignFile(String filePath);
}
