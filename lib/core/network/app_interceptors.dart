import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../cache/shared_pref/shared_pref.dart';
import '../utils/common_methods.dart';
import 'end_points.dart';

class AppInterceptors extends Interceptor {
  static const String _authorizationScheme = 'Bearer';

  AppInterceptors();
  static bool isInternet = true;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    isInternet = true;
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');

    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    if (!options.path.endsWith(EndPoints.login)) {
      final token = CacheHelper.sharedPreferences.getString(
        CacheHelper.authTokenKey,
      );
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = token.startsWith('Bearer ')
            ? token
            : '$_authorizationScheme $token';
      }
    }

    // Check internet connectivity before sending request.
    if (!await CommonMethods.hasConnection()) {
      isInternet = false;
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'No Internet Connection',
          type: DioExceptionType.connectionError,
        ),
      );
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );

    super.onError(err, handler);
  }
}
