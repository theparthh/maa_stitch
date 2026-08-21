import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/app/di/di.dart';
import 'package:maa_design_stitch_viewer/features/viewer/presentation/bloc/bloc.dart';
import 'package:maa_design_stitch_viewer/features/viewer/presentation/widgets/widgets.dart';

@RoutePage()
class ViewerScreen extends StatelessWidget {
  const ViewerScreen({
    super.key,
    required this.filePath,
  });

  final String filePath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewerBloc>(
      create: (_) => getIt<ViewerBloc>()..add(LoadViewerEvent(filePath)),
      child: const ViewerViewWidget(),
    );
  }
}
