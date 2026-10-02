import 'package:get_it/get_it.dart';
import 'package:maa_design_stitch_viewer/app/services/services.dart';
import 'package:maa_design_stitch_viewer/features/auth/auth.dart';
import 'package:maa_design_stitch_viewer/features/home/home.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/reference_files.dart';
import 'package:maa_design_stitch_viewer/features/splash/splash.dart';
import 'package:maa_design_stitch_viewer/features/viewer/viewer.dart';

void registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sessionService: getIt<SessionService>(),
    ),
  );

  getIt.registerLazySingleton<SplashRepository>(
    () => SplashRepositoryImpl(
      sessionService: getIt<SessionService>(),
    ),
  );

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      stitchParserService: getIt<StitchParserService>(),
      fileHandlerService: getIt<FileHandlerService>(),
    ),
  );

  getIt.registerLazySingleton<ViewerRepository>(
    () => ViewerRepositoryImpl(
      stitchParserService: getIt<StitchParserService>(),
    ),
  );

  getIt.registerLazySingleton<ReferenceFilesRepository>(
    () => ReferenceFilesRepositoryImpl(),
  );
}

