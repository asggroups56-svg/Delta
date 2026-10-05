import 'package:dartz/dartz.dart';
import 'package:my_template/core/cache/shared_pref/shared_pref.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/core/network/handle_dio_request.dart';

import '../../../../core/error/failures.dart' hide handleDioRequest;
import '../model/user_model.dart';

abstract interface class AuthRepo {
  Future<Either<Failure, AuthResponseModel>> login({
    required String username,
    required String password,
    required String connectionName,
  });
}

class AuthRepoImpl implements AuthRepo {
  final ApiConsumer apiConsumer;
  final CacheHelper cacheHelper;
  AuthRepoImpl(this.apiConsumer, this.cacheHelper);

  @override
  Future<Either<Failure, AuthResponseModel>> login({
    required String username,
    required String password,
    required String connectionName,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(
          EndPoints.login,
          body: {
            'Username': username,
            'Password': password,
            'connectionName': connectionName,
          },
        );
        final authResponse = AuthResponseModel.fromJson(
          Map<String, dynamic>.from(response as Map),
        );
        if (!authResponse.isSuccess) {
          throw Exception(
            authResponse.message.isEmpty
                ? 'Login failed'
                : authResponse.message,
          );
        }
        await cacheHelper.saveData(
          key: CacheHelper.authTokenKey,
          value: authResponse.token,
        );
        await cacheHelper.saveData(
          key: CacheHelper.refreshTokenKey,
          value: authResponse.refreshToken,
        );
        await cacheHelper.saveData(
          key: CacheHelper.connectionNameKey,
          value: connectionName,
        );
        return authResponse;
      },
    );
  }
}
