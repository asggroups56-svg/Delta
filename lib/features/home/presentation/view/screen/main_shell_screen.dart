import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';
import 'package:my_template/features/company/presentation/view/cubit/company_cubit.dart';
import 'package:my_template/features/company/presentation/view/screen/company_profile_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/home_screen.dart';
import 'package:my_template/features/home/presentation/view/widget/accounting_dashboard_shell_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/ai_chat_bottom_sheet_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/aipulsing_fab_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/bottom_nav_bar_widget.dart';
import 'package:my_template/features/knowledge/presentation/view/screen/knowledge_screen.dart';
import 'package:my_template/features/reports/presentation/view/screen/reports_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  // Cubits are created once and owned by this State, so toggling the language
  // never recreates providers / subtrees (and their running animations).
  CompanyCubit? _homeCompanyCubit;
  CompanyCubit? _profileCompanyCubit;
  String? _languageCode;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final code = context.locale.languageCode;

    if (_homeCompanyCubit == null) {
      _homeCompanyCubit = sl<CompanyCubit>()..getCompany(languageCode: code);
      _profileCompanyCubit = sl<CompanyCubit>();
    } else if (_languageCode != code) {
      // Language changed -> refetch company data in the new language.
      _homeCompanyCubit!.getCompany(languageCode: code);
    }
    _languageCode = code;
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _homeCompanyCubit?.close();
    _profileCompanyCubit?.close();
    super.dispose();
  }

  Future<void> _toggleLanguage() async {
    final next = context.locale.languageCode == 'ar' ? 'en' : 'ar';
    await context.setLocale(Locale(next));
    if (mounted) setState(() {});
  }

  Future<void> _logout() async {
    // Call auth/logout API first, then navigate to login
    await sl<AuthCubit>().logout();
    if (!mounted) return;
    NavigatorMethods.pushReplacementNamed(context, RoutesName.loginScreen);
  }

  void _openAiChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AiChatBottomSheetWidget(),
    );
  }

  void _onTabChanged(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
    _fadeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    // New instances on every build so Home/Profile pick up the new locale,
    // while the cubits (and the element tree) stay the same.
    final pages = <Widget>[
      BlocProvider<CompanyCubit>.value(
        value: _homeCompanyCubit!,
        child: HomeScreen(
          embeddedInShell: true,
          onAiTap: _openAiChat,
          onToggleLanguage: _toggleLanguage,
        ),
      ),
      const AccountingDashboardShell(),
      const ReportsScreen(),
      const KnowledgeScreen(),
      BlocProvider<CompanyCubit>.value(
        value: _profileCompanyCubit!,
        child: CompanyProfileScreen(
          onLogout: _logout,
          onToggleLanguage: _toggleLanguage,
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: Stack(
        children: [
          // ── Main Content with fade transition ────────────────────
          FadeTransition(
            opacity: _fadeAnimation,
            child: IndexedStack(index: _currentIndex, children: pages),
          ),

          // ── Floating AI Pill FAB ─────────────────────────────────
          Positioned(
            bottom: 20.h,
            right: 20.w,
            child: AiPulsingFab(onTap: _openAiChat),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}
