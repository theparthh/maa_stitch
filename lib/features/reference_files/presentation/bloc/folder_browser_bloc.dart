import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/domain/domain.dart';

part 'folder_browser_event.dart';
part 'folder_browser_state.dart';

class FolderBrowserBloc extends Bloc<FolderBrowserEvent, FolderBrowserState> {
  FolderBrowserBloc({required this.repository})
      : super(const FolderBrowserInitial()) {
    on<LoadFoldersEvent>(_onLoadFolders);
    on<SearchFoldersEvent>(_onSearch);
    on<LoadFolderFilesEvent>(_onLoadFiles);
    on<SearchFolderFilesEvent>(_onSearchFiles);
  }

  final ReferenceFilesRepository repository;

  Future<void> _onLoadFolders(
    LoadFoldersEvent event,
    Emitter<FolderBrowserState> emit,
  ) async {
    emit(const FolderBrowserLoading());
    try {
      final folders = await repository.getFolders(event.baseDirectoryPath);
      emit(FolderBrowserLoaded(
        baseDirectoryPath: event.baseDirectoryPath,
        allFolders: folders,
        filteredFolders: folders,
        searchQuery: '',
      ));
    } catch (e) {
      emit(FolderBrowserError(e.toString()));
    }
  }

  void _onSearch(
    SearchFoldersEvent event,
    Emitter<FolderBrowserState> emit,
  ) {
    if (state is FolderBrowserLoaded) {
      final current = state as FolderBrowserLoaded;
      final filtered = event.query.isEmpty
          ? current.allFolders
          : current.allFolders
              .where((f) =>
                  f.name.toLowerCase().contains(event.query.toLowerCase()))
              .toList();
      emit(current.copyWith(
        searchQuery: event.query,
        filteredFolders: filtered,
      ));
    }
  }

  Future<void> _onLoadFiles(
    LoadFolderFilesEvent event,
    Emitter<FolderBrowserState> emit,
  ) async {
    if (state is FolderBrowserLoaded) {
      final current = state as FolderBrowserLoaded;
      emit(current.copyWith(
        filesState: const FolderFilesLoading(),
        selectedFolder: event.folder,
        fileSearchQuery: '',
      ));
      try {
        final files = await repository.getFilesInFolder(event.folder.path);
        emit(current.copyWith(
          selectedFolder: event.folder,
          filesState: FolderFilesLoaded(allFiles: files, filteredFiles: files),
          fileSearchQuery: '',
        ));
      } catch (e) {
        emit(current.copyWith(
          selectedFolder: event.folder,
          filesState: FolderFilesError(e.toString()),
        ));
      }
    }
  }

  void _onSearchFiles(
    SearchFolderFilesEvent event,
    Emitter<FolderBrowserState> emit,
  ) {
    if (state is FolderBrowserLoaded) {
      final current = state as FolderBrowserLoaded;
      if (current.filesState is FolderFilesLoaded) {
        final filesLoaded = current.filesState as FolderFilesLoaded;
        final filtered = event.query.isEmpty
            ? filesLoaded.allFiles
            : filesLoaded.allFiles
                .where((f) =>
                    f.name.toLowerCase().contains(event.query.toLowerCase()) ||
                    f.extensionLabel
                        .toLowerCase()
                        .contains(event.query.toLowerCase()))
                .toList();
        emit(current.copyWith(
          fileSearchQuery: event.query,
          filesState: filesLoaded.copyWith(filteredFiles: filtered),
        ));
      }
    }
  }
}
