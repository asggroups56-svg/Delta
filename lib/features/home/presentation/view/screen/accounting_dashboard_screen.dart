import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/home/presentation/view/widget/ai_fab_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/bank_card_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/cash_card_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/dashboard_sub_action_bar_widget.dart';
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
  const AccountingDashboardScreen({super.key});

  @override
  State<AccountingDashboardScreen> createState() => _AccountingDashboardScreenState();
}

class _AccountingDashboardScreenState extends State<AccountingDashboardScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.darkBackground,
      drawer: SideDrawerAccountingWidget(
        onTap: _logout,
        openAiChatTap: () {},
      ),
      floatingActionButton: const AiFabWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardTopHeaderWidget(
                title: AppLocaleKey.moduleAccounting.tr(),
                subtitle: 'نظام المالي والمحاسبة',
                onToggleLanguage: _toggleLanguage,
                onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              const DashboardSubActionBarWidget(),
              Gap(16.h),
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
                    TaxAdjustmentsCardWidget(onTap: () {
                      NewEntryBottomSheetWidget.show(context, AppLocaleKey.taxAdjustments.tr());
                    }),
                    Gap(16.h),
                    TaxReturnsCardWidget(onTap: () {
                      NewEntryBottomSheetWidget.show(context, AppLocaleKey.taxReturnsCard.tr());
                    }),
                    Gap(16.h),
                    Ifrs16CardWidget(onTap: () {
                      NewEntryBottomSheetWidget.show(context, AppLocaleKey.ifrs16Asset.tr());
                    }),
                    Gap(16.h),
                    ZakatCardWidget(onTap: () {
                      NewEntryBottomSheetWidget.show(context, AppLocaleKey.zakatLabel.tr());
                    }),
                  ],
                ),
              ),
              Gap(80.h),
            ],
          ),
        ),
      ),
    );
  }
}
