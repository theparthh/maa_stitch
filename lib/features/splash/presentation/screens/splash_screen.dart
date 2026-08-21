import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/app/di/di.dart';
import 'package:maa_design_stitch_viewer/features/splash/presentation/bloc/bloc.dart';
import 'package:maa_design_stitch_viewer/features/splash/presentation/widgets/widgets.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (_) => getIt<SplashBloc>()..add(const InitSplashEvent()),
      child: const SplashViewWidget(),
    );
  }
}
