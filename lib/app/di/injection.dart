import 'package:get_it/get_it.dart';
import 'package:maa_design_stitch_viewer/app/di/bloc_module.dart';
import 'package:maa_design_stitch_viewer/app/di/repository_module.dart';
import 'package:maa_design_stitch_viewer/app/di/service_module.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  registerServices(getIt);
  registerRepositories(getIt);
  registerBlocs(getIt);
}
