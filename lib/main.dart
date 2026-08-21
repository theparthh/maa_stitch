import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maa_design_stitch_viewer/app/app.dart';
import 'package:maa_design_stitch_viewer/app/di/di.dart';
import 'package:maa_design_stitch_viewer/app/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Disable runtime HTTP fetching to prevent offline SocketExceptions
  GoogleFonts.config.allowRuntimeFetching = false;

  await initDependencies();
  AppRouteHandler.route = AppRouter();
  runApp(const MaaStitchApp());
}
