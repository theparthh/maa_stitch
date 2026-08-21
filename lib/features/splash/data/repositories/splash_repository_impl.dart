import 'package:maa_design_stitch_viewer/features/splash/domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  SplashRepositoryImpl();

  @override
  Future<String?> checkInitialFileIntent() async {
    // Simulate intent check delay
    await Future.delayed(const Duration(milliseconds: 1600));
    return null;
  }
}
