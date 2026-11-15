import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/core/app_size/adaptive_screen_util.dart';
import 'package:my_template/core/cache/shared_pref/shared_pref.dart';
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/core/theme/cubit/app_theme_cubit.dart';
import 'package:my_template/core/theme/style.dart';
import 'package:my_template/features/auth/data/model/user_model.dart';
import 'package:my_template/features/auth/data/repository/auth_repo.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';
import 'package:my_template/features/auth/presentation/view/screen/account_access_screen.dart';
import 'package:my_template/features/auth/presentation/view/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The auth screens render hardcoded Arabic/English copy, so tests only need
/// the localization delegate to resolve a locale without bundled assets.
class _EmptyAssetLoader extends AssetLoader {
  const _EmptyAssetLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async => {};
}

class _FakeAuthRepo implements AuthRepo {
  @override
  Future<Either<Failure, AuthResponseModel>> login({
    required String username,
    required String password,
    required String connectionName,
  }) async => Left(ServerFailure('not used in this test'));
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Load the real font so text widths match the app and layout overflow
    // regressions are detected (the test default font is much wider).
    final loader = FontLoader('Tajawal')
      ..addFont(rootBundle.load('assets/font/Tajawal-Regular.ttf'))
      ..addFont(rootBundle.load('assets/font/Tajawal-Bold.ttf'));
    await loader.load();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      CacheHelper.selectedModuleKey: 'accounting',
    });
    await CacheHelper().init();
  });

  Future<void> pumpScreen(
    WidgetTester tester,
    Widget screen, {
    required Size size,
    bool withAuthCubit = false,
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
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AppThemeCubit()),
            if (withAuthCubit)
              BlocProvider(create: (_) => AuthCubit(_FakeAuthRepo())),
          ],
          child: AdaptiveScreenUtilInit(
            builder: (context, child) => MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: appThemeData(context),
              home: screen,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  final tabletSizes = <String, Size>{
    'portrait 768x1024': const Size(768, 1024),
    'landscape 1024x768': const Size(1024, 768),
    'small landscape 1024x600': const Size(1024, 600),
    'portrait 834x1194': const Size(834, 1194),
    'landscape 1194x834': const Size(1194, 834),
  };

  for (final entry in tabletSizes.entries) {
    testWidgets('workspace selection renders on tablet ${entry.key}', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        const AccountAccessScreen(),
        size: entry.value,
      );

      expect(find.text('المحاسبة'), findsWidgets);
      expect(find.text('اختر مساحة العمل'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('login renders on tablet ${entry.key}', (tester) async {
      await pumpScreen(
        tester,
        const LoginScreen(),
        size: entry.value,
        withAuthCubit: true,
      );

      expect(find.text('DELTA ASG'), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('keeps the phone layout unchanged', (tester) async {
    await pumpScreen(
      tester,
      const LoginScreen(),
      size: const Size(390, 844),
      withAuthCubit: true,
    );

    expect(find.text('DELTA ASG'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('re-lays out when the tablet is rotated', (tester) async {
    await pumpScreen(
      tester,
      const LoginScreen(),
      size: const Size(768, 1024),
      withAuthCubit: true,
    );

    tester.view.physicalSize = const Size(1024, 768);
    await tester.pumpAndSettle();

    expect(find.text('DELTA ASG'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  group('adaptiveDesignSize', () {
    test('keeps the phone design size on phones', () {
      expect(adaptiveDesignSize(const Size(390, 844)), kDesignSize);
    });

    test('caps the scale on tablets', () {
      for (final size in const [
        Size(768, 1024),
        Size(1024, 768),
        Size(834, 1194),
        Size(1194, 834),
        Size(1920, 1080),
      ]) {
        final design = adaptiveDesignSize(size);
        expect(
          size.width / design.width,
          closeTo(kMaxDesignScale, 0.001),
          reason: 'width scale for $size',
        );
      }
    });
  });
}
