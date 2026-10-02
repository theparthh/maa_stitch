import 'package:get_it/get_it.dart';
import 'package:maa_design_stitch_viewer/app/di/bloc_module.dart';
import 'package:maa_design_stitch_viewer/app/di/repository_module.dart';
import 'package:maa_design_stitch_viewer/app/di/service_module.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  registerServices(getIt);
  registerRepositories(getIt);
  registerBlocs(getIt);
}
