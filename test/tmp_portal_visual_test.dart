import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/core/app_size/adaptive_screen_util.dart';
import 'package:my_template/core/cache/shared_pref/shared_pref.dart';
import 'package:my_template/core/theme/cubit/app_theme_cubit.dart';
import 'package:my_template/core/theme/style.dart';
import 'package:my_template/core/theme/theme_enum.dart';
import 'package:my_template/features/auth/presentation/view/screen/account_access_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, Map<String, dynamic>> _tr = {};

class _MapAssetLoader extends AssetLoader {
  const _MapAssetLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async =>
      _tr[locale.languageCode];
}

class _DarkCubit extends AppThemeCubit {
  @override
  ThemeEnum get theme => ThemeEnum.dark;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final lang in ['ar', 'en']) {
      _tr[lang] = jsonDecode(File('i18n/$lang.json').readAsStringSync())
          as Map<String, dynamic>;
    }
    final loader = FontLoader('Tajawal')
      ..addFont(rootBundle.load('assets/font/Tajawal-Regular.ttf'))
      ..addFont(rootBundle.load('assets/font/Tajawal-Bold.ttf'))
      ..addFont(rootBundle.load('assets/font/Tajawal-Black.ttf'));
    await loader.load();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper().init();
  });

  Future<void> pumpShot(
    WidgetTester tester, {
    required Size size,
    required Locale locale,
    bool dark = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final themeCubit = dark ? _DarkCubit() : AppThemeCubit();

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'i18n',
        assetLoader: const _MapAssetLoader(),
        fallbackLocale: const Locale('ar'),
        startLocale: locale,
        saveLocale: false,
        child: MultiBlocProvider(
          providers: [BlocProvider(create: (_) => themeCubit)],
          child: AdaptiveScreenUtilInit(
            builder: (context, child) => MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: appThemeData(context),
              home: const RepaintBoundary(
                key: Key('shot'),
                child: AccountAccessScreen(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> shot(String name) async {
    await expectLater(
      find.byKey(const Key('shot')),
      matchesGoldenFile('goldens/$name.png'),
    );
  }

  testWidgets('portal ar phone', (tester) async {
    await pumpShot(
      tester,
      size: const Size(390, 844),
      locale: const Locale('ar'),
    );
    await shot('portal_ar_phone');
    expect(tester.takeException(), isNull);
  });

  testWidgets('portal en phone', (tester) async {
    await pumpShot(
      tester,
      size: const Size(390, 844),
      locale: const Locale('en'),
    );
    await shot('portal_en_phone');
    expect(tester.takeException(), isNull);
  });

  testWidgets('portal ar wide', (tester) async {
    await pumpShot(
      tester,
      size: const Size(1200, 900),
      locale: const Locale('ar'),
    );
    await shot('portal_ar_wide');
    expect(tester.takeException(), isNull);
  });

  testWidgets('portal ar wide tall', (tester) async {
    await pumpShot(
      tester,
      size: const Size(1200, 1500),
      locale: const Locale('ar'),
    );
    await shot('portal_ar_wide_tall');
    expect(tester.takeException(), isNull);
  });

  testWidgets('portal selected module ar phone', (tester) async {
    await pumpShot(
      tester,
      size: const Size(390, 844),
      locale: const Locale('ar'),
    );
    await tester.tap(find.text('المحاسبة').last);
    await tester.pumpAndSettle();
    await shot('portal_ar_selected_phone');
    expect(tester.takeException(), isNull);
  });

  testWidgets('portal ar dark', (tester) async {
    await pumpShot(
      tester,
      size: const Size(390, 844),
      locale: const Locale('ar'),
      dark: true,
    );
    await shot('portal_ar_dark');
    expect(tester.takeException(), isNull);
  });

  testWidgets('portal error state', (tester) async {
    await pumpShot(
      tester,
      size: const Size(390, 844),
      locale: const Locale('ar'),
    );
    await tester.ensureVisible(find.text('متابعة إلى تسجيل الدخول'));
    await tester.tap(find.text('متابعة إلى تسجيل الدخول'));
    await tester.pumpAndSettle();
    await shot('portal_ar_errors');
    expect(tester.takeException(), isNull);
  });

  for (final size in const [
    Size(360, 690),
    Size(320, 568),
    Size(768, 1024),
    Size(1024, 600),
    Size(1200, 900),
  ]) {
    testWidgets('no overflow at $size', (tester) async {
      await pumpShot(tester, size: size, locale: const Locale('ar'));
      await shot('portal_size_${size.width.toInt()}x${size.height.toInt()}');
      expect(tester.takeException(), isNull);
    });
  }
}
