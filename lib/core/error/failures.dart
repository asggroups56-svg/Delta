// lib/core/network/error_handler.dart

import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../network/status_code.dart';

/// Base class for all failures, holds an error message.
abstract class Failure {
  final String errMessage;
  const Failure(this.errMessage);
}

/// Represents a failure coming from Dio / the server.
class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure(super.errMessage, {this.statusCode});

  /// Map Dio exceptions to our ServerFailure, extracting server‑side messages when present.
  factory ServerFailure.fromDioError(DioException dioError) {
    try {
      final statusCode = dioError.response?.statusCode;

      // Handle 404 and 401/403 status codes with localized Arabic messages
      if (statusCode == StatusCode.notFound || statusCode == 404) {
        return ServerFailure('لا توجد بيانات', statusCode: 404);
      }
      if (statusCode == StatusCode.unauthorized || statusCode == 401) {
        return ServerFailure('لا توجد صلاحيات', statusCode: 401);
      }
      if (statusCode == StatusCode.forbidden || statusCode == 403) {
        return ServerFailure('لا توجد صلاحيات', statusCode: 403);
      }

      // Attempt to parse raw response data into a Map<String, dynamic>
      final raw = dioError.response?.data;
      Map<String, dynamic>? map;
      if (raw != null) {
        if (raw is Map<String, dynamic>) {
          map = raw;
        } else if (raw is String) {
          try {
            map = jsonDecode(raw) as Map<String, dynamic>;
          } catch (_) {
            map = null;
          }
        } else if (raw is List<int>) {
          try {
            final decoded = utf8.decode(raw);
            map = jsonDecode(decoded) as Map<String, dynamic>;
          } catch (_) {
            map = null;
          }
        }
      }

      final languageCode = dioError.requestOptions.headers['Accept-Language']
          ?.toString()
          .toLowerCase();
      final isArabic = languageCode?.startsWith('ar') ?? false;
      if (map != null) {
        final localizedMessage = _localizedResponseMessage(map, isArabic);
        if (localizedMessage != null) {
          return ServerFailure(localizedMessage, statusCode: statusCode);
        }
      }

      // If we got a JSON map with a "message" field, return it immediately
      // Otherwise fall back based on DioException type
      switch (dioError.type) {
        case DioExceptionType.connectionTimeout:
          return ServerFailure('Connection timeout with API server', statusCode: statusCode);
        case DioExceptionType.sendTimeout:
          return ServerFailure('Send timeout with API server', statusCode: statusCode);
        case DioExceptionType.receiveTimeout:
          return ServerFailure('Receive timeout with API server', statusCode: statusCode);
        case DioExceptionType.cancel:
          return ServerFailure('Request to API server was cancelled', statusCode: statusCode);
        case DioExceptionType.connectionError:
          return ServerFailure('No internet connection', statusCode: statusCode);
        case DioExceptionType.unknown:
          return ServerFailure('Unexpected error, please try again!', statusCode: statusCode);
        case DioExceptionType.badResponse:
          return ServerFailure.fromResponse(
            statusCode,
            map ?? raw,
          );
        default:
          return ServerFailure('Oops! There was an error, please try again.', statusCode: statusCode);
      }
    } catch (e, stack) {
      log('ServerFailure.fromDioError error: $e\n$stack');
      return ServerFailure('An unknown error occurred');
    }
  }

  /// Handle different status codes, prioritizing 404 & 401/403 requirements.
  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    try {
      if (statusCode == StatusCode.notFound || statusCode == 404) {
        return ServerFailure('لا توجد بيانات', statusCode: 404);
      }
      if (statusCode == StatusCode.unauthorized || statusCode == 401) {
        return ServerFailure('لا توجد صلاحيات', statusCode: 401);
      }
      if (statusCode == StatusCode.forbidden || statusCode == 403) {
        return ServerFailure('لا توجد صلاحيات', statusCode: 403);
      }

      if (statusCode == 422) {
        final serverMessage = _responseMessage(response);
        if (serverMessage != null) {
          return ServerFailure(serverMessage, statusCode: statusCode);
        }
      }

      if (response is Map<String, dynamic> &&
          response['message'] is String &&
          (response['message'] as String).trim().isNotEmpty) {
        return ServerFailure(response['message'] as String, statusCode: statusCode);
      }

      switch (statusCode) {
        case StatusCode.badRequest:
          return ServerFailure('Invalid request, please check your input', statusCode: statusCode);
        case StatusCode.internalServerError:
          return ServerFailure('Internal server error, please try later', statusCode: statusCode);
        default:
          return ServerFailure('Request failed with status $statusCode', statusCode: statusCode);
      }
    } catch (e) {
      return ServerFailure('Failed to parse server response', statusCode: statusCode);
    }
  }
}

