import 'package:maa_design_stitch_viewer/app/models/models.dart';

abstract class ViewerRepository {
  Future<EmbroideryDesign> parseDesignFile(String filePath);
}
