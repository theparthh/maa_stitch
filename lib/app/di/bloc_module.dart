import 'package:get_it/get_it.dart';
import 'package:maa_design_stitch_viewer/features/auth/auth.dart';
import 'package:maa_design_stitch_viewer/features/home/home.dart';
import 'package:maa_design_stitch_viewer/features/splash/splash.dart';
import 'package:maa_design_stitch_viewer/features/viewer/viewer.dart';

void registerBlocs(GetIt getIt) {
  getIt.registerFactory<PhoneLoginBloc>(
    () => PhoneLoginBloc(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<OtpVerificationBloc>(
    () => OtpVerificationBloc(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<SplashBloc>(
    () => SplashBloc(repository: getIt<SplashRepository>()),
  );

  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(repository: getIt<HomeRepository>()),
  );

  getIt.registerFactory<ViewerBloc>(
    () => ViewerBloc(repository: getIt<ViewerRepository>()),
  );
}

