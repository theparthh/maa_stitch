import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maa_design_stitch_viewer/app/core/network/api_endpoints.dart';
import 'package:maa_design_stitch_viewer/app/core/network/api_exception.dart';
import 'package:maa_design_stitch_viewer/app/core/network/api_logging_interceptor.dart';

class DioClient {
  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/x-www-form-urlencoded',
            },
          ),
        ) {
    _dio.interceptors.add(ApiLoggingInterceptor());
  }

  final Dio _dio;

  Future<Either<ApiException, Map<String, dynamic>>> postFormUrlEncoded(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.data != null) {
        return right(response.data!);
      }
      return left(const ApiException(message: 'Null response data received from server'));
    } on DioException catch (e) {
      String errorMessage = 'Server connection failed. Please try again.';
      int? statusCode = e.response?.statusCode;

      if (e.response?.data is Map<String, dynamic>) {
        final resData = e.response!.data as Map<String, dynamic>;
        if (resData.containsKey('message') && resData['message'] != null) {
          errorMessage = resData['message'].toString();
        } else if (resData.containsKey('error') && resData['error'] != null) {
          errorMessage = resData['error'].toString();
        }
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }

      return left(ApiException(message: errorMessage, statusCode: statusCode));
    } catch (e) {
      return left(ApiException(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
