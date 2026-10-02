import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/domain/models/reference_file_model.dart';

class FolderListWidget extends StatelessWidget {
  const FolderListWidget({
    super.key,
    required this.folders,
    required this.onFolderTap,
  });

  final List<ReferenceFolder> folders;
  final void Function(ReferenceFolder) onFolderTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.size20,
        vertical: AppSize.size8,
      ),
      itemCount: folders.length,
      separatorBuilder: (_, __) => AppGaps.gap10,
      itemBuilder: (context, index) {
        return _FolderCard(
          folder: folders[index],
          onTap: () => onFolderTap(folders[index]),
        );
      },
    );
  }
}

class _FolderCard extends StatelessWidget {
  const _FolderCard({required this.folder, required this.onTap});

  final ReferenceFolder folder;
  final VoidCallback onTap;

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
          onTap: onTap,
          borderRadius: AppBorderRadius.borderRadius16,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.size16,
              vertical: AppSize.size16,
            ),
            child: Row(
              children: [
                // Folder icon container
                Container(
                  width: AppSize.size56,
                  height: AppSize.size56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppBorderRadius.borderRadius14,
                  ),
                  child: const Icon(
                    Icons.folder_rounded,
                    color: AppColors.white,
                    size: AppSize.size28,
                  ),
                ),
                AppGaps.gap16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        folder.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppGaps.gap4,
                      Text(
                        '${folder.fileCount} ${folder.fileCount == 1 ? 'file' : 'files'}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                AppGaps.gap8,
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: AppSize.size24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
