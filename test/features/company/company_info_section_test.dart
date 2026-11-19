import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/cubit/app_theme_cubit.dart';
import 'package:my_template/features/company/data/models/company_model.dart';
import 'package:my_template/features/company/data/repository/company_repo.dart';
import 'package:my_template/features/company/presentation/view/cubit/company_cubit.dart';
import 'package:my_template/features/company/presentation/view/screen/company_profile_screen.dart';
import 'package:my_template/features/company/presentation/view/widget/company_info_section.dart';
import 'package:my_template/features/lookup/data/repository/lookup_repo.dart';
import 'package:my_template/features/lookup/presentation/widgets/accounts_tree_section.dart';

class _CountingApi implements ApiConsumer {
  int treeRequests = 0;

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? isFormData,
    Options? options,
  }) async {
    treeRequests++;
    return <String, dynamic>{
      'chartOfAccounts': <Map<String, dynamic>>[
        _account(1, 1, 'الأصول', null),
        _account(2, 1, 'الخصوم', null),
      ],
      'hasMore': false,
      'success': true,
      'totalRecords': 2,
    };
  }

  static Map<String, dynamic> _account(
    int no,
    int level,
    String name,
    int? parent,
  ) => <String, dynamic>{
    'accountNo': no,
    'accountType': 0,
    'finalAccount': 3,
    'acctNature': 0,
    'accountLevel': level,
    'accountName': name,
    'eaccountName': name,
    'accountParent': parent,
  };

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => throw UnimplementedError();
  @override
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? isFormData,
    Options? options,
  }) => throw UnimplementedError();
  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? isFormData,
    Options? options,
  }) => throw UnimplementedError();
}

class _FakeCompanyRepo implements CompanyRepo {
  _FakeCompanyRepo(this.company);

  final CompanyModel company;

  @override
  Future<Either<Failure, CompanyResponse>> getCompany({
    String deltaconfig = '1',
    required String languageCode,
  }) async => Right(CompanyResponse(companies: [company]));
}

CompanyModel _company() => CompanyModel(
  deltaconfig: '1',
  companyName: 'شركة النظم التطبيقية',
  companyEname: 'Applied Systems',
  fiscalYearBegin: DateTime(2026, 1, 1),
  fiscalYearEnd: DateTime(2026, 12, 31),
  currency: 'ريال سعودي',
  vouichCurrCntr: 4,
  jrlUpdate: 1,
);

Widget _app({required Widget home}) {
  return EasyLocalization(
    supportedLocales: const [Locale('ar')],
    path: 'i18n',
    fallbackLocale: const Locale('ar'),
    startLocale: const Locale('ar'),
    child: BlocProvider<AppThemeCubit>(
      create: (_) => AppThemeCubit(),
      child: ScreenUtilInit(
        designSize: const Size(390, 1200),
        builder: (context, child) => Builder(
          builder: (context) => MaterialApp(
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: home,
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('info section starts closed and toggles on tap', (tester) async {
    await tester.pumpWidget(
      _app(
        home: const Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: CompanyInfoSection(
              icon: Icons.calendar_month_rounded,
              color: Colors.indigo,
              title: 'السنة المالية',
              rows: [Text('بداية السنة')],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('السنة المالية'), findsOneWidget);
    expect(find.text('بداية السنة'), findsNothing);

    await tester.tap(find.text('السنة المالية'));
    await tester.pumpAndSettle();
    expect(find.text('بداية السنة'), findsOneWidget);

    await tester.tap(find.text('السنة المالية'));
    await tester.pumpAndSettle();
    expect(find.text('بداية السنة'), findsNothing);
  });

  testWidgets('company page starts with every section collapsed', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final api = _CountingApi();
    sl.registerSingleton<LookupRepo>(LookupRepoImpl(api));
    addTearDown(sl.reset);

    await tester.pumpWidget(
      _app(
        home: BlocProvider(
          create: (_) => CompanyCubit(_FakeCompanyRepo(_company())),
          child: const CompanyProfileScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    // Section headers are visible while their content stays hidden.
    expect(find.text('السنة المالية'), findsOneWidget);
    expect(find.text('إعدادات اليومية'), findsOneWidget);
    expect(find.text('شجرة الحسابات'), findsOneWidget);
    expect(find.textContaining('بداية السنة المالية'), findsNothing);
    expect(find.byType(AccountsTreeSection), findsNothing);
    expect(api.treeRequests, 0);

    // Opening the chart section builds the tree and fetches accounts.
    await tester.tap(find.text('شجرة الحسابات'));
    await tester.pumpAndSettle();
    expect(find.byType(AccountsTreeSection), findsOneWidget);
    expect(api.treeRequests, 1);

    // Closing it again hides the tree.
    await tester.tap(find.text('شجرة الحسابات'));
    await tester.pumpAndSettle();
    expect(find.byType(AccountsTreeSection), findsNothing);
  });
}
