import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/app/services/services.dart';
import 'package:maa_design_stitch_viewer/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required this.stitchParserService,
    required this.fileHandlerService,
  });

  final StitchParserService stitchParserService;
  final FileHandlerService fileHandlerService;

  @override
  Future<List<EmbroideryDesign>> getSampleAndRecentDesigns() async {
    return stitchParserService.getSampleDesigns();
  }

  @override
  Future<String?> pickEmbroideryFile() async {
    return fileHandlerService.pickEmbroideryFile();
  }

  @override
  Future<EmbroideryDesign> parseDesignFile(String filePath) async {
    return stitchParserService.parseFile(filePath);
  }
}
