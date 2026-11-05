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
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/reports/data/repository/reports_repo.dart';
import 'package:my_template/features/reports/presentation/view/widget/file_download_service.dart';
import 'package:my_template/features/reports/presentation/view/widget/cash_in_cash_out_voucher_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/checks_data_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/center_on_center_analysis_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/master_accounts_or_centers_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/general_journal_for_level_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/account_statement_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/accounts_comparison_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/accounts_centers_comparison_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/account_centers_summary_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/account_centers_trial_balances_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/chart_of_account_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/chart_of_account_monthly_balances_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/cost_centers_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/cost_centers_projects_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/cost_centers_transaction_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/consolidated_general_ledger_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/fullscreen_pdf_viewer_screen.dart';
import 'package:my_template/features/reports/presentation/view/widget/annual_ledger_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/general_ledger_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/general_ledger_audit_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/general_ledger_payable_aging_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/general_ledger_posting_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/subsidiary_ledger_account_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/trial_balance_by_categories_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/final_reports_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/additional_final_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/trial_balance_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/trial_balances_report_for_period_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/integration_general_ledger_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/ledger_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/ledger_report_for_assistant_accounts_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/ledger_report_for_main_accounts_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/ledger_report_per_users_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/journal_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/monthly_comparison_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/party_vat_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/pdf_export_service.dart';
import 'package:my_template/features/reports/presentation/view/widget/pdf_preview_panel.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_screen_widgets.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_table_item_widget.dart';
import 'package:my_template/features/lookup/presentation/widgets/customer_datum_dropdown.dart';

