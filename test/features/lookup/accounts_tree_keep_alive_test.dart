import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/cubit/app_theme_cubit.dart';
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
        _account(11, 2, 'الأصول المتداولة', 1),
        _account(1101, 3, 'النقدية بالصندوق', 11),
        _account(2, 1, 'الخصوم', null),
      ],
      'hasMore': false,
      'success': true,
      'totalRecords': 4,
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

void main() {
  testWidgets('tree keeps its expanded state while scrolling away and back', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final api = _CountingApi();
    sl.registerSingleton<LookupRepo>(LookupRepoImpl(api));
    addTearDown(sl.reset);

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar')],
        path: 'i18n',
        fallbackLocale: const Locale('ar'),
        startLocale: const Locale('ar'),
        child: BlocProvider<AppThemeCubit>(
          create: (_) => AppThemeCubit(),
          child: ScreenUtilInit(
            designSize: const Size(390, 800),
            builder: (context, child) => Builder(
              builder: (context) => MaterialApp(
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                home: Scaffold(
                  body: ListView(
                    children: const [
                      AccountsTreeSection(),
                      SizedBox(height: 3000),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    expect(api.treeRequests, 1);
    expect(find.text('الأصول المتداولة'), findsOneWidget);

    // Collapse the root manually.
    await tester.tap(find.text('الأصول'));
    await tester.pumpAndSettle();
    expect(find.text('الأصول المتداولة'), findsNothing);

    // Scroll far enough for the section to leave the viewport, then return.
    await tester.drag(find.byType(ListView), const Offset(0, -2500));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 3000));
    await tester.pumpAndSettle();

    // The tree must not refetch or silently expand again.
    expect(api.treeRequests, 1);
    expect(find.text('الأصول المتداولة'), findsNothing);
  });
}
