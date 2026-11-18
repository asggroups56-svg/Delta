import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/core/app_size/adaptive_screen_util.dart';
import 'package:my_template/core/cache/shared_pref/shared_pref.dart';
import 'package:my_template/core/theme/cubit/app_theme_cubit.dart';
import 'package:my_template/features/auth/presentation/view/screen/account_access_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The screen renders hardcoded Arabic/English copy, so tests only need the
/// localization delegate to resolve a locale without touching bundled assets.
class _EmptyAssetLoader extends AssetLoader {
  const _EmptyAssetLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async => {};
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper().init();
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'i18n',
        assetLoader: const _EmptyAssetLoader(),
        useFallbackTranslations: false,
        fallbackLocale: const Locale('ar'),
        startLocale: const Locale('ar'),
        child: AdaptiveScreenUtilInit(
          builder: (context, child) => BlocProvider(
            create: (_) => AppThemeCubit(),
            child: MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: const AccountAccessScreen(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the five requested sections', (tester) async {
    await pumpScreen(tester);

    for (final label in const [
      'المحاسبة',
      'الأصول',
      'المبيعات',
      'المشتريات',
      'المخزون',
    ]) {
      expect(find.text(label), findsWidgets);
    }
    expect(find.text('متابعة إلى تسجيل الدخول'), findsOneWidget);
  });

  testWidgets('asks for a section before continuing', (tester) async {
    await pumpScreen(tester);

    await tester.ensureVisible(find.text('متابعة إلى تسجيل الدخول'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('متابعة إلى تسجيل الدخول'));
    await tester.pumpAndSettle();

    expect(find.text('اختر القسم الذي تريد البدء منه'), findsOneWidget);
  });

  testWidgets('leaves the connection name to the login screen', (tester) async {
    await pumpScreen(tester);

    expect(find.byType(TextFormField), findsNothing);
    expect(find.text('اسم الاتصال'), findsNothing);

    await tester.tap(find.text('المحاسبة').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('delta-icloud'), findsNothing);
  });

  testWidgets('renders at tablet width without overflow', (tester) async {
    await pumpScreen(tester, size: const Size(1200, 900));

    expect(find.text('المحاسبة'), findsWidgets);
    expect(find.text('المخزون'), findsWidgets);
  });
}
