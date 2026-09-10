part of 'app_routers_import.dart';

class AppRouters {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RoutesName.onboardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case RoutesName.mainShellScreen:
        return MaterialPageRoute(builder: (_) => const MainShellScreen());
      case RoutesName.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RoutesName.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: const LoginScreen(),
          ),
        );
      case RoutesName.signupScreen:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
        );
      case RoutesName.forgotPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );
      case RoutesName.accountingDashboardScreen:
        return MaterialPageRoute(
          builder: (_) => const AccountingDashboardScreen(),
        );
      case RoutesName.reportsScreen:
        return MaterialPageRoute(
          builder: (_) => const ReportsScreen(),
        );
      case RoutesName.knowledgeScreen:
        return MaterialPageRoute(
          builder: (_) => const KnowledgeScreen(),
        );
      case RoutesName.createInvoiceScreen:
        return MaterialPageRoute(
          builder: (_) => const CreateInvoiceScreen(),
        );
      case RoutesName.addLeadScreen:
        return MaterialPageRoute(
          builder: (_) => const AddLeadScreen(),
        );
      case RoutesName.scanUploadScreen:
        return MaterialPageRoute(
          builder: (_) => const ScanUploadScreen(),
        );
      case RoutesName.aiCopilotScreen:
        return MaterialPageRoute(
          builder: (_) => const AiCopilotScreen(),
        );

      default:
        return null;
    }
  }
}
