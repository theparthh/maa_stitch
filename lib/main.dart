import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/app.dart';
import 'package:maa_design_stitch_viewer/app/di/di.dart';
import 'package:maa_design_stitch_viewer/app/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  AppRouteHandler.route = AppRouter();
  runApp(const MaaStitchApp());
}
