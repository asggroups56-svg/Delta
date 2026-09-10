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
import 'package:my_template/features/home/presentation/view/widget/quick_actions_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/recent_activities_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/side_drawer_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/welcome_banner_widget.dart';

class HomeScreen extends StatefulWidget {
  final bool embeddedInShell;
  final VoidCallback? onAiTap;
  final VoidCallback? onToggleLanguage;

  const HomeScreen({
    super.key,
    this.embeddedInShell = false,
    this.onAiTap,
    this.onToggleLanguage,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _toggleLanguage() async {
    if (widget.onToggleLanguage != null) {
      widget.onToggleLanguage!();
      return;
    }
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
    if (widget.onAiTap != null) {
      widget.onAiTap!();
      return;
    }
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
      {
        'id': 'discussion',
        'title': AppLocaleKey.moduleDiscuss.tr(),
        'icon': Icons.chat_bubble_outline_rounded,
        'gradient': [AppColor.royalIndigo, AppColor.electricCyan],
        'badge': '3',
      },
      {
        'id': 'knowledge',
        'title': AppLocaleKey.moduleKnowledge.tr(),
        'icon': Icons.collections_bookmark_outlined,
        'gradient': [AppColor.indigoLight, AppColor.skyBlue],
        'badge': 'New',
      },
      {
        'id': 'dashboards',
        'title': AppLocaleKey.moduleReports.tr(),
        'icon': Icons.dashboard_customize_outlined,
        'gradient': [AppColor.purpleAccent, AppColor.royalIndigo],
      },
      {
        'id': 'accounting',
        'title': AppLocaleKey.moduleAccounting.tr(),
        'icon': Icons.account_balance_outlined,
        'gradient': [AppColor.emeraldTeal, AppColor.mintTeal],
      },
      {
        'id': 'documents',
        'title': AppLocaleKey.moduleDocuments.tr(),
        'icon': Icons.folder_special_outlined,
        'gradient': [AppColor.warningOrange, const Color(0xFFFBBF24)],
      },
      {
        'id': 'apps',
        'title': AppLocaleKey.moduleApps.tr(),
        'icon': Icons.grid_view_rounded,
        'gradient': [AppColor.electricCyan, AppColor.skyBlue],
      },
      {
        'id': 'settings',
        'title': AppLocaleKey.moduleSettings.tr(),
        'icon': Icons.settings_outlined,
        'gradient': [const Color(0xFF475569), const Color(0xFF64748B)],
      },
    ];

    final List<Map<String, dynamic>> documentFolders = [
      {'name': AppLocaleKey.folderInsurance.tr(),      'count': AppLocaleKey.folderInsuranceCount.tr(),     'icon': Icons.security_rounded,                   'color': AppColor.emeraldTeal},
      {'name': AppLocaleKey.folderLoans.tr(),          'count': AppLocaleKey.folderLoansCount.tr(),         'icon': Icons.account_balance_wallet_outlined,    'color': AppColor.royalIndigo},
      {'name': AppLocaleKey.folderRegistrations.tr(),  'count': AppLocaleKey.folderRegistrationsCount.tr(), 'icon': Icons.assignment_outlined,                 'color': AppColor.purpleAccent},
      {'name': AppLocaleKey.folderContracts.tr(),      'count': AppLocaleKey.folderContractsCount.tr(),     'icon': Icons.description_outlined,               'color': AppColor.warningOrange},
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.darkBackground,
      drawer: widget.embeddedInShell
          ? null
          : SideDrawerWidget(
              onTap: _logout,
              openAiChatTap: () {
                Navigator.pop(context);
                _openAiChat();
              },
            ),
      floatingActionButton: widget.embeddedInShell ? null : const AiFabWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header
              DashboardTopHeaderWidget(
                title: AppLocaleKey.dashboardLabel.tr(),
                subtitle: 'Delta ERP Enterprise',
                onToggleLanguage: _toggleLanguage,
                onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
              ),

              Gap(16.h),

              // 2. Welcome Banner
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const WelcomeBannerWidget(),
              ),

              Gap(18.h),

              // 3. Quick Actions Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: QuickActionsWidget(onAiTap: _openAiChat),
              ),

              Gap(22.h),

              // 4. Main Modules Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocaleKey.mainModules.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.whiteColor(context).withValues(alpha: 0.85),
                        letterSpacing: -0.2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor(context).withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '${gridModules.length} Modules',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColor.emeraldTeal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GridModulesWidget(modules: gridModules),
              ),

              Gap(20.h),

              // 5. Recent Activity Feed
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const RecentActivitiesWidget(),
              ),

              Gap(24.h),

              // 6. Documents & Files Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const DocumentsHeaderWidget(),
              ),
              Gap(14.h),
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: const CategoryFiltersWidget(),
              ),
              Gap(14.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: FolderListWidget(folders: documentFolders),
              ),

              Gap(widget.embeddedInShell ? 110.h : 90.h),
            ],
          ),
        ),
      ),
    );
  }
}
