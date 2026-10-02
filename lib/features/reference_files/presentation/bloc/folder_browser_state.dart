part of 'folder_browser_bloc.dart';

// ─────────────────────────────────────────────
//  Folder-files sub-state (nested inside FolderBrowserLoaded)
// ─────────────────────────────────────────────

sealed class FolderFilesState extends Equatable {
  const FolderFilesState();
  @override
  List<Object?> get props => [];
}

final class FolderFilesIdle extends FolderFilesState {
  const FolderFilesIdle();
}

final class FolderFilesLoading extends FolderFilesState {
  const FolderFilesLoading();
}

final class FolderFilesLoaded extends FolderFilesState {
  const FolderFilesLoaded({
    required this.allFiles,
    required this.filteredFiles,
  });

  final List<ReferenceFile> allFiles;
  final List<ReferenceFile> filteredFiles;

  @override
  List<Object?> get props => [allFiles, filteredFiles];

  FolderFilesLoaded copyWith({List<ReferenceFile>? filteredFiles}) {
    return FolderFilesLoaded(
      allFiles: allFiles,
      filteredFiles: filteredFiles ?? this.filteredFiles,
    );
  }
}

final class FolderFilesError extends FolderFilesState {
  const FolderFilesError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// ─────────────────────────────────────────────
//  Top-level states
// ─────────────────────────────────────────────

sealed class FolderBrowserState extends Equatable {
  const FolderBrowserState();
  @override
  List<Object?> get props => [];
}

final class FolderBrowserInitial extends FolderBrowserState {
  const FolderBrowserInitial();
}

final class FolderBrowserLoading extends FolderBrowserState {
  const FolderBrowserLoading();
}

final class FolderBrowserLoaded extends FolderBrowserState {
  const FolderBrowserLoaded({
    required this.baseDirectoryPath,
    required this.allFolders,
    required this.filteredFolders,
    required this.searchQuery,
    this.selectedFolder,
    this.filesState = const FolderFilesIdle(),
    this.fileSearchQuery = '',
  });

  final String baseDirectoryPath;
  final List<ReferenceFolder> allFolders;
  final List<ReferenceFolder> filteredFolders;
  final String searchQuery;
  final ReferenceFolder? selectedFolder;
  final FolderFilesState filesState;
  final String fileSearchQuery;

  @override
  List<Object?> get props => [
        baseDirectoryPath,
        allFolders,
        filteredFolders,
        searchQuery,
        selectedFolder?.path,
        filesState,
        fileSearchQuery,
      ];

  FolderBrowserLoaded copyWith({
    List<ReferenceFolder>? filteredFolders,
    String? searchQuery,
    ReferenceFolder? selectedFolder,
    FolderFilesState? filesState,
    String? fileSearchQuery,
  }) {
    return FolderBrowserLoaded(
      baseDirectoryPath: baseDirectoryPath,
      allFolders: allFolders,
      filteredFolders: filteredFolders ?? this.filteredFolders,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFolder: selectedFolder ?? this.selectedFolder,
      filesState: filesState ?? this.filesState,
      fileSearchQuery: fileSearchQuery ?? this.fileSearchQuery,
    );
  }
}

final class FolderBrowserError extends FolderBrowserState {
  const FolderBrowserError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
