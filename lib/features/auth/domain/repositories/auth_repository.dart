import 'package:maa_design_stitch_viewer/features/auth/domain/models/models.dart';

abstract class AuthRepository {
  List<CountryCodeModel> getSupportedCountryCodes();
  Future<bool> sendOtp({
    required String countryCode,
    required String phoneNumber,
  });
  Future<AuthResultModel> verifyOtp({
    required String phoneNumber,
    required String otp,
  });
}
