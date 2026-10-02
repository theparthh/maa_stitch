import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/app/di/di.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/presentation/bloc/bloc.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/presentation/widgets/widgets.dart';

@RoutePage()
class FolderBrowserScreen extends StatelessWidget {
  const FolderBrowserScreen({
    super.key,
    required this.baseDirectoryPath,
    required this.title,
  });

  final String baseDirectoryPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FolderBrowserBloc>(
      create: (_) => getIt<FolderBrowserBloc>()
        ..add(LoadFoldersEvent(baseDirectoryPath)),
      child: FolderBrowserViewWidget(title: title),
    );
  }
}
