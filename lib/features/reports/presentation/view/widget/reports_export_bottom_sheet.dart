import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/common_methods.dart';

typedef ReportExportDispatcher = Future<void> Function({
  required String title,
  required String description,
  required String amount,
  required String date,
  required String status,
  String exportType,
  String? reportName,
  bool isApiReport,
  bool isIncomeAndExpenseSituationReport,
  bool isQuarterlyIncomeAndExpenseSituationReport,
  bool isCostCenterIncomeAndExpenseSituationReport,
  bool isMonthlyExpensesReport,
  bool isDailyIncomeAndExpenseReport,
  bool isJournalReport,
  bool isJournalSummarizedReport,
  bool isOperationTracingReport,
  bool isMainAccountsJournalReport,
  bool isGeneralJournalForLevelReport,
  bool isCashInCashOutVoucherReport,
  bool isChecksDataReport,
  bool isCheckVerificationReport,
  bool isIndicatorDataStandardReport,
  bool isIndicatorDataAdditionReport,
  bool isWithdrawAndDepositingVoucherReport,
  bool isActivityReport,
  bool isActivityCenterDataReport,
  bool isMasterAccountsOrCentersReport,
  int masterAccountsOrCentersReportPageType,
  String masterAccountsOrCentersSummarizedReportName,
  String masterAccountsOrCentersDetailedReportName,
  bool isMasterCentersReport,
  bool isCenterOnCenterAnalysisReport,
  bool isExpensesWithVatReport,
  bool isSalesWithVatReport,
  bool isPurchasesWithVatReport,
  bool isCustomerSupplierNotificationsReport,
  bool isInvoicesApprovedStatusReport,
  bool isAccountCentersAnalyticalDetailsReport,
  bool isAccountCentersAnalyticalGroupsReport,
  bool isIntegratedVouchersStatusReport,
  bool isStatusOfDailyTransactionsReport,
  bool isTestIntegrationVoucherReport,
  bool isLedgerReport,
  bool isGeneralLedgerReport,
  bool isAnnualLedgerReport,
  bool isIntegrationGeneralLedgerReport,
  bool isConsolidatedGeneralLedgerReport,
  bool isGeneralLedgerAuditReport,
  bool isGeneralLedgerPostingReport,
  bool isGeneralLedgerPayableAgingReport,
  bool isSubsidiaryLedgerAccountReport,
  bool isLedgerReportForAssistantAccounts,
  bool isLedgerReportForMainAccounts,
  bool isLedgerReportPerUsers,
  bool isAccountStatementReport,
  bool isTrialBalanceByCategoriesReport,
  bool isTrialBalanceByLevelReport,
  bool isMonthlyTrialBalanceReport,
  bool isMonthlyTrialBalanceWithoutAccountLevelReport,
  bool isTrialBalanceOptionalAccountLevelReport,
  bool isTrialBalancesReportForPeriod,
  bool isAccountCentersTrialBalancesReport,
  bool isFinancialStatementsReport,
  bool isAdditionalFinalReport,
  bool isCostCentersReport,
  bool isCentersMonthlyBalanceReport,
  bool isCentersComparisonReport,
  bool isCentersComparisonByMonthsReport,
  bool isCentersComparisonByMonthReport,
  bool isCentersComparisonBalancesReport,
  bool isAccountsCentersComparisonReport,
  bool isAccountsCentersMonthlyComparisonReport,
  bool isAccountsCentersMonthlyMovementsReport,
  bool isCostCentersTransactionReport,
  bool isCostCentersTransactionAnnualReport,
  bool isCostCentersProjectsReport,
  bool isPurchaseOfProjectsReport,
  bool isAccountCentersSummaryForMainAccountsReport,
  bool isMonthlyAccountComparisonReport,
  bool isMonthlyCostCentersComparisonReport,
  bool isAccountsComparisonReport,
  bool isAccountsMonthlyComparisonReport,
  bool isAccountsComparisonByMonthReport,
  bool isAccountsBalancePeriodicallyReport,
  bool isChartOfAccountMonthlyBalancesReport,
  int chartOfAccountReportPageType,
  int chartOfAccountReportAccountType,
  String chartOfAccountReportName,
});

