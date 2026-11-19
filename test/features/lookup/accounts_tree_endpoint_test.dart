import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/features/lookup/data/models/accounts_tree_model.dart';
import 'package:my_template/features/lookup/data/repository/lookup_repo.dart';

/// Records the last POST so the accounts-tree request can be asserted without
/// touching the network.
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
      'chartOfAccounts': <Map<String, dynamic>>[],
      'hasMore': false,
      'success': true,
      'message': '',
      'totalRecords': 0,
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

Map<String, dynamic> _account({
  required int accountNo,
  required int accountLevel,
  required String accountName,
  int? accountParent,
  int accountType = 0,
  int finalAccount = 3,
  int acctNature = 0,
  String? eaccountName,
}) {
  return <String, dynamic>{
    'accountNo': accountNo,
    'accountType': accountType,
    'finalAccount': finalAccount,
    'acctNature': acctNature,
    'accountLevel': accountLevel,
    'accountName': accountName,
    'eaccountName': eaccountName ?? accountName,
    'accountParent': accountParent,
    'cauDistributed': 0,
    'currencyCode': null,
    'currencyName': null,
    'currencyExchangeRate': null,
  };
}

void main() {
  group('LookupRepoImpl.getAccountsTree', () {
    test('posts the tree query to ChartOfAccount/GetLight', () async {
      final api = _RecordingApiConsumer();
      final repo = LookupRepoImpl(api);

      final result = await repo.getAccountsTree(languageCode: 'ar');

      expect(result.isRight(), isTrue);
      expect(api.lastPath, EndPoints.chartOfAccountLight);
      expect(api.lastPath, 'ChartOfAccount/GetLight');
      expect(api.lastBody, <String, dynamic>{
        'idAsString': null,
        'SearchWord': null,
        'FromAccountNo': null,
        'ToAccountNo': null,
        'IncludeAccountsHasCostCenters': true,
        'page': '1',
        'pageSize': '10',
      });
      expect(api.lastOptions?.headers?['Accept-Language'], 'ar');
    });

    test('forwards every account filter and paging value', () async {
      final api = _RecordingApiConsumer();
      final repo = LookupRepoImpl(api);

      await repo.getAccountsTree(
        languageCode: 'en',
        accountNo: 11,
        accountName: 'Assets',
        accountType: 0,
        accountLevel: 2,
        page: 3,
        pageSize: 25,
      );

      expect(api.lastPath, 'ChartOfAccount/GetLight');
      expect(api.lastBody, <String, dynamic>{
        'idAsString': null,
        'SearchWord': 'Assets',
        'FromAccountNo': 11,
        'ToAccountNo': 11,
        'IncludeAccountsHasCostCenters': true,
        'AccountType': 0,
        'AccountLevel': 2,
        'page': '3',
        'pageSize': '25',
      });
      expect(api.lastOptions?.headers?['Accept-Language'], 'en');
    });

    test(
      'uses the account number as SearchWord when no name is given',
      () async {
        final api = _RecordingApiConsumer();
        final repo = LookupRepoImpl(api);

        await repo.getAccountsTree(languageCode: 'ar', accountNo: 1101);

        expect(api.lastBody?['SearchWord'], '1101');
        expect(api.lastBody?['FromAccountNo'], 1101);
        expect(api.lastBody?['ToAccountNo'], 1101);
        expect(api.lastBody, isNot(contains('AccountType')));
        expect(api.lastBody, isNot(contains('AccountLevel')));
        expect(api.lastOptions?.headers?['Accept-Language'], 'ar');
      },
    );
  });

  group('AccountsTreeResponse', () {
    test('parses the account fields and builds the parent/child tree', () {
      final response = AccountsTreeResponse.fromJson(<String, dynamic>{
        'chartOfAccounts': <Map<String, dynamic>>[
          _account(accountNo: 1, accountLevel: 1, accountName: 'الاصول'),
          _account(
            accountNo: 11,
            accountLevel: 2,
            accountName: 'الاصول المتداوله',
            accountParent: 1,
          ),
          _account(
            accountNo: 14,
            accountLevel: 2,
            accountName: 'أصول ثابتة',
            accountParent: 1,
            eaccountName: 'Fixed Assets',
          ),
          _account(
            accountNo: 2,
            accountLevel: 1,
            accountName: 'خصوم',
            acctNature: 1,
          ),
        ],
        'hasMore': true,
        'success': true,
        'message': 'تم تحميل الحسابات بنجاح',
        'totalRecords': 4,
      });

      expect(response.success, isTrue);
      expect(response.hasMore, isTrue);
      expect(response.totalRecords, 4);
      expect(response.accounts, hasLength(4));
      expect(response.forest, hasLength(2));

      final assets = response.forest.first;
      expect(assets.account.accountNo, 1);
      expect(assets.children.map((node) => node.account.accountNo), <int>[
        11,
        14,
      ]);

      final fixedAssets = response.accounts.firstWhere(
        (account) => account.accountNo == 14,
      );
      expect(fixedAssets.accountType, 0);
      expect(fixedAssets.finalAccount, 3);
      expect(fixedAssets.acctNature, 0);
      expect(fixedAssets.accountLevel, 2);
      expect(fixedAssets.accountParent, 1);
      expect(fixedAssets.cauDistributed, 0);
      expect(fixedAssets.nameFor(isArabic: false), 'Fixed Assets');
      expect(fixedAssets.nameFor(isArabic: true), 'أصول ثابتة');
    });

    test('sorts siblings and keeps orphaned rows as roots', () {
      final forest = buildAccountsForest(<AccountsTreeModel>[
        AccountsTreeModel.fromJson(
          _account(
            accountNo: 13,
            accountLevel: 2,
            accountName: 'Tax',
            accountParent: 1,
          ),
        ),
        AccountsTreeModel.fromJson(
          _account(accountNo: 1, accountLevel: 1, accountName: 'Assets'),
        ),
        AccountsTreeModel.fromJson(
          _account(
            accountNo: 11,
            accountLevel: 2,
            accountName: 'Current assets',
            accountParent: 1,
          ),
        ),
        // Parent 99 is not in the response (filtered page) -> root.
        AccountsTreeModel.fromJson(
          _account(
            accountNo: 991,
            accountLevel: 3,
            accountName: 'Filtered child',
            accountParent: 99,
          ),
        ),
      ]);

      expect(forest.map((node) => node.account.accountNo), <int>[1, 991]);
      expect(forest.first.children.map((node) => node.account.accountNo), <int>[
        11,
        13,
      ]);
    });

    test('accepts alternate list keys and tolerates an empty payload', () {
      final response = AccountsTreeResponse.fromJson(<String, dynamic>{
        'accountsTree': <Map<String, dynamic>>[
          _account(accountNo: 5, accountLevel: 1, accountName: 'Expenses'),
        ],
        'hasMore': false,
        'success': true,
        'message': '',
        'totalRecords': 1,
      });
      final empty = AccountsTreeResponse.fromJson(<String, dynamic>{});

      expect(response.forest.single.account.accountNo, 5);
      expect(empty.accounts, isEmpty);
      expect(empty.forest, isEmpty);
      expect(empty.totalRecords, 0);
    });
  });
}
