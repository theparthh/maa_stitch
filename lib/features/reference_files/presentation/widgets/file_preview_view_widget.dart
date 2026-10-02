import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/services/file_type_detector.dart';

/// Generic file preview screen.
/// - Text files: displayed as scrollable plain text.
/// - Unknown types: shows an "unsupported" message with file metadata.
class FilePreviewViewWidget extends StatefulWidget {
  const FilePreviewViewWidget({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.fileType,
  });

  final String filePath;
  final String fileName;
  final FileType fileType;

  @override
  State<FilePreviewViewWidget> createState() => _FilePreviewViewWidgetState();
}

class _FilePreviewViewWidgetState extends State<FilePreviewViewWidget> {
  String? _textContent;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.fileType != FileType.text) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final content = await File(widget.filePath).readAsString();
      if (mounted) {
        setState(() {
          _textContent = content;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to read file: $e';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          widget.fileName,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return _buildUnsupported(errorMessage: _error);
    }

    if (widget.fileType == FileType.text && _textContent != null) {
      return _buildTextViewer();
    }

    return _buildUnsupported();
  }

  Widget _buildTextViewer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSize.size20),
      child: SelectableText(
        _textContent ?? '',
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: AppColors.textPrimary,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildUnsupported({String? errorMessage}) {
    final stat = File(widget.filePath).statSync();
    final sizeBytes = stat.size;
    String formattedSize;
    if (sizeBytes < 1024) {
      formattedSize = '$sizeBytes B';
    } else if (sizeBytes < 1024 * 1024) {
      formattedSize = '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      formattedSize =
          '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSize.size32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSize.size24),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: AppBorderRadius.borderRadius24,
              ),
              child: Icon(
                Icons.insert_drive_file_outlined,
                color: AppColors.grey,
                size: AppSize.size64,
              ),
            ),
            AppGaps.gap24,
            Text(
              errorMessage ?? 'File Preview',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            AppGaps.gap12,
            Text(
              errorMessage == null
                  ? 'This file type cannot be previewed inside the application.'
                  : '',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            AppGaps.gap20,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.size16,
                vertical: AppSize.size12,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: AppBorderRadius.borderRadius12,
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.insert_drive_file_rounded,
                    color: AppColors.primary,
                    size: AppSize.size20,
                  ),
                  AppGaps.gap10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fileName,
                        style: AppTextStyles.labelLarge,
                      ),
                      Text(
                        '$formattedSize  •  ${FileTypeDetector.extensionLabel(widget.filePath)}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
