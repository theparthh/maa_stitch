import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';

/// Shows what can be shown of a Wilcom EMB: a same-name companion image if
/// one sits next to the file, otherwise the TrueView preview stored inside.
class EmbPreviewWidget extends StatelessWidget {
  const EmbPreviewWidget({
    super.key,
    required this.design,
    required this.transformationController,
  });

  final EmbroideryDesign design;
  final TransformationController transformationController;

  @override
  Widget build(BuildContext context) {
    final companion = design.previewImagePath;
    final Widget image;
    if (companion != null) {
      image = Image.file(File(companion),
          fit: BoxFit.contain, filterQuality: FilterQuality.high);
    } else if (design.previewImageBytes != null) {
      image = Image.memory(design.previewImageBytes!,
          fit: BoxFit.contain, filterQuality: FilterQuality.high);
    } else {
      image = const Center(
        child: Icon(Icons.image_not_supported_outlined,
            size: AppSize.size48, color: AppColors.textMuted),
      );
    }
    return ColoredBox(
      color: AppColors.white,
      child: InteractiveViewer(
        transformationController: transformationController,
        minScale: 1,
        maxScale: 8,
        child: Padding(
          padding: const EdgeInsets.all(AppSize.size24),
          child: Center(child: image),
        ),
      ),
    );
  }
}
