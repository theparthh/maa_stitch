import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  SessionService(this._prefs);

  final SharedPreferences _prefs;

  static const String _keyIsLoggedIn = 'stitch_is_logged_in';
  static const String _keyAuthToken = 'stitch_auth_token';
  static const String _keyUserId = 'stitch_user_id';
  static const String _keyPhoneNumber = 'stitch_phone_number';
  static const String _keyUserName = 'stitch_user_name';
  static const String _keyLoginTimestamp = 'stitch_login_timestamp';

  bool get isLoggedIn {
    final loggedIn = _prefs.getBool(_keyIsLoggedIn) ?? false;
    final tokenValid = token != null && token!.trim().isNotEmpty;
    return loggedIn && tokenValid;
  }

  String? get token => _prefs.getString(_keyAuthToken);

  String? get userId => _prefs.getString(_keyUserId);

  String? get phoneNumber => _prefs.getString(_keyPhoneNumber);

  String? get userName => _prefs.getString(_keyUserName);

  int? get loginTimestamp => _prefs.getInt(_keyLoginTimestamp);

  Future<void> saveSession({
    required String token,
    required String userId,
    required String phoneNumber,
    String? userName,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyAuthToken, token);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyPhoneNumber, phoneNumber);
    if (userName != null && userName.isNotEmpty) {
      await _prefs.setString(_keyUserName, userName);
    }
    await _prefs.setInt(
      _keyLoginTimestamp,
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}
