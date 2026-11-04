import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/features/lookup/data/repository/lookup_repo.dart';

/// Records the path/body of the last POST so the account lookup endpoint can be
/// asserted without touching the network.
class _RecordingApiConsumer implements ApiConsumer {
  String? lastPath;
  Map<String, dynamic>? lastBody;
  Options? lastOptions;

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? isFormData,
    Options? options,
  }) async {
    lastPath = path;
    lastBody = body;
    lastOptions = options;
    return <String, dynamic>{
      'chartOfAccounts': <Map<String, dynamic>>[
        <String, dynamic>{
          'accountNo': 1101,
          'accountLevel': 2,
          'accountName': 'Cash',
          'accountParent': 1100,
          'cauDistributed': 0,
        },
      ],
      'hasMore': false,
      'success': true,
      'message': '',
      'totalRecords': 1,
    };
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => throw UnimplementedError('Account lookups must use POST.');

  @override
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? isFormData,
    Options? options,
  }) => throw UnimplementedError('Account lookups must use POST.');

  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? isFormData,
    Options? options,
  }) => throw UnimplementedError('Account lookups must use POST.');
}

void main() {
  group('LookupRepoImpl.getChartOfAccountLight', () {
    test('posts account selection to ChartOfAccount/GetLight', () async {
      final api = _RecordingApiConsumer();
      final repo = LookupRepoImpl(api);

      final result = await repo.getChartOfAccountLight(
        languageCode: 'en',
        accountType: null,
        includeAccountsHasCostCenters: true,
        searchWord: 'cash',
        page: 1,
        pageSize: 100,
      );

      expect(result.isRight(), isTrue);
      expect(api.lastPath, EndPoints.chartOfAccountLight);
      expect(api.lastPath, 'ChartOfAccount/GetLight');
      expect(api.lastBody?['AccountType'], isNull);
      expect(api.lastBody?['SearchWord'], 'cash');
      expect(api.lastBody?['page'], '1');
      expect(api.lastBody?['pageSize'], '100');
      expect(api.lastBody?['IncludeAccountsHasCostCenters'], isTrue);
      expect(api.lastOptions?.headers?['Accept-Language'], 'en');
    });

    test('keeps the same endpoint and forwards the account type', () async {
      final api = _RecordingApiConsumer();
      final repo = LookupRepoImpl(api);

      final result = await repo.getChartOfAccountLight(
        languageCode: 'ar',
        accountType: 2,
      );

      expect(result.isRight(), isTrue);
      expect(api.lastPath, 'ChartOfAccount/GetLight');
      expect(api.lastBody?['AccountType'], 2);
      expect(api.lastBody?['SearchWord'], isNull);
      expect(api.lastOptions?.headers?['Accept-Language'], 'ar');
    });

    test('never targets a report endpoint', () async {
      final api = _RecordingApiConsumer();
      final repo = LookupRepoImpl(api);

      await repo.getChartOfAccountLight(languageCode: 'en');

      expect(api.lastPath, isNot(contains('Report/')));
      expect(api.lastPath, isNot(contains('ChartOfAccountReport')));
    });
  });
}
