import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor that prints API request payload, cURL command, and response/error details in terminal.
class ApiLoggingInterceptor extends Interceptor {
  ApiLoggingInterceptor({this.compact = false});

  final bool compact;
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['request_start_time'] = DateTime.now().millisecondsSinceEpoch;

    final buffer = StringBuffer();
    buffer.writeln('\n┌─── 🚀 [API REQUEST] ──────────────────────────────────────────────');
    buffer.writeln('│ Method  : ${options.method.toUpperCase()}');
    buffer.writeln('│ URL     : ${options.uri}');
    
    // Headers
    if (options.headers.isNotEmpty) {
      buffer.writeln('├─ 🔑 Headers:');
      options.headers.forEach((key, value) {
        buffer.writeln('│   $key: $value');
      });
    }

    // Query Parameters
    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('├─ 🔍 Query Parameters:');
      options.queryParameters.forEach((key, value) {
        buffer.writeln('│   $key: $value');
      });
    }

    // Payload / Body
    if (options.data != null) {
      buffer.writeln('├─ 📦 Payload:');
      final formattedData = _prettyPrintData(options.data);
      for (final line in formattedData.split('\n')) {
        buffer.writeln('│   $line');
      }
    }

    // cURL Command
    buffer.writeln('├─ 📋 cURL:');
    final curl = _generateCurl(options);
    for (final line in curl.split('\n')) {
      buffer.writeln('│   $line');
    }
    buffer.writeln('└───────────────────────────────────────────────────────────────────\n');

    _printLog(buffer.toString());
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['request_start_time'] as int?;
    final durationMs = startTime != null
        ? DateTime.now().millisecondsSinceEpoch - startTime
        : null;

    final buffer = StringBuffer();
    final statusCode = response.statusCode ?? 200;
    final statusMsg = response.statusMessage ?? 'OK';

    buffer.writeln('\n┌─── ✅ [API RESPONSE $statusCode $statusMsg] ${durationMs != null ? '(${durationMs}ms)' : ''} ──────────────');
    buffer.writeln('│ Method  : ${response.requestOptions.method.toUpperCase()}');
    buffer.writeln('│ URL     : ${response.requestOptions.uri}');

    // Response Data
    if (response.data != null) {
      buffer.writeln('├─ 📥 Response Body:');
      final formattedData = _prettyPrintData(response.data);
      for (final line in formattedData.split('\n')) {
        buffer.writeln('│   $line');
      }
    } else {
      buffer.writeln('├─ 📥 Response Body: (Empty)');
    }
    buffer.writeln('└───────────────────────────────────────────────────────────────────\n');

    _printLog(buffer.toString());
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['request_start_time'] as int?;
    final durationMs = startTime != null
        ? DateTime.now().millisecondsSinceEpoch - startTime
        : null;

    final buffer = StringBuffer();
    final statusCode = err.response?.statusCode;
    final statusMsg = err.response?.statusMessage ?? err.type.name;

    buffer.writeln('\n┌─── ❌ [API ERROR ${statusCode ?? ''} $statusMsg] ${durationMs != null ? '(${durationMs}ms)' : ''} ──────────────');
    buffer.writeln('│ Method  : ${err.requestOptions.method.toUpperCase()}');
    buffer.writeln('│ URL     : ${err.requestOptions.uri}');
    buffer.writeln('├─ ⚠️ Error Message: ${err.message ?? 'Unknown error'}');

    if (err.response?.data != null) {
      buffer.writeln('├─ 📥 Error Response Body:');
      final formattedData = _prettyPrintData(err.response!.data);
      for (final line in formattedData.split('\n')) {
        buffer.writeln('│   $line');
      }
    }
    buffer.writeln('└───────────────────────────────────────────────────────────────────\n');

    _printLog(buffer.toString());
    super.onError(err, handler);
  }

  String _prettyPrintData(dynamic data) {
    if (data == null) return 'null';
    if (data is FormData) {
      final fields = data.fields.map((f) => '${f.key}: ${f.value}').toList();
      final files = data.files.map((f) => '${f.key}: (File: ${f.value.filename})').toList();
      return 'FormData:\n  Fields: $fields\n  Files: $files';
    }
    if (data is Map || data is List) {
      try {
        return _encoder.convert(data);
      } catch (_) {
        return data.toString();
      }
    }
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        return _encoder.convert(decoded);
      } catch (_) {
        return data;
      }
    }
    return data.toString();
  }

  String _generateCurl(RequestOptions options) {
    final components = <String>[];
    components.add('curl -X ${options.method.toUpperCase()}');
    components.add('\'${options.uri.toString()}\'');

    // Headers
    options.headers.forEach((k, v) {
      if (k.toLowerCase() != 'content-length') {
        components.add('-H \'$k: $v\'');
      }
    });

    // Content Type if not in headers
    if (options.contentType != null &&
        !options.headers.keys.any((k) => k.toLowerCase() == 'content-type')) {
      components.add('-H \'content-type: ${options.contentType}\'');
    }

    // Body
    if (options.data != null) {
      if (options.data is FormData) {
        final formData = options.data as FormData;
        for (final field in formData.fields) {
          components.add('-F \'${field.key}=${field.value}\'');
        }
        for (final file in formData.files) {
          components.add('-F \'${file.key}=@${file.value.filename ?? "file"}\'');
        }
      } else if (options.data is Map) {
        final isForm = options.contentType == Headers.formUrlEncodedContentType ||
            options.headers['content-type'] == Headers.formUrlEncodedContentType ||
            options.headers['Content-Type'] == Headers.formUrlEncodedContentType;

        if (isForm) {
          final formStr = (options.data as Map).entries.map((e) {
            final key = Uri.encodeQueryComponent(e.key.toString());
            final val = Uri.encodeQueryComponent(e.value.toString());
            return '$key=$val';
          }).join('&');
          components.add('--data \'$formStr\'');
        } else {
          try {
            final jsonStr = jsonEncode(options.data);
            components.add('--data-raw \'$jsonStr\'');
          } catch (_) {
            components.add('--data \'${options.data}\'');
          }
        }
      } else if (options.data is String) {
        components.add('--data \'${options.data}\'');
      } else {
        components.add('--data \'${options.data.toString()}\'');
      }
    }

    return components.join(' \\\n  ');
  }

  void _printLog(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
