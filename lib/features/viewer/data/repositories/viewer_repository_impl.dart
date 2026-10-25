import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/app/services/services.dart';
import 'package:maa_design_stitch_viewer/features/viewer/domain/repositories/viewer_repository.dart';

class ViewerRepositoryImpl implements ViewerRepository {
  ViewerRepositoryImpl({
    required this.stitchParserService,
    required this.threadColorStore,
  });

  final StitchParserService stitchParserService;
  final ThreadColorStore threadColorStore;

  @override
  Future<EmbroideryDesign> parseDesignFile(String filePath) =>
      stitchParserService.parseFile(filePath);

  @override
  EmbroideryDesign applySavedThreadColors(EmbroideryDesign design) =>
      threadColorStore.applySaved(design);

  @override
  Future<void> saveThreadColors(EmbroideryDesign design) =>
      threadColorStore.save(design);

  @override
  Future<void> clearThreadColors(EmbroideryDesign design) =>
      threadColorStore.clear(design);
}
