import 'package:dartz/dartz.dart';
import 'package:maa_design_stitch_viewer/app/core/network/api_exception.dart';
import 'package:maa_design_stitch_viewer/features/auth/domain/models/models.dart';

abstract class AuthRepository {
  Future<Either<ApiException, bool>> sendOtp({
    required String phoneNumber,
  });

  Future<Either<ApiException, bool>> resendOtp({
    required String phoneNumber,
  });

  Future<Either<ApiException, AuthResultModel>> verifyOtp({
    required String phoneNumber,
    required String otp,
  });
}
