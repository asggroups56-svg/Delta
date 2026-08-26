import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/home/presentation/view/widget/ai_chat_bottom_sheet_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/ai_fab_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/category_filters_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/dashboard_top_header_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/documents_header_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/folder_list_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/grid_modules_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/side_drawer_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/welcome_banner_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _toggleLanguage() async {
    if (context.locale.languageCode == 'ar') {
      await context.setLocale(const Locale('en'));
    } else {
      await context.setLocale(const Locale('ar'));
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _logout() {
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

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gridModules = [
      {'id': 'discussion', 'title': AppLocaleKey.moduleDiscuss.tr(),       'icon': Icons.chat_bubble_outline_rounded,    'gradient': [const Color(0xFFFF7675), const Color(0xFFE84393)]},
      {'id': 'knowledge',  'title': AppLocaleKey.moduleKnowledge.tr(),     'icon': Icons.collections_bookmark_outlined,  'gradient': [AppColor.mintTeal, AppColor.oceanBlue]},
      {'id': 'dashboards', 'title': AppLocaleKey.moduleReports.tr(),       'icon': Icons.dashboard_customize_outlined,   'gradient': [AppColor.purpleAccent, const Color(0xFFA29BFE)]},
      {'id': 'accounting', 'title': AppLocaleKey.moduleAccounting.tr(),    'icon': Icons.account_balance_outlined,       'gradient': [AppColor.emeraldTeal, AppColor.mintTeal]},
      {'id': 'documents',  'title': AppLocaleKey.moduleDocuments.tr(),     'icon': Icons.folder_special_outlined,        'gradient': [const Color(0xFFFDCB6E), AppColor.warningOrange]},
      {'id': 'apps',       'title': AppLocaleKey.moduleApps.tr(),          'icon': Icons.grid_view_rounded,              'gradient': [AppColor.oceanBlue, AppColor.skyBlue]},
      {'id': 'settings',   'title': AppLocaleKey.moduleSettings.tr(),      'icon': Icons.settings_outlined,              'gradient': [const Color(0xFF636E72), const Color(0xFFB2BEC3)]},
    ];

    final List<Map<String, dynamic>> documentFolders = [
      {'name': AppLocaleKey.folderInsurance.tr(),      'count': AppLocaleKey.folderInsuranceCount.tr(),     'icon': Icons.security_rounded,                   'color': AppColor.emeraldTeal},
      {'name': AppLocaleKey.folderLoans.tr(),          'count': AppLocaleKey.folderLoansCount.tr(),         'icon': Icons.account_balance_wallet_outlined,    'color': AppColor.oceanBlue},
      {'name': AppLocaleKey.folderRegistrations.tr(),  'count': AppLocaleKey.folderRegistrationsCount.tr(), 'icon': Icons.assignment_outlined,                 'color': AppColor.purpleAccent},
      {'name': AppLocaleKey.folderContracts.tr(),      'count': AppLocaleKey.folderContractsCount.tr(),     'icon': Icons.description_outlined,               'color': AppColor.warningOrange},
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.darkBackground,
      drawer: SideDrawerWidget(
        onTap: _logout,
        openAiChatTap: () {
          Navigator.pop(context);
          _openAiChat();
        },
      ),
      floatingActionButton: const AiFabWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardTopHeaderWidget(
                title: AppLocaleKey.dashboardLabel.tr(),
                subtitle: 'Delta ERP Solutions',
                onToggleLanguage: _toggleLanguage,
                onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              Gap(20.h),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16.w), child: const WelcomeBannerWidget()),
              Gap(20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  AppLocaleKey.mainModules.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.whiteColor(context).withValues(alpha: 0.7),
                  ),
                ),
              ),
              Gap(12.h),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16.w), child: GridModulesWidget(modules: gridModules)),
              Gap(28.h),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16.w), child: const DocumentsHeaderWidget()),
              Gap(16.h),
              Padding(padding: EdgeInsets.only(left: 16.w), child: const CategoryFiltersWidget()),
              Gap(16.h),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16.w), child: FolderListWidget(folders: documentFolders)),
              Gap(100.h),
            ],
          ),
        ),
      ),
    );
  }
}
