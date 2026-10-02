import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/app/router/app_route_handler.dart';
import 'package:maa_design_stitch_viewer/app/router/app_router.dart';
import 'package:maa_design_stitch_viewer/app/services/file_type_detector.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/domain/models/reference_file_model.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/presentation/bloc/bloc.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/presentation/widgets/ref_empty_state_widget.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/presentation/widgets/ref_error_widget.dart';

class FolderFilesPanelWidget extends StatelessWidget {
  const FolderFilesPanelWidget({
    super.key,
    required this.folder,
    required this.filesState,
    required this.fileSearchQuery,
  });

  final ReferenceFolder folder;
  final FolderFilesState filesState;
  final String fileSearchQuery;

  @override
  Widget build(BuildContext context) {
    return switch (filesState) {
      FolderFilesIdle() => const SizedBox.shrink(),
      FolderFilesLoading() => Center(
          child: LoadingAnimationWidget.fallingDot(
            color: AppColors.secondary,
            size: 48,
          ),
        ),
      FolderFilesError(:final message) => RefErrorWidget(message: message),
      FolderFilesLoaded(:final filteredFiles) => filteredFiles.isEmpty
          ? RefEmptyStateWidget(
              icon: Icons.insert_drive_file_outlined,
              title: fileSearchQuery.isEmpty
                  ? 'No Files Found'
                  : 'No Matches',
              subtitle: fileSearchQuery.isEmpty
                  ? 'This folder doesn\'t contain any files.'
                  : 'No files match "$fileSearchQuery".',
            )
          : _FileList(files: filteredFiles),
    };
  }
}

class _FileList extends StatelessWidget {
  const _FileList({required this.files});
  final List<ReferenceFile> files;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.size20,
        vertical: AppSize.size8,
      ),
      itemCount: files.length,
      separatorBuilder: (_, __) => AppGaps.gap10,
      itemBuilder: (_, index) {
        return _FileCard(file: files[index]);
      },
    );
  }
}

class _FileCard extends StatelessWidget {
  const _FileCard({required this.file});

  final ReferenceFile file;

  void _openFile(BuildContext context) {
    switch (file.fileType) {
      case FileType.image:
        AppRouteHandler.route.push(
          ImageViewerRoute(filePath: file.path, fileName: file.name),
        );
      case FileType.embroidery:
        AppRouteHandler.route.push(
          ViewerRoute(filePath: file.path),
        );
      case FileType.text:
        AppRouteHandler.route.push(
          FilePreviewRoute(
            filePath: file.path,
            fileName: file.name,
            fileType: file.fileType,
          ),
        );
      case FileType.unknown:
        AppRouteHandler.route.push(
          FilePreviewRoute(
            filePath: file.path,
            fileName: file.name,
            fileType: file.fileType,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppBorderRadius.borderRadius16,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: AppBorderRadius.borderRadius16,
        child: InkWell(
          onTap: () => _openFile(context),
          borderRadius: AppBorderRadius.borderRadius16,
          child: Padding(
            padding: const EdgeInsets.all(AppSize.size14),
            child: Row(
              children: [
                _buildThumbnail(),
                AppGaps.gap14,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppGaps.gap4,
                      Row(
                        children: [
                          _TypeBadge(label: file.extensionLabel),
                          AppGaps.gap8,
                          Text(
                            file.formattedSize,
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppGaps.gap8,
                Icon(
                  _actionIcon,
                  color: _actionIconColor,
                  size: AppSize.size20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData get _actionIcon {
    switch (file.fileType) {
      case FileType.image:
        return Icons.open_in_full_rounded;
      case FileType.embroidery:
        return Icons.visibility_rounded;
      case FileType.text:
        return Icons.article_outlined;
      case FileType.unknown:
        return Icons.open_in_new_rounded;
    }
  }

  Color get _actionIconColor {
    switch (file.fileType) {
      case FileType.image:
        return AppColors.secondary;
      case FileType.embroidery:
        return AppColors.primary;
      case FileType.text:
        return AppColors.secondary;
      case FileType.unknown:
        return AppColors.textMuted;
    }
  }

  Widget _buildThumbnail() {
    if (file.fileType == FileType.image) {
      return ClipRRect(
        borderRadius: AppBorderRadius.borderRadius12,
        child: SizedBox(
          width: AppSize.size64,
          height: AppSize.size64,
          child: Image.file(
            File(file.path),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _iconContainer(),
            frameBuilder: (ctx, child, frame, wasSynced) {
              if (wasSynced || frame != null) return child;
              return _iconContainer();
            },
          ),
        ),
      );
    }
    return _iconContainer();
  }

  Widget _iconContainer() {
    final (icon, color) = switch (file.fileType) {
      FileType.image => (Icons.image_rounded, AppColors.blue),
      FileType.embroidery => (Icons.gesture_rounded, AppColors.primary),
      FileType.text => (Icons.description_rounded, AppColors.secondary),
      FileType.unknown => (Icons.insert_drive_file_outlined, AppColors.grey),
    };

    return Container(
      width: AppSize.size64,
      height: AppSize.size64,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppBorderRadius.borderRadius12,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: AppSize.size24),
          AppGaps.gap4,
          _TypeBadge(label: file.extensionLabel),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.size6,
        vertical: AppSize.size2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: AppBorderRadius.borderRadius4,
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