String? _responseMessage(dynamic response) {
  if (response is String && response.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(response);
      final decodedMessage = _responseMessage(decoded);
      if (decodedMessage != null) return decodedMessage;
    } catch (_) {
      return response.trim();
    }
  }
  if (response is Map) {
    for (final key in const [
      'message',
      'Message',
      'detail',
      'title',
      'error',
    ]) {
      final value = response[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    final errors = response['errors'];
    if (errors is Map) {
      for (final value in errors.values) {
        final message = _responseMessage(value);
        if (message != null) return message;
      }
    } else if (errors is List) {
      return _responseMessage(errors);
    }
  }
  if (response is List) {
    for (final value in response) {
      final message = _responseMessage(value);
      if (message != null) return message;
    }
  }
  return null;
}

String? _localizedResponseMessage(Map<String, dynamic> response, bool isArabic) {
  final localizedKeys = isArabic
      ? const ['messageAr', 'MessageAr', 'errorAr', 'ErrorAr', 'titleAr']
      : const ['messageEn', 'MessageEn', 'errorEn', 'ErrorEn', 'titleEn'];
  for (final key in localizedKeys) {
    final value = response[key];
    if (value is String && value.trim().isNotEmpty) return value;
  }
  for (final key in const ['message', 'Message', 'detail', 'title', 'error']) {
    final value = response[key];
    if (value is String && value.trim().isNotEmpty) return value;
  }
  final errors = response['errors'];
  if (errors is Map) {
    for (final value in errors.values) {
      if (value is String && value.trim().isNotEmpty) return value;
      if (value is List && value.isNotEmpty) return value.first.toString();
    }
  } else if (errors is List && errors.isNotEmpty) {
    return errors.first.toString();
  }
  return null;
}

/// Executes any Dio request and returns either the parsed data or a Failure.
Future<Either<Failure, T>> handleDioRequest<T>({
  required Future<T> Function() request,
}) async {
  try {
    final response = await request();
    return Right(response);
  } on DioException catch (e) {
    // Debug logs
    log('[DioException] ➜ ${e.message}');
    if (e.response?.data != null) {
      final serverMsg = _extractServerMessage(e.response!.data);
      log('[Server message] ➜ $serverMsg');
    }
    return Left(ServerFailure.fromDioError(e));
  } catch (e, stack) {
    log('[Unknown Error] ➜ $e');
    log('[StackTrace] ➜ $stack');
    return Left(ServerFailure(e.toString()));
  }
}

/// Helper to grab "message" from raw response data for logging.
String? _extractServerMessage(dynamic rawData) {
  try {
    if (rawData is Map<String, dynamic> && rawData['message'] is String) {
      return rawData['message'] as String;
    }
    if (rawData is String) {
      final decoded = jsonDecode(rawData);
      if (decoded is Map<String, dynamic> && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    }
    if (rawData is List<int>) {
      final decoded = jsonDecode(utf8.decode(rawData));
      if (decoded is Map<String, dynamic> && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    }
  } catch (_) {}
  return null;
}
