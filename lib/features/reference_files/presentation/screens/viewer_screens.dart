import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/services/file_type_detector.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/presentation/widgets/widgets.dart';

@RoutePage()
class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  final String filePath;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return ImageViewerViewWidget(filePath: filePath, fileName: fileName);
  }
}

@RoutePage()
class FilePreviewScreen extends StatelessWidget {
  const FilePreviewScreen({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.fileType,
  });

  final String filePath;
  final String fileName;
  final FileType fileType;

  @override
  Widget build(BuildContext context) {
    return FilePreviewViewWidget(
      filePath: filePath,
      fileName: fileName,
      fileType: fileType,
    );
  }
}
