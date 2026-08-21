import 'package:maa_design_stitch_viewer/features/auth/domain/domain.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const List<CountryCodeModel> _supportedCountries = [
    CountryCodeModel(
      countryName: 'India',
      code: '+91',
      flagEmoji: '🇮🇳',
      phoneLength: 10,
    ),
    CountryCodeModel(
      countryName: 'United States',
      code: '+1',
      flagEmoji: '🇺🇸',
      phoneLength: 10,
    ),
    CountryCodeModel(
      countryName: 'United Kingdom',
      code: '+44',
      flagEmoji: '🇬🇧',
      phoneLength: 10,
    ),
    CountryCodeModel(
      countryName: 'United Arab Emirates',
      code: '+971',
      flagEmoji: '🇦🇪',
      phoneLength: 9,
    ),
    CountryCodeModel(
      countryName: 'Germany',
      code: '+49',
      flagEmoji: '🇩🇪',
      phoneLength: 10,
    ),
  ];

  @override
  List<CountryCodeModel> getSupportedCountryCodes() {
    return _supportedCountries;
  }

  @override
  Future<bool> sendOtp({
    required String countryCode,
    required String phoneNumber,
  }) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    final sanitized = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (sanitized == '0000000000') {
      throw Exception('Server error: Unable to send OTP to this number.');
    }
    return true;
  }

  @override
  Future<AuthResultModel> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    if (otp == '0000') {
      return const AuthResultModel(
        success: false,
        errorMessage: 'Invalid OTP entered. Try 1234.',
      );
    }

    // Default demo OTP is 1234 or any non-zero 4-digit OTP
    return AuthResultModel(
      success: true,
      token: 'jwt_auth_token_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'usr_892341',
    );
  }
}
