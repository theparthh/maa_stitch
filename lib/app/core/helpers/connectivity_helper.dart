import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityHelper {
  static Future<List<ConnectivityResult>> checkConnectivity() async {
    return await Connectivity().checkConnectivity();
  }

  static bool isOnline(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  static Future<bool> checkIsOnline() async {
    final results = await checkConnectivity();
    return isOnline(results);
  }
}
