import 'dart:io';
import 'package:maa_design_stitch_viewer/features/reference_files/domain/models/reference_file_model.dart';
import 'package:maa_design_stitch_viewer/features/reference_files/domain/repositories/reference_files_repository.dart';

/// Concrete implementation of [ReferenceFilesRepository].
///
/// Dynamically discovers folders and files from the real file system.
/// No folder name, file name, extension, or path is hardcoded.
/// Adding or removing files/folders on disk is automatically reflected
/// on the next call — no code changes required.
class ReferenceFilesRepositoryImpl implements ReferenceFilesRepository {
  /// Returns all immediate subdirectories of [baseDirectoryPath], sorted by name.
  /// Each [ReferenceFolder] includes a live file count.
  @override
  Future<List<ReferenceFolder>> getFolders(String baseDirectoryPath) async {
    try {
      final base = Directory(baseDirectoryPath);
      if (!await base.exists()) return [];

      final List<ReferenceFolder> folders = [];

      await for (final entity in base.list()) {
        if (entity is Directory) {
          final name = entity.path.split(Platform.pathSeparator).last;
          // Skip hidden directories (e.g. .git, .dart_tool)
          if (name.startsWith('.')) continue;

          final fileCount = await _countFiles(entity.path);
          folders.add(ReferenceFolder(
            name: name,
            path: entity.path,
            fileCount: fileCount,
          ));
        }
      }

      folders.sort((a, b) => a.name.compareTo(b.name));
      return folders;
    } catch (_) {
      return [];
    }
  }

  /// Returns all files inside [folderPath], sorted by name.
  @override
  Future<List<ReferenceFile>> getFilesInFolder(String folderPath) async {
    try {
      final dir = Directory(folderPath);
      if (!await dir.exists()) return [];

      final List<ReferenceFile> files = [];

      await for (final entity in dir.list()) {
        if (entity is File) {
          final name = entity.path.split(Platform.pathSeparator).last;
          if (name.startsWith('.')) continue;
          files.add(ReferenceFile.fromFileSystemEntity(entity));
        }
      }

      files.sort((a, b) => a.name.compareTo(b.name));
      return files;
    } catch (_) {
      return [];
    }
  }

  Future<int> _countFiles(String dirPath) async {
    try {
      int count = 0;
      await for (final entity in Directory(dirPath).list()) {
        if (entity is File) {
          final name = entity.path.split(Platform.pathSeparator).last;
          if (!name.startsWith('.')) count++;
        }
      }
      return count;
    } catch (_) {
      return 0;
    }
  }
}
