import 'package:flutter/services.dart';
import 'package:maa_design_stitch_viewer/app/router/app_router.dart';

class AppRouteHandler {
  AppRouteHandler._();
  static late AppRouter route;

  static const MethodChannel _fileIntentChannel =
      MethodChannel('com.maadesign.viewstitch/file_intent');

  static void initFileIntentListener() {
    _fileIntentChannel.setMethodCallHandler((call) async {
      if (call.method == 'onFileOpened') {
        final filePath = call.arguments?.toString();
        if (filePath != null && filePath.trim().isNotEmpty) {
          route.push(ViewerRoute(filePath: filePath));
        }
      }
    });
  }
}
