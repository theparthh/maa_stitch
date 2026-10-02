import 'package:get_it/get_it.dart';
import 'package:maa_design_stitch_viewer/app/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void registerServices(GetIt getIt) {
  getIt.registerLazySingleton<SessionService>(
    () => SessionService(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<StitchParserService>(() => StitchParserService());
  getIt.registerLazySingleton<FileHandlerService>(() => FileHandlerService());
}
