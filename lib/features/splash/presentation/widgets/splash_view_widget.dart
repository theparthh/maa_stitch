import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/router/app_route_handler.dart';
import 'package:maa_design_stitch_viewer/app/router/app_router.dart';
import 'package:maa_design_stitch_viewer/features/splash/presentation/bloc/bloc.dart';
import 'package:maa_design_stitch_viewer/features/splash/presentation/widgets/widgets.dart';

class SplashViewWidget extends StatelessWidget {
  const SplashViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          if (state.initialFilePath != null) {
            AppRouteHandler.route.replace(
              ViewerRoute(filePath: state.initialFilePath!),
            );
          } else {
            AppRouteHandler.route.replace(const PhoneLoginRoute());
          }
        }
      },
      child: const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: SplashLogoWidget(),
        ),
      ),
    );
  }
}
