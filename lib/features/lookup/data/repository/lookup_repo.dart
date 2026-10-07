import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/chart_of_account_light_model.dart';
import '../models/cost_center_light_model.dart';
import '../models/customer_datum_light_model.dart';

abstract interface class LookupRepo {
  Future<Either<Failure, ChartOfAccountLightResponse>> getChartOfAccountLight({
    required String languageCode,
    int accountType = 1,
    bool includeAccountsHasCostCenters = true,
    String? searchWord,
    int page = 1,
    int pageSize = 100,
  });

  Future<Either<Failure, CustomerDatumLightResponse>> getCustomerDatumLight({
    required String languageCode,
    required int custSuppType, // 1 = customers, 2 = suppliers
    String? searchWord,
    int page = 1,
    int pageSize = 50,
  });

  Future<Either<Failure, CostCenterLightResponse>> getCostCenterLight({
    required String languageCode,
    int centerType = 1,
    int centerKind = 0,
    String? idAsString,
    String? searchWord,
    int page = 1,
    int pageSize = 20,
  });
}

class LookupRepoImpl implements LookupRepo {
  final ApiConsumer apiConsumer;

  LookupRepoImpl(this.apiConsumer);

  @override
  Future<Either<Failure, ChartOfAccountLightResponse>> getChartOfAccountLight({
    required String languageCode,
    int accountType = 1,
    bool includeAccountsHasCostCenters = true,
    String? searchWord,
    int page = 1,
    int pageSize = 100,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(
          EndPoints.chartOfAccountLight,
          body: {
            'AccountType': accountType,
            'idAsString': null,
            'SearchWord': searchWord,
            'page': page.toString(),
            'pageSize': pageSize.toString(),
            'IncludeAccountsHasCostCenters': includeAccountsHasCostCenters,
          },
          options: Options(
            headers: {
              'Accept-Language': languageCode == 'ar' ? 'ar' : 'en',
            },
          ),
        );
        return ChartOfAccountLightResponse.fromJson(
          response as Map<String, dynamic>,
        );
      },
    );
  }

  @override
  Future<Either<Failure, CustomerDatumLightResponse>> getCustomerDatumLight({
    required String languageCode,
    required int custSuppType,
    String? searchWord,
    int page = 1,
    int pageSize = 50,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(
          EndPoints.customerDatumLight,
          body: {
            'CustSuppType': custSuppType,
            'idAsString': null,
            'SearchWord': searchWord,
            'page': page.toString(),
            'pageSize': pageSize.toString(),
          },
          options: Options(
            headers: {
              'Accept-Language': languageCode == 'ar' ? 'ar' : 'en',
            },
          ),
        );
        return CustomerDatumLightResponse.fromJson(
          response as Map<String, dynamic>,
        );
      },
    );
  }

  @override
  Future<Either<Failure, CostCenterLightResponse>> getCostCenterLight({
    required String languageCode,
    int centerType = 1,
    int centerKind = 0,
    String? idAsString,
    String? searchWord,
    int page = 1,
    int pageSize = 20,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(
          EndPoints.costCenterLight,
          body: {
            'CenterType': centerType,
            'CenterKind': centerKind,
            'idAsString': idAsString,
            'SearchWord': searchWord,
            'page': page.toString(),
            'pageSize': pageSize.toString(),
          },
          options: Options(
            headers: {
              'Accept-Language': languageCode == 'ar' ? 'ar' : 'en',
            },
          ),
        );
        return CostCenterLightResponse.fromJson(
          response as Map<String, dynamic>,
        );
      },
    );
  }
}
