import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/features/lookup/data/models/assistant_code_light_model.dart';
import 'package:my_template/features/lookup/data/models/category_light_model.dart';
import 'package:my_template/features/lookup/data/repository/lookup_repo.dart';

/// Records the path/body of the last POST so the account lookup endpoint can be
/// asserted without touching the network.
class _RecordingApiConsumer implements ApiConsumer {
  _RecordingApiConsumer({this.response});

  final Map<String, dynamic>? response;
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
    return response ??
        <String, dynamic>{
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
  group('CategoryLightModel', () {
    test('parses account and center category fields', () {
      final accountCategory = CategoryLightModel.fromJson(<String, dynamic>{
        'catId': 12,
        'catName': 'الأصول',
        'ecatName': 'Assets',
      });
      final centerCategory = CategoryLightModel.fromJson(<String, dynamic>{
        'centerCatId': 4,
        'centerCatName': 'الإدارات',
        'ecenterCatName': 'Departments',
      });

      expect(accountCategory.categoryNo, 12);
      expect(accountCategory.categoryName, 'الأصول');
      expect(centerCategory.categoryNo, 4);
      expect(centerCategory.categoryName, 'الإدارات');
    });
  });

  group('LookupRepoImpl category methods', () {
    test('posts account categories to AccCat/GetLight', () async {
      final api = _RecordingApiConsumer(
        response: <String, dynamic>{
          'accCats': <Map<String, dynamic>>[
            <String, dynamic>{'accCatNo': 12, 'accCatName': 'Assets'},
          ],
        },
      );
      final repo = LookupRepoImpl(api);

      final result = await repo.getAccountCategoriesLight(languageCode: 'en');

      expect(result.isRight(), isTrue);
      expect(api.lastPath, EndPoints.accountCategoryLight);
      expect(api.lastBody, <String, dynamic>{
        'idAsString': null,
        'SearchWord': null,
        'page': '1',
        'pageSize': '100',
      });
      result.fold((_) => fail('Expected account category data'), (response) {
        expect(response.categories.single.categoryNo, 12);
      });
    });

    test('posts center categories to CenterCat/Get', () async {
      final api = _RecordingApiConsumer(
        response: <String, dynamic>{
          'centerCats': <Map<String, dynamic>>[
            <String, dynamic>{'centerCatNo': 4, 'centerCatName': 'Departments'},
          ],
        },
      );
      final repo = LookupRepoImpl(api);

      final result = await repo.getCenterCategories(languageCode: 'en');

      expect(result.isRight(), isTrue);
      expect(api.lastPath, EndPoints.centerCategory);
      expect(api.lastPath, 'CenterCat/Get');
      expect(api.lastBody, <String, dynamic>{
        'idAsString': null,
        'SearchWord': null,
        'page': '1',
        'pageSize': '100',
      });
      result.fold((_) => fail('Expected center category data'), (response) {
        expect(response.categories.single.categoryNo, 4);
      });
    });
  });

  group('AssistantCodeLightModel', () {
    test('parses assistant identifiers with different naming conventions', () {
      final model = AssistantCodeLightModel.fromJson(<String, dynamic>{
        'Assistant_Account_Id': '301',
        'AssistantCodeName': 'Assistant account',
      });

      expect(model.assistantCode, 301);
      expect(model.assistantName, 'Assistant account');
    });

    test('uses the only numeric identifier when its field name differs', () {
      final model = AssistantCodeLightModel.fromJson(<String, dynamic>{
        'assistant': 301,
        'assistantName': 'Assistant account',
      });

      expect(model.assistantCode, 301);
    });

    test('includes available field names when the identifier is ambiguous', () {
      expect(
        () => AssistantCodeLightModel.fromJson(<String, dynamic>{
          'description': 'Assistant account',
          'active': true,
        }),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            contains('description, active'),
          ),
        ),
      );
    });
  });

  group('LookupRepoImpl.getAssistantCode', () {
    test('posts the first 100 assistant codes to AssistantCode/Get', () async {
      final api = _RecordingApiConsumer(
        response: <String, dynamic>{
          'assistantCodes': <Map<String, dynamic>>[
            <String, dynamic>{
              'assCode': 301,
              'assName': 'Assistant account',
              'assEname': 'Assistant account English',
            },
          ],
        },
      );
      final repo = LookupRepoImpl(api);

      final result = await repo.getAssistantCode(languageCode: 'en');

      expect(result.isRight(), isTrue);
      expect(api.lastPath, 'AssistantCode/Get');
      expect(api.lastBody, <String, dynamic>{
        'idAsString': null,
        'SearchWord': null,
        'page': '1',
        'pageSize': '100',
      });
      result.fold((_) => fail('Expected assistant codes to be parsed'), (
        response,
      ) {
        expect(response.assistantCodes.single.assistantCode, 301);
        expect(
          response.assistantCodes.single.assistantName,
          'Assistant account',
        );
      });
    });
  });

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
      expect(api.lastBody, isNot(contains('AccountType')));
      expect(api.lastBody?['FromAccountNo'], isNull);
      expect(api.lastBody?['ToAccountNo'], isNull);
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

    test('forwards the account level filter', () async {
      final api = _RecordingApiConsumer();
      final repo = LookupRepoImpl(api);

      final result = await repo.getChartOfAccountLight(
        languageCode: 'en',
        accountType: null,
        accountLevel: 1,
      );

      expect(result.isRight(), isTrue);
      expect(api.lastPath, 'ChartOfAccount/GetLight');
      expect(api.lastBody?['AccountType'], isNull);
      expect(api.lastBody?['AccountLevel'], 1);
    });

    test('forwards the selected account range', () async {
      final api = _RecordingApiConsumer();
      final repo = LookupRepoImpl(api);

      final result = await repo.getChartOfAccountLight(
        languageCode: 'en',
        fromAccountNo: 1101,
        toAccountNo: 1200,
      );

      expect(result.isRight(), isTrue);
      expect(api.lastPath, 'ChartOfAccount/GetLight');
      expect(api.lastBody?['FromAccountNo'], 1101);
      expect(api.lastBody?['ToAccountNo'], 1200);
    });

    test(
      'supports the assistant-ledger account lookup request shape',
      () async {
        final api = _RecordingApiConsumer();
        final repo = LookupRepoImpl(api);

        final result = await repo.getChartOfAccountLight(
          languageCode: 'en',
          accountType: 1,
          includeAccountRangeFields: false,
          includeAccountsHasCostCenters: null,
          pageSize: 100,
        );

        expect(result.isRight(), isTrue);
        expect(api.lastPath, 'ChartOfAccount/GetLight');
        expect(api.lastBody, <String, dynamic>{
          'AccountType': 1,
          'idAsString': null,
          'SearchWord': null,
          'page': '1',
          'pageSize': '100',
        });
      },
    );

    test(
      'supports the period trial balance account-level lookup request shape',
      () async {
        final api = _RecordingApiConsumer();
        final repo = LookupRepoImpl(api);

        final result = await repo.getChartOfAccountLight(
          languageCode: 'en',
          accountType: null,
          accountLevel: 1,
          includeAccountRangeFields: false,
          includeAccountsHasCostCenters: null,
          pageSize: 100,
        );

        expect(result.isRight(), isTrue);
        expect(api.lastPath, 'ChartOfAccount/GetLight');
        expect(api.lastBody, <String, dynamic>{
          'idAsString': null,
          'SearchWord': null,
          'page': '1',
          'pageSize': '100',
          'AccountLevel': 1,
        });
      },
    );
  });

  group('LookupRepoImpl.getCostCenterLight', () {
    test(
      'posts center selection to CostCenter/GetLight with level/type',
      () async {
        final api = _RecordingApiConsumer(
          response: <String, dynamic>{
            'costCenters': <Map<String, dynamic>>[
              <String, dynamic>{
                'costCenterNo': 1,
                'centerName': 'Main Center',
                'centerParent': null,
              },
            ],
            'hasMore': false,
            'success': true,
            'message': '',
            'totalRecords': 1,
          },
        );
        final repo = LookupRepoImpl(api);

        final result = await repo.getCostCenterLight(
          languageCode: 'en',
          centerType: null,
          centerKind: null,
          centerLevel: 1,
          accountType: 1,
          pageSize: 10,
        );

        expect(result.isRight(), isTrue);
        expect(api.lastPath, EndPoints.costCenterLight);
        expect(api.lastPath, 'CostCenter/GetLight');
        expect(api.lastBody, <String, dynamic>{
          'idAsString': null,
          'SearchWord': null,
          'page': '1',
          'pageSize': '10',
          'CenterLevel': 1,
          'AccountType': 1,
        });
        expect(api.lastOptions?.headers?['Accept-Language'], 'en');
      },
    );
  });

  group('LookupRepoImpl.getCurrencyDataLight', () {
    test('posts the requested page to CurrencyData/GetLight', () async {
      final api = _RecordingApiConsumer(
        response: <String, dynamic>{
          'currencyDatas': <Map<String, dynamic>>[
            <String, dynamic>{
              'currencyCode': 1,
              'currencyName': 'Local currency',
            },
          ],
        },
      );
      final repo = LookupRepoImpl(api);

      final result = await repo.getCurrencyDataLight(languageCode: 'ar');

      expect(result.isRight(), isTrue);
      expect(api.lastPath, EndPoints.currencyDataLight);
      expect(api.lastPath, 'CurrencyData/GetLight');
      expect(api.lastBody, <String, dynamic>{
        'idAsString': null,
        'SearchWord': null,
        'page': '1',
        'pageSize': '3',
      });
      expect(api.lastOptions?.headers?['Accept-Language'], 'ar');
      result.fold((_) => fail('Expected currencies to be parsed'), (response) {
        expect(response.currencies.single.currencyCode, '1');
        expect(response.currencies.single.currencyName, 'Local currency');
      });
    });
  });
}
