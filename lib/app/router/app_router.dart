import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/services/file_type_detector.dart';
import 'package:maa_design_stitch_viewer/features/auth/auth.dart';
import 'package:maa_design_stitch_viewer/features/home/home.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/reference_files.dart';
import 'package:maa_design_stitch_viewer/features/splash/splash.dart';
import 'package:maa_design_stitch_viewer/features/viewer/viewer.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.custom(
        transitionsBuilder: TransitionsBuilders.fadeIn,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
      );

  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: SplashRoute.page,
          path: '/',
          initial: true,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          duration: const Duration(milliseconds: 300),
        ),
        CustomRoute(
          page: PhoneLoginRoute.page,
          path: '/phone-login',
          transitionsBuilder: TransitionsBuilders.fadeIn,
          duration: const Duration(milliseconds: 300),
        ),
        CustomRoute(
          page: OtpVerificationRoute.page,
          path: '/otp-verification',
          transitionsBuilder: TransitionsBuilders.fadeIn,
          duration: const Duration(milliseconds: 300),
        ),
        CustomRoute(
          page: HomeRoute.page,
          path: '/home',
          transitionsBuilder: TransitionsBuilders.fadeIn,
          duration: const Duration(milliseconds: 300),
        ),
        CustomRoute(
          page: ViewerRoute.page,
          path: '/viewer',
          transitionsBuilder: TransitionsBuilders.fadeIn,
          duration: const Duration(milliseconds: 300),
        ),
        CustomRoute(
          page: FolderBrowserRoute.page,
          path: '/reference-files',
          transitionsBuilder: TransitionsBuilders.slideLeft,
          duration: const Duration(milliseconds: 300),
        ),
        CustomRoute(
          page: ImageViewerRoute.page,
          path: '/image-viewer',
          transitionsBuilder: TransitionsBuilders.fadeIn,
          duration: const Duration(milliseconds: 250),
        ),
        CustomRoute(
          page: FilePreviewRoute.page,
          path: '/file-preview',
          transitionsBuilder: TransitionsBuilders.slideLeft,
          duration: const Duration(milliseconds: 300),
        ),
        RedirectRoute(path: '*', redirectTo: '/'),
      ];
}

