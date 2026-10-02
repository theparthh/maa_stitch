import 'package:flutter/services.dart';
import 'package:maa_design_stitch_viewer/app/services/services.dart';
import 'package:maa_design_stitch_viewer/features/splash/domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  SplashRepositoryImpl({SessionService? sessionService})
      : _sessionService = sessionService;

  final SessionService? _sessionService;
  static const MethodChannel _channel =
      MethodChannel('com.maadesign.viewstitch/file_intent');

  @override
  bool get isAuthenticated => _sessionService?.isLoggedIn ?? false;

  @override
  Future<String?> checkInitialFileIntent() async {
    final delayFuture = Future.delayed(const Duration(milliseconds: 1400));
    try {
      final String? path =
          await _channel.invokeMethod<String>('getInitialFile');
      await delayFuture;
      if (path != null && path.trim().isNotEmpty) {
        return path;
      }
    } catch (_) {
      await delayFuture;
    }
    return null;
  }
}
