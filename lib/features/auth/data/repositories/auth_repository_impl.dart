import 'package:dartz/dartz.dart';
import 'package:maa_design_stitch_viewer/app/core/network/api_endpoints.dart';
import 'package:maa_design_stitch_viewer/app/core/network/api_exception.dart';
import 'package:maa_design_stitch_viewer/app/core/network/dio_client.dart';
import 'package:maa_design_stitch_viewer/features/auth/domain/domain.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  @override
  Future<Either<ApiException, bool>> sendOtp({
    required String phoneNumber,
  }) async {
    final response = await _dioClient.postFormUrlEncoded(
      ApiEndpoints.login,
      {
        'mobile': phoneNumber,
        'name': 'user',
        'email': 'user@maa.com',
        'app_source': ApiEndpoints.appSource,
      },
    );

    return response.fold(
      (exception) => left(exception),
      (data) {
        // Handle success response
        final success = data['success'] == true ||
            data['status'] == 'success' ||
            data['status'] == 200 ||
            !data.containsKey('error');
        if (success) {
          return right(true);
        }
        final msg = data['message']?.toString() ?? 'Failed to send OTP';
        return left(ApiException(message: msg));
      },
    );
  }

  @override
  Future<Either<ApiException, bool>> resendOtp({
    required String phoneNumber,
  }) async {
    final response = await _dioClient.postFormUrlEncoded(
      ApiEndpoints.resendOtp,
      {
        'mobile': phoneNumber,
        'app_source': ApiEndpoints.appSource,
      },
    );

    return response.fold(
      (exception) => left(exception),
      (data) {
        final success = data['success'] == true ||
            data['status'] == 'success' ||
            data['status'] == 200 ||
            !data.containsKey('error');
        if (success) {
          return right(true);
        }
        final msg = data['message']?.toString() ?? 'Failed to resend OTP';
        return left(ApiException(message: msg));
      },
    );
  }

  @override
  Future<Either<ApiException, AuthResultModel>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final response = await _dioClient.postFormUrlEncoded(
      ApiEndpoints.verifyOtp,
      {
        'mobile': phoneNumber,
        'otp': otp,
        'device_token': 'device_token_stitch',
        'app_source': ApiEndpoints.appSource,
      },
    );

    return response.fold(
      (exception) => left(exception),
      (data) {
        final success = data['success'] == true ||
            data['status'] == 'success' ||
            data['token'] != null ||
            data['data'] != null;

        if (success) {
          final token = data['token']?.toString() ??
              data['data']?['token']?.toString() ??
              'auth_token_${DateTime.now().millisecondsSinceEpoch}';
          final userId = data['user_id']?.toString() ??
              data['user']?['id']?.toString() ??
              'usr_stitch';

          return right(
            AuthResultModel(
              success: true,
              token: token,
              userId: userId,
            ),
          );
        }

        final msg = data['message']?.toString() ?? 'Invalid OTP entered';
        return left(ApiException(message: msg));
      },
    );
  }
}
