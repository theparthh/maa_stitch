import 'package:get_it/get_it.dart';
import 'package:maa_design_stitch_viewer/app/services/services.dart';

void registerServices(GetIt getIt) {
  getIt.registerLazySingleton<StitchParserService>(() => StitchParserService());
  getIt.registerLazySingleton<FileHandlerService>(() => FileHandlerService());
}
