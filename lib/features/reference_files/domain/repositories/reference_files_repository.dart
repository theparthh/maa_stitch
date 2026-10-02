import 'package:maa_design_stitch_viewer/features/reference_files/domain/models/reference_file_model.dart';

/// Abstract contract for discovering reference folders and their files.
/// The concrete implementation uses the file system dynamically —
/// no folder names, file names, or paths are hardcoded.
abstract class ReferenceFilesRepository {
  /// Discover all top-level reference folders at [baseDirectoryPath].
  /// Returns an empty list if none exist; never throws.
  Future<List<ReferenceFolder>> getFolders(String baseDirectoryPath);

  /// List all files inside [folderPath].
  /// Returns an empty list if the folder is empty or unreadable.
  Future<List<ReferenceFile>> getFilesInFolder(String folderPath);
}
