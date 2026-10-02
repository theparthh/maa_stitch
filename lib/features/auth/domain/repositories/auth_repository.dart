import 'package:dartz/dartz.dart';
import 'package:maa_design_stitch_viewer/app/core/network/api_exception.dart';
import 'package:maa_design_stitch_viewer/features/auth/domain/models/models.dart';

abstract class AuthRepository {
  Future<Either<ApiException, String>> sendOtp({
    required String phoneNumber,
  });

  Future<Either<ApiException, String>> resendOtp({
    required String phoneNumber,
  });

  Future<Either<ApiException, AuthResultModel>> verifyOtp({
    required String phoneNumber,
    required String otp,
  });

  bool get isLoggedIn;
  String? get token;
  String? get phoneNumber;
}
