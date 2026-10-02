import 'package:dartz/dartz.dart';
import 'package:maa_design_stitch_viewer/app/core/network/api_endpoints.dart';
import 'package:maa_design_stitch_viewer/app/core/network/api_exception.dart';
import 'package:maa_design_stitch_viewer/app/core/network/dio_client.dart';
import 'package:maa_design_stitch_viewer/app/services/services.dart';
import 'package:maa_design_stitch_viewer/features/auth/domain/domain.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    DioClient? dioClient,
    SessionService? sessionService,
  })  : _dioClient = dioClient ?? DioClient(),
        _sessionService = sessionService;

  final DioClient _dioClient;
  final SessionService? _sessionService;

  @override
  bool get isLoggedIn => _sessionService?.isLoggedIn ?? false;

  @override
  String? get token => _sessionService?.token;

  @override
  String? get phoneNumber => _sessionService?.phoneNumber;

  @override
  Future<Either<ApiException, String>> sendOtp({
    required String phoneNumber,
  }) async {
    final response = await _dioClient.postFormUrlEncoded(
      ApiEndpoints.login,
      {
        'mobile': phoneNumber,
        'app_source': ApiEndpoints.appSource,
      },
    );

    return response.fold(
      (exception) => left(exception),
      (data) {
        final success = data['success'] == true ||
            data['status'] == true ||
            data['status'] == 'success' ||
            data['status'] == 200 ||
            !data.containsKey('error');
        if (success) {
          final msg = data['message']?.toString() ?? 'OTP sent successfully';
          return right(msg);
        }
        final msg = data['message']?.toString() ?? 'Failed to send OTP';
        return left(ApiException(message: msg));
      },
    );
  }

  @override
  Future<Either<ApiException, String>> resendOtp({
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
            data['status'] == true ||
            data['status'] == 'success' ||
            data['status'] == 200 ||
            !data.containsKey('error');
        if (success) {
          final msg = data['message']?.toString() ?? 'OTP resent successfully';
          return right(msg);
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
      (data) async {
        final success = data['success'] == true ||
            data['status'] == true ||
            data['status'] == 'success' ||
            data['token'] != null ||
            data['data'] != null;

        if (success) {
          final token = data['token']?.toString() ??
              data['data']?['token']?.toString() ??
              'auth_token_${DateTime.now().millisecondsSinceEpoch}';
          final userMap = data['user'] is Map<String, dynamic>
              ? (data['user'] as Map<String, dynamic>)
              : null;
          final userId = userMap?['id']?.toString() ??
              data['user_id']?.toString() ??
              'usr_stitch';
          final userName = userMap?['name']?.toString();

          if (_sessionService != null) {
            await _sessionService!.saveSession(
              token: token,
              userId: userId,
              phoneNumber: phoneNumber,
              userName: userName,
            );
          }

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