class ReportsExportBottomSheet {
  static void show(
    BuildContext context, {
    required ReportExportDispatcher onExportReport,
  }) {
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
              _buildExportOption(context, 
                icon: Icons.account_tree_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementChartOfAccount.tr(),
                subtitle: 'Report/ChartOfAccountReport',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.sync_alt_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar' ? 'تقرير حركات التكامل بدون قيود' : 'Integration Transactions Without Vouchers',
                subtitle: 'Report/StatusOfTheDailyTransacitionsReport (AGL2000)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: context.locale.languageCode == 'ar' ? 'تقرير حركات التكامل بدون قيود' : 'Integration Transactions Without Vouchers',
                    description: context.locale.languageCode == 'ar' ? 'حالة حركات التكامل حسب نوع الحركة' : 'Integration transaction status by transaction type',
                    amount: '', date: '', status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL2000', isStatusOfDailyTransactionsReport: true,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.show_chart_rounded,
                color: AppColor.emeraldTeal,
                title: AppLocaleKey.statementMonthlyIncome.tr(),
                subtitle: 'Report/IncomeAndExpenseSituationReport (AGL300_M)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: AppLocaleKey.statementMonthlyIncome.tr(),
                    description: AppLocaleKey.statementMonthlyIncomeDesc.tr(),
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
              _buildExportOption(context, 
                icon: Icons.calendar_view_month_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementMultiMonthIncome.tr(),
                subtitle: 'Report/IncomeAndExpenseSituationReport (AGL300_MS)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: AppLocaleKey.statementMultiMonthIncome.tr(),
                    description: AppLocaleKey.statementMultiMonthIncomeDesc
                        .tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL300_MS',
                    isIncomeAndExpenseSituationReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.calendar_view_week_rounded,
                color: AppColor.purpleAccent,
                title: AppLocaleKey.statementQuarterlyIncome.tr(),
                subtitle: 'Report/IncomeAndExpenseSituationReport (AGL300_QS)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: AppLocaleKey.statementQuarterlyIncome.tr(),
                    description: AppLocaleKey.statementQuarterlyIncomeDesc.tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL300_QS',
                    isQuarterlyIncomeAndExpenseSituationReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.account_tree_outlined,
                color: AppColor.emeraldTeal,
                title: AppLocaleKey.statementCostCenterIncome.tr(),
                subtitle: 'Report/IncomeAndExpenseSituationReport (AGL300C)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: AppLocaleKey.statementCostCenterIncome.tr(),
                    description: AppLocaleKey.statementCostCenterIncomeDesc
                        .tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL300C',
                    isCostCenterIncomeAndExpenseSituationReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.money_off_csred_rounded,
                color: AppColor.emeraldTeal,
                title: AppLocaleKey.statementMonthlyExpenses.tr(),
                subtitle: 'Report/IncomeAndExpenseSituationReport (AGL0400)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: AppLocaleKey.statementMonthlyExpenses.tr(),
                    description: AppLocaleKey.statementMonthlyExpensesDesc.tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL0400',
                    isMonthlyExpensesReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.calendar_view_day_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementDailyIncome.tr(),
                subtitle: 'Report/IncomeAndExpenseSituationReport (AGL300_D)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.receipt_long_outlined,
                color: AppColor.purpleAccent,
                title: AppLocaleKey.statementExpensesWithVat.tr(),
                subtitle: 'Report/ExpensesWithVatReport (AGL1001E)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.point_of_sale_rounded,
                color: AppColor.emeraldTeal,
                title: AppLocaleKey.statementSalesWithVat.tr(),
                subtitle: 'Report/SalesWithVatReport (AAR1000)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.shopping_bag_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementPurchasesWithVat.tr(),
                subtitle: 'Report/PurchasesWithVatReport (AAR1001)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.notifications_active_outlined,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'إشعارات العملاء والموردين'
                    : 'Customer and Supplier Notifications',
                subtitle: 'Report/CustomerSupplierNotificationsReport (AAR020V)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'إشعارات العملاء والموردين'
                        : 'Customer and Supplier Notifications',
                    description: context.locale.languageCode == 'ar'
                        ? 'عرض إشعارات العملاء أو الموردين حسب نوع المتعامل'
                        : 'View customer or supplier notifications by party type',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AAR020V',
                    isCustomerSupplierNotificationsReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.fact_check_outlined,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'موقف الفواتير من الاعتماد'
                    : 'Invoice Approval Status',
                subtitle: 'Report/InvoicesApprovedStatusReport (AAR206)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'موقف الفواتير من الاعتماد'
                        : 'Invoice Approval Status',
                    description: context.locale.languageCode == 'ar'
                        ? 'عرض حالة اعتماد الفواتير حسب العميل والتاريخ'
                        : 'View invoice approval status by customer and date',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AAR206',
                    isInvoicesApprovedStatusReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.menu_book_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementLedger.tr(),
                subtitle: 'Report/LedgerReportForAllAccounts (AGL021C)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.menu_book_rounded,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'حساب الأستاذ العام'
                    : 'General Ledger Account Report',
                subtitle: 'Report/LedgerReport (AGL100)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.account_tree_outlined,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير حساب الأستاذ المساعد'
                    : 'Subsidiary Ledger Account Report',
                subtitle: 'Report/LedgerReport (AGL021AS / AGL023AS)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.fact_check_rounded,
                color: AppColor.purpleAccent,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير تدقيق الأستاذ العام'
                    : 'General Ledger Audit Report',
                subtitle: 'Report/LedgerReport (AGL100)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.post_add_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ترحيل الأستاذ العام'
                    : 'General Ledger Posting Report',
                subtitle:
                    'Report/LedgerReport (AGL021CLP / AGL023CLP / AGL025LP)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.elderly_rounded,
                color: AppColor.warningOrange,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير الأستاذ العام مع تحليل أعمار الذمم الدائنة'
                    : 'General Ledger Report with Accounts Payable Aging Analysis (Creditors)',
                subtitle: 'Report/LedgerReport (AGL041C / AGL040C)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.menu_book_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير الأستاذ العام السنوي'
                    : 'Annual General Ledger Report',
                subtitle: 'Report/LedgerReport (AGL021Y / AGL023Y)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.menu_book_rounded,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير الأستاذ العام للتكامل'
                    : 'Integration General Ledger Report',
                subtitle: 'Report/LedgerReport (AGLT26C / AGLT26)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.menu_book_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير الأستاذ العام الموحد للمنشآت'
                    : 'Consolidated General Ledger Report for Establishments',
                subtitle: 'Report/LedgerReport (AGL021T / AGL023T)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.receipt_long_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementAccountStatement.tr(),
                subtitle: 'Report/AccountStatementReport (AGL079)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.account_balance_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'التقارير الختامية'
                    : 'Final Reports',
                subtitle: 'Report/FinancialStatementsReport (AGL034A - AGL044)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.playlist_add_check_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ختامي إضافي'
                    : 'Additional Final Report',
                subtitle: 'Report/AdditionalFinalReport (AGL037A - AGL045C)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.query_stats_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'بيانات المؤشر القياسي'
                    : 'Standard Indicator Data',
                subtitle:
                    'Report/IndicatorDataStandardReport (AGL066 / AGL067)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: AppLocaleKey.statementStandardIndicatorData.tr(),
                    description: AppLocaleKey.statementStandardIndicatorDataDesc
                        .tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL066',
                    isIndicatorDataStandardReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.analytics_rounded,
                color: AppColor.purpleAccent,
                title: context.locale.languageCode == 'ar'
                    ? 'تحليلى الحركة الحالية لمراكز الحسابات - مستويات'
                    : 'Current Analytical Movements of Account Centers - Levels',
                subtitle: 'Report/AccountCentersAnalyticalGroupsReport (AGL026L / AGL099)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تحليلى الحركة الحالية لمراكز الحسابات - مستويات'
                        : 'Current Analytical Movements of Account Centers - Levels',
                    description: context.locale.languageCode == 'ar'
                        ? 'تحليل حركة مراكز الحسابات حسب المستويات'
                        : 'Analytical account center movements by level',
                    amount: '', date: '', status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL026L',
                    isAccountCentersAnalyticalGroupsReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.sync_alt_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير حالة قيود التكامل من الترحيل'
                    : 'Integration Voucher Posting Status Report',
                subtitle: 'Report/IntegratedVouchersStatusReport (TAGL111)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير حالة قيود التكامل من الترحيل'
                        : 'Integration Voucher Posting Status Report',
                    description: context.locale.languageCode == 'ar'
                        ? 'حالة قيود التكامل حسب حالة الترحيل والبرنامج'
                        : 'Integration voucher status by posting state and program',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'TAGL111',
                    isIntegratedVouchersStatusReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.fact_check_outlined,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير مراجعة واختبار قيود يومية التكامل'
                    : 'Integration Daily Vouchers Review and Test Report',
                subtitle: 'Report/TestIntegrationVoucherReport (AGL063)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تقرير مراجعة واختبار قيود يومية التكامل'
                        : 'Integration Daily Vouchers Review and Test Report',
                    description: context.locale.languageCode == 'ar'
                        ? 'مراجعة واختبار قيود يومية التكامل حسب الرقم التسلسلي والتاريخ'
                        : 'Review and test integration daily vouchers by serial and date',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL063',
                    isTestIntegrationVoucherReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.rule_folder_outlined,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'اليومية إجمالي حسب نوع القيد'
                    : 'Daily Summary by Entry Type',
                subtitle: 'Report/JournalSummarizedReport (AGL900)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'اليومية إجمالي حسب نوع القيد'
                        : 'Daily Summary by Entry Type',
                    description: context.locale.languageCode == 'ar'
                        ? 'ملخص اليومية حسب نوع القيد'
                        : 'Daily journal summary by entry type',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL900',
                    isJournalSummarizedReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.analytics_outlined,
                color: AppColor.purpleAccent,
                title: context.locale.languageCode == 'ar'
                    ? 'تحليلى الحركة الحالية لمراكز الحسابات'
                    : 'Current Account Center Analytical Movements',
                subtitle: 'Report/AccountCentersAnalyticalDetailsReport (AGL098)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: context.locale.languageCode == 'ar'
                        ? 'تحليلى الحركة الحالية لمراكز الحسابات'
                        : 'Current Account Center Analytical Movements',
                    description: context.locale.languageCode == 'ar'
                        ? 'تحليل الحركة الحالية للحسابات ومراكز التكلفة'
                        : 'Analytical details of current account center movements',
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL098',
                    isAccountCentersAnalyticalDetailsReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.stacked_line_chart_rounded,
                color: AppColor.purpleAccent,
                title: context.locale.languageCode == 'ar'
                    ? 'بيانات المؤشرات الإضافية'
                    : 'Additional Indicators Data',
                subtitle:
                    'Report/IndicatorDataAdditionReport (AGL800A / AGL800)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: AppLocaleKey.statementAdditionalIndicatorData.tr(),
                    description: AppLocaleKey
                        .statementAdditionalIndicatorDataDesc
                        .tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL800A',
                    isIndicatorDataAdditionReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.swap_vert_circle_outlined,
                color: AppColor.warningOrange,
                title: context.locale.languageCode == 'ar'
                    ? 'حركات السحب والإيداع'
                    : 'Withdrawal and Deposit Transactions',
                subtitle: 'Report/WithdrawandDepositingVoucherReport (AGL065)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: AppLocaleKey.statementWithdrawalAndDeposit.tr(),
                    description: AppLocaleKey.statementWithdrawalAndDepositDesc
                        .tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL065',
                    isWithdrawAndDepositingVoucherReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.timeline_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementActivityReports.tr(),
                subtitle: 'Report/VigorReport (AGL111)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: AppLocaleKey.statementActivityReports.tr(),
                    description: AppLocaleKey.statementActivityReportsDesc.tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL111',
                    isActivityReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.analytics_outlined,
                color: AppColor.purpleAccent,
                title: AppLocaleKey.statementActivityCenterData.tr(),
                subtitle: 'Report/CostCentersReport (AGL007A)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
                    title: AppLocaleKey.statementActivityCenterData.tr(),
                    description: AppLocaleKey.statementActivityCenterDataDesc
                        .tr(),
                    amount: '',
                    date: '',
                    status: AppLocaleKey.statusAudited.tr(),
                    reportName: 'AGL007A',
                    isActivityCenterDataReport: true,
                    exportType: defaultExportType,
                  );
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.account_balance_wallet_outlined,
                color: AppColor.emeraldTeal,
                title: AppLocaleKey.statementTrialBalanceByCategories.tr(),
                subtitle: 'Report/TrialBalanceByCategoriesReport (AGL055)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.account_balance_rounded,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ميزان المراجعة'
                    : 'Trial Balance Report',
                subtitle: 'Report/TrialBalanceReport (AGL030)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.calendar_month_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ميزان المراجعة الشهري'
                    : 'Monthly Trial Balance Report',
                subtitle: 'Report/TrialBalanceReport (AGL060 / AGL060A)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.calendar_view_month_rounded,
                color: AppColor.purpleAccent,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ميزان المراجعة الشهري حسب المجموعات'
                    : 'Monthly Trial Balance Report by Groups',
                subtitle: 'Report/TrialBalanceReport (AGL060H)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.account_balance_wallet_rounded,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ميزان المراجعة حسب المراكز'
                    : 'Trial Balance Report by Centers',
                subtitle: 'Report/TrialBalanceReport (AGL031)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.account_balance_rounded,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقرير ميزان المراجعة لفترة'
                    : 'Trial Balance Report for a Period',
                subtitle: 'Report/TrialBalancesReportForPeriod (AGL078)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.domain_disabled_outlined,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقارير ميزان المراجعة حسب المراكز'
                    : 'Trial Balance Reports by Centers',
                subtitle: 'Report/AccountCentersTrialBalancesReport (AGL026C)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.business_outlined,
                color: AppColor.purpleAccent,
                title: AppLocaleKey.statementCostCenters.tr(),
                subtitle: 'Report/CostCentersReport (AGL007)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.calendar_month_outlined,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'الأرصدة الشهرية لمراكز التكلفة'
                    : 'Cost Centers Monthly Balances',
                subtitle: 'Report/CentersMonthlyBalanceReport (AGL008A)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.account_tree_rounded,
                color: AppColor.purpleAccent,
                title: context.locale.languageCode == 'ar'
                    ? 'حركة مراكز التكلفة'
                    : 'Cost Centers Transactions',
                subtitle: 'Report/CostCentersTransactionReport (AGL028)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.calendar_view_month_outlined,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'الحركة السنوية لمراكز التكلفة'
                    : 'Annual Cost Centers Transactions',
                subtitle: 'Report/CostCentersTransactionAnnualReport (AGL029Y)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.shopping_bag_outlined,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar' ? 'تقرير حركة مراكز المشتريات' : 'Purchase Centers Movement Report',
                subtitle: 'Report/PurchaseOfProjectsReport (AGL1002)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(title: context.locale.languageCode == 'ar' ? 'تقرير حركة مراكز المشتريات' : 'Purchase Centers Movement Report', description: context.locale.languageCode == 'ar' ? 'حركة المشتريات حسب المورد ومركز التكلفة' : 'Purchases by supplier and cost center', amount: '', date: '', status: AppLocaleKey.statusAudited.tr(), reportName: 'AGL1002', isPurchaseOfProjectsReport: true);
                },
              ),
              Gap(10.h),
              _buildExportOption(context, 
                icon: Icons.domain_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementCostCentersProjects.tr(),
                subtitle: 'Report/CostCentersProjectsReport (Agl026)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.account_tree_outlined,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'ملخص مراكز الحسابات الرئيسية'
                    : 'Main Accounts Centers Summary',
                subtitle:
                    'Report/AccountCentersSummaryForMainAccountsReport (AGL0103)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.compare_arrows_rounded,
                color: AppColor.oceanBlue,
                title: AppLocaleKey.statementMonthlyAccountsComparison.tr(),
                subtitle: 'Report/MonthlyAccountComparsionReport (AGL003)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.insights_rounded,
                color: AppColor.purpleAccent,
                title: AppLocaleKey.statementMonthlyCostCentersComparison.tr(),
                subtitle: 'Report/MonthlyCostCentersComparsionReport (AGL008)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.calendar_month_rounded,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'مقارنة الحسابات بالشهور'
                    : 'Accounts Comparison by Months',
                subtitle: 'Report/AccountsComparsionReport (AGL053)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.event_repeat_rounded,
                color: AppColor.oceanBlue,
                title: context.locale.languageCode == 'ar'
                    ? 'تقارير مقارنة شهر - الحسابات'
                    : 'Account Month Comparison',
                subtitle: 'Report/AccountsComparsionReport (AGL054)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
                icon: Icons.assessment_outlined,
                color: AppColor.emeraldTeal,
                title: context.locale.languageCode == 'ar'
                    ? 'مقارنة دليل الحسابات'
                    : 'Chart of Accounts Comparison',
                subtitle: 'Report/AccountsComparsionReport (AGL006)',
                onTap: () {
                  Navigator.pop(ctx);
                  onExportReport(
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
              _buildExportOption(context, 
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

  static Widget _buildExportOption(
    BuildContext context, {
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

}
