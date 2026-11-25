import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/custom_widgets/date_range_bottom_sheet_widget.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/reports/data/repository/reports_repo.dart';
import 'package:my_template/features/reports/presentation/view/widget/file_download_service.dart';
import 'package:my_template/features/reports/presentation/view/widget/activity_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/activity_center_data_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/cash_in_cash_out_voucher_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/checks_data_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/check_verification_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/indicator_data_standard_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/indicator_data_addition_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/withdraw_and_depositing_voucher_report_filter_bottom_sheet_widget.dart';
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
import 'package:my_template/features/reports/presentation/view/widget/income_and_expense_situation_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/monthly_expenses_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/additional_final_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/trial_balance_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/trial_balances_report_for_period_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/integration_general_ledger_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/ledger_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/ledger_report_for_assistant_accounts_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/ledger_report_for_main_accounts_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/ledger_report_per_users_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/journal_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/journal_summarized_report_filter_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/operation_tracing_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/monthly_comparison_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/party_vat_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/customer_supplier_notifications_report_filter_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/invoices_approved_status_report_filter_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/account_centers_analytical_details_report_filter_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/account_centers_analytical_groups_report_filter_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/integrated_vouchers_status_report_filter_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/status_of_daily_transactions_report_filter_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/purchase_of_projects_report_filter_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/test_integration_voucher_report_filter_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/pdf_export_service.dart';
import 'package:my_template/features/reports/presentation/view/widget/pdf_preview_panel.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_screen_widgets.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_table_item_widget.dart';
import 'package:my_template/features/lookup/presentation/widgets/customer_datum_dropdown.dart';


import 'package:my_template/features/reports/presentation/view/widget/reports_preview_area_widget.dart';

