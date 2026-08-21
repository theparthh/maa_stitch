import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/app/di/di.dart';
import 'package:maa_design_stitch_viewer/features/home/presentation/bloc/bloc.dart';
import 'package:maa_design_stitch_viewer/features/home/presentation/widgets/widgets.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => getIt<HomeBloc>()..add(const LoadHomeEvent()),
      child: const HomeViewWidget(),
    );
  }
}
