// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [FilePreviewScreen]
class FilePreviewRoute extends PageRouteInfo<FilePreviewRouteArgs> {
  FilePreviewRoute({
    Key? key,
    required String filePath,
    required String fileName,
    required FileType fileType,
    List<PageRouteInfo>? children,
  }) : super(
          FilePreviewRoute.name,
          args: FilePreviewRouteArgs(
            key: key,
            filePath: filePath,
            fileName: fileName,
            fileType: fileType,
          ),
          initialChildren: children,
        );

  static const String name = 'FilePreviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FilePreviewRouteArgs>();
      return FilePreviewScreen(
        key: args.key,
        filePath: args.filePath,
        fileName: args.fileName,
        fileType: args.fileType,
      );
    },
  );
}

class FilePreviewRouteArgs {
  const FilePreviewRouteArgs({
    this.key,
    required this.filePath,
    required this.fileName,
    required this.fileType,
  });

  final Key? key;

  final String filePath;

  final String fileName;

  final FileType fileType;

  @override
  String toString() {
    return 'FilePreviewRouteArgs{key: $key, filePath: $filePath, fileName: $fileName, fileType: $fileType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FilePreviewRouteArgs) return false;
    return key == other.key &&
        filePath == other.filePath &&
        fileName == other.fileName &&
        fileType == other.fileType;
  }

  @override
  int get hashCode =>
      key.hashCode ^ filePath.hashCode ^ fileName.hashCode ^ fileType.hashCode;
}

/// generated route for
/// [FolderBrowserScreen]
class FolderBrowserRoute extends PageRouteInfo<FolderBrowserRouteArgs> {
  FolderBrowserRoute({
    Key? key,
    required String baseDirectoryPath,
    required String title,
    List<PageRouteInfo>? children,
  }) : super(
          FolderBrowserRoute.name,
          args: FolderBrowserRouteArgs(
            key: key,
            baseDirectoryPath: baseDirectoryPath,
            title: title,
          ),
          initialChildren: children,
        );

  static const String name = 'FolderBrowserRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FolderBrowserRouteArgs>();
      return FolderBrowserScreen(
        key: args.key,
        baseDirectoryPath: args.baseDirectoryPath,
        title: args.title,
      );
    },
  );
}

class FolderBrowserRouteArgs {
  const FolderBrowserRouteArgs({
    this.key,
    required this.baseDirectoryPath,
    required this.title,
  });

  final Key? key;

  final String baseDirectoryPath;

  final String title;

  @override
  String toString() {
    return 'FolderBrowserRouteArgs{key: $key, baseDirectoryPath: $baseDirectoryPath, title: $title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FolderBrowserRouteArgs) return false;
    return key == other.key &&
        baseDirectoryPath == other.baseDirectoryPath &&
        title == other.title;
  }

  @override
  int get hashCode =>
      key.hashCode ^ baseDirectoryPath.hashCode ^ title.hashCode;
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [ImageViewerScreen]
class ImageViewerRoute extends PageRouteInfo<ImageViewerRouteArgs> {
  ImageViewerRoute({
    Key? key,
    required String filePath,
    required String fileName,
    List<PageRouteInfo>? children,
  }) : super(
          ImageViewerRoute.name,
          args: ImageViewerRouteArgs(
            key: key,
            filePath: filePath,
            fileName: fileName,
          ),
          initialChildren: children,
        );

  static const String name = 'ImageViewerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ImageViewerRouteArgs>();
      return ImageViewerScreen(
        key: args.key,
        filePath: args.filePath,
        fileName: args.fileName,
      );
    },
  );
}

class ImageViewerRouteArgs {
  const ImageViewerRouteArgs({
    this.key,
    required this.filePath,
    required this.fileName,
  });

  final Key? key;

  final String filePath;

  final String fileName;

  @override
  String toString() {
    return 'ImageViewerRouteArgs{key: $key, filePath: $filePath, fileName: $fileName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ImageViewerRouteArgs) return false;
    return key == other.key &&
        filePath == other.filePath &&
        fileName == other.fileName;
  }

  @override
  int get hashCode => key.hashCode ^ filePath.hashCode ^ fileName.hashCode;
}

/// generated route for
/// [OtpVerificationScreen]
class OtpVerificationRoute extends PageRouteInfo<OtpVerificationRouteArgs> {
  OtpVerificationRoute({
    Key? key,
    required String phoneNumber,
    List<PageRouteInfo>? children,
  }) : super(
          OtpVerificationRoute.name,
          args: OtpVerificationRouteArgs(key: key, phoneNumber: phoneNumber),
          initialChildren: children,
        );

  static const String name = 'OtpVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OtpVerificationRouteArgs>();
      return OtpVerificationScreen(
        key: args.key,
        phoneNumber: args.phoneNumber,
      );
    },
  );
}

class OtpVerificationRouteArgs {
  const OtpVerificationRouteArgs({this.key, required this.phoneNumber});

  final Key? key;

  final String phoneNumber;

  @override
  String toString() {
    return 'OtpVerificationRouteArgs{key: $key, phoneNumber: $phoneNumber}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OtpVerificationRouteArgs) return false;
    return key == other.key && phoneNumber == other.phoneNumber;
  }

  @override
  int get hashCode => key.hashCode ^ phoneNumber.hashCode;
}

/// generated route for
/// [PhoneLoginScreen]
class PhoneLoginRoute extends PageRouteInfo<void> {
  const PhoneLoginRoute({List<PageRouteInfo>? children})
      : super(PhoneLoginRoute.name, initialChildren: children);

  static const String name = 'PhoneLoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PhoneLoginScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [ViewerScreen]
class ViewerRoute extends PageRouteInfo<ViewerRouteArgs> {
  ViewerRoute({
    Key? key,
    required String filePath,
    List<PageRouteInfo>? children,
  }) : super(
          ViewerRoute.name,
          args: ViewerRouteArgs(key: key, filePath: filePath),
          initialChildren: children,
        );

  static const String name = 'ViewerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ViewerRouteArgs>();
      return ViewerScreen(key: args.key, filePath: args.filePath);
    },
  );
}

class ViewerRouteArgs {
  const ViewerRouteArgs({this.key, required this.filePath});

  final Key? key;

  final String filePath;

  @override
  String toString() {
    return 'ViewerRouteArgs{key: $key, filePath: $filePath}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ViewerRouteArgs) return false;
    return key == other.key && filePath == other.filePath;
  }

  @override
  int get hashCode => key.hashCode ^ filePath.hashCode;
}