mixin ReportsExportHandlerMixin<T extends StatefulWidget> on State<T> {
  ReportPreviewKind previewKind = ReportPreviewKind.none;
  File? pdfFile;
  String previewTitle = '';
  bool isGenerating = false;
  final ScrollController scrollController = ScrollController();

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



  void showReportPreparationDialog() {
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

  String exportFormatLabel(String exportType) => switch (exportType) {
    'pdf' => 'PDF',
    'excel' => 'Excel',
    'word' => 'Word',
    'excelformatted' => 'Excel formatted',
    _ => exportType,
  };

  String fileExtension(String exportType) => switch (exportType) {
    'pdf' => 'pdf',
    'excel' || 'excelformatted' => 'xlsx',
    'word' => 'docx',
    _ => throw ArgumentError.value(exportType, 'exportType', 'Unsupported'),
  };

  void scrollToPreview() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void closePreview() {
    setState(() {
      previewKind = ReportPreviewKind.none;
      pdfFile = null;
    });
  }


  Future<void> handleExportReport({
    required String title,
    required String description,
    required String amount,
    required String date,
    required String status,
    String exportType = 'pdf',
    String? reportName,
    bool isApiReport = false,
    bool isIncomeAndExpenseSituationReport = false,
    bool isQuarterlyIncomeAndExpenseSituationReport = false,
    bool isCostCenterIncomeAndExpenseSituationReport = false,
    bool isMonthlyExpensesReport = false,
    bool isDailyIncomeAndExpenseReport = false,
    bool isJournalReport = false,
    bool isJournalSummarizedReport = false,
    bool isOperationTracingReport = false,
    bool isMainAccountsJournalReport = false,
    bool isGeneralJournalForLevelReport = false,
    bool isCashInCashOutVoucherReport = false,
    bool isChecksDataReport = false,
    bool isCheckVerificationReport = false,
    bool isIndicatorDataStandardReport = false,
    bool isIndicatorDataAdditionReport = false,
    bool isWithdrawAndDepositingVoucherReport = false,
    bool isActivityReport = false,
    bool isActivityCenterDataReport = false,
    bool isMasterAccountsOrCentersReport = false,
    int masterAccountsOrCentersReportPageType = 1,
    String masterAccountsOrCentersSummarizedReportName = 'AGL076',
    String masterAccountsOrCentersDetailedReportName = 'AGL077A',
    bool isMasterCentersReport = false,
    bool isCenterOnCenterAnalysisReport = false,
    bool isExpensesWithVatReport = false,
    bool isSalesWithVatReport = false,
    bool isPurchasesWithVatReport = false,
    bool isCustomerSupplierNotificationsReport = false,
    bool isInvoicesApprovedStatusReport = false,
    bool isAccountCentersAnalyticalDetailsReport = false,
    bool isAccountCentersAnalyticalGroupsReport = false,
    bool isIntegratedVouchersStatusReport = false,
    bool isStatusOfDailyTransactionsReport = false,
    bool isTestIntegrationVoucherReport = false,
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
    bool isPurchaseOfProjectsReport = false,
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

    IncomeAndExpenseSituationReportFilterSelection? incomeExpenseFilter;
    if (isIncomeAndExpenseSituationReport ||
        isQuarterlyIncomeAndExpenseSituationReport ||
        isCostCenterIncomeAndExpenseSituationReport) {
      incomeExpenseFilter =
          await IncomeAndExpenseSituationReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
            initialReportName:
                reportName ??
                (isQuarterlyIncomeAndExpenseSituationReport
                    ? 'AGL300_QS'
                    : isCostCenterIncomeAndExpenseSituationReport
                    ? 'AGL300C'
                    : 'AGL300_M'),
            initialReportPageType: isQuarterlyIncomeAndExpenseSituationReport
                ? 4
                : isCostCenterIncomeAndExpenseSituationReport
                ? 5
                : (reportName == 'AGL300_MS' ? 3 : 2),
            initialAccountLevel:
                isQuarterlyIncomeAndExpenseSituationReport ||
                    isCostCenterIncomeAndExpenseSituationReport
                ? null
                : (reportName == 'AGL300_MS' ? 10 : 15),
            initialYearQuarter: 5,
          );
      if (!mounted || incomeExpenseFilter == null) return;
      exportType = incomeExpenseFilter.exportType;
      reportName = incomeExpenseFilter.reportName;
    }

    MonthlyExpensesReportFilterSelection? monthlyExpensesFilter;
    if (isMonthlyExpensesReport) {
      monthlyExpensesFilter =
          await MonthlyExpensesReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || monthlyExpensesFilter == null) return;
      exportType = monthlyExpensesFilter.exportType;
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
    TestIntegrationVoucherReportFilter? testIntegrationVoucherFilter;
    if (isTestIntegrationVoucherReport) {
      testIntegrationVoucherFilter =
          await TestIntegrationVoucherReportFilterWidget.show(
            context,
            title: title,
            initialExportType: exportType,
            initialReportName: reportName ?? 'AGL063',
          );
      if (!mounted || testIntegrationVoucherFilter == null) return;
      exportType = testIntegrationVoucherFilter.exportType;
      reportName = testIntegrationVoucherFilter.reportName;
    }
    IntegratedVouchersStatusReportFilter? integratedVouchersStatusFilter;
    if (isIntegratedVouchersStatusReport) {
      integratedVouchersStatusFilter =
          await IntegratedVouchersStatusReportFilterWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || integratedVouchersStatusFilter == null) return;
      exportType = integratedVouchersStatusFilter.exportType;
    }
    StatusOfDailyTransactionsFilter? statusOfDailyTransactionsFilter;
    if (isStatusOfDailyTransactionsReport) {
      statusOfDailyTransactionsFilter = await StatusOfDailyTransactionsReportFilterWidget.show(context, title: title);
      if (!mounted || statusOfDailyTransactionsFilter == null) return;
      exportType = statusOfDailyTransactionsFilter.exportType;
    }
    AccountCentersAnalyticalGroupsReportFilter?
    accountCentersAnalyticalGroupsFilter;
    if (isAccountCentersAnalyticalGroupsReport) {
      accountCentersAnalyticalGroupsFilter =
          await AccountCentersAnalyticalGroupsReportFilterWidget.show(
            context,
            title: title,
            initialExportType: exportType,
            initialReportName: reportName ?? 'AGL026L',
          );
      if (!mounted || accountCentersAnalyticalGroupsFilter == null) return;
      exportType = accountCentersAnalyticalGroupsFilter.exportType;
      reportName = accountCentersAnalyticalGroupsFilter.reportName;
    }
    AccountCentersAnalyticalDetailsReportFilter?
    accountCentersAnalyticalDetailsFilter;
    if (isAccountCentersAnalyticalDetailsReport) {
      accountCentersAnalyticalDetailsFilter =
          await AccountCentersAnalyticalDetailsReportFilterWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || accountCentersAnalyticalDetailsFilter == null) return;
      exportType = accountCentersAnalyticalDetailsFilter.exportType;
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
    if (isSalesWithVatReport ||
        isPurchasesWithVatReport ||
        isExpensesWithVatReport) {
      partyVatFilter = await PartyVatReportFilterBottomSheetWidget.show(
        context,
        title: title,
        reportCode: isSalesWithVatReport
            ? 'AAR1000'
            : isExpensesWithVatReport
            ? 'AGL1001E'
            : 'AAR1001',
        type: isSalesWithVatReport
            ? CustomerDatumType.customer
            : CustomerDatumType.supplier,
      );
      if (!mounted || partyVatFilter == null) return;
      exportType = partyVatFilter.exportType;
    }
    CustomerSupplierNotificationsReportFilter?
    customerSupplierNotificationsFilter;
    if (isCustomerSupplierNotificationsReport) {
      customerSupplierNotificationsFilter =
          await CustomerSupplierNotificationsReportFilterWidget.show(
            context,
            title: title,
          );
      if (!mounted || customerSupplierNotificationsFilter == null) return;
      exportType = customerSupplierNotificationsFilter.exportType;
    }
    InvoicesApprovedStatusReportFilter? invoicesApprovedStatusFilter;
    if (isInvoicesApprovedStatusReport) {
      invoicesApprovedStatusFilter =
          await InvoicesApprovedStatusReportFilterWidget.show(
            context,
            title: title,
          );
      if (!mounted || invoicesApprovedStatusFilter == null) return;
      exportType = invoicesApprovedStatusFilter.exportType;
    }
    DateRangeSelection? dateRange;
    if (isDailyIncomeAndExpenseReport) {
      dateRange = await DateRangeBottomSheetWidget.show(
        context,
        title: title,
        confirmLabel: languageCode == 'ar' ? 'عرض التقرير' : 'Generate report',
        showIncomeExpenseOptions: true,
      );
      if (!mounted || dateRange == null) return;
      exportType = dateRange.exportType;
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
    JournalSummarizedReportFilter? journalSummarizedFilter;
    if (isJournalSummarizedReport) {
      journalSummarizedFilter = await JournalSummarizedReportFilterWidget.show(context, title: title);
      if (!mounted || journalSummarizedFilter == null) return;
      exportType = journalSummarizedFilter.exportType;
    }
    OperationTracingReportFilter? operationTracingFilter;
    if (isOperationTracingReport) {
      operationTracingFilter =
          await OperationTracingReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || operationTracingFilter == null) return;
      exportType = operationTracingFilter.exportType;
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
    WithdrawAndDepositingVoucherReportFilterSelection?
    withdrawAndDepositingVoucherFilter;
    if (isWithdrawAndDepositingVoucherReport) {
      withdrawAndDepositingVoucherFilter =
          await WithdrawAndDepositingVoucherReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || withdrawAndDepositingVoucherFilter == null) return;
      exportType = withdrawAndDepositingVoucherFilter.exportType;
    }
    ActivityReportFilterSelection? activityReportFilter;
    if (isActivityReport) {
      activityReportFilter = await ActivityReportFilterBottomSheetWidget.show(
        context,
        title: title,
        initialExportType: exportType,
      );
      if (!mounted || activityReportFilter == null) return;
      exportType = activityReportFilter.exportType;
    }
    ActivityCenterDataReportFilterSelection? activityCenterDataReportFilter;
    if (isActivityCenterDataReport) {
      activityCenterDataReportFilter =
          await ActivityCenterDataReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || activityCenterDataReportFilter == null) return;
      exportType = activityCenterDataReportFilter.exportType;
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
    CheckVerificationFilter? checkVerificationFilter;
    if (isCheckVerificationReport) {
      checkVerificationFilter =
          await CheckVerificationReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialExportType: exportType,
          );
      if (!mounted || checkVerificationFilter == null) return;
      exportType = checkVerificationFilter.exportType;
    }
    IndicatorDataStandardReportFilterSelection? indicatorDataStandardFilter;
    if (isIndicatorDataStandardReport) {
      indicatorDataStandardFilter =
          await IndicatorDataStandardReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialReportName: reportName ?? 'AGL066',
            initialExportType: exportType,
          );
      if (!mounted || indicatorDataStandardFilter == null) return;
      reportName = indicatorDataStandardFilter.reportName;
      exportType = indicatorDataStandardFilter.exportType;
    }
    IndicatorDataAdditionReportFilterSelection? indicatorDataAdditionFilter;
    if (isIndicatorDataAdditionReport) {
      indicatorDataAdditionFilter =
          await IndicatorDataAdditionReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialReportName: reportName ?? 'AGL800A',
            initialExportType: exportType,
          );
      if (!mounted || indicatorDataAdditionFilter == null) return;
      reportName = indicatorDataAdditionFilter.reportName;
      exportType = indicatorDataAdditionFilter.exportType;
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
    PurchaseOfProjectsReportFilter? purchaseOfProjectsFilter;
    if (isPurchaseOfProjectsReport) {
      purchaseOfProjectsFilter = await PurchaseOfProjectsReportFilterWidget.show(context, title: title);
      if (!mounted || purchaseOfProjectsFilter == null) return;
      exportType = purchaseOfProjectsFilter.exportType;
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
            isAccountMovement: isAccountsComparisonReport,
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
      isGenerating = true;
      previewTitle = title;
    });
    showReportPreparationDialog();

    try {
      final File file;
      if (isApiReport ||
          isIncomeAndExpenseSituationReport ||
          isQuarterlyIncomeAndExpenseSituationReport ||
          isCostCenterIncomeAndExpenseSituationReport ||
          isMonthlyExpensesReport ||
          isDailyIncomeAndExpenseReport ||
          isJournalReport ||
          isJournalSummarizedReport ||
          isOperationTracingReport ||
          isMainAccountsJournalReport ||
          isGeneralJournalForLevelReport ||
          isCashInCashOutVoucherReport ||
          isChecksDataReport ||
          isCheckVerificationReport ||
          isIndicatorDataStandardReport ||
          isIndicatorDataAdditionReport ||
          isWithdrawAndDepositingVoucherReport ||
          isActivityReport ||
          isActivityCenterDataReport ||
          isMasterAccountsOrCentersReport ||
          isCenterOnCenterAnalysisReport ||
          isExpensesWithVatReport ||
          isSalesWithVatReport ||
          isPurchasesWithVatReport ||
          isCustomerSupplierNotificationsReport ||
          isInvoicesApprovedStatusReport ||
          isAccountCentersAnalyticalDetailsReport ||
          isAccountCentersAnalyticalGroupsReport ||
          isIntegratedVouchersStatusReport ||
          isStatusOfDailyTransactionsReport ||
          isTestIntegrationVoucherReport ||
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
          isPurchaseOfProjectsReport ||
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
            : isCheckVerificationReport
            ? await reportsRepo.getCheckVerificationReport(
                fromBankCode: checkVerificationFilter?.fromBankCode,
                toBankCode: checkVerificationFilter?.toBankCode,
                fromDate: checkVerificationFilter?.fromDate,
                toDate: checkVerificationFilter?.toDate,
                receiveName: checkVerificationFilter?.receiveName,
                checkStatus: checkVerificationFilter?.checkStatus ?? 2,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isIndicatorDataStandardReport
            ? await reportsRepo.getIndicatorDataStandardReport(
                fromIndicatorCode:
                    indicatorDataStandardFilter?.fromIndicatorCode,
                toIndicatorCode: indicatorDataStandardFilter?.toIndicatorCode,
                reportName: reportName ?? 'AGL066',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isIndicatorDataAdditionReport
            ? await reportsRepo.getIndicatorDataAdditionReport(
                fromIndicatorCode:
                    indicatorDataAdditionFilter?.fromIndicatorCode,
                toIndicatorCode: indicatorDataAdditionFilter?.toIndicatorCode,
                reportName: reportName ?? 'AGL800A',
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
            : isWithdrawAndDepositingVoucherReport
            ? await reportsRepo.getWithdrawAndDepositingVoucherReport(
                fromBankCode: withdrawAndDepositingVoucherFilter?.fromBankCode,
                toBankCode: withdrawAndDepositingVoucherFilter?.toBankCode,
                fromDate: withdrawAndDepositingVoucherFilter?.fromDate,
                toDate: withdrawAndDepositingVoucherFilter?.toDate,
                reportName: reportName ?? 'AGL065',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isActivityReport
            ? await reportsRepo.getActivityReport(
                fromCenterNoOne: activityReportFilter?.fromCenterNoOne,
                toCenterNoOne: activityReportFilter?.toCenterNoOne,
                fromAccountNo: activityReportFilter?.fromAccountNo,
                toAccountNo: activityReportFilter?.toAccountNo,
                fromCenterNoZero: activityReportFilter?.fromCenterNoZero,
                toCenterNoZero: activityReportFilter?.toCenterNoZero,
                fromDate: activityReportFilter?.fromDate,
                toDate: activityReportFilter?.toDate,
                reportName: reportName ?? 'AGL111',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isActivityCenterDataReport
            ? await reportsRepo.getActivityCenterDataReport(
                fromCostCenterNo:
                    activityCenterDataReportFilter?.fromCostCenterNo,
                toCostCenterNo: activityCenterDataReportFilter?.toCostCenterNo,
                fromLevel: activityCenterDataReportFilter?.fromLevel,
                toLevel: activityCenterDataReportFilter?.toLevel,
                centerType: activityCenterDataReportFilter?.centerType ?? 0,
                fromCenterNoZero:
                    activityCenterDataReportFilter?.fromCenterNoZero,
                toCenterNoZero: activityCenterDataReportFilter?.toCenterNoZero,
                reportName: reportName ?? 'AGL007A',
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
            : isOperationTracingReport
            ? await reportsRepo.getOperationTracingReport(
                fromEntrySerial: operationTracingFilter?.fromEntrySerial,
                toEntrySerial: operationTracingFilter?.toEntrySerial,
                fromEntryNo: operationTracingFilter?.fromEntryNo,
                toEntryNo: operationTracingFilter?.toEntryNo,
                fromDate: operationTracingFilter?.fromDate,
                toDate: operationTracingFilter?.toDate,
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
            : isJournalSummarizedReport
            ? await reportsRepo.getJournalSummarizedReport(
                entryType: journalSummarizedFilter?.entryType ?? 5,
                fromEntrySerial: journalSummarizedFilter?.fromEntrySerial,
                toEntrySerial: journalSummarizedFilter?.toEntrySerial,
                fromDate: journalSummarizedFilter?.fromDate,
                toDate: journalSummarizedFilter?.toDate,
                reportName: 'AGL900', languageCode: languageCode, exportType: exportType,
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
                accountLevel: accountCentersSummaryFilter?.accountLevel ?? 1,
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
                costCenterNo: additionalFinalReportFilter?.costCenterNo,
                reportTitle: languageCode == 'ar'
                    ? 'تقرير إضافي'
                    : 'Additional Report',
                fromLineSerial: additionalFinalReportFilter?.fromLineSerial,
                toLineSerial: additionalFinalReportFilter?.toLineSerial,
                reportName:
                    additionalFinalReportFilter?.reportName ?? 'AGL037A',
                languageCode: languageCode,
                exportType: exportType,
              )
            : (isIncomeAndExpenseSituationReport ||
                  isQuarterlyIncomeAndExpenseSituationReport ||
                  isCostCenterIncomeAndExpenseSituationReport)
            ? await reportsRepo.getIncomeAndExpenseSituationReport(
                accountLevel: incomeExpenseFilter?.accountLevel,
                fromMonth: incomeExpenseFilter?.fromMonth,
                toMonth: incomeExpenseFilter?.toMonth,
                fromCostCenterNo: incomeExpenseFilter?.fromCostCenterNo,
                toCostCenterNo: incomeExpenseFilter?.toCostCenterNo,
                yearQuarter: incomeExpenseFilter?.yearQuarter,
                finalAccountType: incomeExpenseFilter?.finalAccountType ?? 3,
                reportPageType: incomeExpenseFilter?.reportPageType ?? 2,
                reportName:
                    incomeExpenseFilter?.reportName ??
                    (isQuarterlyIncomeAndExpenseSituationReport
                        ? 'AGL300_QS'
                        : isCostCenterIncomeAndExpenseSituationReport
                        ? 'AGL300C'
                        : 'AGL300_M'),
                languageCode: languageCode,
                exportType: exportType,
              )
            : isMonthlyExpensesReport
            ? await reportsRepo.getIncomeAndExpenseSituationReport(
                fromAccountNo: monthlyExpensesFilter?.fromAccountNo,
                toAccountNo: monthlyExpensesFilter?.toAccountNo,
                fromCostCenterNo: monthlyExpensesFilter?.fromCostCenterNo,
                toCostCenterNo: monthlyExpensesFilter?.toCostCenterNo,
                fromChartAnaly: monthlyExpensesFilter?.fromChartAnaly,
                toChartAnaly: monthlyExpensesFilter?.toChartAnaly,
                finalAccountType: monthlyExpensesFilter?.finalAccountType ?? 3,
                mainAccountsFilter:
                    monthlyExpensesFilter?.mainAccountsFilter ?? 1,
                reportPageType: 6,
                reportName: 'AGL0400',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isDailyIncomeAndExpenseReport
            ? await reportsRepo.getDailyIncomeAndExpenseSituationReport(
                fromDate: dateRange?.fromDate,
                toDate: dateRange?.toDate,
                accountLevel: dateRange?.accountLevel,
                doNotDisplayAccountsWithZeroBalances:
                    dateRange?.doNotDisplayAccountsWithZeroBalances ??
                    false,
                finalAccountType:
                    dateRange?.finalAccountType ?? 3,
                reportPageType: 1,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isExpensesWithVatReport
            ? await reportsRepo.getExpensesWithVatReport(
                fromCustomerNo: partyVatFilter?.fromCustomerNo,
                toCustomerNo: partyVatFilter?.toCustomerNo,
                fromVoucherDate: partyVatFilter?.fromTransDate,
                toVoucherDate: partyVatFilter?.toTransDate,
                taxTreatment: partyVatFilter?.taxTreatment ?? 3,
                taxPeriod: partyVatFilter?.taxPeriod ?? 3,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isSalesWithVatReport
            ? await reportsRepo.getSalesWithVatReport(
                fromCustomerNo: partyVatFilter?.fromCustomerNo,
                toCustomerNo: partyVatFilter?.toCustomerNo,
                fromItemCode: partyVatFilter?.fromItemCode,
                toItemCode: partyVatFilter?.toItemCode,
                fromDocId: partyVatFilter?.fromDocId,
                toDocId: partyVatFilter?.toDocId,
                fromTransDate: partyVatFilter?.fromTransDate,
                toTransDate: partyVatFilter?.toTransDate,
                documentType: partyVatFilter?.documentType ?? 5,
                accountingSystem: partyVatFilter?.accountingSystem ?? 1,
                taxTreatment: partyVatFilter?.taxTreatment ?? 1,
                taxPeriod: partyVatFilter?.taxPeriod ?? 3,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isPurchasesWithVatReport
            ? await reportsRepo.getPurchasesWithVatReport(
                fromCustomerNo: partyVatFilter?.fromCustomerNo,
                toCustomerNo: partyVatFilter?.toCustomerNo,
                fromItemCode: partyVatFilter?.fromItemCode,
                toItemCode: partyVatFilter?.toItemCode,
                fromDocId: partyVatFilter?.fromDocId,
                toDocId: partyVatFilter?.toDocId,
                fromTransDate: partyVatFilter?.fromTransDate,
                toTransDate: partyVatFilter?.toTransDate,
                documentType: partyVatFilter?.documentType ?? 3,
                accountingSystem: partyVatFilter?.accountingSystem ?? 1,
                taxTreatment: partyVatFilter?.taxTreatment ?? 1,
                taxPeriod: partyVatFilter?.taxPeriod ?? 3,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isCustomerSupplierNotificationsReport
            ? await reportsRepo.getCustomerSupplierNotificationsReport(
                dealingType: customerSupplierNotificationsFilter?.dealingType ?? 1,
                fromCustomerNo:
                    customerSupplierNotificationsFilter?.fromCustomerNo,
                toCustomerNo:
                    customerSupplierNotificationsFilter?.toCustomerNo,
                fromVoucherNo:
                    customerSupplierNotificationsFilter?.fromVoucherNo,
                toVoucherNo:
                    customerSupplierNotificationsFilter?.toVoucherNo,
                fromTransNo:
                    customerSupplierNotificationsFilter?.fromTransNo,
                toTransNo:
                    customerSupplierNotificationsFilter?.toTransNo,
                fromTransDate:
                    customerSupplierNotificationsFilter?.fromTransDate,
                toTransDate:
                    customerSupplierNotificationsFilter?.toTransDate,
                fromAnalysisNo:
                    customerSupplierNotificationsFilter?.fromAnalysisNo,
                toAnalysisNo:
                    customerSupplierNotificationsFilter?.toAnalysisNo,
                typeTransacition:
                    customerSupplierNotificationsFilter?.typeTransacition ?? 7,
                accountingSystemType:
                    customerSupplierNotificationsFilter?.accountingSystemType ?? 1,
                impactType:
                    customerSupplierNotificationsFilter?.impactType ?? 3,
                paymentType:
                    customerSupplierNotificationsFilter?.paymentType ?? 3,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isInvoicesApprovedStatusReport
            ? await reportsRepo.getInvoicesApprovedStatusReport(
                fromCustomerNo: invoicesApprovedStatusFilter?.fromCustomerNo,
                toCustomerNo: invoicesApprovedStatusFilter?.toCustomerNo,
                fromTransDate: invoicesApprovedStatusFilter?.fromTransDate,
                toTransDate: invoicesApprovedStatusFilter?.toTransDate,
                invoiceType: invoicesApprovedStatusFilter?.invoiceType ?? 4,
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
            : isAccountCentersAnalyticalDetailsReport
            ? await reportsRepo.getAccountCentersAnalyticalDetailsReport(
                fromAccountNo: accountCentersAnalyticalDetailsFilter?.fromAccountNo,
                toAccountNo: accountCentersAnalyticalDetailsFilter?.toAccountNo,
                fromCostCenterNo: accountCentersAnalyticalDetailsFilter?.fromCostCenterNo,
                toCostCenterNo: accountCentersAnalyticalDetailsFilter?.toCostCenterNo,
                fromAccAnal: accountCentersAnalyticalDetailsFilter?.fromAccAnal,
                toAccAnal: accountCentersAnalyticalDetailsFilter?.toAccAnal,
                fromCentAnal: accountCentersAnalyticalDetailsFilter?.fromCentAnal,
                toCentAnal: accountCentersAnalyticalDetailsFilter?.toCentAnal,
                fromAnalytical: accountCentersAnalyticalDetailsFilter?.fromAnalytical,
                toAnalytical: accountCentersAnalyticalDetailsFilter?.toAnalytical,
                fromDate: accountCentersAnalyticalDetailsFilter?.fromDate,
                toDate: accountCentersAnalyticalDetailsFilter?.toDate,
                reportName: 'AGL098',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isAccountCentersAnalyticalGroupsReport
            ? await reportsRepo.getAccountCentersAnalyticalGroupsReport(
                levelCenter: accountCentersAnalyticalGroupsFilter?.levelCenter,
                fromAccountNo: accountCentersAnalyticalGroupsFilter?.fromAccountNo,
                toAccountNo: accountCentersAnalyticalGroupsFilter?.toAccountNo,
                fromCostCenterNo: accountCentersAnalyticalGroupsFilter?.fromCostCenterNo,
                toCostCenterNo: accountCentersAnalyticalGroupsFilter?.toCostCenterNo,
                fromDate: accountCentersAnalyticalGroupsFilter?.fromDate,
                toDate: accountCentersAnalyticalGroupsFilter?.toDate,
                reportName: reportName ?? 'AGL026L',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isTestIntegrationVoucherReport
            ? await reportsRepo.getTestIntegrationVoucherReport(
                entryType: testIntegrationVoucherFilter?.entryType,
                fromEntrySerial: testIntegrationVoucherFilter?.fromEntrySerial,
                toEntrySerial: testIntegrationVoucherFilter?.toEntrySerial,
                fromDate: testIntegrationVoucherFilter?.fromDate,
                toDate: testIntegrationVoucherFilter?.toDate,
                reportName: reportName ?? 'AGL063',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isIntegratedVouchersStatusReport
            ? await reportsRepo.getIntegratedVouchersStatusReport(
                fromDate: integratedVouchersStatusFilter?.fromDate,
                toDate: integratedVouchersStatusFilter?.toDate,
                integratedVouchersStatusType:
                    integratedVouchersStatusFilter?.integratedVouchersStatusType ?? 3,
                programType: integratedVouchersStatusFilter?.programType ?? 6,
                reportName: 'TAGL111',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isStatusOfDailyTransactionsReport
            ? await reportsRepo.getStatusOfDailyTransactionsReport(
                fromDate: statusOfDailyTransactionsFilter?.fromDate,
                toDate: statusOfDailyTransactionsFilter?.toDate,
                transactionType: statusOfDailyTransactionsFilter?.transactionType ?? 12,
                reportName: 'AGL2000', languageCode: languageCode, exportType: exportType,
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
            : isPurchaseOfProjectsReport
            ? await reportsRepo.getPurchaseOfProjectsReport(
                fromCustomerNo: purchaseOfProjectsFilter?.fromCustomerNo,
                toCustomerNo: purchaseOfProjectsFilter?.toCustomerNo,
                fromCostCenterNo: purchaseOfProjectsFilter?.fromCostCenterNo,
                toCostCenterNo: purchaseOfProjectsFilter?.toCostCenterNo,
                fromTransDate: purchaseOfProjectsFilter?.fromDate,
                toTransDate: purchaseOfProjectsFilter?.toDate,
                reportName: 'AGL1002',
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
            'صيغة ${exportFormatLabel(exportType)} غير مدعومة لهذا التقرير',
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
          '${baseName.replaceAll(RegExp(r'\s+'), '_')}_${DateTime.now().millisecondsSinceEpoch}.${fileExtension(exportType)}';
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
          pdfFile = file;
          previewTitle = title;
          previewKind = ReportPreviewKind.pdf;
          isGenerating = false;
        });
        scrollToPreview();
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
            'تم تنزيل التقرير، لكن لا يوجد تطبيق لفتح صيغة ${exportFormatLabel(exportType)}',
          );
        }
        setState(() {
          previewKind = ReportPreviewKind.none;
          pdfFile = null;
          isGenerating = false;
        });
        CommonMethods.showToast(
          message:
              'تم تنزيل وفتح التقرير بصيغة ${exportFormatLabel(exportType)}',
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      setState(() => isGenerating = false);
      String errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'حدث خطأ أثناء تحميل ملف ${exportFormatLabel(exportType)}';

      if (errorMessage.contains('404')) {
        errorMessage = 'لا توجد بيانات';
      } else if (errorMessage.contains('401') || errorMessage.contains('403')) {
        errorMessage = 'لا توجد صلاحيات';
      }

      CommonMethods.showToast(message: errorMessage, type: ToastType.error);
    }
  }




  Future<void> exportReportFromStatement(
    Map<String, dynamic> statement,
    String exportType,
  ) {
    final title = statement['title'] as String;
    final description = statement['desc'] as String;
    final amount = statement['amount'] as String? ?? '';
    final date = statement['date'] as String? ?? '';
    final status = statement['status'] as String;
    return handleExportReport(
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
      isQuarterlyIncomeAndExpenseSituationReport:
          statement['isQuarterlyIncomeAndExpenseSituationReport'] == true,
      isCostCenterIncomeAndExpenseSituationReport:
          statement['isCostCenterIncomeAndExpenseSituationReport'] == true,
      isMonthlyExpensesReport: statement['isMonthlyExpensesReport'] == true,
      isDailyIncomeAndExpenseReport:
          statement['isDailyIncomeAndExpenseReport'] == true,
      isJournalReport: statement['isJournalReport'] == true,
      isJournalSummarizedReport:
          statement['isJournalSummarizedReport'] == true,
      isOperationTracingReport: statement['isOperationTracingReport'] == true,
      isMainAccountsJournalReport:
          statement['isMainAccountsJournalReport'] == true,
      isGeneralJournalForLevelReport:
          statement['isGeneralJournalForLevelReport'] == true,
      isCashInCashOutVoucherReport:
          statement['isCashInCashOutVoucherReport'] == true,
      isChecksDataReport: statement['isChecksDataReport'] == true,
      isCheckVerificationReport: statement['isCheckVerificationReport'] == true,
      isIndicatorDataStandardReport:
          statement['isIndicatorDataStandardReport'] == true,
      isIndicatorDataAdditionReport:
          statement['isIndicatorDataAdditionReport'] == true,
      isWithdrawAndDepositingVoucherReport:
          statement['isWithdrawAndDepositingVoucherReport'] == true,
      isActivityReport: statement['isActivityReport'] == true,
      isActivityCenterDataReport:
          statement['isActivityCenterDataReport'] == true,
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
      isCustomerSupplierNotificationsReport:
          statement['isCustomerSupplierNotificationsReport'] == true,
      isInvoicesApprovedStatusReport:
          statement['isInvoicesApprovedStatusReport'] == true,
      isTestIntegrationVoucherReport:
          statement['isTestIntegrationVoucherReport'] == true,
      isAccountCentersAnalyticalDetailsReport:
          statement['isAccountCentersAnalyticalDetailsReport'] == true,
      isAccountCentersAnalyticalGroupsReport:
          statement['isAccountCentersAnalyticalGroupsReport'] == true,
      isIntegratedVouchersStatusReport:
          statement['isIntegratedVouchersStatusReport'] == true,
      isStatusOfDailyTransactionsReport:
          statement['isStatusOfDailyTransactionsReport'] == true,
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
      isPurchaseOfProjectsReport:
          statement['isPurchaseOfProjectsReport'] == true,
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
  }

}
