import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/app/services/services.dart';
import 'package:maa_design_stitch_viewer/features/viewer/domain/repositories/viewer_repository.dart';

class ViewerRepositoryImpl implements ViewerRepository {
  ViewerRepositoryImpl({required this.stitchParserService});

  final StitchParserService stitchParserService;

  @override
  Future<EmbroideryDesign> parseDesignFile(String filePath) async {
    return stitchParserService.parseFile(filePath);
  }
}
