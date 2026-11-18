import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/company_model.dart';

abstract interface class CompanyRepo {
  Future<Either<Failure, CompanyResponse>> getCompany({
    String deltaconfig = '1',
    required String languageCode,
  });
}
class CompanyRepoImpl implements CompanyRepo {
  final ApiConsumer apiConsumer;

  CompanyRepoImpl(this.apiConsumer);

  static const String fallbackAssetPath = 'assets/data/company_config.json';

  @override
  Future<Either<Failure, CompanyResponse>> getCompany({
    String deltaconfig = '1',
    required String languageCode,
  }) async {
    final remote = await handleDioRequest<CompanyResponse>(
      request: () async {
        final response = await apiConsumer.post(
          EndPoints.company,
          body: {
            'Deltaconfig': deltaconfig,
          },
          options: Options(
            headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
          ),
        );
        return CompanyResponse.fromJson(response);
      },
    );

    return remote.fold(
      (failure) async => _loadFallback(failure),
      (data) async {
        if (data.isEmpty) {
          return _loadFallback( ServerFailure('No company data found'));
        }
        return Right(data);
      },
    );
  }

  Future<Either<Failure, CompanyResponse>> _loadFallback(
    Failure failure,
  ) async {
    try {
      final raw = await rootBundle.loadString(fallbackAssetPath);
      final response = CompanyResponse.fromJson(jsonDecode(raw));
      if (!response.isEmpty) {
        return Right(response);
      }
      return Left(failure);
    } catch (_) {
      return Left(failure);
    }
  }
}
