import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
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
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
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

    await tester.enterText(
      find.byType(TextFormField).first,
      'company.delta-icloud.com',
    );
    await tester.ensureVisible(find.text('متابعة إلى تسجيل الدخول'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('متابعة إلى تسجيل الدخول'));
    await tester.pumpAndSettle();

    expect(find.text('اختر القسم الذي تريد البدء منه'), findsOneWidget);
  });

  testWidgets('renders at tablet width without overflow', (tester) async {
    await pumpScreen(tester, size: const Size(1200, 900));

    expect(find.text('المحاسبة'), findsWidgets);
    expect(find.text('المخزون'), findsWidgets);
  });
}
