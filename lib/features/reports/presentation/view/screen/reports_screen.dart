import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/custom_widgets/date_range_bottom_sheet_widget.dart';
import 'package:my_template/core/custom_widgets/month_range_bottom_sheet_widget.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/reports/data/repository/reports_repo.dart';
import 'package:my_template/features/reports/presentation/view/widget/file_download_service.dart';
import 'package:my_template/features/reports/presentation/view/widget/general_journal_for_level_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/account_statement_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/accounts_comparison_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/accounts_centers_comparison_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/account_centers_summary_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/chart_of_account_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/chart_of_account_monthly_balances_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/cost_centers_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/cost_centers_projects_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/cost_centers_transaction_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/fullscreen_pdf_viewer_screen.dart';
import 'package:my_template/features/reports/presentation/view/widget/ledger_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/journal_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/monthly_comparison_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/party_vat_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/pdf_export_service.dart';
import 'package:my_template/features/reports/presentation/view/widget/pdf_preview_panel.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_screen_widgets.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_table_item_widget.dart';
import 'package:my_template/features/lookup/presentation/widgets/customer_datum_dropdown.dart';

enum _PreviewKind { none, pdf }

class _ReportOption {
  final String title;
  final String description;
  final String reportName;
  final int? financialStatementReportType;

  const _ReportOption({
    required this.title,
    required this.description,
    required this.reportName,
    this.financialStatementReportType,
  });
}

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // ── State ────────────────────────────────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _searchDebounce;
  String _searchQuery = '';

  // ── Preview state ────────────────────────────────────────────────────────
  _PreviewKind _previewKind = _PreviewKind.none;
  File? _pdfFile;
  String _previewTitle = '';
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_handleSearchFocus);
  }

  void _handleSearchFocus() {
    if (mounted) setState(() {});
  }

  String _normalizeSearchText(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[\u064B-\u0652\u0670]'), '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .trim();
  }

  String _centersComparisonBalancesReportName(int balance, int periodically) {
    if (balance == 0) return periodically == 0 ? 'AGL051' : 'AGL050';
    return periodically == 0 ? 'AGL048' : 'AGL047';
  }

  String _accountsCentersComparisonReportName(
    int balance,
    int periodically,
    int reportGroup,
  ) {
    final suffix = reportGroup == 0 ? 'A' : 'B';
    if (balance == 0)
      return periodically == 0 ? 'AGL051$suffix' : 'AGL050$suffix';
    return periodically == 0 ? 'AGL048$suffix' : 'AGL047$suffix';
  }

  String _accountsCentersMonthlyComparisonReportName(
    int reportPageType,
    int reportGroup,
  ) {
    final suffix = reportGroup == 0 ? 'A' : 'B';
    return 'AGL${reportPageType == 2 ? '091' : '092'}$suffix';
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 180), () {
      if (!mounted) return;
      setState(() => _searchQuery = value.trim());
    });
  }

  void _applySearch(String value) {
    _searchDebounce?.cancel();
    _searchController
      ..text = value
      ..selection = TextSelection.collapsed(offset: value.length);
    setState(() {
      _searchQuery = value.trim();
    });
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  Future<_ReportOption?> _selectReportOption({
    required String title,
    required List<_ReportOption> options,
  }) {
    return showModalBottomSheet<_ReportOption>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.85,
        ),
        decoration: BoxDecoration(
          color: AppColor.cardColor(sheetContext),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColor.borderColor(sheetContext),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              Gap(18.h),
              Text(
                title,
                style: TextStyle(
                  color: AppColor.titleFormFiledColor(sheetContext),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(10.h),
              ...options.map(
                (option) => Card(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(option.title),
                    subtitle: Text(
                      '${option.description}\n${option.reportName}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_left_rounded),
                    onTap: () => Navigator.pop(sheetContext, option),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Language ─────────────────────────────────────────────────────────────
  Future<void> _toggleLanguage() async {
    if (context.locale.languageCode == 'ar') {
      await context.setLocale(const Locale('en'));
    } else {
      await context.setLocale(const Locale('ar'));
    }
    if (mounted) setState(() {});
  }

  // ── Export Modal ─────────────────────────────────────────────────────────
  void _showExportModal() {
    const defaultExportType = 'pdf';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(ctx).height * 0.85,
        ),
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColor.cardColor(context),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(color: AppColor.borderColor(context)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColor.darkTextColor(context),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              Gap(16.h),
              Text(
                AppLocaleKey.exportReport.tr(),
                style: TextStyle(
                  color: AppColor.titleFormFiledColor(context),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(16.h),
              _buildExportOption(
                icon: Icons.account_tree_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementChartOfAccount.tr(),
                subtitle: 'Report/ChartOfAccountReport',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementChartOfAccount.tr(),
                    description: AppLocaleKey.statementChartOfAccountDesc.tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL004',
                    isApiReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.show_chart_rounded,
                color: AppColor.emeraldTeal,
                title: AppLocaleKey.statementIncome.tr(),
                subtitle: 'Report/IncomeAndExpenseSituationReport (AGL300_M)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementIncome.tr(),
                    description: AppLocaleKey.statementIncomeDesc.tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL300_M',
                    isIncomeAndExpenseSituationReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.calendar_view_day_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementDailyIncome.tr(),
                subtitle: 'Report/IncomeAndExpenseSituationReport (AGL300_D)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementDailyIncome.tr(),
                    description: AppLocaleKey.statementDailyIncomeDesc.tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL300_D',
                    isDailyIncomeAndExpenseReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.receipt_long_outlined,
                color: AppColor.purpleAccent,
                title: AppLocaleKey.statementExpensesWithVat.tr(),
                subtitle: 'Report/ExpensesWithVatReport (AGL1001E)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementExpensesWithVat.tr(),
                    description: AppLocaleKey.statementExpensesWithVatDesc.tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL1001E',
                    isExpensesWithVatReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.point_of_sale_rounded,
                color: AppColor.emeraldTeal,
                title: AppLocaleKey.statementSalesWithVat.tr(),
                subtitle: 'Report/SalesWithVatReport (AAR1000)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementSalesWithVat.tr(),
                    description: AppLocaleKey.statementSalesWithVatDesc.tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AAR1000',
                    isSalesWithVatReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.shopping_bag_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementPurchasesWithVat.tr(),
                subtitle: 'Report/PurchasesWithVatReport (AAR1001)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementPurchasesWithVat.tr(),
                    description: AppLocaleKey.statementPurchasesWithVatDesc
                        .tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AAR1001',
                    isPurchasesWithVatReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.menu_book_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementLedger.tr(),
                subtitle: 'Report/LedgerReportForAllAccounts (AGL025)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementLedger.tr(),
                    description: AppLocaleKey.statementLedgerDesc.tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL025',
                    isLedgerReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.receipt_long_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementAccountStatement.tr(),
                subtitle: 'Report/AccountStatementReport (AGL079)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementAccountStatement.tr(),
                    description: AppLocaleKey.statementAccountStatementDesc
                        .tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL079',
                    isAccountStatementReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.account_balance_wallet_outlined,
                color: AppColor.emeraldTeal,
                title: AppLocaleKey.statementTrialBalanceByCategories.tr(),
                subtitle: 'Report/TrialBalanceByCategoriesReport (AGL055)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementTrialBalanceByCategories.tr(),
                    description: AppLocaleKey
                        .statementTrialBalanceByCategoriesDesc
                        .tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL055',
                    isTrialBalanceByCategoriesReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.business_outlined,
                color: AppColor.purpleAccent,
                title: AppLocaleKey.statementCostCenters.tr(),
                subtitle: 'Report/CostCentersReport (AGL007)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementCostCenters.tr(),
                    description: AppLocaleKey.statementCostCentersDesc.tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL007',
                    isCostCentersReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.calendar_month_outlined,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'الأرصدة الشهرية لمراكز التكلفة'
                    : 'Cost Centers Monthly Balances',
                subtitle: 'Report/CentersMonthlyBalanceReport (AGL008A)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'الأرصدة الشهرية لمراكز التكلفة'
                        : 'Cost Centers Monthly Balances',
                    description: '',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL008A',
                    isCentersMonthlyBalanceReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.account_tree_rounded,
                color: AppColor.purpleAccent,
                title: context.locale.languageCode == 'ar'
                    ? 'حركة مراكز التكلفة'
                    : 'Cost Centers Transactions',
                subtitle: 'Report/CostCentersTransactionReport (AGL028)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'حركة مراكز التكلفة'
                        : 'Cost Centers Transactions',
                    description: '',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL028',
                    isCostCentersTransactionReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.calendar_view_month_outlined,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'الحركة السنوية لمراكز التكلفة'
                    : 'Annual Cost Centers Transactions',
                subtitle: 'Report/CostCentersTransactionAnnualReport (AGL029Y)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'الحركة السنوية لمراكز التكلفة'
                        : 'Annual Cost Centers Transactions',
                    description: '',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL029Y',
                    isCostCentersTransactionAnnualReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.domain_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementCostCentersProjects.tr(),
                subtitle: 'Report/CostCentersProjectsReport (Agl026)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementCostCentersProjects.tr(),
                    description: AppLocaleKey.statementCostCentersProjectsDesc
                        .tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'Agl026_Project2',
                    isCostCentersProjectsReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.account_tree_outlined,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'ملخص مراكز الحسابات الرئيسية'
                    : 'Main Accounts Centers Summary',
                subtitle:
                    'Report/AccountCentersSummaryForMainAccountsReport (AGL0103)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'ملخص مراكز الحسابات الرئيسية'
                        : 'Main Accounts Centers Summary',
                    description: '',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL0103',
                    isAccountCentersSummaryForMainAccountsReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.compare_arrows_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementMonthlyAccountsComparison.tr(),
                subtitle: 'Report/MonthlyAccountComparsionReport (AGL003)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementMonthlyAccountsComparison.tr(),
                    description: AppLocaleKey
                        .statementMonthlyAccountsComparisonDesc
                        .tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL003_Bar',
                    isMonthlyAccountComparisonReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.insights_rounded,
                color: AppColor.purpleAccent,
                title: AppLocaleKey.statementMonthlyCostCentersComparison.tr(),
                subtitle: 'Report/MonthlyCostCentersComparsionReport (AGL008)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementMonthlyCostCentersComparison
                        .tr(),
                    description: AppLocaleKey
                        .statementMonthlyCostCentersComparisonDesc
                        .tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL008_Chart',
                    isMonthlyCostCentersComparisonReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.calendar_month_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'مقارنة الحسابات بالشهور'
                    : 'Accounts Comparison by Months',
                subtitle: 'Report/AccountsComparsionReport (AGL053)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'مقارنة الحسابات بالشهور'
                        : 'Accounts Comparison by Months',
                    description: '',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL053',
                    isAccountsMonthlyComparisonReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.event_repeat_rounded,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقارير مقارنة شهر - الحسابات'
                    : 'Account Month Comparison',
                subtitle: 'Report/AccountsComparsionReport (AGL054)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقارير مقارنة شهر - الحسابات'
                        : 'Account Month Comparison',
                    description: '',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL054',
                    isAccountsComparisonByMonthReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.assessment_outlined,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'مقارنة دليل الحسابات'
                    : 'Chart of Accounts Comparison',
                subtitle: 'Report/AccountsComparsionReport (AGL006)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'مقارنة دليل الحسابات'
                        : 'Chart of Accounts Comparison',
                    description: '',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL006',
                    isAccountsBalancePeriodicallyReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.share_rounded,
                color: AppColor.purpleAccent,
                title: AppLocaleKey.shareReport.tr(),
                subtitle: 'Direct Link & Board Presentation Format',
                onTap: () {
                  Navigator.pop(ctx);
                  CommonMethods.showToast(
                    message: AppLocaleKey.reportExportSuccess.tr(),
                    type: ToastType.success,
                  );
                },
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20.r),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.titleFormFiledColor(context),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColor.darkTextColor(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColor.darkTextColor(context),
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }

  // ── Report Export ────────────────────────────────────────────────────────
  Future<void> _handleExportReport({
    required String title,
    required String description,
    required String amount,
    required String date,
    required String status,
    String exportType = 'pdf',
    String? reportName,
    bool isApiReport = false,
    bool isIncomeAndExpenseSituationReport = false,
    bool isDailyIncomeAndExpenseReport = false,
    bool isJournalReport = false,
    bool isMainAccountsJournalReport = false,
    bool isGeneralJournalForLevelReport = false,
    bool isExpensesWithVatReport = false,
    bool isSalesWithVatReport = false,
    bool isPurchasesWithVatReport = false,
    bool isLedgerReport = false,
    bool isAccountStatementReport = false,
    bool isTrialBalanceByCategoriesReport = false,
    bool isFinancialStatementsReport = false,
    bool isCostCentersReport = false,
    bool isCentersMonthlyBalanceReport = false,
    bool isCentersComparisonReport = false,
    bool isCentersComparisonByMonthsReport = false,
    bool isCentersComparisonByMonthReport = false,
    bool isCentersComparisonBalancesReport = false,
    bool isAccountsCentersComparisonReport = false,
    bool isAccountsCentersMonthlyComparisonReport = false,
    bool isAccountsCentersMonthlyMovementsReport = false,
    bool isCostCentersTransactionReport = false,
    bool isCostCentersTransactionAnnualReport = false,
    bool isCostCentersProjectsReport = false,
    bool isAccountCentersSummaryForMainAccountsReport = false,
    bool isMonthlyAccountComparisonReport = false,
    bool isMonthlyCostCentersComparisonReport = false,
    bool isAccountsComparisonReport = false,
    bool isAccountsMonthlyComparisonReport = false,
    bool isAccountsComparisonByMonthReport = false,
    bool isAccountsBalancePeriodicallyReport = false,
    bool isChartOfAccountMonthlyBalancesReport = false,
    int chartOfAccountReportPageType = 2,
    int chartOfAccountReportAccountType = 0,
    String chartOfAccountReportName = 'AGL015A',
  }) async {
    final languageCode = context.locale.languageCode;
    ChartOfAccountReportFilterSelection? chartOfAccountFilter;
    if (isApiReport) {
      chartOfAccountFilter =
          await ChartOfAccountReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || chartOfAccountFilter == null) return;
      reportName = chartOfAccountFilter.reportName;
      exportType = chartOfAccountFilter.exportType;
    }

    if (isTrialBalanceByCategoriesReport) {
      final selection = await _selectReportOption(
        title: 'اختر طريقة ترتيب ميزان المراجعة',
        options: const [
          _ReportOption(
            title: 'بدون ترتيب',
            description: 'ميزان المراجعة حسب الفئات',
            reportName: 'AGL055',
          ),
          _ReportOption(
            title: 'ترتيب رقمي',
            description: 'عرض الحسابات بترتيب رقمي',
            reportName: 'AGL055H',
          ),
          _ReportOption(
            title: 'ترتيب شجري',
            description: 'عرض الحسابات كتسلسل شجري',
            reportName: 'AGL055H',
          ),
        ],
      );
      if (!mounted || selection == null) return;
      reportName = selection.reportName;
    }

    _ReportOption? financialStatementSelection;
    if (isFinancialStatementsReport) {
      financialStatementSelection = await _selectReportOption(
        title: 'اختر نوع القائمة المالية',
        options: const [
          _ReportOption(
            title: 'الأرباح والخسائر',
            description: 'قائمة الأرباح والخسائر',
            reportName: 'AGL035',
            financialStatementReportType: 2,
          ),
          _ReportOption(
            title: 'الميزانية العمومية',
            description: 'بيان الأصول والخصوم وحقوق الملكية',
            reportName: 'AGL036',
            financialStatementReportType: 3,
          ),
          _ReportOption(
            title: 'قائمة الدخل',
            description: 'بيان الدخل والإيرادات والمصروفات',
            reportName: 'AGL069',
            financialStatementReportType: 4,
          ),
          _ReportOption(
            title: 'التدفقات النقدية',
            description: 'التدفقات التشغيلية والاستثمارية والتمويلية',
            reportName: 'AGL073',
            financialStatementReportType: 5,
          ),
        ],
      );
      if (!mounted || financialStatementSelection == null) return;
      reportName = financialStatementSelection.reportName;
    }

    MonthRangeSelection? monthRange;
    if (isIncomeAndExpenseSituationReport) {
      monthRange = await MonthRangeBottomSheetWidget.show(
        context,
        title: AppLocaleKey.selectMonthRange.tr(),
      );
      if (!mounted || monthRange == null) return;
    }
    LedgerReportFilterSelection? ledgerFilter;
    if (isLedgerReport) {
      ledgerFilter = await LedgerReportFilterBottomSheetWidget.show(
        context,
        title: title,
      );
      if (!mounted || ledgerFilter == null) return;
    }
    AccountStatementFilterSelection? accountStatementFilter;
    if (isAccountStatementReport) {
      accountStatementFilter =
          await AccountStatementFilterBottomSheetWidget.show(
            context,
            title: title,
          );
      if (!mounted || accountStatementFilter == null) return;
    }
    PartyVatReportFilterSelection? partyVatFilter;
    if (isSalesWithVatReport || isPurchasesWithVatReport) {
      partyVatFilter = await PartyVatReportFilterBottomSheetWidget.show(
        context,
        title: title,
        reportCode: isSalesWithVatReport ? 'AAR1000' : 'AAR1001',
        type: isSalesWithVatReport
            ? CustomerDatumType.customer
            : CustomerDatumType.supplier,
      );
      if (!mounted || partyVatFilter == null) return;
    }
    DateRangeSelection? dateRange;
    if (isDailyIncomeAndExpenseReport || isExpensesWithVatReport) {
      dateRange = await DateRangeBottomSheetWidget.show(
        context,
        title: AppLocaleKey.selectDateRange.tr(),
        allowAllDates: isExpensesWithVatReport,
      );
      if (!mounted || dateRange == null) return;
    }
    JournalReportFilterSelection? journalReportFilter;
    if (isJournalReport || isMainAccountsJournalReport) {
      journalReportFilter = await JournalReportFilterBottomSheetWidget.show(
        context,
        title: title,
        initialExportType: exportType,
        isMainAccountsReport: isMainAccountsJournalReport,
      );
      if (!mounted || journalReportFilter == null) return;
      exportType = journalReportFilter.exportType;
      reportName = journalReportFilter.reportName;
    }
    GeneralJournalForLevelReportFilterSelection? generalJournalLevelFilter;
    if (isGeneralJournalForLevelReport) {
      generalJournalLevelFilter =
          await GeneralJournalForLevelReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || generalJournalLevelFilter == null) return;
      exportType = generalJournalLevelFilter.exportType;
    }
    CostCentersReportFilterSelection? costCentersFilter;
    if (isCostCentersReport ||
        isCentersMonthlyBalanceReport ||
        isCentersComparisonReport ||
        isCentersComparisonByMonthsReport ||
        isCentersComparisonByMonthReport ||
        isCentersComparisonBalancesReport) {
      costCentersFilter = await CostCentersReportFilterBottomSheetWidget.show(
        context,
        title: title,
        endpointPath:
            isCentersComparisonReport ||
                isCentersComparisonByMonthsReport ||
                isCentersComparisonByMonthReport ||
                isCentersComparisonBalancesReport
            ? 'Report/CentersComparsionReport'
            : null,
        initialReportName: isCentersComparisonByMonthsReport
            ? 'AGL091'
            : isCentersComparisonByMonthReport
            ? 'AGL090'
            : isCentersComparisonBalancesReport
            ? 'AGL051'
            : isCentersComparisonReport
            ? 'AGL092'
            : isCentersMonthlyBalanceReport
            ? 'AGL008A'
            : reportName ?? 'AGL008',
        showReportNameSelector:
            !isCentersMonthlyBalanceReport &&
            !isCentersComparisonReport &&
            !isCentersComparisonByMonthsReport &&
            !isCentersComparisonByMonthReport &&
            !isCentersComparisonBalancesReport,
        showDateFilter:
            !isCentersMonthlyBalanceReport &&
            !isCentersComparisonReport &&
            !isCentersComparisonByMonthsReport &&
            !isCentersComparisonByMonthReport &&
            !isCentersComparisonBalancesReport,
        showMonthFilters: isCentersComparisonByMonthsReport,
        showComparisonMonth: isCentersComparisonByMonthReport,
        showBalancePeriodicallyFilters: isCentersComparisonBalancesReport,
      );
      if (!mounted || costCentersFilter == null) return;
      reportName = costCentersFilter.reportName;
      exportType = costCentersFilter.exportType;
    }
    AccountsCentersComparisonReportFilterSelection?
    accountsCentersComparisonFilter;
    if (isAccountsCentersComparisonReport ||
        isAccountsCentersMonthlyComparisonReport ||
        isAccountsCentersMonthlyMovementsReport) {
      accountsCentersComparisonFilter =
          await AccountsCentersComparisonReportFilterBottomSheetWidget.show(
            context,
            title: title,
            showBalanceFilter:
                !isAccountsCentersMonthlyMovementsReport &&
                !isAccountsCentersMonthlyComparisonReport,
            showPeriodFilter:
                !isAccountsCentersMonthlyMovementsReport &&
                !isAccountsCentersMonthlyComparisonReport,
          );
      if (!mounted || accountsCentersComparisonFilter == null) return;
      exportType = accountsCentersComparisonFilter.exportType;
    }
    CostCentersTransactionReportFilterSelection? costCentersTransactionFilter;
    if (isCostCentersTransactionReport ||
        isCostCentersTransactionAnnualReport) {
      costCentersTransactionFilter =
          await CostCentersTransactionReportFilterBottomSheetWidget.show(
            context,
            title: title,
            isAnnual: isCostCentersTransactionAnnualReport,
            initialReportName: isCostCentersTransactionAnnualReport
                ? reportName ?? 'AGL029Y'
                : reportName ?? 'AGL028',
          );
      if (!mounted || costCentersTransactionFilter == null) return;
      reportName = costCentersTransactionFilter.reportName;
      exportType = costCentersTransactionFilter.exportType;
    }
    CostCentersProjectsReportFilterSelection? costCentersProjectsFilter;
    if (isCostCentersProjectsReport) {
      costCentersProjectsFilter =
          await CostCentersProjectsReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialReportName: reportName ?? 'Agl026_Project2',
          );
      if (!mounted || costCentersProjectsFilter == null) return;
    }
    AccountCentersSummaryReportFilterSelection? accountCentersSummaryFilter;
    if (isAccountCentersSummaryForMainAccountsReport) {
      accountCentersSummaryFilter =
          await AccountCentersSummaryReportFilterBottomSheetWidget.show(
            context,
            title: title,
          );
      if (!mounted || accountCentersSummaryFilter == null) return;
      exportType = accountCentersSummaryFilter.exportType;
    }
    MonthlyComparisonReportFilterSelection? monthlyComparisonFilter;
    if (isMonthlyAccountComparisonReport ||
        isMonthlyCostCentersComparisonReport) {
      monthlyComparisonFilter =
          await MonthlyComparisonReportFilterBottomSheetWidget.show(
            context,
            title: title,
            mode: isMonthlyAccountComparisonReport
                ? MonthlyComparisonReportMode.accounts
                : MonthlyComparisonReportMode.costCenters,
          );
      if (!mounted || monthlyComparisonFilter == null) return;
      reportName = monthlyComparisonFilter.reportName;
    }
    AccountsComparisonReportFilterSelection? accountsComparisonFilter;
    if (isAccountsComparisonReport ||
        isAccountsMonthlyComparisonReport ||
        isAccountsComparisonByMonthReport ||
        isAccountsBalancePeriodicallyReport) {
      accountsComparisonFilter =
          await AccountsComparisonReportFilterBottomSheetWidget.show(
            context,
            title: title,
            isMonthly: isAccountsMonthlyComparisonReport,
            isComparisonMonth: isAccountsComparisonByMonthReport,
            isBalancePeriodically: isAccountsBalancePeriodicallyReport,
          );
      if (!mounted || accountsComparisonFilter == null) return;
      exportType = accountsComparisonFilter.exportType;
    }
    ChartOfAccountMonthlyBalancesFilterSelection? monthlyBalancesFilter;
    if (isChartOfAccountMonthlyBalancesReport) {
      monthlyBalancesFilter =
          await ChartOfAccountMonthlyBalancesFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
            initialAccountType: chartOfAccountReportAccountType,
            reportPageType: chartOfAccountReportPageType,
            reportName: chartOfAccountReportName,
          );
      if (!mounted || monthlyBalancesFilter == null) return;
      exportType = monthlyBalancesFilter.exportType;
      reportName = monthlyBalancesFilter.reportName;
    }

    setState(() {
      _isGenerating = true;
      _previewTitle = title;
    });
    _showReportPreparationDialog();

    try {
      final File file;
      if (isApiReport ||
          isIncomeAndExpenseSituationReport ||
          isDailyIncomeAndExpenseReport ||
          isJournalReport ||
          isMainAccountsJournalReport ||
          isGeneralJournalForLevelReport ||
          isExpensesWithVatReport ||
          isSalesWithVatReport ||
          isPurchasesWithVatReport ||
          isLedgerReport ||
          isAccountStatementReport ||
          isTrialBalanceByCategoriesReport ||
          isFinancialStatementsReport ||
          isCostCentersReport ||
          isCentersMonthlyBalanceReport ||
          isCostCentersTransactionReport ||
          isCostCentersTransactionAnnualReport ||
          isCostCentersProjectsReport ||
          isAccountCentersSummaryForMainAccountsReport ||
          isMonthlyAccountComparisonReport ||
          isMonthlyCostCentersComparisonReport ||
          isAccountsComparisonReport ||
          isAccountsMonthlyComparisonReport ||
          isAccountsComparisonByMonthReport ||
          isAccountsBalancePeriodicallyReport ||
          isChartOfAccountMonthlyBalancesReport ||
          reportName != null) {
        final reportsRepo = sl<ReportsRepo>();
        final result = isGeneralJournalForLevelReport
            ? await reportsRepo.getGeneralJournalForLevelReport(
                accountLevel: generalJournalLevelFilter?.accountLevel,
                fromEntrySerial: generalJournalLevelFilter?.fromEntrySerial,
                toEntrySerial: generalJournalLevelFilter?.toEntrySerial,
                fromDate: generalJournalLevelFilter?.fromDate,
                toDate: generalJournalLevelFilter?.toDate,
                reportName: 'AGL0104',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isJournalReport || isMainAccountsJournalReport
            ? await reportsRepo.getJournalReport(
                fromEntrySerial: journalReportFilter?.fromEntrySerial,
                toEntrySerial: journalReportFilter?.toEntrySerial,
                fromEntryNo: journalReportFilter?.fromEntryNo,
                toEntryNo: journalReportFilter?.toEntryNo,
                fromDate: journalReportFilter?.fromDate,
                toDate: journalReportFilter?.toDate,
                journalType: journalReportFilter?.journalType ?? 0,
                journalReportType: journalReportFilter?.journalReportType ?? 5,
                reportPageType: isMainAccountsJournalReport ? 2 : 1,
                reportName:
                    journalReportFilter?.reportName ??
                    (isMainAccountsJournalReport ? 'AGL0101C' : 'AGL009'),
                languageCode: languageCode,
                exportType: exportType,
              )
            : isAccountsComparisonReport
            ? await reportsRepo.getAccountsComparsionReport(
                fromAccountNo: accountsComparisonFilter?.fromAccountNo,
                toAccountNo: accountsComparisonFilter?.toAccountNo,
                fromAccountLevel: accountsComparisonFilter?.fromAccountLevel,
                toAccountLevel: accountsComparisonFilter?.toAccountLevel,
                accountType: accountsComparisonFilter?.accountType ?? 2,
                financialStatementType:
                    accountsComparisonFilter?.financialStatementType ?? 4,
                reportPageType: 4,
                reportName: 'AGL052',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isAccountsMonthlyComparisonReport
            ? await reportsRepo.getAccountsComparsionReport(
                fromAccountNo: accountsComparisonFilter?.fromAccountNo,
                toAccountNo: accountsComparisonFilter?.toAccountNo,
                fromAccountLevel: accountsComparisonFilter?.fromAccountLevel,
                toAccountLevel: accountsComparisonFilter?.toAccountLevel,
                fromMonth: accountsComparisonFilter?.fromMonth,
                toMonth: accountsComparisonFilter?.toMonth,
                accountType: accountsComparisonFilter?.accountType ?? 2,
                financialStatementType:
                    accountsComparisonFilter?.financialStatementType ?? 4,
                balance: accountsComparisonFilter?.balance ?? 0,
                reportPageType: 3,
                reportName: 'AGL053',
                includeMonthlyFilters: true,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isAccountsComparisonByMonthReport
            ? await reportsRepo.getAccountsComparsionReport(
                fromAccountNo: accountsComparisonFilter?.fromAccountNo,
                toAccountNo: accountsComparisonFilter?.toAccountNo,
                fromAccountLevel: accountsComparisonFilter?.fromAccountLevel,
                toAccountLevel: accountsComparisonFilter?.toAccountLevel,
                comparisonMonth: accountsComparisonFilter?.comparisonMonth ?? 1,
                accountType: accountsComparisonFilter?.accountType ?? 2,
                financialStatementType:
                    accountsComparisonFilter?.financialStatementType ?? 4,
                balance: null,
                periodically: null,
                reportPageType: 2,
                reportName: 'AGL054',
                includeComparisonMonthFilters: true,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isAccountsBalancePeriodicallyReport
            ? await reportsRepo.getAccountsComparsionReport(
                fromAccountNo: accountsComparisonFilter?.fromAccountNo,
                toAccountNo: accountsComparisonFilter?.toAccountNo,
                fromAccountLevel: accountsComparisonFilter?.fromAccountLevel,
                toAccountLevel: accountsComparisonFilter?.toAccountLevel,
                fromMonth: accountsComparisonFilter?.fromMonth,
                toMonth: accountsComparisonFilter?.toMonth,
                accountType: accountsComparisonFilter?.accountType ?? 2,
                financialStatementType:
                    accountsComparisonFilter?.financialStatementType ?? 4,
                balance: accountsComparisonFilter?.balance ?? 1,
                periodically: accountsComparisonFilter?.periodically ?? 0,
                reportPageType: 1,
                reportName: accountsComparisonFilter?.reportName ?? 'AGL006',
                includeBalancePeriodicallyFilters: true,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isAccountsCentersMonthlyComparisonReport ||
                  isAccountsCentersMonthlyMovementsReport
            ? await reportsRepo.getAccountsCentersComparisonReport(
                fromAccountNo: accountsCentersComparisonFilter?.fromAccountNo,
                toAccountNo: accountsCentersComparisonFilter?.toAccountNo,
                fromCostCenterNo:
                    accountsCentersComparisonFilter?.fromCostCenterNo,
                toCostCenterNo: accountsCentersComparisonFilter?.toCostCenterNo,
                fromMonth: accountsCentersComparisonFilter?.fromMonth,
                toMonth: accountsCentersComparisonFilter?.toMonth,
                balance: 0,
                periodically: isAccountsCentersMonthlyComparisonReport ? 1 : 0,
                reportGroup: accountsCentersComparisonFilter?.reportGroup ?? 0,
                reportPageType: isAccountsCentersMonthlyComparisonReport
                    ? 2
                    : 3,
                reportName: _accountsCentersMonthlyComparisonReportName(
                  isAccountsCentersMonthlyComparisonReport ? 2 : 3,
                  accountsCentersComparisonFilter?.reportGroup ?? 0,
                ),
                includeBalanceAndPeriodically:
                    isAccountsCentersMonthlyComparisonReport,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isAccountsCentersComparisonReport
            ? await reportsRepo.getAccountsCentersComparisonReport(
                fromAccountNo: accountsCentersComparisonFilter?.fromAccountNo,
                toAccountNo: accountsCentersComparisonFilter?.toAccountNo,
                fromCostCenterNo:
                    accountsCentersComparisonFilter?.fromCostCenterNo,
                toCostCenterNo: accountsCentersComparisonFilter?.toCostCenterNo,
                fromMonth: accountsCentersComparisonFilter?.fromMonth,
                toMonth: accountsCentersComparisonFilter?.toMonth,
                balance: accountsCentersComparisonFilter?.balance ?? 0,
                periodically:
                    accountsCentersComparisonFilter?.periodically ?? 0,
                reportGroup: accountsCentersComparisonFilter?.reportGroup ?? 0,
                reportPageType: 1,
                reportName: _accountsCentersComparisonReportName(
                  accountsCentersComparisonFilter?.balance ?? 0,
                  accountsCentersComparisonFilter?.periodically ?? 0,
                  accountsCentersComparisonFilter?.reportGroup ?? 0,
                ),
                languageCode: languageCode,
                exportType: exportType,
              )
            : isCentersComparisonByMonthsReport ||
                  isCentersComparisonReport ||
                  isCentersComparisonByMonthReport ||
                  isCentersComparisonBalancesReport
            ? await reportsRepo.getCentersComparisonReport(
                fromCostCenterNo: costCentersFilter?.fromCostCenterNo,
                toCostCenterNo: costCentersFilter?.toCostCenterNo,
                fromCenterLevel: costCentersFilter?.fromCenterLevel,
                toCenterLevel: costCentersFilter?.toCenterLevel,
                fromMonth: isCentersComparisonByMonthsReport
                    ? costCentersFilter?.fromMonth
                    : null,
                toMonth: isCentersComparisonByMonthsReport
                    ? costCentersFilter?.toMonth
                    : null,
                comparisonMonth: isCentersComparisonByMonthReport
                    ? costCentersFilter?.comparisonMonth ?? 1
                    : null,
                centerType: costCentersFilter?.costCenterType ?? 2,
                balance:
                    isCentersComparisonByMonthsReport ||
                        isCentersComparisonBalancesReport
                    ? costCentersFilter?.balance ?? 0
                    : null,
                periodically: isCentersComparisonBalancesReport
                    ? costCentersFilter?.periodically ?? 0
                    : null,
                reportPageType: isCentersComparisonBalancesReport
                    ? 1
                    : isCentersComparisonByMonthReport
                    ? 2
                    : isCentersComparisonByMonthsReport
                    ? 3
                    : 4,
                reportName: isCentersComparisonBalancesReport
                    ? _centersComparisonBalancesReportName(
                        costCentersFilter?.balance ?? 0,
                        costCentersFilter?.periodically ?? 0,
                      )
                    : isCentersComparisonByMonthReport
                    ? 'AGL090'
                    : isCentersComparisonByMonthsReport
                    ? 'AGL091'
                    : 'AGL092',
                includeMonthFilters:
                    isCentersComparisonByMonthsReport ||
                    isCentersComparisonBalancesReport,
                includeComparisonMonth: isCentersComparisonByMonthReport,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isCentersMonthlyBalanceReport
            ? await reportsRepo.getCentersMonthlyBalanceReport(
                fromCostCenterNo: costCentersFilter?.fromCostCenterNo,
                toCostCenterNo: costCentersFilter?.toCostCenterNo,
                fromCenterLevel: costCentersFilter?.fromCenterLevel,
                toCenterLevel: costCentersFilter?.toCenterLevel,
                costCenterType: costCentersFilter?.costCenterType ?? 2,
                reportName: 'AGL008A',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isCostCentersTransactionAnnualReport
            ? await reportsRepo.getCostCentersTransactionAnnualReport(
                fromAccountNo: costCentersTransactionFilter?.fromAccountNo,
                toAccountNo: costCentersTransactionFilter?.toAccountNo,
                fromCostCenterNo:
                    costCentersTransactionFilter?.fromCostCenterNo,
                toCostCenterNo: costCentersTransactionFilter?.toCostCenterNo,
                fromDate: costCentersTransactionFilter?.fromDate,
                toDate: costCentersTransactionFilter?.toDate,
                reportName:
                    costCentersTransactionFilter?.reportName ?? 'AGL029Y',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isCostCentersTransactionReport
            ? await reportsRepo.getCostCentersTransactionReport(
                fromAccountNo: costCentersTransactionFilter?.fromAccountNo,
                toAccountNo: costCentersTransactionFilter?.toAccountNo,
                fromCostCenterNo:
                    costCentersTransactionFilter?.fromCostCenterNo,
                toCostCenterNo: costCentersTransactionFilter?.toCostCenterNo,
                fromDate: costCentersTransactionFilter?.fromDate,
                toDate: costCentersTransactionFilter?.toDate,
                prepareCostCentersTree:
                    costCentersTransactionFilter?.prepareCostCentersTree ??
                    false,
                reportName:
                    costCentersTransactionFilter?.reportName ?? 'AGL028',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isAccountCentersSummaryForMainAccountsReport
            ? await reportsRepo.getAccountCentersSummaryForMainAccountsReport(
                fromAccountNo: accountCentersSummaryFilter?.fromAccountNo,
                toAccountNo: accountCentersSummaryFilter?.toAccountNo,
                fromCostCenterNo: accountCentersSummaryFilter?.fromCostCenterNo,
                toCostCenterNo: accountCentersSummaryFilter?.toCostCenterNo,
                fromDate: accountCentersSummaryFilter?.fromDate,
                toDate: accountCentersSummaryFilter?.toDate,
                accountLevel: 1,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isChartOfAccountMonthlyBalancesReport
            ? await reportsRepo.getChartOfAccountMonthlyBalancesReport(
                fromAccountNo: monthlyBalancesFilter?.fromAccountNo,
                toAccountNo: monthlyBalancesFilter?.toAccountNo,
                fromAccountLevel: monthlyBalancesFilter?.fromAccountLevel,
                toAccountLevel: monthlyBalancesFilter?.toAccountLevel,
                accountType: monthlyBalancesFilter?.accountType ?? 0,
                finalAccount: monthlyBalancesFilter?.finalAccount ?? 4,
                reportPageType: monthlyBalancesFilter?.reportPageType ?? 2,
                reportName: reportName ?? 'AGL015A',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isFinancialStatementsReport
            ? await reportsRepo.getFinancialStatementsReport(
                financialStatementReportType:
                    financialStatementSelection!.financialStatementReportType!,
                reportName: reportName!,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isIncomeAndExpenseSituationReport
            ? await reportsRepo.getIncomeAndExpenseSituationReport(
                fromMonth: monthRange?.fromMonth,
                toMonth: monthRange?.toMonth,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isDailyIncomeAndExpenseReport
            ? await reportsRepo.getDailyIncomeAndExpenseSituationReport(
                fromDate: dateRange?.fromDate,
                toDate: dateRange?.toDate,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isExpensesWithVatReport
            ? await reportsRepo.getExpensesWithVatReport(
                fromVoucherDate: dateRange?.fromDate,
                toVoucherDate: dateRange?.toDate,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isSalesWithVatReport
            ? await reportsRepo.getSalesWithVatReport(
                fromCustomerNo: partyVatFilter?.fromCustomerNo,
                toCustomerNo: partyVatFilter?.toCustomerNo,
                fromTransDate: partyVatFilter?.fromTransDate,
                toTransDate: partyVatFilter?.toTransDate,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isPurchasesWithVatReport
            ? await reportsRepo.getPurchasesWithVatReport(
                fromCustomerNo: partyVatFilter?.fromCustomerNo,
                toCustomerNo: partyVatFilter?.toCustomerNo,
                fromTransDate: partyVatFilter?.fromTransDate,
                toTransDate: partyVatFilter?.toTransDate,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isLedgerReport
            ? await reportsRepo.getLedgerReportForAllAccounts(
                fromDate: ledgerFilter?.fromDate,
                toDate: ledgerFilter?.toDate,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isAccountStatementReport
            ? await reportsRepo.getAccountStatementReport(
                subVoucherAccountNo:
                    accountStatementFilter?.subVoucherAccountNo,
                subVoucherOraDate: accountStatementFilter?.subVoucherOraDate,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isTrialBalanceByCategoriesReport
            ? await reportsRepo.getTrialBalanceByCategoriesReport(
                reportName: reportName ?? 'AGL055',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isCostCentersReport
            ? await reportsRepo.getCostCentersReport(
                fromCostCenterNo: costCentersFilter?.fromCostCenterNo,
                toCostCenterNo: costCentersFilter?.toCostCenterNo,
                fromCenterLevel: costCentersFilter?.fromCenterLevel,
                toCenterLevel: costCentersFilter?.toCenterLevel,
                fromDate: costCentersFilter?.fromDate,
                toDate: costCentersFilter?.toDate,
                costCenterType: costCentersFilter!.costCenterType,
                reportName: costCentersFilter.reportName,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isCostCentersProjectsReport
            ? await reportsRepo.getCostCentersProjectsReport(
                fromCostCenterNo: costCentersProjectsFilter?.fromCostCenterNo,
                toCostCenterNo: costCentersProjectsFilter?.toCostCenterNo,
                fromDate: costCentersProjectsFilter?.fromDate,
                toDate: costCentersProjectsFilter?.toDate,
                reportName:
                    costCentersProjectsFilter?.reportName ??
                    reportName ??
                    'Agl026_Project2',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isMonthlyAccountComparisonReport
            ? await reportsRepo.getMonthlyAccountComparisonReport(
                fromAccountNo: monthlyComparisonFilter?.fromNo,
                toAccountNo: monthlyComparisonFilter?.toNo,
                accountType: monthlyComparisonFilter?.accountType ?? 3,
                reportName: monthlyComparisonFilter?.reportName ?? 'AGL003_Bar',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isMonthlyCostCentersComparisonReport
            ? await reportsRepo.getMonthlyCostCentersComparisonReport(
                fromCostCenterNo: monthlyComparisonFilter?.fromNo,
                toCostCenterNo: monthlyComparisonFilter?.toNo,
                accountType: monthlyComparisonFilter?.accountType ?? 3,
                reportName:
                    monthlyComparisonFilter?.reportName ?? 'AGL008_Chart',
                languageCode: languageCode,
                exportType: exportType,
              )
            : await reportsRepo.getChartOfAccountReport(
                fromAccountNo: chartOfAccountFilter?.fromAccountNo,
                toAccountNo: chartOfAccountFilter?.toAccountNo,
                fromCurrencyCode: chartOfAccountFilter?.fromCurrencyCode,
                toCurrencyCode: chartOfAccountFilter?.toCurrencyCode,
                fromAccountLevel: chartOfAccountFilter?.fromAccountLevel,
                toAccountLevel: chartOfAccountFilter?.toAccountLevel,
                accountType: chartOfAccountFilter?.accountType ?? 2,
                finalAccount: chartOfAccountFilter?.finalAccount ?? 4,
                reportName: reportName ?? 'AGL004',
                languageCode: languageCode,
                exportType: exportType,
              );

        file = result.fold(
          (failure) => throw Exception(failure.errMessage),
          (savedFile) => savedFile,
        );
      } else {
        if (exportType != 'pdf') {
          throw UnsupportedError(
            'صيغة ${_exportFormatLabel(exportType)} غير مدعومة لهذا التقرير',
          );
        }
        file = await PdfExportService.generate(
          title: title,
          description: description,
          amount: amount,
          date: date,
          status: status,
        );
      }

      if (!mounted) return;

      // ── حفظ وتنزيل الملف تلقائياً في مجلد التنزيلات بالجهاز ──
      final baseName = reportName != null && reportName.isNotEmpty
          ? reportName
          : title;
      final fileName =
          '${baseName.replaceAll(RegExp(r'\s+'), '_')}_${DateTime.now().millisecondsSinceEpoch}.${_fileExtension(exportType)}';
      final savedFile = await FileDownloadService.saveFileToDevice(
        sourceFile: file,
        defaultFileName: fileName,
      );
      if (savedFile == null) {
        throw Exception('تعذر حفظ التقرير على الجهاز');
      }
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      if (exportType == 'pdf') {
        setState(() {
          _pdfFile = file;
          _previewTitle = title;
          _previewKind = _PreviewKind.pdf;
          _isGenerating = false;
        });
        _scrollToPreview();
        CommonMethods.showToast(
          message: 'تم جلب وتنزيل التقرير بنجاح ($title)',
          type: ToastType.success,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullscreenPdfViewerScreen(
              file: file,
              title: title,
              reportName: reportName,
              autoDownloaded: true,
            ),
          ),
        );
      } else {
        final opened = await FileDownloadService.openFile(savedFile.path);
        if (!mounted) return;
        if (!opened) {
          throw Exception(
            'تم تنزيل التقرير، لكن لا يوجد تطبيق لفتح صيغة ${_exportFormatLabel(exportType)}',
          );
        }
        setState(() {
          _previewKind = _PreviewKind.none;
          _pdfFile = null;
          _isGenerating = false;
        });
        CommonMethods.showToast(
          message:
              'تم تنزيل وفتح التقرير بصيغة ${_exportFormatLabel(exportType)}',
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      setState(() => _isGenerating = false);
      String errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'حدث خطأ أثناء تحميل ملف ${_exportFormatLabel(exportType)}';

      if (errorMessage.contains('404')) {
        errorMessage = 'لا توجد بيانات';
      } else if (errorMessage.contains('401') || errorMessage.contains('403')) {
        errorMessage = 'لا توجد صلاحيات';
      }

      CommonMethods.showToast(message: errorMessage, type: ToastType.error);
    }
  }

  void _showReportPreparationDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 30.h),
            decoration: BoxDecoration(
              color: AppColor.cardColor(dialogContext),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 48.r,
                  height: 48.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 4,
                    color: AppColor.oceanBlue,
                  ),
                ),
                Gap(22.h),
                Text(
                  'جاري تحضير التقرير...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.titleFormFiledColor(dialogContext),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10.h),
                Text(
                  'قد يستغرق هذا بعض الوقت للتقارير الكبيرة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.darkTextColor(dialogContext),
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _exportFormatLabel(String exportType) => switch (exportType) {
    'pdf' => 'PDF',
    'excel' => 'Excel',
    'word' => 'Word',
    'excelformatted' => 'Excel formatted',
    _ => exportType,
  };

  String _fileExtension(String exportType) => switch (exportType) {
    'pdf' => 'pdf',
    'excel' || 'excelformatted' => 'xlsx',
    'word' => 'docx',
    _ => throw ArgumentError.value(exportType, 'exportType', 'Unsupported'),
  };

  // ── Scroll to preview ────────────────────────────────────────────────────
  final ScrollController _scrollController = ScrollController();

  void _scrollToPreview() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _closePreview() {
    setState(() {
      _previewKind = _PreviewKind.none;
      _pdfFile = null;
    });
  }

  // ── Dispose ──────────────────────────────────────────────────────────────
  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchFocusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final categoryTabs = [
      AppLocaleKey.allReports.tr(),
      AppLocaleKey.tabFinancials.tr(),
      AppLocaleKey.tabSales.tr(),
      AppLocaleKey.tabInventory.tr(),
      AppLocaleKey.tabTax.tr(),
    ];

    final List<Map<String, dynamic>> statements = [
      {
        'id': 'chart_of_account',
        'reportName': 'AGL004',
        'isApiReport': true,
        'title': AppLocaleKey.statementChartOfAccount.tr(),
        'desc': AppLocaleKey.statementChartOfAccountDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'treeGroup': 'accounts',
      },
      {
        'id': 'chart_of_account_monthly_balances',
        'reportName': 'AGL015A',
        'isChartOfAccountMonthlyBalancesReport': true,
        'isSubmenu': true,
        'chartOfAccountReportPageType': 2,
        'chartOfAccountReportAccountType': 0,
        'chartOfAccountReportName': 'AGL015A',
        'title': context.locale.languageCode == 'ar'
            ? 'الأرصدة الشهرية / كشف الحساب'
            : 'Monthly balances / Account statement',
        'desc': context.locale.languageCode == 'ar'
            ? 'تقرير الأرصدة الشهرية أو كشف الحساب'
            : 'Monthly balances or account statement report',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'treeGroup': 'accounts',
      },
      {
        'id': 'chart_of_account_monthly_movement',
        'reportName': 'AGL003',
        'isChartOfAccountMonthlyBalancesReport': true,
        'isSubmenu': true,
        'chartOfAccountReportPageType': 1,
        'chartOfAccountReportAccountType': 2,
        'chartOfAccountReportName': 'AGL003',
        'title': context.locale.languageCode == 'ar'
            ? 'الحركة الشهرية للحسابات'
            : 'Monthly account movement',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض حركة الحسابات الشهرية'
            : 'View monthly account movements',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'treeGroup': 'accounts',
      },
      {
        'id': 'account_centers_summary_for_main_accounts',
        'reportName': 'AGL0103',
        'isAccountCentersSummaryForMainAccountsReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'ملخص مراكز الحسابات الرئيسية'
            : 'Main Accounts Centers Summary',
        'desc': context.locale.languageCode == 'ar'
            ? 'ملخص الحسابات الرئيسية حسب مراكز التكلفة'
            : 'Summary of main accounts by cost centers',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_outlined,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'treeGroup': 'costCenters',
      },
      {
        'title': 'القوائم المالية',
        'desc': 'اختر: الأرباح والخسائر، الميزانية، الدخل أو التدفقات النقدية',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'isFinancialStatementsReport': true,
        'treeGroup': 'financial',
      },
      {
        'title': AppLocaleKey.statementDailyIncome.tr(),
        'desc': AppLocaleKey.statementDailyIncomeDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_view_day_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL300_D',
        'isDailyIncomeAndExpenseReport': true,
        'treeGroup': 'operations',
      },
      {
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير اليومية العامة'
            : 'General Journal Reports',
        'desc': context.locale.languageCode == 'ar'
            ? 'تقارير اليومية التفصيلية والإجمالية مع خيارات القيود والتاريخ'
            : 'Detailed and summary journal reports with entry and date filters',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.receipt_long_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL009',
        'isJournalReport': true,
        'treeGroup': 'journalReports',
      },
      {
        'title': context.locale.languageCode == 'ar'
            ? 'قيد اليومية للحسابات الرئيسية'
            : 'Main Accounts Journal Entry',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض قيد اليومية للحسابات الرئيسية بالتفصيل أو الإجمالي'
            : 'View main accounts journal entries in detail or summary',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL0101C',
        'isMainAccountsJournalReport': true,
        'treeGroup': 'journalReports',
      },
      {
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير اليومية مع تحديد المستويات'
            : 'Journal Report by Account Level',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض قيود اليومية حسب مستوى الحساب وفترة التقرير'
            : 'View journal entries by account level and report period',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.format_list_numbered_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL0104',
        'isGeneralJournalForLevelReport': true,
        'treeGroup': 'journalReports',
      },
      {
        'title': AppLocaleKey.statementExpensesWithVat.tr(),
        'desc': AppLocaleKey.statementExpensesWithVatDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.receipt_long_outlined,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL1001E',
        'isExpensesWithVatReport': true,
        'treeGroup': 'tax',
      },
      {
        'title': AppLocaleKey.statementSalesWithVat.tr(),
        'desc': AppLocaleKey.statementSalesWithVatDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.point_of_sale_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 2,
        'reportName': 'AAR1000',
        'isSalesWithVatReport': true,
        'treeGroup': 'tax',
      },
      {
        'title': AppLocaleKey.statementPurchasesWithVat.tr(),
        'desc': AppLocaleKey.statementPurchasesWithVatDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.shopping_bag_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 2,
        'reportName': 'AAR1001',
        'isPurchasesWithVatReport': true,
        'treeGroup': 'tax',
      },
      {
        'title': AppLocaleKey.statementLedger.tr(),
        'desc': AppLocaleKey.statementLedgerDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL025',
        'isLedgerReport': true,
        'treeGroup': 'ledger',
      },
      {
        'title': AppLocaleKey.statementAccountStatement.tr(),
        'desc': AppLocaleKey.statementAccountStatementDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.receipt_long_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL079',
        'isAccountStatementReport': true,
        'treeGroup': 'ledger',
      },
      {
        'title': AppLocaleKey.statementTrialBalanceByCategories.tr(),
        'desc': AppLocaleKey.statementTrialBalanceByCategoriesDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_wallet_outlined,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL055',
        'isTrialBalanceByCategoriesReport': true,
        'treeGroup': 'ledger',
      },
      {
        'title': AppLocaleKey.statementCostCenters.tr(),
        'desc': AppLocaleKey.statementCostCentersDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.business_outlined,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL007',
        'isCostCentersReport': true,
        'treeGroup': 'costCenters',
      },
      {
        'id': 'centers_monthly_balance',
        'reportName': 'AGL008A',
        'isCentersMonthlyBalanceReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'الأرصدة الشهرية لمراكز التكلفة'
            : 'Cost Centers Monthly Balances',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض أرصدة مراكز التكلفة الشهرية'
            : 'View monthly cost center balances',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_month_outlined,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'treeGroup': 'costCenters',
      },
      {
        'id': 'cost_centers_transaction',
        'reportName': 'AGL028',
        'isCostCentersTransactionReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'حركة مراكز التكلفة'
            : 'Cost Centers Transactions',
        'desc': context.locale.languageCode == 'ar'
            ? 'تفاصيل وإجماليات الحسابات حسب مراكز التكلفة'
            : 'Account details and totals by cost center',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'treeGroup': 'costCenters',
      },
      {
        'id': 'cost_centers_transaction_annual',
        'reportName': 'AGL029Y',
        'isCostCentersTransactionAnnualReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'الحركة السنوية لمراكز التكلفة'
            : 'Annual Cost Centers Transactions',
        'desc': context.locale.languageCode == 'ar'
            ? 'تفاصيل وإجماليات الحسابات حسب مراكز التكلفة سنوياً'
            : 'Annual account details and totals by cost center',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_view_month_outlined,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'treeGroup': 'costCenters',
      },
      {
        'title': AppLocaleKey.statementCostCentersProjects.tr(),
        'desc': AppLocaleKey.statementCostCentersProjectsDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.domain_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'Agl026_Project2',
        'isCostCentersProjectsReport': true,
        'treeGroup': 'costCenters',
      },
      {
        'title': AppLocaleKey.statementMonthlyAccountsComparison.tr(),
        'desc': AppLocaleKey.statementMonthlyAccountsComparisonDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.compare_arrows_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL003_Bar',
        'isMonthlyAccountComparisonReport': true,
        'treeGroup': 'accountComparisons',
      },
      {
        'title': AppLocaleKey.statementMonthlyCostCentersComparison.tr(),
        'desc': AppLocaleKey.statementMonthlyCostCentersComparisonDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.insights_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL008_Chart',
        'isMonthlyCostCentersComparisonReport': true,
        'treeGroup': 'centersComparison',
      },
      {
        'id': 'centers_comparison_report',
        'title': context.locale.languageCode == 'ar'
            ? 'مقارنة حركة المراكز الشهرية'
            : 'Monthly Cost Center Movements Comparison',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة حركة مراكز التكلفة الشهرية'
            : 'Compare monthly cost center movements',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.compare_arrows_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL092',
        'isCentersComparisonReport': true,
        'treeGroup': 'centersComparison',
      },
      {
        'id': 'centers_comparison_by_months_report',
        'title': context.locale.languageCode == 'ar'
            ? 'مقارنة المراكز بالشهور'
            : 'Cost Centers Comparison by Months',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة مراكز التكلفة خلال فترة شهرية'
            : 'Compare cost centers over a monthly period',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_month_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL091',
        'isCentersComparisonByMonthsReport': true,
        'treeGroup': 'centersComparison',
      },
      {
        'id': 'centers_comparison_by_month_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير مقارنة شهر - المراكز'
            : 'Cost Center Month Comparison Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة مراكز التكلفة في شهر محدد'
            : 'Compare cost centers in a selected month',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.event_repeat_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL090',
        'isCentersComparisonByMonthReport': true,
        'treeGroup': 'centersComparison',
      },
      {
        'id': 'centers_comparison_balances_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير مقارنة أرصدة مراكز التكلفة'
            : 'Cost Center Balances Comparison Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة أرصدة مراكز التكلفة حسب نوع الرصيد والفترة'
            : 'Compare cost center balances by balance and period type',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_wallet_outlined,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL051',
        'isCentersComparisonBalancesReport': true,
        'treeGroup': 'centersComparison',
      },
      {
        'id': 'accounts_centers_comparison_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير مقارنة أرصدة مراكز الحسابات'
            : 'Account Center Balances Comparison Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة أرصدة الحسابات ومراكز التكلفة'
            : 'Compare account and cost center balances',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.compare_arrows_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL051A',
        'isAccountsCentersComparisonReport': true,
        'treeGroup': 'accountCentersComparison',
      },
      {
        'id': 'accounts_centers_monthly_comparison_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير مقارنة مراكز الحسابات بالشهور'
            : 'Account Centers Balances Comparison by Month',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة أرصدة مراكز الحسابات شهرياً'
            : 'Compare account center balances monthly',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_month_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL091B',
        'isAccountsCentersMonthlyComparisonReport': true,
        'treeGroup': 'accountCentersComparison',
      },
      {
        'id': 'accounts_centers_monthly_movements_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير مقارنة حركة مراكز الحسابات الشهرية'
            : 'Account Centers Monthly Movements Comparison',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة حركة مراكز الحسابات شهرياً'
            : 'Compare account center movements monthly',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.compare_arrows_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL092A',
        'isAccountsCentersMonthlyMovementsReport': true,
        'treeGroup': 'accountCentersComparison',
      },
      {
        'id': 'accounts_comparison',
        'reportName': 'AGL052',
        'isAccountsComparisonReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'مقارنة حركة الحسابات الشهرية'
            : 'Monthly Account Movements Comparison',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة حركة الحسابات الشهرية حسب القوائم المالية'
            : 'Compare monthly account movements by financial statement type',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.compare_arrows_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'treeGroup': 'accountComparisons',
      },
      {
        'id': 'accounts_monthly_comparison',
        'reportName': 'AGL053',
        'isAccountsMonthlyComparisonReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'مقارنة الحسابات بالشهور'
            : 'Accounts Comparison by Months',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة الحسابات بين الشهور مع تحديد نوع الرصيد'
            : 'Compare accounts across months by balance type',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_month_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'treeGroup': 'accountComparisons',
      },
      {
        'id': 'accounts_comparison_by_month',
        'reportName': 'AGL054',
        'isAccountsComparisonByMonthReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير مقارنة شهر - الحسابات'
            : 'Account Month Comparison',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة الحسابات في شهر محدد'
            : 'Compare accounts for a selected month',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.event_repeat_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'treeGroup': 'accountComparisons',
      },
      {
        'id': 'accounts_balance_periodically',
        'reportName': 'AGL006',
        'isAccountsBalancePeriodicallyReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'مقارنة دليل الحسابات'
            : 'Chart of Accounts Comparison',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة دليل الحسابات حسب الرصيد والفترة'
            : 'Compare chart of accounts by balance and period',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.assessment_outlined,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'treeGroup': 'accountComparisons',
      },
    ];

    final normalizedQuery = _normalizeSearchText(_searchQuery);
    final filteredStatements = statements.where((item) {
      if (normalizedQuery.isEmpty) {
        return true;
      }

      final title = _normalizeSearchText(item['title'] as String);
      final desc = _normalizeSearchText(item['desc'] as String);
      final code = _normalizeSearchText(item['reportName'] as String? ?? '');
      final category = _normalizeSearchText(
        categoryTabs[(item['category'] as int)],
      );
      return title.contains(normalizedQuery) ||
          desc.contains(normalizedQuery) ||
          code.contains(normalizedQuery) ||
          category.contains(normalizedQuery);
    }).toList();

    final visibleSections = _buildCategorySections(filteredStatements);
    final totalCategories = statements
        .map((statement) => statement['treeGroup'])
        .whereType<String>()
        .toSet()
        .length;

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: ReportsPageHeaderWidget(
                onExport: _showExportModal,
                onToggleLanguage: _toggleLanguage,
                reportCount: statements.length,
                categoryCount: totalCategories,
              ),
            ),

            SliverToBoxAdapter(child: _buildPreviewArea()),
            SliverToBoxAdapter(child: Gap(14.h)),
            SliverToBoxAdapter(
              child: ReportsSearchFieldWidget(
                controller: _searchController,
                focusNode: _searchFocusNode,
                isFocused: _searchFocusNode.hasFocus,
                hintText: context.locale.languageCode == 'ar'
                    ? 'ابحث في ${statements.length} تقرير...'
                    : 'Search ${statements.length} reports...',
                onChanged: _onSearchChanged,
                onSubmitted: _applySearch,
                onClear: _clearSearch,
              ),
            ),
            SliverToBoxAdapter(
              child: ReportsSearchSummaryWidget(
                query: _searchQuery,
                resultCount: filteredStatements.length,
              ),
            ),
            SliverToBoxAdapter(child: Gap(16.h)),
            if (visibleSections.isEmpty)
              SliverToBoxAdapter(
                child: ReportsEmptyStateWidget(
                  query: _searchQuery,
                  onClearSearch: _clearSearch,
                  onShowAllReports: _clearSearch,
                ),
              )
            else
              ReportsCategoryAccordionListWidget(
                sections: visibleSections,
                searchQuery: _searchQuery,
                reportBuilder: _buildReportItem,
              ),
            SliverToBoxAdapter(child: Gap(100.h)),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Preview Area (تظهر ديناميكيًا داخل الصفحة)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildPreviewArea() {
    // إذا لا يوجد معاينة → مساحة صفرية.
    if (_previewKind == _PreviewKind.none && !_isGenerating) {
      return const SizedBox.shrink();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        child: SizedBox(height: 500.h, child: _buildPreviewContent()),
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (_isGenerating) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColor.emeraldTeal.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.emeraldTeal.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColor.emeraldTeal.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 32.r,
                  height: 32.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColor.emeraldTeal,
                  ),
                ),
              ),
              Gap(16.h),
              Text(
                'جاري جلب وإنشاء التقرير المالي...',
                style: TextStyle(
                  color: AppColor.titleFormFiledColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
              Gap(6.h),
              Text(
                'Report API • $_previewTitle',
                style: TextStyle(
                  color: AppColor.mintTeal.withValues(alpha: 0.8),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    switch (_previewKind) {
      case _PreviewKind.pdf:
        if (_pdfFile == null) return const SizedBox.shrink();
        return PdfPreviewPanel(
          file: _pdfFile!,
          title: _previewTitle,
          onClose: _closePreview,
        );

      case _PreviewKind.none:
        return const SizedBox.shrink();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Statements List
  // ─────────────────────────────────────────────────────────────────────────
  List<ReportsCategorySectionData> _buildCategorySections(
    List<Map<String, dynamic>> filteredStatements,
  ) {
    final sections = <ReportsCategorySectionData>[];
    final isArabic = context.locale.languageCode == 'ar';
    const groups = [
      (
        id: 3,
        key: 'centersComparison',
        titleAr: 'مقارنة المراكز',
        titleEn: 'Cost Centers Comparison',
        icon: Icons.compare_arrows_rounded,
        accent: AppColor.purpleAccent,
      ),
      (
        id: 9,
        key: 'accountCentersComparison',
        titleAr: 'مقارنة مراكز الحسابات',
        titleEn: 'Account Centers Comparison',
        icon: Icons.account_tree_outlined,
        accent: AppColor.oceanBlue,
      ),
      (
        id: 1,
        key: 'accounts',
        titleAr: 'دليل الحسابات',
        titleEn: 'Chart of accounts',
        icon: Icons.account_tree_rounded,
        accent: AppColor.oceanBlue,
      ),
      (
        id: 2,
        key: 'costCenters',
        titleAr: 'مراكز التكلفة',
        titleEn: 'Cost centers',
        icon: Icons.business_rounded,
        accent: AppColor.purpleAccent,
      ),
      (
        id: 4,
        key: 'accountComparisons',
        titleAr: 'تقارير المقارنة للحسابات',
        titleEn: 'Account comparison reports',
        icon: Icons.insights_rounded,
        accent: AppColor.emeraldTeal,
      ),
      (
        id: 10,
        key: 'journalReports',
        titleAr: 'تقارير اليومية العامة',
        titleEn: 'General Journal Reports',
        icon: Icons.receipt_long_rounded,
        accent: AppColor.oceanBlue,
      ),
      (
        id: 5,
        key: 'operations',
        titleAr: 'تقارير العمليات',
        titleEn: 'Operations reports',
        icon: Icons.receipt_long_rounded,
        accent: AppColor.warningOrange,
      ),
      (
        id: 6,
        key: 'tax',
        titleAr: 'تقارير ضريبة القيمة المضافة',
        titleEn: 'VAT reports',
        icon: Icons.percent_rounded,
        accent: AppColor.emeraldTeal,
      ),
      (
        id: 7,
        key: 'ledger',
        titleAr: 'تقارير الأستاذ والحسابات',
        titleEn: 'Ledger and account reports',
        icon: Icons.menu_book_rounded,
        accent: AppColor.oceanBlue,
      ),
      (
        id: 8,
        key: 'financial',
        titleAr: 'القوائم المالية',
        titleEn: 'Financial statements',
        icon: Icons.account_balance_rounded,
        accent: AppColor.emeraldTeal,
      ),
    ];

    for (final group in groups) {
      final categoryReports = filteredStatements
          .where((statement) => statement['treeGroup'] == group.key)
          .toList();
      if (categoryReports.isEmpty) continue;

      sections.add(
        ReportsCategorySectionData(
          id: group.id,
          title: isArabic ? group.titleAr : group.titleEn,
          icon: group.icon,
          accent: group.accent,
          reports: categoryReports,
        ),
      );
    }

    return sections;
  }

  Widget _buildReportItem(
    Map<String, dynamic> statement, {
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    final title = statement['title'] as String;
    final description = statement['desc'] as String;
    final amount = statement['amount'] as String? ?? '';
    final date = statement['date'] as String? ?? '';
    final status = statement['status'] as String;
    Future<void> exportReport(String exportType) => _handleExportReport(
      title: title,
      description: description,
      amount: amount,
      date: date,
      status: status,
      exportType: exportType,
      reportName: statement['reportName'] as String?,
      isApiReport: statement['isApiReport'] == true,
      isIncomeAndExpenseSituationReport:
          statement['isIncomeAndExpenseSituationReport'] == true,
      isDailyIncomeAndExpenseReport:
          statement['isDailyIncomeAndExpenseReport'] == true,
      isJournalReport: statement['isJournalReport'] == true,
      isMainAccountsJournalReport:
          statement['isMainAccountsJournalReport'] == true,
      isGeneralJournalForLevelReport:
          statement['isGeneralJournalForLevelReport'] == true,
      isExpensesWithVatReport: statement['isExpensesWithVatReport'] == true,
      isSalesWithVatReport: statement['isSalesWithVatReport'] == true,
      isPurchasesWithVatReport: statement['isPurchasesWithVatReport'] == true,
      isLedgerReport: statement['isLedgerReport'] == true,
      isAccountStatementReport: statement['isAccountStatementReport'] == true,
      isTrialBalanceByCategoriesReport:
          statement['isTrialBalanceByCategoriesReport'] == true,
      isFinancialStatementsReport:
          statement['isFinancialStatementsReport'] == true,
      isCostCentersReport: statement['isCostCentersReport'] == true,
      isCentersMonthlyBalanceReport:
          statement['isCentersMonthlyBalanceReport'] == true,
      isCentersComparisonReport: statement['isCentersComparisonReport'] == true,
      isCentersComparisonByMonthsReport:
          statement['isCentersComparisonByMonthsReport'] == true,
      isCentersComparisonByMonthReport:
          statement['isCentersComparisonByMonthReport'] == true,
      isCentersComparisonBalancesReport:
          statement['isCentersComparisonBalancesReport'] == true,
      isAccountsCentersComparisonReport:
          statement['isAccountsCentersComparisonReport'] == true,
      isAccountsCentersMonthlyComparisonReport:
          statement['isAccountsCentersMonthlyComparisonReport'] == true,
      isAccountsCentersMonthlyMovementsReport:
          statement['isAccountsCentersMonthlyMovementsReport'] == true,
      isCostCentersTransactionReport:
          statement['isCostCentersTransactionReport'] == true,
      isCostCentersTransactionAnnualReport:
          statement['isCostCentersTransactionAnnualReport'] == true,
      isCostCentersProjectsReport:
          statement['isCostCentersProjectsReport'] == true,
      isAccountCentersSummaryForMainAccountsReport:
          statement['isAccountCentersSummaryForMainAccountsReport'] == true,
      isMonthlyAccountComparisonReport:
          statement['isMonthlyAccountComparisonReport'] == true,
      isMonthlyCostCentersComparisonReport:
          statement['isMonthlyCostCentersComparisonReport'] == true,
      isAccountsComparisonReport:
          statement['isAccountsComparisonReport'] == true,
      isAccountsMonthlyComparisonReport:
          statement['isAccountsMonthlyComparisonReport'] == true,
      isAccountsComparisonByMonthReport:
          statement['isAccountsComparisonByMonthReport'] == true,
      isAccountsBalancePeriodicallyReport:
          statement['isAccountsBalancePeriodicallyReport'] == true,
      isChartOfAccountMonthlyBalancesReport:
          statement['isChartOfAccountMonthlyBalancesReport'] == true,
      chartOfAccountReportPageType:
          statement['chartOfAccountReportPageType'] as int? ?? 2,
      chartOfAccountReportAccountType:
          statement['chartOfAccountReportAccountType'] as int? ?? 0,
      chartOfAccountReportName:
          statement['chartOfAccountReportName'] as String? ?? 'AGL015A',
    );

    return ReportsTableItemWidget(
      title: title,
      description: description,
      reportCode: statement['reportName'] as String?,
      icon: statement['icon'] as IconData?,
      accent: statement['iconColor'] as Color?,
      searchQuery: _searchQuery,
      isSelected: isSelected,
      onSelect: onSelect,
      onExportPdf: () => exportReport('pdf'),
      onExportFormat: exportReport,
    );
  }
}
