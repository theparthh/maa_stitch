import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';

/// Full-screen image viewer with InteractiveViewer (pan + pinch-zoom).
/// Preserves aspect ratio. Title shows the file name.
class ImageViewerViewWidget extends StatelessWidget {
  const ImageViewerViewWidget({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  final String filePath;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          fileName,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 8.0,
          child: Image.file(
            File(filePath),
            fit: BoxFit.contain,
            errorBuilder: (_, error, __) {
              return _buildError();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image_rounded,
              color: Colors.white54, size: 72),
          const SizedBox(height: 16),
          Text(
            'Image could not be loaded.',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