enum _PreviewKind { none, pdf }

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
    if (balance == 0) {
      return periodically == 0 ? 'AGL051$suffix' : 'AGL050$suffix';
    }
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
                style: AppTextStyle.bodyLarge(context).copyWith(
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
                subtitle: 'Report/LedgerReportForAllAccounts (AGL021C)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: AppLocaleKey.statementLedger.tr(),
                    description: AppLocaleKey.statementLedgerDesc.tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL021C',
                    isLedgerReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.menu_book_rounded,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'حساب الأستاذ العام'
                    : 'General Ledger Account Report',
                subtitle: 'Report/LedgerReport (AGL100)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'حساب الأستاذ العام'
                        : 'General Ledger Account Report',
                    description: context.locale.languageCode == 'ar'
                        ? 'كشف حساب الأستاذ العام مع العملات والتحليلات'
                        : 'General ledger with currency and analytical filters',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL100',
                    isGeneralLedgerReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.account_tree_outlined,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير حساب الأستاذ المساعد'
                    : 'Subsidiary Ledger Account Report',
                subtitle: 'Report/LedgerReport (AGL021AS / AGL023AS)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير حساب الأستاذ المساعد'
                        : 'Subsidiary Ledger Account Report',
                    description: context.locale.languageCode == 'ar'
                        ? 'كشف حساب الأستاذ المساعد ملخص أو تفصيلي'
                        : 'Subsidiary ledger summary or detailed account statement',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL021AS',
                    isSubsidiaryLedgerAccountReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.fact_check_rounded,
                color: AppColor.purpleAccent,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير تدقيق الأستاذ العام'
                    : 'General Ledger Audit Report',
                subtitle: 'Report/LedgerReport (AGL100)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير تدقيق الأستاذ العام'
                        : 'General Ledger Audit Report',
                    description: context.locale.languageCode == 'ar'
                        ? 'كشف تدقيق الأستاذ العام حسب الحساب والتاريخ'
                        : 'General ledger audit by account and date',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL100',
                    isGeneralLedgerAuditReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.post_add_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ترحيل الأستاذ العام'
                    : 'General Ledger Posting Report',
                subtitle:
                    'Report/LedgerReport (AGL021CLP / AGL023CLP / AGL025LP)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير ترحيل الأستاذ العام'
                        : 'General Ledger Posting Report',
                    description: context.locale.languageCode == 'ar'
                        ? 'كشف ترحيل الأستاذ العام ملخص أو تفصيلي'
                        : 'General ledger posting summary or detailed',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL021CLP',
                    isGeneralLedgerPostingReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.elderly_rounded,
                color: AppColor.warningOrange,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير الأستاذ العام مع تحليل أعمار الذمم الدائنة'
                    : 'General Ledger Report with Accounts Payable Aging Analysis (Creditors)',
                subtitle: 'Report/LedgerReport (AGL041C / AGL040C)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير الأستاذ العام مع تحليل أعمار الذمم الدائنة'
                        : 'General Ledger Report with Accounts Payable Aging Analysis (Creditors)',
                    description: context.locale.languageCode == 'ar'
                        ? 'كشف الأستاذ العام مع تحليل أعمار الذمم الدائنة ملخص أو تفصيلي'
                        : 'General ledger with accounts payable aging analysis summary or detailed',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL041C',
                    isGeneralLedgerPayableAgingReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.menu_book_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير الأستاذ العام السنوي'
                    : 'Annual General Ledger Report',
                subtitle: 'Report/LedgerReport (AGL021Y / AGL023Y)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير الأستاذ العام السنوي'
                        : 'Annual General Ledger Report',
                    description: context.locale.languageCode == 'ar'
                        ? 'كشف الأستاذ السنوي ملخص أو تفصيلي'
                        : 'Annual ledger summary or detailed',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL021Y',
                    isAnnualLedgerReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.menu_book_rounded,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير الأستاذ العام للتكامل'
                    : 'Integration General Ledger Report',
                subtitle: 'Report/LedgerReport (AGLT26C / AGLT26)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير الأستاذ العام للتكامل'
                        : 'Integration General Ledger Report',
                    description: context.locale.languageCode == 'ar'
                        ? 'كشف الأستاذ العام ملخص أو تفصيلي'
                        : 'Summary or detailed general ledger statement',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGLT26C',
                    isIntegrationGeneralLedgerReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.menu_book_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير الأستاذ العام الموحد للمنشآت'
                    : 'Consolidated General Ledger Report for Establishments',
                subtitle: 'Report/LedgerReport (AGL021T / AGL023T)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير الأستاذ العام الموحد للمنشآت'
                        : 'Consolidated General Ledger Report for Establishments',
                    description: context.locale.languageCode == 'ar'
                        ? 'كشف الأستاذ العام الموحد ملخص أو تفصيلي للمنشآت'
                        : 'Consolidated summary or detailed general ledger for establishments',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL021T',
                    isConsolidatedGeneralLedgerReport: true,
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
                icon: Icons.account_balance_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'التقارير الختامية'
                    : 'Final Reports',
                subtitle: 'Report/FinancialStatementsReport (AGL034A - AGL044)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'التقارير الختامية'
                        : 'Final Reports',
                    description: context.locale.languageCode == 'ar'
                        ? 'المتاجرة والأرباح والخسائر والميزانية والدخل والتدفقات النقدية'
                        : 'Trading, profit and loss, balance sheet, income statement and cash flow',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL034A',
                    isFinancialStatementsReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.playlist_add_check_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ختامي إضافي'
                    : 'Additional Final Report',
                subtitle: 'Report/AdditionalFinalReport (AGL037A - AGL045C)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير ختامي إضافي'
                        : 'Additional Final Report',
                    description: context.locale.languageCode == 'ar'
                        ? 'تقرير ختامي إضافي برقم الحساب أو بدونه أو بطريقة طولية أو بالمقارنات'
                        : 'Additional final report with or without account numbers, vertical, or comparative',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL037A',
                    isAdditionalFinalReport: true,
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
                icon: Icons.account_balance_rounded,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ميزان المراجعة'
                    : 'Trial Balance Report',
                subtitle: 'Report/TrialBalanceReport (AGL030)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير ميزان المراجعة'
                        : 'Trial Balance Report',
                    description: '',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL030',
                    isTrialBalanceByLevelReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.calendar_month_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ميزان المراجعة الشهري'
                    : 'Monthly Trial Balance Report',
                subtitle: 'Report/TrialBalanceReport (AGL060 / AGL060A)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير ميزان المراجعة الشهري'
                        : 'Monthly Trial Balance Report',
                    description: '',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL060',
                    isMonthlyTrialBalanceReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.calendar_view_month_rounded,
                color: AppColor.purpleAccent,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ميزان المراجعة الشهري حسب المجموعات'
                    : 'Monthly Trial Balance Report by Groups',
                subtitle: 'Report/TrialBalanceReport (AGL060H)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير ميزان المراجعة الشهري حسب المجموعات'
                        : 'Monthly Trial Balance Report by Groups',
                    description: '',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL060H',
                    isMonthlyTrialBalanceWithoutAccountLevelReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.account_balance_wallet_rounded,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ميزان المراجعة حسب المراكز'
                    : 'Trial Balance Report by Centers',
                subtitle: 'Report/TrialBalanceReport (AGL031)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير ميزان المراجعة حسب المراكز'
                        : 'Trial Balance Report by Centers',
                    description: '',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL031',
                    isTrialBalanceOptionalAccountLevelReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.account_balance_rounded,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ميزان المراجعة لفترة'
                    : 'Trial Balance Report for a Period',
                subtitle: 'Report/TrialBalancesReportForPeriod (AGL078)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير ميزان المراجعة لفترة'
                        : 'Trial Balance Report for a Period',
                    description: '',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL078',
                    isTrialBalancesReportForPeriod: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(
                icon: Icons.domain_disabled_outlined,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقارير ميزان المراجعة حسب المراكز'
                    : 'Trial Balance Reports by Centers',
                subtitle: 'Report/AccountCentersTrialBalancesReport (AGL026C)',
                onTap: () {
                  Navigator.pop(ctx);
                  _handleExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقارير ميزان المراجعة حسب المراكز'
                        : 'Trial Balance Reports by Centers',
                    description: '',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL026C',
                    isAccountCentersTrialBalancesReport: true,
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
                    style: AppTextStyle.bodyMedium(context).copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.titleFormFiledColor(context),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyle.bodySmall(context).copyWith(
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
    bool isCashInCashOutVoucherReport = false,
    bool isChecksDataReport = false,
    bool isMasterAccountsOrCentersReport = false,
    int masterAccountsOrCentersReportPageType = 1,
    String masterAccountsOrCentersSummarizedReportName = 'AGL076',
    String masterAccountsOrCentersDetailedReportName = 'AGL077A',
    bool isMasterCentersReport = false,
    bool isCenterOnCenterAnalysisReport = false,
    bool isExpensesWithVatReport = false,
    bool isSalesWithVatReport = false,
    bool isPurchasesWithVatReport = false,
    bool isLedgerReport = false,
    bool isGeneralLedgerReport = false,
    bool isAnnualLedgerReport = false,
    bool isIntegrationGeneralLedgerReport = false,
    bool isConsolidatedGeneralLedgerReport = false,
    bool isGeneralLedgerAuditReport = false,
    bool isGeneralLedgerPostingReport = false,
    bool isGeneralLedgerPayableAgingReport = false,
    bool isSubsidiaryLedgerAccountReport = false,
    bool isLedgerReportForAssistantAccounts = false,
    bool isLedgerReportForMainAccounts = false,
    bool isLedgerReportPerUsers = false,
    bool isAccountStatementReport = false,
    bool isTrialBalanceByCategoriesReport = false,
    bool isTrialBalanceByLevelReport = false,
    bool isMonthlyTrialBalanceReport = false,
    bool isMonthlyTrialBalanceWithoutAccountLevelReport = false,
    bool isTrialBalanceOptionalAccountLevelReport = false,
    bool isTrialBalancesReportForPeriod = false,
    bool isAccountCentersTrialBalancesReport = false,
    bool isFinancialStatementsReport = false,
    bool isAdditionalFinalReport = false,
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

    TrialBalanceByCategoriesReportFilterSelection?
    trialBalanceByCategoriesFilter;
    if (isTrialBalanceByCategoriesReport) {
      trialBalanceByCategoriesFilter =
          await TrialBalanceByCategoriesReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || trialBalanceByCategoriesFilter == null) return;
      reportName = trialBalanceByCategoriesFilter.reportName;
      exportType = trialBalanceByCategoriesFilter.exportType;
    }

    TrialBalanceReportFilterSelection? trialBalanceByLevelFilter;
    if (isTrialBalanceByLevelReport) {
      trialBalanceByLevelFilter =
          await TrialBalanceReportFilterBottomSheetWidget.show(
            context,
            title: title,
            mode: TrialBalanceReportMode.byLevel,
            initialExportType: exportType,
          );
      if (!mounted || trialBalanceByLevelFilter == null) return;
      reportName = trialBalanceByLevelFilter.reportName;
      exportType = trialBalanceByLevelFilter.exportType;
    }
    TrialBalanceReportFilterSelection? monthlyTrialBalanceFilter;
    if (isMonthlyTrialBalanceReport) {
      monthlyTrialBalanceFilter =
          await TrialBalanceReportFilterBottomSheetWidget.show(
            context,
            title: title,
            mode: TrialBalanceReportMode.monthly,
            initialExportType: exportType,
            initialReportName: reportName ?? 'AGL060',
          );
      if (!mounted || monthlyTrialBalanceFilter == null) return;
      reportName = monthlyTrialBalanceFilter.reportName;
      exportType = monthlyTrialBalanceFilter.exportType;
    }
    TrialBalanceReportFilterSelection?
    monthlyTrialBalanceWithoutAccountLevelFilter;
    if (isMonthlyTrialBalanceWithoutAccountLevelReport) {
      monthlyTrialBalanceWithoutAccountLevelFilter =
          await TrialBalanceReportFilterBottomSheetWidget.show(
            context,
            title: title,
            mode: TrialBalanceReportMode.monthlyWithoutAccountLevel,
            initialExportType: exportType,
            initialReportName: reportName ?? 'AGL060H',
          );
      if (!mounted || monthlyTrialBalanceWithoutAccountLevelFilter == null) {
        return;
      }
      reportName = monthlyTrialBalanceWithoutAccountLevelFilter.reportName;
      exportType = monthlyTrialBalanceWithoutAccountLevelFilter.exportType;
    }
    TrialBalanceReportFilterSelection? trialBalanceOptionalAccountLevelFilter;
    if (isTrialBalanceOptionalAccountLevelReport) {
      trialBalanceOptionalAccountLevelFilter =
          await TrialBalanceReportFilterBottomSheetWidget.show(
            context,
            title: title,
            mode: TrialBalanceReportMode.optionalAccountLevel,
            initialExportType: exportType,
            initialReportName: reportName ?? 'AGL031',
          );
      if (!mounted || trialBalanceOptionalAccountLevelFilter == null) return;
      reportName = trialBalanceOptionalAccountLevelFilter.reportName;
      exportType = trialBalanceOptionalAccountLevelFilter.exportType;
    }

    FinalReportsFilterSelection? finalReportsFilter;
    if (isFinancialStatementsReport) {
      finalReportsFilter = await FinalReportsFilterBottomSheetWidget.show(
        context,
        title: title,
        initialExportType: exportType,
      );
      if (!mounted || finalReportsFilter == null) return;
      reportName = finalReportsFilter.reportName;
      exportType = finalReportsFilter.exportType;
    }

    AdditionalFinalReportFilterSelection? additionalFinalReportFilter;
    if (isAdditionalFinalReport) {
      additionalFinalReportFilter =
          await AdditionalFinalReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || additionalFinalReportFilter == null) return;
      reportName = additionalFinalReportFilter.reportName;
      exportType = additionalFinalReportFilter.exportType;
    }

    MonthRangeSelection? monthRange;
    if (isIncomeAndExpenseSituationReport) {
      monthRange = await MonthRangeBottomSheetWidget.show(
        context,
        title: AppLocaleKey.selectMonthRange.tr(),
      );
      if (!mounted || monthRange == null) return;
    }
    AnnualLedgerReportFilterSelection? annualLedgerFilter;
    if (isAnnualLedgerReport) {
      annualLedgerFilter = await AnnualLedgerReportFilterBottomSheetWidget.show(
        context,
        title: title,
        initialExportType: exportType,
      );
      if (!mounted || annualLedgerFilter == null) return;
      exportType = annualLedgerFilter.exportType;
    }
    IntegrationGeneralLedgerReportFilterSelection?
    integrationGeneralLedgerFilter;
    if (isIntegrationGeneralLedgerReport) {
      integrationGeneralLedgerFilter =
          await IntegrationGeneralLedgerReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || integrationGeneralLedgerFilter == null) return;
      exportType = integrationGeneralLedgerFilter.exportType;
      reportName = integrationGeneralLedgerFilter.reportName;
    }
    ConsolidatedGeneralLedgerReportFilterSelection?
    consolidatedGeneralLedgerFilter;
    if (isConsolidatedGeneralLedgerReport) {
      consolidatedGeneralLedgerFilter =
          await ConsolidatedGeneralLedgerReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || consolidatedGeneralLedgerFilter == null) return;
      exportType = consolidatedGeneralLedgerFilter.exportType;
      reportName = consolidatedGeneralLedgerFilter.reportName;
    }
    GeneralLedgerAuditReportFilterSelection? generalLedgerAuditFilter;
    if (isGeneralLedgerAuditReport) {
      generalLedgerAuditFilter =
          await GeneralLedgerAuditReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || generalLedgerAuditFilter == null) return;
      exportType = generalLedgerAuditFilter.exportType;
      reportName = generalLedgerAuditFilter.reportName;
    }
    GeneralLedgerPostingReportFilterSelection? generalLedgerPostingFilter;
    if (isGeneralLedgerPostingReport) {
      generalLedgerPostingFilter =
          await GeneralLedgerPostingReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || generalLedgerPostingFilter == null) return;
      exportType = generalLedgerPostingFilter.exportType;
      reportName = generalLedgerPostingFilter.reportName;
    }
    GeneralLedgerPayableAgingReportFilterSelection?
    generalLedgerPayableAgingFilter;
    if (isGeneralLedgerPayableAgingReport) {
      generalLedgerPayableAgingFilter =
          await GeneralLedgerPayableAgingReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || generalLedgerPayableAgingFilter == null) return;
      exportType = generalLedgerPayableAgingFilter.exportType;
      reportName = generalLedgerPayableAgingFilter.reportName;
    }
    SubsidiaryLedgerAccountReportFilterSelection? subsidiaryLedgerFilter;
    if (isSubsidiaryLedgerAccountReport) {
      subsidiaryLedgerFilter =
          await SubsidiaryLedgerAccountReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || subsidiaryLedgerFilter == null) return;
      exportType = subsidiaryLedgerFilter.exportType;
      reportName = subsidiaryLedgerFilter.reportName;
    }
    GeneralLedgerReportFilterSelection? generalLedgerFilter;
    if (isGeneralLedgerReport) {
      generalLedgerFilter =
          await GeneralLedgerReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || generalLedgerFilter == null) return;
      exportType = generalLedgerFilter.exportType;
    }
    LedgerReportFilterSelection? ledgerFilter;
    if (isLedgerReport) {
      ledgerFilter = await LedgerReportFilterBottomSheetWidget.show(
        context,
        title: title,
      );
      if (!mounted || ledgerFilter == null) return;
    }
    LedgerReportForAssistantAccountsFilterSelection?
    assistantAccountsLedgerFilter;
    if (isLedgerReportForAssistantAccounts) {
      assistantAccountsLedgerFilter =
          await LedgerReportForAssistantAccountsFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || assistantAccountsLedgerFilter == null) return;
      exportType = assistantAccountsLedgerFilter.exportType;
    }
    LedgerReportForMainAccountsFilterSelection? mainAccountsLedgerFilter;
    if (isLedgerReportForMainAccounts) {
      mainAccountsLedgerFilter =
          await LedgerReportForMainAccountsFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || mainAccountsLedgerFilter == null) return;
      exportType = mainAccountsLedgerFilter.exportType;
    }
    LedgerReportPerUsersFilterSelection? perUsersLedgerFilter;
    if (isLedgerReportPerUsers) {
      perUsersLedgerFilter =
          await LedgerReportPerUsersFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || perUsersLedgerFilter == null) return;
      exportType = perUsersLedgerFilter.exportType;
      reportName = perUsersLedgerFilter.reportName;
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
    TrialBalancesReportForPeriodFilterSelection?
    trialBalancesReportForPeriodFilter;
    if (isTrialBalancesReportForPeriod) {
      trialBalancesReportForPeriodFilter =
          await TrialBalancesReportForPeriodFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || trialBalancesReportForPeriodFilter == null) return;
      exportType = trialBalancesReportForPeriodFilter.exportType;
    }
    AccountCentersTrialBalancesReportFilterSelection?
    accountCentersTrialBalancesFilter;
    if (isAccountCentersTrialBalancesReport) {
      accountCentersTrialBalancesFilter =
          await AccountCentersTrialBalancesReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || accountCentersTrialBalancesFilter == null) return;
      exportType = accountCentersTrialBalancesFilter.exportType;
      reportName = 'AGL026C';
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
    CashInCashOutVoucherReportFilterSelection? cashVoucherReportFilter;
    if (isCashInCashOutVoucherReport) {
      cashVoucherReportFilter =
          await CashInCashOutVoucherReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || cashVoucherReportFilter == null) return;
      exportType = cashVoucherReportFilter.exportType;
    }
    ChecksDataReportFilterSelection? checksDataReportFilter;
    if (isChecksDataReport) {
      checksDataReportFilter =
          await ChecksDataReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || checksDataReportFilter == null) return;
      exportType = checksDataReportFilter.exportType;
    }
    MasterAccountsOrCentersReportFilterSelection? masterAccountsOrCentersFilter;
    if (isMasterAccountsOrCentersReport) {
      masterAccountsOrCentersFilter =
          await MasterAccountsOrCentersReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
            summarizedReportName: masterAccountsOrCentersSummarizedReportName,
            detailedReportName: masterAccountsOrCentersDetailedReportName,
            isCentersReport: isMasterCentersReport,
          );
      if (!mounted || masterAccountsOrCentersFilter == null) return;
      exportType = masterAccountsOrCentersFilter.exportType;
    }
    CenterOnCenterAnalysisReportFilterSelection? centerOnCenterAnalysisFilter;
    if (isCenterOnCenterAnalysisReport) {
      centerOnCenterAnalysisFilter =
          await CenterOnCenterAnalysisReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || centerOnCenterAnalysisFilter == null) return;
      exportType = centerOnCenterAnalysisFilter.exportType;
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
          isCashInCashOutVoucherReport ||
          isChecksDataReport ||
          isMasterAccountsOrCentersReport ||
          isCenterOnCenterAnalysisReport ||
          isExpensesWithVatReport ||
          isSalesWithVatReport ||
          isPurchasesWithVatReport ||
          isGeneralLedgerReport ||
          isAnnualLedgerReport ||
          isIntegrationGeneralLedgerReport ||
          isConsolidatedGeneralLedgerReport ||
          isGeneralLedgerAuditReport ||
          isGeneralLedgerPostingReport ||
          isGeneralLedgerPayableAgingReport ||
          isSubsidiaryLedgerAccountReport ||
          isLedgerReport ||
          isLedgerReportForAssistantAccounts ||
          isLedgerReportForMainAccounts ||
          isLedgerReportPerUsers ||
          isAccountStatementReport ||
          isTrialBalanceByCategoriesReport ||
          isTrialBalanceByLevelReport ||
          isMonthlyTrialBalanceReport ||
          isMonthlyTrialBalanceWithoutAccountLevelReport ||
          isTrialBalanceOptionalAccountLevelReport ||
          isTrialBalancesReportForPeriod ||
          isAccountCentersTrialBalancesReport ||
          isFinancialStatementsReport ||
          isAdditionalFinalReport ||
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
        final result = isCenterOnCenterAnalysisReport
            ? await reportsRepo.getCenterOnCenterAnalysisReport(
                fromCostCenterNo:
                    centerOnCenterAnalysisFilter?.fromCostCenterNo,
                toCostCenterNo: centerOnCenterAnalysisFilter?.toCostCenterNo,
                fromDate: centerOnCenterAnalysisFilter?.fromDate,
                toDate: centerOnCenterAnalysisFilter?.toDate,
                reportName:
                    centerOnCenterAnalysisFilter?.reportName ?? 'AGL025A',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isMasterAccountsOrCentersReport
            ? await reportsRepo.getMasterAccountsOrCentersReport(
                fromCategoryNo: masterAccountsOrCentersFilter?.fromCategoryNo,
                toCategoryNo: masterAccountsOrCentersFilter?.toCategoryNo,
                fromDate: masterAccountsOrCentersFilter?.fromDate,
                toDate: masterAccountsOrCentersFilter?.toDate,
                masterReportType:
                    masterAccountsOrCentersFilter?.masterReportType ?? 1,
                reportPageType: masterAccountsOrCentersReportPageType,
                reportName:
                    masterAccountsOrCentersFilter?.reportName ??
                    masterAccountsOrCentersDetailedReportName,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isChecksDataReport
            ? await reportsRepo.getChecksDataReport(
                fromChqNo: checksDataReportFilter?.fromChqNo,
                toChqNo: checksDataReportFilter?.toChqNo,
                fromDate: checksDataReportFilter?.fromDate,
                toDate: checksDataReportFilter?.toDate,
                fromBankCode: checksDataReportFilter?.fromBankCode,
                toBankCode: checksDataReportFilter?.toBankCode,
                fromCashAccount: checksDataReportFilter?.fromCashAccount,
                toCashAccount: checksDataReportFilter?.toCashAccount,
                reportName: 'AGL019_1',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isCashInCashOutVoucherReport
            ? await reportsRepo.getCashInCashOutVoucherReport(
                receiptType: cashVoucherReportFilter?.receiptType ?? 1,
                fromVoucherNo: cashVoucherReportFilter?.fromVoucherNo,
                toVoucherNo: cashVoucherReportFilter?.toVoucherNo,
                fromBankCode: cashVoucherReportFilter?.fromBankCode,
                toBankCode: cashVoucherReportFilter?.toBankCode,
                fromDate: cashVoucherReportFilter?.fromDate,
                toDate: cashVoucherReportFilter?.toDate,
                reportName: 'AGL019',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isGeneralJournalForLevelReport
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
                    finalReportsFilter!.financialStatementReportType,
                reportType: finalReportsFilter.reportType,
                toMonth: finalReportsFilter.toMonth,
                costCenterNo: finalReportsFilter.costCenterNo,
                reportName: reportName!,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isAdditionalFinalReport
            ? await reportsRepo.getAdditionalFinalReport(
                reportSerial: additionalFinalReportFilter?.reportSerial,
                costCenterNo: additionalFinalReportFilter?.costCenterNo,
                reportTitle: additionalFinalReportFilter?.reportTitle,
                fromLineSerial: additionalFinalReportFilter?.fromLineSerial,
                toLineSerial: additionalFinalReportFilter?.toLineSerial,
                reportName:
                    additionalFinalReportFilter?.reportName ?? 'AGL037A',
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
            : isAnnualLedgerReport
            ? await reportsRepo.getAnnualLedgerReport(
                fromAccountNo: annualLedgerFilter?.fromAccountNo,
                toAccountNo: annualLedgerFilter?.toAccountNo,
                fromCurrencyCode: annualLedgerFilter?.fromCurrencyCode,
                toCurrencyCode: annualLedgerFilter?.toCurrencyCode,
                fromAnalytical: annualLedgerFilter?.fromAnalytical,
                toAnalytical: annualLedgerFilter?.toAnalytical,
                fromAnalytical1: annualLedgerFilter?.fromAnalytical1,
                toAnalytical1: annualLedgerFilter?.toAnalytical1,
                fromSubVoucher: annualLedgerFilter?.fromSubVoucher,
                toSubVoucher: annualLedgerFilter?.toSubVoucher,
                fromSubDescId: annualLedgerFilter?.fromSubDescId,
                toSubDescId: annualLedgerFilter?.toSubDescId,
                fromDate: annualLedgerFilter?.fromDate,
                toDate: annualLedgerFilter?.toDate,
                accountsWithZeroBalances:
                    annualLedgerFilter?.accountsWithZeroBalances,
                prepareWithAccountRange:
                    annualLedgerFilter?.prepareWithAccountRange,
                ledgerReportType: annualLedgerFilter?.ledgerReportType ?? 1,
                reportPageType: 2,
                reportName: annualLedgerFilter?.reportName,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isIntegrationGeneralLedgerReport
            ? await reportsRepo.getIntegrationGeneralLedgerReport(
                fromAccountNo: integrationGeneralLedgerFilter?.fromAccountNo,
                toAccountNo: integrationGeneralLedgerFilter?.toAccountNo,
                fromDate: integrationGeneralLedgerFilter?.fromDate,
                toDate: integrationGeneralLedgerFilter?.toDate,
                accountsWithZeroBalances:
                    integrationGeneralLedgerFilter?.accountsWithZeroBalances ??
                    false,
                ledgerReportType:
                    integrationGeneralLedgerFilter?.ledgerReportType ?? 1,
                reportPageType: 3,
                reportName: integrationGeneralLedgerFilter?.reportName,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isConsolidatedGeneralLedgerReport
            ? await reportsRepo.getConsolidatedGeneralLedgerReport(
                fromAccountNo: consolidatedGeneralLedgerFilter?.fromAccountNo,
                toAccountNo: consolidatedGeneralLedgerFilter?.toAccountNo,
                fromDate: consolidatedGeneralLedgerFilter?.fromDate,
                toDate: consolidatedGeneralLedgerFilter?.toDate,
                accountsWithZeroBalances:
                    consolidatedGeneralLedgerFilter?.accountsWithZeroBalances ??
                    false,
                prepareWithAccountRange:
                    consolidatedGeneralLedgerFilter?.prepareWithAccountRange ??
                    false,
                ledgerReportType:
                    consolidatedGeneralLedgerFilter?.ledgerReportType ?? 1,
                reportPageType: 4,
                reportName: consolidatedGeneralLedgerFilter?.reportName,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isGeneralLedgerAuditReport
            ? await reportsRepo.getGeneralLedgerAuditReport(
                fromAccountNo: generalLedgerAuditFilter?.fromAccountNo,
                toAccountNo: generalLedgerAuditFilter?.toAccountNo,
                fromDate: generalLedgerAuditFilter?.fromDate,
                toDate: generalLedgerAuditFilter?.toDate,
                accountsWithZeroBalances:
                    generalLedgerAuditFilter?.accountsWithZeroBalances ?? false,
                reportPageType: 1,
                reportName: generalLedgerAuditFilter?.reportName ?? 'AGL100',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isGeneralLedgerPostingReport
            ? await reportsRepo.getGeneralLedgerPostingReport(
                fromAccountNo: generalLedgerPostingFilter?.fromAccountNo,
                toAccountNo: generalLedgerPostingFilter?.toAccountNo,
                searchGroup: generalLedgerPostingFilter?.searchGroup,
                fromDate: generalLedgerPostingFilter?.fromDate,
                toDate: generalLedgerPostingFilter?.toDate,
                accountsWithZeroBalances:
                    generalLedgerPostingFilter?.accountsWithZeroBalances ??
                    false,
                ledgerReportType:
                    generalLedgerPostingFilter?.ledgerReportType ?? 1,
                reportPageType: 5,
                reportName: generalLedgerPostingFilter?.reportName,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isGeneralLedgerPayableAgingReport
            ? await reportsRepo.getGeneralLedgerPayableAgingReport(
                fromAccountNo: generalLedgerPayableAgingFilter?.fromAccountNo,
                toAccountNo: generalLedgerPayableAgingFilter?.toAccountNo,
                fromDate: generalLedgerPayableAgingFilter?.fromDate,
                toDate: generalLedgerPayableAgingFilter?.toDate,
                accountsWithZeroBalances:
                    generalLedgerPayableAgingFilter?.accountsWithZeroBalances ??
                    false,
                ledgerReportType:
                    generalLedgerPayableAgingFilter?.ledgerReportType ?? 1,
                reportPageType: 7,
                reportName: generalLedgerPayableAgingFilter?.reportName,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isSubsidiaryLedgerAccountReport
            ? await reportsRepo.getSubsidiaryLedgerAccountReport(
                fromAccountNo: subsidiaryLedgerFilter?.fromAccountNo,
                toAccountNo: subsidiaryLedgerFilter?.toAccountNo,
                fromMainAccountNo: subsidiaryLedgerFilter?.fromMainAccountNo,
                toMainAccountNo: subsidiaryLedgerFilter?.toMainAccountNo,
                fromDate: subsidiaryLedgerFilter?.fromDate,
                toDate: subsidiaryLedgerFilter?.toDate,
                accountsWithZeroBalances:
                    subsidiaryLedgerFilter?.accountsWithZeroBalances ?? false,
                ledgerReportType: subsidiaryLedgerFilter?.ledgerReportType ?? 1,
                reportPageType: 6,
                reportName: subsidiaryLedgerFilter?.reportName,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isGeneralLedgerReport
            ? await reportsRepo.getGeneralLedgerReport(
                fromAccountNo: generalLedgerFilter?.fromAccountNo,
                toAccountNo: generalLedgerFilter?.toAccountNo,
                fromCurrencyCode: generalLedgerFilter?.fromCurrencyCode,
                toCurrencyCode: generalLedgerFilter?.toCurrencyCode,
                fromAnalytical: generalLedgerFilter?.fromAnalytical,
                toAnalytical: generalLedgerFilter?.toAnalytical,
                fromAnalytical1: generalLedgerFilter?.fromAnalytical1,
                toAnalytical1: generalLedgerFilter?.toAnalytical1,
                fromSubVoucher: generalLedgerFilter?.fromSubVoucher,
                toSubVoucher: generalLedgerFilter?.toSubVoucher,
                fromSubDescId: generalLedgerFilter?.fromSubDescId,
                toSubDescId: generalLedgerFilter?.toSubDescId,
                fromDate: generalLedgerFilter?.fromDate,
                toDate: generalLedgerFilter?.toDate,
                accountsWithZeroBalances:
                    generalLedgerFilter?.accountsWithZeroBalances,
                reportPageType: 1,
                reportName: 'AGL100',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isLedgerReportPerUsers
            ? await reportsRepo.getLedgerReportPerUsers(
                fromAccountNo: perUsersLedgerFilter?.fromAccountNo,
                toAccountNo: perUsersLedgerFilter?.toAccountNo,
                fromDate: perUsersLedgerFilter?.fromDate,
                toDate: perUsersLedgerFilter?.toDate,
                reportName: perUsersLedgerFilter?.reportName ?? 'AGL021',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isLedgerReportForMainAccounts
            ? await reportsRepo.getLedgerReportForMainAccounts(
                accountLevel: mainAccountsLedgerFilter?.accountLevel,
                fromAccountNo: mainAccountsLedgerFilter?.fromAccountNo,
                toAccountNo: mainAccountsLedgerFilter?.toAccountNo,
                fromAnalytical: mainAccountsLedgerFilter?.fromAnalytical,
                toAnalytical: mainAccountsLedgerFilter?.toAnalytical,
                fromDate: mainAccountsLedgerFilter?.fromDate,
                toDate: mainAccountsLedgerFilter?.toDate,
                fromAnalytical1: mainAccountsLedgerFilter?.fromAnalytical1,
                toAnalytical1: mainAccountsLedgerFilter?.toAnalytical1,
                fromSubVoucher: mainAccountsLedgerFilter?.fromSubVoucher,
                toSubVoucher: mainAccountsLedgerFilter?.toSubVoucher,
                reportName: mainAccountsLedgerFilter?.reportName ?? 'AGL021N',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isLedgerReportForAssistantAccounts
            ? await reportsRepo.getLedgerReportForAssistantAccounts(
                fromAccountNo: assistantAccountsLedgerFilter!.fromAccountNo,
                toAccountNo: assistantAccountsLedgerFilter.toAccountNo,
                centerLevel: assistantAccountsLedgerFilter.centerLevel,
                fromCostCenterNo:
                    assistantAccountsLedgerFilter.fromCostCenterNo,
                toCostCenterNo: assistantAccountsLedgerFilter.toCostCenterNo,
                fromAccAnal: assistantAccountsLedgerFilter.fromAccAnal,
                toAccAnal: assistantAccountsLedgerFilter.toAccAnal,
                fromDate: assistantAccountsLedgerFilter.fromDate,
                toDate: assistantAccountsLedgerFilter.toDate,
                fromCentAnal: assistantAccountsLedgerFilter.fromCentAnal,
                toCentAnal: assistantAccountsLedgerFilter.toCentAnal,
                fromAnalytical: assistantAccountsLedgerFilter.fromAnalytical,
                toAnalytical: assistantAccountsLedgerFilter.toAnalytical,
                sideType: assistantAccountsLedgerFilter.sideType,
                reportName: assistantAccountsLedgerFilter.reportName,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isLedgerReport
            ? await reportsRepo.getLedgerReportForAllAccounts(
                fromAccountNo: ledgerFilter?.fromAccountNo,
                toAccountNo: ledgerFilter?.toAccountNo,
                fromCurrencyCode: ledgerFilter?.fromCurrencyCode,
                toCurrencyCode: ledgerFilter?.toCurrencyCode,
                searchGroup: ledgerFilter?.searchGroup,
                fromDate: ledgerFilter?.fromDate,
                toDate: ledgerFilter?.toDate,
                accountsWithZeroBalances:
                    ledgerFilter?.accountsWithZeroBalances ?? false,
                reportName: ledgerFilter?.reportName ?? 'AGL021C',
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
            : isTrialBalanceByLevelReport
            ? await reportsRepo.getTrialBalanceReport(
                accountLevel: trialBalanceByLevelFilter?.accountLevel,
                doNotDisplayAccountsWithZeroBalances:
                    trialBalanceByLevelFilter
                        ?.doNotDisplayAccountsWithZeroBalances ??
                    false,
                balanceType: trialBalanceByLevelFilter?.balanceType,
                reportPageType: 1,
                reportName: 'AGL030',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isMonthlyTrialBalanceReport
            ? await reportsRepo.getTrialBalanceReport(
                accountLevel: monthlyTrialBalanceFilter?.accountLevel,
                fromMonth: monthlyTrialBalanceFilter?.fromMonth,
                toMonth: monthlyTrialBalanceFilter?.toMonth,
                isGeneral: monthlyTrialBalanceFilter?.isGeneral,
                reportPageType: 2,
                reportName: monthlyTrialBalanceFilter?.reportName ?? 'AGL060',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isMonthlyTrialBalanceWithoutAccountLevelReport
            ? await reportsRepo.getTrialBalanceReport(
                fromMonth:
                    monthlyTrialBalanceWithoutAccountLevelFilter?.fromMonth,
                toMonth: monthlyTrialBalanceWithoutAccountLevelFilter?.toMonth,
                reportPageType: 3,
                reportName:
                    monthlyTrialBalanceWithoutAccountLevelFilter?.reportName ??
                    'AGL060H',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isTrialBalanceOptionalAccountLevelReport
            ? await reportsRepo.getTrialBalanceReport(
                accountLevel:
                    trialBalanceOptionalAccountLevelFilter?.accountLevel,
                reportPageType: 4,
                reportName:
                    trialBalanceOptionalAccountLevelFilter?.reportName ??
                    'AGL031',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isTrialBalancesReportForPeriod
            ? await reportsRepo.getTrialBalancesReportForPeriod(
                fromAccountNo:
                    trialBalancesReportForPeriodFilter?.fromAccountNo,
                toAccountNo: trialBalancesReportForPeriodFilter?.toAccountNo,
                fromDate: trialBalancesReportForPeriodFilter?.fromDate,
                toDate: trialBalancesReportForPeriodFilter?.toDate,
                doNotDisplayAccountsWithZeroBalances:
                    trialBalancesReportForPeriodFilter
                        ?.doNotDisplayAccountsWithZeroBalances ??
                    false,
                prepareTree:
                    trialBalancesReportForPeriodFilter?.prepareTree ?? false,
                reportName: 'AGL078',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isAccountCentersTrialBalancesReport
            ? await reportsRepo.getAccountCentersTrialBalancesReport(
                accountLevel: accountCentersTrialBalancesFilter!.accountLevel,
                fromAccountNo: accountCentersTrialBalancesFilter.fromAccountNo,
                toAccountNo: accountCentersTrialBalancesFilter.toAccountNo,
                fromCostCenterNo:
                    accountCentersTrialBalancesFilter.fromCostCenterNo,
                toCostCenterNo:
                    accountCentersTrialBalancesFilter.toCostCenterNo,
                fromDate: accountCentersTrialBalancesFilter.fromDate,
                toDate: accountCentersTrialBalancesFilter.toDate,
                reportName: 'AGL026C',
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
                  style: AppTextStyle.bodyLarge(context).copyWith(
                    color: AppColor.titleFormFiledColor(dialogContext),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10.h),
                Text(
                  'قد يستغرق هذا بعض الوقت للتقارير الكبيرة',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodySmall(context).copyWith(
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
        'id': 'master_accounts_or_centers',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير أرصدة أبواب الحسابات'
            : 'Account Category Balances Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض أرصدة أبواب الحسابات حسب النطاق والتاريخ'
            : 'View account category balances by range and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_wallet_outlined,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL076',
        'isMasterAccountsOrCentersReport': true,
        'treeGroup': 'masterAccountsOrCenters',
      },
      {
        'id': 'master_centers_balances',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير أرصدة أبواب المراكز'
            : 'Center Category Balances Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض أرصدة أبواب المراكز حسب النطاق والتاريخ'
            : 'View center category balances by range and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_outlined,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL077B',
        'isMasterAccountsOrCentersReport': true,
        'masterAccountsOrCentersReportPageType': 2,
        'masterAccountsOrCentersSummarizedReportName': 'AGL077C',
        'masterAccountsOrCentersDetailedReportName': 'AGL077B',
        'isMasterCentersReport': true,
        'treeGroup': 'masterAccountsOrCenters',
      },
      {
        'id': 'center_on_center_analysis',
        'title': context.locale.languageCode == 'ar'
            ? 'تحليل مركز على مركز'
            : 'Center on Center Analysis',
        'desc': context.locale.languageCode == 'ar'
            ? 'تحليل مراكز التكلفة حسب نطاق المركز والتاريخ'
            : 'Analyze cost centers by center range and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.compare_arrows_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL025A',
        'isCenterOnCenterAnalysisReport': true,
        'treeGroup': 'masterAccountsOrCenters',
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
        'title': context.locale.languageCode == 'ar'
            ? 'التقارير الختامية'
            : 'Final Reports',
        'desc': context.locale.languageCode == 'ar'
            ? 'المتاجرة والأرباح والخسائر والميزانية والدخل والتدفقات النقدية بجميع أنواع التقارير'
            : 'Trading, profit and loss, balance sheet, income statement and cash flow in all report variants',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'isFinancialStatementsReport': true,
        'treeGroup': 'concluding',
      },
      {
        'id': 'additional_final_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ختامي إضافي'
            : 'Additional Final Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'تقرير ختامي إضافي برقم الحساب أو بدونه أو بطريقة طولية أو بالمقارنات'
            : 'Additional final report with or without account numbers, vertical, or comparative',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.playlist_add_check_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL037A',
        'isAdditionalFinalReport': true,
        'treeGroup': 'concluding',
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
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير سندات القبض والصرف'
            : 'Cash In/Out Voucher Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'تقرير سندات القبض أو الصرف حسب رقم السند والبنك والتاريخ'
            : 'Report cash-in or cash-out vouchers by voucher number, bank, and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.receipt_long_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL019',
        'isCashInCashOutVoucherReport': true,
        'treeGroup': 'cashVouchers',
      },
      {
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير متابعة الشيكات'
            : 'Check Follow-up Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'متابعة الشيكات حسب الرقم والبنك وحساب النقدية والتاريخ'
            : 'Follow checks by number, bank, cash account, and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.fact_check_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL019_1',
        'isChecksDataReport': true,
        'treeGroup': 'cashVouchers',
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
        'reportName': 'AGL021C',
        'isLedgerReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'general_ledger_report',
        'title': context.locale.languageCode == 'ar'
            ? 'حساب الأستاذ العام'
            : 'General Ledger Account Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف حساب الأستاذ العام مع العملات والتحليلات والقيود الفرعية'
            : 'General ledger with currency, analytical, and sub-voucher filters',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL100',
        'isGeneralLedgerReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'subsidiary_ledger_account_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير حساب الأستاذ المساعد'
            : 'Subsidiary Ledger Account Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف حساب الأستاذ المساعد ملخص أو تفصيلي'
            : 'Subsidiary ledger summary or detailed account statement',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_outlined,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL021AS',
        'isSubsidiaryLedgerAccountReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'general_ledger_audit_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير تدقيق الأستاذ العام'
            : 'General Ledger Audit Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف تدقيق الأستاذ العام حسب الحساب والتاريخ'
            : 'General ledger audit by account and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.fact_check_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL100',
        'isGeneralLedgerAuditReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'general_ledger_posting_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ترحيل الأستاذ العام'
            : 'General Ledger Posting Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف ترحيل الأستاذ العام ملخص أو تفصيلي'
            : 'General ledger posting summary or detailed',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.post_add_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL021CLP',
        'isGeneralLedgerPostingReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'general_ledger_payable_aging_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير الأستاذ العام مع تحليل أعمار الذمم الدائنة'
            : 'General Ledger Report with Accounts Payable Aging Analysis (Creditors)',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف الأستاذ العام مع تحليل أعمار الذمم الدائنة ملخص أو تفصيلي'
            : 'General ledger with accounts payable aging analysis summary or detailed',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.elderly_rounded,
        'iconColor': AppColor.warningOrange,
        'category': 1,
        'reportName': 'AGL041C',
        'isGeneralLedgerPayableAgingReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'annual_ledger_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير الأستاذ العام السنوي'
            : 'Annual General Ledger Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف الأستاذ السنوي ملخص أو تفصيلي حسب نطاق الحسابات والتحليلات'
            : 'Annual ledger summary or detailed by account range and analytics',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL021Y',
        'isAnnualLedgerReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'integration_general_ledger_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير الأستاذ العام للتكامل'
            : 'Integration General Ledger Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف الأستاذ العام ملخص أو تفصيلي حسب نطاق الحسابات والتاريخ'
            : 'Summary or detailed general ledger by account range and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGLT26C',
        'isIntegrationGeneralLedgerReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'consolidated_general_ledger_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير الأستاذ العام الموحد للمنشآت'
            : 'Consolidated General Ledger Report for Establishments',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف الأستاذ العام الموحد ملخص أو تفصيلي للمنشآت'
            : 'Consolidated summary or detailed general ledger for establishments',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL021T',
        'isConsolidatedGeneralLedgerReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'ledger_report_assistant_accounts',
        'title': context.locale.languageCode == 'ar'
            ? 'حساب الأستاذ للحسابات المساعدة'
            : 'Assistant Accounts Ledger',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف الأستاذ للحسابات المساعدة حسب الحساب والمركز والجانب'
            : 'Assistant accounts ledger by account, center, and entry side',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL094',
        'isLedgerReportForAssistantAccounts': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'ledger_report_main_accounts',
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير حساب الأستاذ للحسابات الرئيسية'
            : 'Main Accounts Ledger Reports',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف الأستاذ للحسابات الرئيسية حسب الحساب والتحليلات'
            : 'Main accounts ledger by account and analytical ranges',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL021N',
        'isLedgerReportForMainAccounts': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'ledger_report_per_users',
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير الأستاذ حسب المستخدمين'
            : 'User-specific Ledger Reports',
        'desc': context.locale.languageCode == 'ar'
            ? 'تقارير الأستاذ للحسابات مع إمكانية التصفية حسب الحساب والتاريخ'
            : 'Ledger reports filtered by account and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL021',
        'isLedgerReportPerUsers': true,
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
        'treeGroup': 'trialBalance',
      },
      {
        'id': 'trial_balance_by_level',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ميزان المراجعة'
            : 'Trial Balance Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'ميزان المراجعة حسب مستوى الحساب ونوع الرصيد'
            : 'Trial balance by account level and balance type',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL030',
        'isTrialBalanceByLevelReport': true,
        'treeGroup': 'trialBalance',
      },
      {
        'id': 'monthly_trial_balance',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ميزان المراجعة الشهري'
            : 'Monthly Trial Balance Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'ميزان المراجعة الشهري (AGL060 / AGL060A)'
            : 'Monthly trial balance (AGL060 / AGL060A)',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_month_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL060',
        'isMonthlyTrialBalanceReport': true,
        'treeGroup': 'trialBalance',
      },
      {
        'id': 'monthly_trial_balance_without_account_level',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ميزان المراجعة الشهري حسب المجموعات'
            : 'Monthly Trial Balance Report by Groups',
        'desc': context.locale.languageCode == 'ar'
            ? 'ميزان المراجعة الشهري حسب نطاق الشهور'
            : 'Monthly trial balance for a selected month range',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_view_month_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL060H',
        'isMonthlyTrialBalanceWithoutAccountLevelReport': true,
        'treeGroup': 'trialBalance',
      },
      {
        'id': 'trial_balance_optional_account_level',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ميزان المراجعة حسب المراكز'
            : 'Trial Balance Report by Centers',
        'desc': context.locale.languageCode == 'ar'
            ? 'ميزان المراجعة مع مستوى حساب اختياري (AGL031)'
            : 'Trial balance with an optional account level (AGL031)',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_wallet_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL031',
        'isTrialBalanceOptionalAccountLevelReport': true,
        'treeGroup': 'trialBalance',
      },
      {
        'id': 'trial_balances_report_for_period',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ميزان المراجعة لفترة'
            : 'Trial Balance Report for a Period',
        'desc': context.locale.languageCode == 'ar'
            ? 'ميزان مراجعة الحسابات خلال فترة زمنية'
            : 'Trial balance of accounts over a selected period',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL078',
        'isTrialBalancesReportForPeriod': true,
        'treeGroup': 'trialBalance',
      },
      {
        'id': 'account_centers_trial_balances',
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير ميزان المراجعة حسب المراكز'
            : 'Trial Balance Reports by Centers',
        'desc': context.locale.languageCode == 'ar'
            ? 'ميزان مراجعة حسابات مراكز التكلفة حسب مستوى الحساب'
            : 'Trial balance of cost center accounts by account level',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.domain_disabled_outlined,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL026C',
        'isAccountCentersTrialBalancesReport': true,
        'treeGroup': 'trialBalance',
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
                style: AppTextStyle.bodyLarge(context).copyWith(
                  color: AppColor.titleFormFiledColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
              Gap(6.h),
              Text(
                'Report API • $_previewTitle',
                style: AppTextStyle.bodySmall(context).copyWith(
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
        id: 12,
        key: 'masterAccountsOrCenters',
        titleAr: 'أرصدة وأبواب',
        titleEn: 'Balances and Categories',
        icon: Icons.account_balance_wallet_outlined,
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
        id: 11,
        key: 'cashVouchers',
        titleAr: 'تقارير سندات القبض والدفع',
        titleEn: 'Cash Receipt and Payment Reports',
        icon: Icons.receipt_long_rounded,
        accent: AppColor.emeraldTeal,
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
        key: 'concluding',
        titleAr: 'التقارير الختامية',
        titleEn: 'Concluding Reports',
        icon: Icons.account_balance_rounded,
        accent: AppColor.emeraldTeal,
      ),
      (
        id: 9,
        key: 'trialBalance',
        titleAr: 'ميزان مراجعة',
        titleEn: 'Trial Balance',
        icon: Icons.account_balance_rounded,
        accent: AppColor.oceanBlue,
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
      isCashInCashOutVoucherReport:
          statement['isCashInCashOutVoucherReport'] == true,
      isChecksDataReport: statement['isChecksDataReport'] == true,
      isMasterAccountsOrCentersReport:
          statement['isMasterAccountsOrCentersReport'] == true,
      masterAccountsOrCentersReportPageType:
          statement['masterAccountsOrCentersReportPageType'] as int? ?? 1,
      masterAccountsOrCentersSummarizedReportName:
          statement['masterAccountsOrCentersSummarizedReportName'] as String? ??
          'AGL076',
      masterAccountsOrCentersDetailedReportName:
          statement['masterAccountsOrCentersDetailedReportName'] as String? ??
          'AGL077A',
      isMasterCentersReport: statement['isMasterCentersReport'] == true,
      isCenterOnCenterAnalysisReport:
          statement['isCenterOnCenterAnalysisReport'] == true,
      isExpensesWithVatReport: statement['isExpensesWithVatReport'] == true,
      isSalesWithVatReport: statement['isSalesWithVatReport'] == true,
      isPurchasesWithVatReport: statement['isPurchasesWithVatReport'] == true,
      isLedgerReport: statement['isLedgerReport'] == true,
      isGeneralLedgerReport: statement['isGeneralLedgerReport'] == true,
      isAnnualLedgerReport: statement['isAnnualLedgerReport'] == true,
      isIntegrationGeneralLedgerReport:
          statement['isIntegrationGeneralLedgerReport'] == true,
      isConsolidatedGeneralLedgerReport:
          statement['isConsolidatedGeneralLedgerReport'] == true,
      isGeneralLedgerAuditReport:
          statement['isGeneralLedgerAuditReport'] == true,
      isGeneralLedgerPostingReport:
          statement['isGeneralLedgerPostingReport'] == true,
      isGeneralLedgerPayableAgingReport:
          statement['isGeneralLedgerPayableAgingReport'] == true,
      isSubsidiaryLedgerAccountReport:
          statement['isSubsidiaryLedgerAccountReport'] == true,
      isLedgerReportForAssistantAccounts:
          statement['isLedgerReportForAssistantAccounts'] == true,
      isLedgerReportForMainAccounts:
          statement['isLedgerReportForMainAccounts'] == true,
      isLedgerReportPerUsers: statement['isLedgerReportPerUsers'] == true,
      isAccountStatementReport: statement['isAccountStatementReport'] == true,
      isTrialBalanceByCategoriesReport:
          statement['isTrialBalanceByCategoriesReport'] == true,
      isTrialBalanceByLevelReport:
          statement['isTrialBalanceByLevelReport'] == true,
      isMonthlyTrialBalanceReport:
          statement['isMonthlyTrialBalanceReport'] == true,
      isMonthlyTrialBalanceWithoutAccountLevelReport:
          statement['isMonthlyTrialBalanceWithoutAccountLevelReport'] == true,
      isTrialBalanceOptionalAccountLevelReport:
          statement['isTrialBalanceOptionalAccountLevelReport'] == true,
      isTrialBalancesReportForPeriod:
          statement['isTrialBalancesReportForPeriod'] == true,
      isAccountCentersTrialBalancesReport:
          statement['isAccountCentersTrialBalancesReport'] == true,
      isFinancialStatementsReport:
          statement['isFinancialStatementsReport'] == true,
      isAdditionalFinalReport: statement['isAdditionalFinalReport'] == true,
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
