import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/lookup/presentation/widgets/accounts_tree_section.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';
import 'package:my_template/features/home/presentation/view/widget/ai_fab_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/bank_card_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/cash_card_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/dashboard_top_header_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/ifrs_16_card_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/new_entry_bottom_sheet_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/purchases_card_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/sales_card_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/side_drawer_accounting_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/tax_adjustments_card_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/tax_returns_card_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/zakat_card_widget.dart';

class AccountingDashboardScreen extends StatefulWidget {
  final bool embeddedInShell;
  final VoidCallback? onToggleLanguage;

  const AccountingDashboardScreen({
    super.key,
    this.embeddedInShell = false,
    this.onToggleLanguage,
  });

  @override
  State<AccountingDashboardScreen> createState() =>
      _AccountingDashboardScreenState();
}

class _AccountingDashboardScreenState extends State<AccountingDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentView = 0; // 0 = شجرة الحسابات (Tree View), 1 = لوحة المؤشرات والعمليات (Dashboard)

  bool get _isAr => context.locale.languageCode == 'ar';
  String _t(String ar, String en) => _isAr ? ar : en;

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

  Future<void> _logout() async {
    await sl<AuthCubit>().logout();
    if (!mounted) return;
    NavigatorMethods.pushReplacementNamed(context, RoutesName.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.scaffoldColor(context),
      drawer: widget.embeddedInShell
          ? null
          : SideDrawerAccountingWidget(onTap: _logout, openAiChatTap: () {}),
      floatingActionButton: widget.embeddedInShell ? null : const AiFabWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardTopHeaderWidget(
                title: AppLocaleKey.moduleAccounting.tr(),
                subtitle: _t('دليل الحسابات واللوحة المالية', 'Chart of Accounts & Dashboard'),
                onToggleLanguage: _toggleLanguage,
                onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              _buildViewSwitcher(context),
              Gap(10.h),
              if (_currentView == 0)
                // ── شجرة الحسابات بالكامل من أعلى إلى أسفل ──
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const AccountsTreeSection(),
                )
              else
                // ── بطاقات العمليات والمؤشرات ──
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      const SalesCardWidget(),
                    Gap(16.h),
                    const PurchasesCardWidget(),
                    Gap(16.h),
                    const BankCardWidget(),
                    Gap(16.h),
                    const CashCardWidget(),
                    Gap(16.h),
                    TaxAdjustmentsCardWidget(
                      onTap: () {
                        NewEntryBottomSheetWidget.show(
                          context,
                          AppLocaleKey.taxAdjustments.tr(),
                        );
                      },
                    ),
                    Gap(16.h),
                    TaxReturnsCardWidget(
                      onTap: () {
                        NewEntryBottomSheetWidget.show(
                          context,
                          AppLocaleKey.taxReturnsCard.tr(),
                        );
                      },
                    ),
                    Gap(16.h),
                    Ifrs16CardWidget(
                      onTap: () {
                        NewEntryBottomSheetWidget.show(
                          context,
                          AppLocaleKey.ifrs16Asset.tr(),
                        );
                      },
                    ),
                    Gap(16.h),
                    ZakatCardWidget(
                      onTap: () {
                        NewEntryBottomSheetWidget.show(
                          context,
                          AppLocaleKey.zakatLabel.tr(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Gap(widget.embeddedInShell ? 110.h : 80.h),
            ],
          ),
        ),
      ),
    );
 
  }
   Widget _buildViewSwitcher(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: AppColor.cardColor(context),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColor.borderColor(context).withValues(alpha: 0.8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _switcherTab(
                context,
                index: 0,
                icon: Icons.account_tree_rounded,
                label: _t('شجرة الحسابات', 'Chart of Accounts'),
              ),
            ),
            Gap(6.w),
            Expanded(
              child: _switcherTab(
                context,
                index: 1,
                icon: Icons.dashboard_customize_rounded,
                label: _t('لوحة المؤشرات', 'Dashboard Cards'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switcherTab(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentView == index;
    final primary = AppColor.primaryColor(context);

    return GestureDetector(
      onTap: () {
        if (_currentView != index) {
          setState(() => _currentView = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(vertical: 9.h),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.r,
              color: isSelected
                  ? Colors.white
                  : AppColor.darkTextColor(context),
            ),
            Gap(7.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : AppColor.titleFormFiledColor(context),
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 