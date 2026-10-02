part of 'folder_browser_bloc.dart';

sealed class FolderBrowserEvent extends Equatable {
  const FolderBrowserEvent();

  @override
  List<Object?> get props => [];
}

final class LoadFoldersEvent extends FolderBrowserEvent {
  const LoadFoldersEvent(this.baseDirectoryPath);
  final String baseDirectoryPath;

  @override
  List<Object?> get props => [baseDirectoryPath];
}

final class SearchFoldersEvent extends FolderBrowserEvent {
  const SearchFoldersEvent(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

final class LoadFolderFilesEvent extends FolderBrowserEvent {
  const LoadFolderFilesEvent(this.folder);
  final ReferenceFolder folder;

  @override
  List<Object?> get props => [folder.path];
}

final class SearchFolderFilesEvent extends FolderBrowserEvent {
  const SearchFolderFilesEvent(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}
