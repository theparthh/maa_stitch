import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/presentation/bloc/bloc.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/presentation/widgets/folder_list_widget.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/presentation/widgets/folder_files_panel_widget.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/presentation/widgets/reference_search_bar_widget.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/presentation/widgets/ref_empty_state_widget.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/presentation/widgets/ref_error_widget.dart';

class FolderBrowserViewWidget extends StatelessWidget {
  const FolderBrowserViewWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderBrowserBloc, FolderBrowserState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: switch (state) {
              FolderBrowserInitial() ||
              FolderBrowserLoading() =>
                _buildLoading(),
              FolderBrowserError(:final message) =>
                RefErrorWidget(message: message),
              FolderBrowserLoaded() => _buildLoaded(context, state),
            },
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: LoadingAnimationWidget.fallingDot(
        color: AppColors.secondary,
        size: 48,
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, FolderBrowserLoaded state) {
    final hasSelectedFolder = state.selectedFolder != null;

    return Column(
      children: [
        _buildHeader(context, state, hasSelectedFolder),
        const SizedBox(height: AppSize.size12),
        Expanded(
          child: hasSelectedFolder
              ? FolderFilesPanelWidget(
                  folder: state.selectedFolder!,
                  filesState: state.filesState,
                  fileSearchQuery: state.fileSearchQuery,
                )
              : _buildFolderList(context, state),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    FolderBrowserLoaded state,
    bool hasSelectedFolder,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSize.size20,
        AppSize.size20,
        AppSize.size20,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (hasSelectedFolder) {
                    // Go back to folder list
                    context.read<FolderBrowserBloc>().add(
                          LoadFoldersEvent(state.baseDirectoryPath),
                        );
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSize.size10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: AppBorderRadius.borderRadius12,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary,
                    size: AppSize.size18,
                  ),
                ),
              ),
              AppGaps.gap12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasSelectedFolder
                          ? state.selectedFolder!.name
                          : title,
                      style: AppTextStyles.h3,
                    ),
                    if (!hasSelectedFolder)
                      Text(
                        '${state.filteredFolders.length} folder${state.filteredFolders.length == 1 ? '' : 's'}',
                        style: AppTextStyles.bodySmall,
                      ),
                    if (hasSelectedFolder)
                      Text(
                        title,
                        style: AppTextStyles.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
          ),
          AppGaps.gap16,
          ReferenceSearchBarWidget(
            hint: hasSelectedFolder ? 'Search files…' : 'Search folders…',
            query: hasSelectedFolder
                ? state.fileSearchQuery
                : state.searchQuery,
            onChanged: (q) {
              if (hasSelectedFolder) {
                context
                    .read<FolderBrowserBloc>()
                    .add(SearchFolderFilesEvent(q));
              } else {
                context
                    .read<FolderBrowserBloc>()
                    .add(SearchFoldersEvent(q));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFolderList(BuildContext context, FolderBrowserLoaded state) {
    if (state.filteredFolders.isEmpty) {
      return RefEmptyStateWidget(
        icon: Icons.folder_off_rounded,
        title: state.searchQuery.isEmpty
            ? 'No Folders Available'
            : 'No Folders Found',
        subtitle: state.searchQuery.isEmpty
            ? 'There are currently no reference folders in this directory.'
            : 'No folders match "${state.searchQuery}".',
        onReset: state.searchQuery.isEmpty
            ? null
            : () => context
                .read<FolderBrowserBloc>()
                .add(const SearchFoldersEvent('')),
      );
    }

    return FolderListWidget(
      folders: state.filteredFolders,
      onFolderTap: (folder) {
        context
            .read<FolderBrowserBloc>()
            .add(LoadFolderFilesEvent(folder));
      },
    );
  }
}
