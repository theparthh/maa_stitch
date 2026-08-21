import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/features/auth/auth.dart';
import 'package:maa_design_stitch_viewer/features/home/home.dart';
import 'package:maa_design_stitch_viewer/features/splash/splash.dart';
import 'package:maa_design_stitch_viewer/features/viewer/viewer.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: PhoneLoginRoute.page),
        AutoRoute(page: OtpVerificationRoute.page),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: ViewerRoute.page),
      ];
}

