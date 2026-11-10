import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/account_centers_trial_balances_report_request_model.dart';
import '../models/account_centers_analytical_details_report_request_model.dart';
import '../models/account_centers_analytical_groups_report_request_model.dart';
import '../models/account_statement_report_request_model.dart';
import '../models/additional_final_report_request_model.dart';
import '../models/annual_ledger_report_request_model.dart';
import '../models/accounts_comparison_report_request_model.dart';
import '../models/account_centers_summary_for_main_accounts_report_request_model.dart';
import '../models/accounts_centers_comparison_report_request_model.dart';
import '../models/activity_center_data_report_request_model.dart';
import '../models/activity_report_request_model.dart';
import '../models/chart_of_account_report_request_model.dart';
import '../models/cash_in_cash_out_voucher_report_request_model.dart';
import '../models/center_on_center_analysis_report_request_model.dart';
import '../models/checks_data_report_request_model.dart';
import '../models/check_verification_report_request_model.dart';
import '../models/operation_tracing_report_request_model.dart';
import '../models/chart_of_account_monthly_balances_report_request_model.dart';
import '../models/centers_comparison_report_request_model.dart';
import '../models/centers_monthly_balance_report_request_model.dart';
import '../models/consolidated_general_ledger_report_request_model.dart';
import '../models/cost_centers_projects_report_request_model.dart';
import '../models/cost_centers_report_request_model.dart';
import '../models/cost_centers_transaction_report_request_model.dart';
import '../models/cost_centers_transaction_annual_report_request_model.dart';
import '../models/customer_supplier_notifications_report_request_model.dart';
import '../models/daily_income_and_expense_situation_report_request_model.dart';
import '../models/expenses_with_vat_report_request_model.dart';
import '../models/financial_statement_report_request_model.dart';
import '../models/general_journal_for_level_report_request_model.dart';
import '../models/general_ledger_audit_report_request_model.dart';
import '../models/general_ledger_payable_aging_report_request_model.dart';
import '../models/general_ledger_posting_report_request_model.dart';
import '../models/general_ledger_report_request_model.dart';
import '../models/income_and_expense_situation_report_request_model.dart';
import '../models/invoices_approved_status_report_request_model.dart';
import '../models/indicator_data_addition_report_request_model.dart';
import '../models/indicator_data_standard_report_request_model.dart';
import '../models/integration_general_ledger_report_request_model.dart';
import '../models/integrated_vouchers_status_report_request_model.dart';
import '../models/status_of_daily_transactions_report_request_model.dart';
import '../models/purchase_of_projects_report_request_model.dart';
import '../models/test_integration_voucher_report_request_model.dart';
import '../models/journal_report_request_model.dart';
import '../models/journal_summarized_report_request_model.dart';
import '../models/ledger_report_request_model.dart';
import '../models/ledger_report_for_assistant_accounts_request_model.dart';
import '../models/ledger_report_for_main_accounts_request_model.dart';
import '../models/ledger_report_per_users_request_model.dart';
import '../models/master_accounts_or_centers_report_request_model.dart';
import '../models/monthly_account_comparison_report_request_model.dart';
import '../models/monthly_cost_centers_comparison_report_request_model.dart';
import '../models/purchases_with_vat_report_request_model.dart';
import '../models/sales_with_vat_report_request_model.dart';
import '../models/subsidiary_ledger_account_report_request_model.dart';
import '../models/trial_balance_by_categories_report_request_model.dart';
import '../models/trial_balance_report_request_model.dart';
import '../models/trial_balances_report_for_period_request_model.dart';
import '../models/withdraw_and_depositing_voucher_report_request_model.dart';

abstract interface class ReportsRepo {
  Future<Either<Failure, File>> getChartOfAccountReport({
    num? fromAccountNo,
    num? toAccountNo,
    String? fromCurrencyCode,
    String? toCurrencyCode,
    int? fromAccountLevel,
    int? toAccountLevel,
    int accountType = 2,
    int finalAccount = 4,
    String reportName = 'AGL004',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getChartOfAccountMonthlyBalancesReport({
    num? fromAccountNo,
    num? toAccountNo,
    int? fromAccountLevel,
    int? toAccountLevel,
    int accountType = 0,
    int finalAccount = 4,
    int reportPageType = 2,
    String reportName = 'AGL015A',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getIncomeAndExpenseSituationReport({
    int? accountLevel,
    int? fromMonth,
    int? toMonth,
    int? fromAccountNo,
    int? toAccountNo,
    int? fromCostCenterNo,
    int? toCostCenterNo,
    int? fromChartAnaly,
    int? toChartAnaly,
    int? yearQuarter,
    int finalAccountType = 3,
    int mainAccountsFilter = 1,
    int reportPageType = 2,
    String reportName = 'AGL300_M',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getDailyIncomeAndExpenseSituationReport({
    DateTime? fromDate,
    DateTime? toDate,
    int? accountLevel,
    bool doNotDisplayAccountsWithZeroBalances = false,
    int finalAccountType = 3,
    int reportPageType = 1,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getJournalReport({
    int? fromEntrySerial,
    int? toEntrySerial,
    String? fromEntryNo,
    String? toEntryNo,
    DateTime? fromDate,
    DateTime? toDate,
    int journalType = 0,
    int journalReportType = 5,
    int reportPageType = 1,
    String reportName = 'AGL009',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getJournalSummarizedReport({
    int entryType = 5, int? fromEntrySerial, int? toEntrySerial,
    DateTime? fromDate, DateTime? toDate, String reportName = 'AGL900',
    required String languageCode, String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getOperationTracingReport({
    int? fromEntrySerial,
    int? toEntrySerial,
    String? fromEntryNo,
    String? toEntryNo,
    DateTime? fromDate,
    DateTime? toDate,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getGeneralJournalForLevelReport({
    int? accountLevel,
    int? fromEntrySerial,
    int? toEntrySerial,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL0104',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getCashInCashOutVoucherReport({
    int receiptType = 1,
    String? fromVoucherNo,
    String? toVoucherNo,
    int? fromBankCode,
    int? toBankCode,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL019',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getChecksDataReport({
    String? fromChqNo,
    String? toChqNo,
    DateTime? fromDate,
    DateTime? toDate,
    int? fromBankCode,
    int? toBankCode,
    int? fromCashAccount,
    int? toCashAccount,
    String reportName = 'AGL019_1',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getCheckVerificationReport({
    int? fromBankCode,
    int? toBankCode,
    DateTime? fromDate,
    DateTime? toDate,
    String? receiveName,
    int checkStatus = 2,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getIndicatorDataStandardReport({
    int? fromIndicatorCode,
    int? toIndicatorCode,
    String reportName = 'AGL066',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getIndicatorDataAdditionReport({
    int? fromIndicatorCode,
    int? toIndicatorCode,
    String reportName = 'AGL800A',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getWithdrawAndDepositingVoucherReport({
    int? fromBankCode,
    int? toBankCode,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL065',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getActivityReport({
    int? fromCenterNoOne,
    int? toCenterNoOne,
    int? fromAccountNo,
    int? toAccountNo,
    int? fromCenterNoZero,
    int? toCenterNoZero,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL111',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getExpensesWithVatReport({
    double? fromCustomerNo,
    double? toCustomerNo,
    DateTime? fromVoucherDate,
    DateTime? toVoucherDate,
    int taxTreatment = 3,
    int taxPeriod = 3,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getSalesWithVatReport({
    double? fromCustomerNo,
    double? toCustomerNo,
    String? fromItemCode,
    String? toItemCode,
    int? fromDocId,
    int? toDocId,
    DateTime? fromTransDate,
    DateTime? toTransDate,
    int documentType = 5,
    int accountingSystem = 1,
    int taxTreatment = 1,
    int taxPeriod = 3,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getPurchasesWithVatReport({
    double? fromCustomerNo,
    double? toCustomerNo,
    String? fromItemCode,
    String? toItemCode,
    int? fromDocId,
    int? toDocId,
    DateTime? fromTransDate,
    DateTime? toTransDate,
    int documentType = 3,
    int accountingSystem = 1,
    int taxTreatment = 1,
    int taxPeriod = 3,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getCustomerSupplierNotificationsReport({
    int dealingType = 1,
    double? fromCustomerNo,
    double? toCustomerNo,
    String? fromVoucherNo,
    String? toVoucherNo,
    int? fromTransNo,
    int? toTransNo,
    DateTime? fromTransDate,
    DateTime? toTransDate,
    int? fromAnalysisNo,
    int? toAnalysisNo,
    int typeTransacition = 7,
    int accountingSystemType = 1,
    int impactType = 3,
    int paymentType = 3,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getInvoicesApprovedStatusReport({
    double? fromCustomerNo,
    double? toCustomerNo,
    DateTime? fromTransDate,
    DateTime? toTransDate,
    int invoiceType = 4,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getGeneralLedgerReport({
    int? fromAccountNo,
    int? toAccountNo,
    String? fromCurrencyCode,
    String? toCurrencyCode,
    int? fromAnalytical,
    int? toAnalytical,
    int? fromAnalytical1,
    int? toAnalytical1,
    int? fromSubVoucher,
    int? toSubVoucher,
    int? fromSubDescId,
    int? toSubDescId,
    DateTime? fromDate,
    DateTime? toDate,
    bool? accountsWithZeroBalances,
    int reportPageType = 1,
    String reportName = 'AGL100',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getAnnualLedgerReport({
    int? fromAccountNo,
    int? toAccountNo,
    String? fromCurrencyCode,
    String? toCurrencyCode,
    int? fromAnalytical,
    int? toAnalytical,
    int? fromAnalytical1,
    int? toAnalytical1,
    int? fromSubVoucher,
    int? toSubVoucher,
    int? fromSubDescId,
    int? toSubDescId,
    DateTime? fromDate,
    DateTime? toDate,
    bool? accountsWithZeroBalances,
    bool? prepareWithAccountRange,
    int ledgerReportType = 1,
    int reportPageType = 2,
    String? reportName,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getLedgerReportForAllAccounts({
    int? fromAccountNo,
    int? toAccountNo,
    String? fromCurrencyCode,
    String? toCurrencyCode,
    int? searchGroup,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    String reportName = 'AGL021C',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getIntegrationGeneralLedgerReport({
    int? fromAccountNo,
    int? toAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    int ledgerReportType = 1,
    int reportPageType = 3,
    String? reportName,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getConsolidatedGeneralLedgerReport({
    int? fromAccountNo,
    int? toAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    bool prepareWithAccountRange = false,
    int ledgerReportType = 1,
    int reportPageType = 4,
    String? reportName,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getGeneralLedgerAuditReport({
    int? fromAccountNo,
    int? toAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    int reportPageType = 1,
    String reportName = 'AGL100',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getGeneralLedgerPostingReport({
    int? fromAccountNo,
    int? toAccountNo,
    int? searchGroup,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    int ledgerReportType = 1,
    int reportPageType = 5,
    String? reportName,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getSubsidiaryLedgerAccountReport({
    int? fromAccountNo,
    int? toAccountNo,
    int? fromMainAccountNo,
    int? toMainAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    int ledgerReportType = 1,
    int reportPageType = 6,
    String? reportName,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getGeneralLedgerPayableAgingReport({
    int? fromAccountNo,
    int? toAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    int ledgerReportType = 1,
    int reportPageType = 7,
    String? reportName,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getLedgerReportForAssistantAccounts({
    num? fromAccountNo,
    num? toAccountNo,
    required int centerLevel,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int? fromAccAnal,
    int? toAccAnal,
    DateTime? fromDate,
    DateTime? toDate,
    int? fromCentAnal,
    int? toCentAnal,
    int? fromAnalytical,
    int? toAnalytical,
    int sideType = 2,
    String reportName = 'AGL094',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getAccountCentersAnalyticalDetailsReport({
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int? fromAccAnal,
    int? toAccAnal,
    int? fromCentAnal,
    int? toCentAnal,
    int? fromAnalytical,
    int? toAnalytical,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL098',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getAccountCentersAnalyticalGroupsReport({
    int? levelCenter,
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    required String reportName,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getIntegratedVouchersStatusReport({
    DateTime? fromDate,
    DateTime? toDate,
    int integratedVouchersStatusType = 3,
    int programType = 6,
    String reportName = 'TAGL111',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getStatusOfDailyTransactionsReport({
    DateTime? fromDate,
    DateTime? toDate,
    int transactionType = 12,
    String reportName = 'AGL2000',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getTestIntegrationVoucherReport({
    int? entryType,
    num? fromEntrySerial,
    num? toEntrySerial,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL063',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getLedgerReportForMainAccounts({
    int? accountLevel,
    num? fromAccountNo,
    num? toAccountNo,
    int? fromAnalytical,
    int? toAnalytical,
    DateTime? fromDate,
    DateTime? toDate,
    int? fromAnalytical1,
    int? toAnalytical1,
    int? fromSubVoucher,
    int? toSubVoucher,
    String reportName = 'AGL021N',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getLedgerReportPerUsers({
    num? fromAccountNo,
    num? toAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL021',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getAccountStatementReport({
    int? subVoucherAccountNo,
    DateTime? subVoucherOraDate,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getTrialBalanceByCategoriesReport({
    String reportName = 'AGL055',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getTrialBalanceReport({
    int? accountLevel,
    bool? doNotDisplayAccountsWithZeroBalances,
    int? balanceType,
    int? fromMonth,
    int? toMonth,
    bool? isGeneral,
    int reportPageType = 1,
    String reportName = 'AGL030',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getTrialBalancesReportForPeriod({
    int? fromAccountNo,
    int? toAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool doNotDisplayAccountsWithZeroBalances = false,
    bool prepareTree = false,
    String reportName = 'AGL078',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getAccountCentersTrialBalancesReport({
    required int accountLevel,
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL026C',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getMasterAccountsOrCentersReport({
    int? fromCategoryNo,
    int? toCategoryNo,
    DateTime? fromDate,
    DateTime? toDate,
    int masterReportType = 1,
    int reportPageType = 1,
    String reportName = 'AGL077A',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getCenterOnCenterAnalysisReport({
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL025A',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getFinancialStatementsReport({
    required int financialStatementReportType,
    int reportType = 1,
    int? toMonth,
    num? costCenterNo,
    required String reportName,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getAdditionalFinalReport({
    num? costCenterNo,
    String? reportTitle,
    int? fromLineSerial,
    int? toLineSerial,
    String reportName = 'AGL037A',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getCostCentersReport({
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int? fromCenterLevel,
    int? toCenterLevel,
    DateTime? fromDate,
    DateTime? toDate,
    required int costCenterType,
    required String reportName,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getActivityCenterDataReport({
    int? fromCostCenterNo,
    int? toCostCenterNo,
    int? fromLevel,
    int? toLevel,
    int centerType = 2,
    int? fromCenterNoZero,
    int? toCenterNoZero,
    int? fromAccountNo,
    int? toAccountNo,
    String reportName = 'AGL007A',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getCentersMonthlyBalanceReport({
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int? fromCenterLevel,
    int? toCenterLevel,
    int costCenterType = 2,
    String reportName = 'AGL008A',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getCostCentersTransactionReport({
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool prepareCostCentersTree = false,
    String reportName = 'AGL028',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getCostCentersTransactionAnnualReport({
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL029Y',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getCostCentersProjectsReport({
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    required String reportName,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getPurchaseOfProjectsReport({
    num? fromCustomerNo, num? toCustomerNo, num? fromCostCenterNo,
    num? toCostCenterNo, DateTime? fromTransDate, DateTime? toTransDate,
    String reportName = 'AGL1002', required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getAccountCentersSummaryForMainAccountsReport({
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    int accountLevel = 1,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getMonthlyAccountComparisonReport({
    num? fromAccountNo,
    num? toAccountNo,
    int accountType = 3,
    String reportName = 'AGL003_Bar',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getAccountsComparsionReport({
    num? fromAccountNo,
    num? toAccountNo,
    int? fromAccountLevel,
    int? toAccountLevel,
    int? fromMonth,
    int? toMonth,
    int? comparisonMonth,
    int accountType = 2,
    int financialStatementType = 4,
    int? balance = 0,
    int? periodically,
    int reportPageType = 4,
    String reportName = 'AGL052',
    bool includeMonthlyFilters = false,
    bool includeComparisonMonthFilters = false,
    bool includeBalancePeriodicallyFilters = false,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getMonthlyCostCentersComparisonReport({
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int accountType = 3,
    String reportName = 'AGL008_Chart',
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getCentersComparisonReport({
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int? fromCenterLevel,
    int? toCenterLevel,
    int? fromMonth,
    int? toMonth,
    int? comparisonMonth,
    int centerType = 2,
    int? balance,
    int? periodically,
    int reportPageType = 4,
    String reportName = 'AGL092',
    bool includeMonthFilters = false,
    bool includeComparisonMonth = false,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getAccountsCentersComparisonReport({
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int? fromMonth,
    int? toMonth,
    int balance = 0,
    int periodically = 0,
    int reportGroup = 0,
    int reportPageType = 1,
    required String reportName,
    bool includeBalanceAndPeriodically = true,
    required String languageCode,
    String exportType = 'pdf',
  });
}

class ReportsRepoImpl implements ReportsRepo {
  final ApiConsumer apiConsumer;

  ReportsRepoImpl(this.apiConsumer);

  @override
  Future<Either<Failure, File>> getChartOfAccountReport({
    num? fromAccountNo,
    num? toAccountNo,
    String? fromCurrencyCode,
    String? toCurrencyCode,
    int? fromAccountLevel,
    int? toAccountLevel,
    int accountType = 2,
    int finalAccount = 4,
    String reportName = 'AGL004',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = ChartOfAccountReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromCurrencyCode: fromCurrencyCode,
          toCurrencyCode: toCurrencyCode,
          fromAccountLevel: fromAccountLevel,
          toAccountLevel: toAccountLevel,
          accountType: accountType,
          finalAccount: finalAccount,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.chartOfAccountReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'chart_of_account',
          exportType: exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getAccountCentersAnalyticalGroupsReport({
    int? levelCenter,
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    required String reportName,
    required String languageCode,
    String exportType = 'pdf',
  }) => handleDioRequest(
    request: () async {
      final requestModel = AccountCentersAnalyticalGroupsReportRequestModel(
        levelCenter: levelCenter,
        fromAccountNo: fromAccountNo,
        toAccountNo: toAccountNo,
        fromCostCenterNo: fromCostCenterNo,
        toCostCenterNo: toCostCenterNo,
        fromDate: fromDate,
        toDate: toDate,
        reportName: reportName,
        exportType: exportType,
      );
      return _downloadReport(
        endpoint: EndPoints.accountCentersAnalyticalGroupsReport,
        body: requestModel.toJson(),
        fileNamePrefix: 'account_centers_analytical_groups_report',
        exportType: requestModel.exportType,
        headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
      );
    },
  );

  @override
  Future<Either<Failure, File>> getInvoicesApprovedStatusReport({
    double? fromCustomerNo,
    double? toCustomerNo,
    DateTime? fromTransDate,
    DateTime? toTransDate,
    int invoiceType = 4,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = InvoicesApprovedStatusReportRequestModel(
          fromCustomerNo: fromCustomerNo,
          toCustomerNo: toCustomerNo,
          fromTransDate: fromTransDate,
          toTransDate: toTransDate,
          invoiceType: invoiceType,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.invoicesApprovedStatusReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'invoices_approved_status_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getCustomerSupplierNotificationsReport({
    int dealingType = 1,
    double? fromCustomerNo,
    double? toCustomerNo,
    String? fromVoucherNo,
    String? toVoucherNo,
    int? fromTransNo,
    int? toTransNo,
    DateTime? fromTransDate,
    DateTime? toTransDate,
    int? fromAnalysisNo,
    int? toAnalysisNo,
    int typeTransacition = 7,
    int accountingSystemType = 1,
    int impactType = 3,
    int paymentType = 3,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = CustomerSupplierNotificationsReportRequestModel(
          dealingType: dealingType,
          fromCustomerNo: fromCustomerNo,
          toCustomerNo: toCustomerNo,
          fromVoucherNo: fromVoucherNo,
          toVoucherNo: toVoucherNo,
          fromTransNo: fromTransNo,
          toTransNo: toTransNo,
          fromTransDate: fromTransDate,
          toTransDate: toTransDate,
          fromAnalysisNo: fromAnalysisNo,
          toAnalysisNo: toAnalysisNo,
          typeTransacition: typeTransacition,
          accountingSystemType: accountingSystemType,
          impactType: impactType,
          paymentType: paymentType,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.customerSupplierNotificationsReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'customer_supplier_notifications_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getChartOfAccountMonthlyBalancesReport({
    num? fromAccountNo,
    num? toAccountNo,
    int? fromAccountLevel,
    int? toAccountLevel,
    int accountType = 0,
    int finalAccount = 4,
    int reportPageType = 2,
    String reportName = 'AGL015A',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = ChartOfAccountMonthlyBalancesReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromAccountLevel: fromAccountLevel,
          toAccountLevel: toAccountLevel,
          accountType: accountType,
          finalAccount: finalAccount,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.chartOfAccountMonthlyBalancesOrStatementReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'chart_of_account_monthly_balances',
          exportType: exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getIncomeAndExpenseSituationReport({
    int? accountLevel,
    int? fromMonth,
    int? toMonth,
    int? fromAccountNo,
    int? toAccountNo,
    int? fromCostCenterNo,
    int? toCostCenterNo,
    int? fromChartAnaly,
    int? toChartAnaly,
    int? yearQuarter,
    int finalAccountType = 3,
    int mainAccountsFilter = 1,
    int reportPageType = 2,
    String reportName = 'AGL300_M',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = IncomeAndExpenseSituationReportRequestModel(
          accountLevel: accountLevel,
          fromMonth: fromMonth,
          toMonth: toMonth,
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          fromChartAnaly: fromChartAnaly,
          toChartAnaly: toChartAnaly,
          yearQuarter: yearQuarter,
          finalAccountType: finalAccountType,
          mainAccountsFilter: mainAccountsFilter,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.incomeAndExpenseSituationReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'income_and_expense_situation_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getDailyIncomeAndExpenseSituationReport({
    DateTime? fromDate,
    DateTime? toDate,
    int? accountLevel,
    bool doNotDisplayAccountsWithZeroBalances = false,
    int finalAccountType = 3,
    int reportPageType = 1,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = DailyIncomeAndExpenseSituationReportRequestModel(
          accountLevel: accountLevel,
          doNotDisplayAccountsWithZeroBalances:
              doNotDisplayAccountsWithZeroBalances,
          fromDate: fromDate,
          toDate: toDate,
          finalAccountType: finalAccountType,
          reportPageType: reportPageType,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.incomeAndExpenseSituationReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'daily_income_and_expense_situation_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getOperationTracingReport({
    int? fromEntrySerial,
    int? toEntrySerial,
    String? fromEntryNo,
    String? toEntryNo,
    DateTime? fromDate,
    DateTime? toDate,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = OperationTracingReportRequestModel(
          fromEntrySerial: fromEntrySerial,
          toEntrySerial: toEntrySerial,
          fromEntryNo: fromEntryNo,
          toEntryNo: toEntryNo,
          fromDate: fromDate,
          toDate: toDate,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.operationTracingReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'operation_tracing_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getJournalReport({
    int? fromEntrySerial,
    int? toEntrySerial,
    String? fromEntryNo,
    String? toEntryNo,
    DateTime? fromDate,
    DateTime? toDate,
    int journalType = 0,
    int journalReportType = 5,
    int reportPageType = 1,
    String reportName = 'AGL009',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = JournalReportRequestModel(
          fromEntrySerial: fromEntrySerial,
          toEntrySerial: toEntrySerial,
          fromEntryNo: fromEntryNo,
          toEntryNo: toEntryNo,
          fromDate: fromDate,
          toDate: toDate,
          journalType: journalType,
          journalReportType: journalReportType,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.journalReport,
          body: requestModel.toJson(),
          fileNamePrefix: reportName.toLowerCase(),
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getJournalSummarizedReport({
    int entryType = 5, int? fromEntrySerial, int? toEntrySerial,
    DateTime? fromDate, DateTime? toDate, String reportName = 'AGL900',
    required String languageCode, String exportType = 'pdf',
  }) => handleDioRequest(request: () async {
    final requestModel = JournalSummarizedReportRequestModel(
      entryType: entryType, fromEntrySerial: fromEntrySerial,
      toEntrySerial: toEntrySerial, fromDate: fromDate, toDate: toDate,
      reportName: reportName, exportType: exportType,
    );
    return _downloadReport(endpoint: EndPoints.journalSummarizedReport,
      body: requestModel.toJson(), fileNamePrefix: 'journal_summarized_report',
      exportType: requestModel.exportType,
      headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'});
  });

  @override
  Future<Either<Failure, File>> getGeneralJournalForLevelReport({
    int? accountLevel,
    int? fromEntrySerial,
    int? toEntrySerial,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL0104',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = GeneralJournalForLevelReportRequestModel(
          accountLevel: accountLevel,
          fromEntrySerial: fromEntrySerial,
          toEntrySerial: toEntrySerial,
          fromDate: fromDate,
          toDate: toDate,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.generalJournalForLevelReport,
          body: requestModel.toJson(),
          fileNamePrefix: reportName.toLowerCase(),
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getCashInCashOutVoucherReport({
    int receiptType = 1,
    String? fromVoucherNo,
    String? toVoucherNo,
    int? fromBankCode,
    int? toBankCode,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL019',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = CashInCashOutVoucherReportRequestModel(
          receiptType: receiptType,
          fromVoucherNo: fromVoucherNo,
          toVoucherNo: toVoucherNo,
          fromBankCode: fromBankCode,
          toBankCode: toBankCode,
          fromDate: fromDate,
          toDate: toDate,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.cashInCashOutVoucherReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'cash_in_cash_out_voucher_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getChecksDataReport({
    String? fromChqNo,
    String? toChqNo,
    DateTime? fromDate,
    DateTime? toDate,
    int? fromBankCode,
    int? toBankCode,
    int? fromCashAccount,
    int? toCashAccount,
    String reportName = 'AGL019_1',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = ChecksDataReportRequestModel(
          fromChqNo: fromChqNo,
          toChqNo: toChqNo,
          fromDate: fromDate,
          toDate: toDate,
          fromBankCode: fromBankCode,
          toBankCode: toBankCode,
          fromCashAccount: fromCashAccount,
          toCashAccount: toCashAccount,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.checksDataReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'checks_data_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getCheckVerificationReport({
    int? fromBankCode,
    int? toBankCode,
    DateTime? fromDate,
    DateTime? toDate,
    String? receiveName,
    int checkStatus = 2,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = CheckVerificationReportRequestModel(
          fromBankCode: fromBankCode,
          toBankCode: toBankCode,
          fromDate: fromDate,
          toDate: toDate,
          receiveName: receiveName,
          checkStatus: checkStatus,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.checkVerificationReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'check_verification_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getIndicatorDataStandardReport({
    int? fromIndicatorCode,
    int? toIndicatorCode,
    String reportName = 'AGL066',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = IndicatorDataStandardReportRequestModel(
          fromIndicatorCode: fromIndicatorCode,
          toIndicatorCode: toIndicatorCode,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.indicatorDataStandardReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'indicator_data_standard_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getIndicatorDataAdditionReport({
    int? fromIndicatorCode,
    int? toIndicatorCode,
    String reportName = 'AGL800A',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = IndicatorDataAdditionReportRequestModel(
          fromIndicatorCode: fromIndicatorCode,
          toIndicatorCode: toIndicatorCode,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.indicatorDataAdditionReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'indicator_data_addition_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getWithdrawAndDepositingVoucherReport({
    int? fromBankCode,
    int? toBankCode,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL065',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = WithdrawAndDepositingVoucherReportRequestModel(
          fromBankCode: fromBankCode,
          toBankCode: toBankCode,
          fromDate: fromDate,
          toDate: toDate,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.withdrawAndDepositingVoucherReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'withdraw_and_depositing_voucher_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getActivityReport({
    int? fromCenterNoOne,
    int? toCenterNoOne,
    int? fromAccountNo,
    int? toAccountNo,
    int? fromCenterNoZero,
    int? toCenterNoZero,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL111',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = ActivityReportRequestModel(
          fromCenterNoOne: fromCenterNoOne,
          toCenterNoOne: toCenterNoOne,
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromCenterNoZero: fromCenterNoZero,
          toCenterNoZero: toCenterNoZero,
          fromDate: fromDate,
          toDate: toDate,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.activityReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'activity_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getExpensesWithVatReport({
    double? fromCustomerNo,
    double? toCustomerNo,
    DateTime? fromVoucherDate,
    DateTime? toVoucherDate,
    int taxTreatment = 3,
    int taxPeriod = 3,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = ExpensesWithVatReportRequestModel(
          fromCustomerNo: fromCustomerNo,
          toCustomerNo: toCustomerNo,
          fromVoucherDate: fromVoucherDate,
          toVoucherDate: toVoucherDate,
          taxTreatment: taxTreatment,
          taxPeriod: taxPeriod,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.expensesWithVatReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'expenses_with_vat_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getSalesWithVatReport({
    double? fromCustomerNo,
    double? toCustomerNo,
    String? fromItemCode,
    String? toItemCode,
    int? fromDocId,
    int? toDocId,
    DateTime? fromTransDate,
    DateTime? toTransDate,
    int documentType = 5,
    int accountingSystem = 1,
    int taxTreatment = 1,
    int taxPeriod = 3,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = SalesWithVatReportRequestModel(
          fromCustomerNo: fromCustomerNo,
          toCustomerNo: toCustomerNo,
          fromItemCode: fromItemCode,
          toItemCode: toItemCode,
          fromDocId: fromDocId,
          toDocId: toDocId,
          fromTransDate: fromTransDate,
          toTransDate: toTransDate,
          documentType: documentType,
          accountingSystem: accountingSystem,
          taxTreatment: taxTreatment,
          taxPeriod: taxPeriod,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.salesWithVatReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'sales_with_vat_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getPurchasesWithVatReport({
    double? fromCustomerNo,
    double? toCustomerNo,
    String? fromItemCode,
    String? toItemCode,
    int? fromDocId,
    int? toDocId,
    DateTime? fromTransDate,
    DateTime? toTransDate,
    int documentType = 3,
    int accountingSystem = 1,
    int taxTreatment = 1,
    int taxPeriod = 3,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = PurchasesWithVatReportRequestModel(
          fromCustomerNo: fromCustomerNo,
          toCustomerNo: toCustomerNo,
          fromItemCode: fromItemCode,
          toItemCode: toItemCode,
          fromDocId: fromDocId,
          toDocId: toDocId,
          fromTransDate: fromTransDate,
          toTransDate: toTransDate,
          documentType: documentType,
          accountingSystem: accountingSystem,
          taxTreatment: taxTreatment,
          taxPeriod: taxPeriod,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.purchasesWithVatReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'purchases_with_vat_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getGeneralLedgerReport({
    int? fromAccountNo,
    int? toAccountNo,
    String? fromCurrencyCode,
    String? toCurrencyCode,
    int? fromAnalytical,
    int? toAnalytical,
    int? fromAnalytical1,
    int? toAnalytical1,
    int? fromSubVoucher,
    int? toSubVoucher,
    int? fromSubDescId,
    int? toSubDescId,
    DateTime? fromDate,
    DateTime? toDate,
    bool? accountsWithZeroBalances,
    int reportPageType = 1,
    String reportName = 'AGL100',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = GeneralLedgerReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromCurrencyCode: fromCurrencyCode,
          toCurrencyCode: toCurrencyCode,
          fromAnalytical: fromAnalytical,
          toAnalytical: toAnalytical,
          fromAnalytical1: fromAnalytical1,
          toAnalytical1: toAnalytical1,
          fromSubVoucher: fromSubVoucher,
          toSubVoucher: toSubVoucher,
          fromSubDescId: fromSubDescId,
          toSubDescId: toSubDescId,
          fromDate: fromDate,
          toDate: toDate,
          accountsWithZeroBalances: accountsWithZeroBalances,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.ledgerReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'general_ledger_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getAnnualLedgerReport({
    int? fromAccountNo,
    int? toAccountNo,
    String? fromCurrencyCode,
    String? toCurrencyCode,
    int? fromAnalytical,
    int? toAnalytical,
    int? fromAnalytical1,
    int? toAnalytical1,
    int? fromSubVoucher,
    int? toSubVoucher,
    int? fromSubDescId,
    int? toSubDescId,
    DateTime? fromDate,
    DateTime? toDate,
    bool? accountsWithZeroBalances,
    bool? prepareWithAccountRange,
    int ledgerReportType = 1,
    int reportPageType = 2,
    String? reportName,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = AnnualLedgerReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromCurrencyCode: fromCurrencyCode,
          toCurrencyCode: toCurrencyCode,
          fromAnalytical: fromAnalytical,
          toAnalytical: toAnalytical,
          fromAnalytical1: fromAnalytical1,
          toAnalytical1: toAnalytical1,
          fromSubVoucher: fromSubVoucher,
          toSubVoucher: toSubVoucher,
          fromSubDescId: fromSubDescId,
          toSubDescId: toSubDescId,
          fromDate: fromDate,
          toDate: toDate,
          accountsWithZeroBalances: accountsWithZeroBalances,
          prepareWithAccountRange: prepareWithAccountRange,
          ledgerReportType: ledgerReportType,
          reportPageType: reportPageType,
          reportName:
              reportName ?? (ledgerReportType == 2 ? 'AGL023Y' : 'AGL021Y'),
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.ledgerReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'annual_ledger_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getTestIntegrationVoucherReport({
    int? entryType,
    num? fromEntrySerial,
    num? toEntrySerial,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL063',
    required String languageCode,
    String exportType = 'pdf',
  }) => handleDioRequest(
    request: () async {
      final requestModel = TestIntegrationVoucherReportRequestModel(
        entryType: entryType,
        fromEntrySerial: fromEntrySerial,
        toEntrySerial: toEntrySerial,
        fromDate: fromDate,
        toDate: toDate,
        reportName: reportName,
        exportType: exportType,
      );
      return _downloadReport(
        endpoint: EndPoints.testIntegrationVoucherReport,
        body: requestModel.toJson(),
        fileNamePrefix: 'test_integration_voucher_report',
        exportType: requestModel.exportType,
        headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
      );
    },
  );

  @override
  Future<Either<Failure, File>> getIntegratedVouchersStatusReport({
    DateTime? fromDate,
    DateTime? toDate,
    int integratedVouchersStatusType = 3,
    int programType = 6,
    String reportName = 'TAGL111',
    required String languageCode,
    String exportType = 'pdf',
  }) => handleDioRequest(
    request: () async {
      final requestModel = IntegratedVouchersStatusReportRequestModel(
        fromDate: fromDate,
        toDate: toDate,
        integratedVouchersStatusType: integratedVouchersStatusType,
        programType: programType,
        reportName: reportName,
        exportType: exportType,
      );
      return _downloadReport(
        endpoint: EndPoints.integratedVouchersStatusReport,
        body: requestModel.toJson(),
        fileNamePrefix: 'integrated_vouchers_status_report',
        exportType: requestModel.exportType,
        headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
      );
    },
  );

  @override
  Future<Either<Failure, File>> getStatusOfDailyTransactionsReport({
    DateTime? fromDate,
    DateTime? toDate,
    int transactionType = 12,
    String reportName = 'AGL2000',
    required String languageCode,
    String exportType = 'pdf',
  }) => handleDioRequest(
    request: () async {
      final requestModel = StatusOfDailyTransactionsReportRequestModel(
        fromDate: fromDate,
        toDate: toDate,
        transactionType: transactionType,
        reportName: reportName,
        exportType: exportType,
      );
      return _downloadReport(
        endpoint: EndPoints.statusOfTheDailyTransacitionsReport,
        body: requestModel.toJson(),
        fileNamePrefix: 'status_of_daily_transactions_report',
        exportType: requestModel.exportType,
        headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
      );
    },
  );

  @override
  Future<Either<Failure, File>> getIntegrationGeneralLedgerReport({
    int? fromAccountNo,
    int? toAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    int ledgerReportType = 1,
    int reportPageType = 3,
    String? reportName,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = IntegrationGeneralLedgerReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromDate: fromDate,
          toDate: toDate,
          accountsWithZeroBalances: accountsWithZeroBalances,
          ledgerReportType: ledgerReportType,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.ledgerReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'integration_general_ledger_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getConsolidatedGeneralLedgerReport({
    int? fromAccountNo,
    int? toAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    bool prepareWithAccountRange = false,
    int ledgerReportType = 1,
    int reportPageType = 4,
    String? reportName,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = ConsolidatedGeneralLedgerReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromDate: fromDate,
          toDate: toDate,
          accountsWithZeroBalances: accountsWithZeroBalances,
          prepareWithAccountRange: prepareWithAccountRange,
          ledgerReportType: ledgerReportType,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.ledgerReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'consolidated_general_ledger_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getGeneralLedgerAuditReport({
    int? fromAccountNo,
    int? toAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    int reportPageType = 1,
    String reportName = 'AGL100',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = GeneralLedgerAuditReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromDate: fromDate,
          toDate: toDate,
          accountsWithZeroBalances: accountsWithZeroBalances,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.ledgerReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'general_ledger_audit_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getGeneralLedgerPostingReport({
    int? fromAccountNo,
    int? toAccountNo,
    int? searchGroup,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    int ledgerReportType = 1,
    int reportPageType = 5,
    String? reportName,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = GeneralLedgerPostingReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          searchGroup: searchGroup,
          fromDate: fromDate,
          toDate: toDate,
          accountsWithZeroBalances: accountsWithZeroBalances,
          ledgerReportType: ledgerReportType,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.ledgerReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'general_ledger_posting_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getSubsidiaryLedgerAccountReport({
    int? fromAccountNo,
    int? toAccountNo,
    int? fromMainAccountNo,
    int? toMainAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    int ledgerReportType = 1,
    int reportPageType = 6,
    String? reportName,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = SubsidiaryLedgerAccountReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromMainAccountNo: fromMainAccountNo,
          toMainAccountNo: toMainAccountNo,
          fromDate: fromDate,
          toDate: toDate,
          accountsWithZeroBalances: accountsWithZeroBalances,
          ledgerReportType: ledgerReportType,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.ledgerReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'subsidiary_ledger_account_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getGeneralLedgerPayableAgingReport({
    int? fromAccountNo,
    int? toAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    int ledgerReportType = 1,
    int reportPageType = 7,
    String? reportName,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = GeneralLedgerPayableAgingReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromDate: fromDate,
          toDate: toDate,
          accountsWithZeroBalances: accountsWithZeroBalances,
          ledgerReportType: ledgerReportType,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.ledgerReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'general_ledger_payable_aging_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getLedgerReportForAllAccounts({
    int? fromAccountNo,
    int? toAccountNo,
    String? fromCurrencyCode,
    String? toCurrencyCode,
    int? searchGroup,
    DateTime? fromDate,
    DateTime? toDate,
    bool accountsWithZeroBalances = false,
    String reportName = 'AGL021C',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = LedgerReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromCurrencyCode: fromCurrencyCode,
          toCurrencyCode: toCurrencyCode,
          searchGroup: searchGroup,
          fromDate: fromDate,
          toDate: toDate,
          accountsWithZeroBalances: accountsWithZeroBalances,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.ledgerReportForAllAccounts,
          body: requestModel.toJson(),
          fileNamePrefix: 'ledger_report_all_accounts',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getLedgerReportForAssistantAccounts({
    num? fromAccountNo,
    num? toAccountNo,
    required int centerLevel,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int? fromAccAnal,
    int? toAccAnal,
    DateTime? fromDate,
    DateTime? toDate,
    int? fromCentAnal,
    int? toCentAnal,
    int? fromAnalytical,
    int? toAnalytical,
    int sideType = 2,
    String reportName = 'AGL094',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = LedgerReportForAssistantAccountsRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          centerLevel: centerLevel,
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          fromAccAnal: fromAccAnal,
          toAccAnal: toAccAnal,
          fromDate: fromDate,
          toDate: toDate,
          fromCentAnal: fromCentAnal,
          toCentAnal: toCentAnal,
          fromAnalytical: fromAnalytical,
          toAnalytical: toAnalytical,
          sideType: sideType,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.ledgerReportForAssistantAccounts,
          body: requestModel.toJson(),
          fileNamePrefix: 'ledger_report_assistant_accounts',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getAccountCentersAnalyticalDetailsReport({
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int? fromAccAnal,
    int? toAccAnal,
    int? fromCentAnal,
    int? toCentAnal,
    int? fromAnalytical,
    int? toAnalytical,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL098',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = AccountCentersAnalyticalDetailsReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          fromAccAnal: fromAccAnal,
          toAccAnal: toAccAnal,
          fromCentAnal: fromCentAnal,
          toCentAnal: toCentAnal,
          fromAnalytical: fromAnalytical,
          toAnalytical: toAnalytical,
          fromDate: fromDate,
          toDate: toDate,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.accountCentersAnalyticalDetailsReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'account_centers_analytical_details_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getLedgerReportForMainAccounts({
    int? accountLevel,
    num? fromAccountNo,
    num? toAccountNo,
    int? fromAnalytical,
    int? toAnalytical,
    DateTime? fromDate,
    DateTime? toDate,
    int? fromAnalytical1,
    int? toAnalytical1,
    int? fromSubVoucher,
    int? toSubVoucher,
    String reportName = 'AGL021N',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = LedgerReportForMainAccountsRequestModel(
          accountLevel: accountLevel,
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromAnalytical: fromAnalytical,
          toAnalytical: toAnalytical,
          fromDate: fromDate,
          toDate: toDate,
          fromAnalytical1: fromAnalytical1,
          toAnalytical1: toAnalytical1,
          fromSubVoucher: fromSubVoucher,
          toSubVoucher: toSubVoucher,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.ledgerReportForMainAccounts,
          body: requestModel.toJson(),
          fileNamePrefix: 'ledger_report_main_accounts',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getLedgerReportPerUsers({
    num? fromAccountNo,
    num? toAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL021',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = LedgerReportPerUsersRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromDate: fromDate,
          toDate: toDate,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.ledgerReportPerUsers,
          body: requestModel.toJson(),
          fileNamePrefix: 'ledger_report_per_users',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getAccountStatementReport({
    int? subVoucherAccountNo,
    DateTime? subVoucherOraDate,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = AccountStatementReportRequestModel(
          subVoucherAccountNo: subVoucherAccountNo,
          subVoucherOraDate: subVoucherOraDate,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.accountStatementReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'account_statement_report',
          exportType: exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getTrialBalanceByCategoriesReport({
    String reportName = 'AGL055',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = TrialBalanceByCategoriesReportRequestModel(
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.trialBalanceByCategoriesReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'trial_balance_by_categories',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getTrialBalanceReport({
    int? accountLevel,
    bool? doNotDisplayAccountsWithZeroBalances,
    int? balanceType,
    int? fromMonth,
    int? toMonth,
    bool? isGeneral,
    int reportPageType = 1,
    String reportName = 'AGL030',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = TrialBalanceReportRequestModel(
          accountLevel: accountLevel,
          doNotDisplayAccountsWithZeroBalances:
              doNotDisplayAccountsWithZeroBalances,
          balanceType: balanceType,
          fromMonth: fromMonth,
          toMonth: toMonth,
          isGeneral: isGeneral,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.trialBalanceReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'trial_balance_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getTrialBalancesReportForPeriod({
    int? fromAccountNo,
    int? toAccountNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool doNotDisplayAccountsWithZeroBalances = false,
    bool prepareTree = false,
    String reportName = 'AGL078',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = TrialBalancesReportForPeriodRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromDate: fromDate,
          toDate: toDate,
          doNotDisplayAccountsWithZeroBalances:
              doNotDisplayAccountsWithZeroBalances,
          prepareTree: prepareTree,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.trialBalancesReportForPeriod,
          body: requestModel.toJson(),
          fileNamePrefix: 'trial_balances_report_for_period',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getAccountCentersTrialBalancesReport({
    required int accountLevel,
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL026C',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = AccountCentersTrialBalancesReportRequestModel(
          accountLevel: accountLevel,
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          fromDate: fromDate,
          toDate: toDate,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.accountCentersTrialBalancesReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'account_centers_trial_balances_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getMasterAccountsOrCentersReport({
    int? fromCategoryNo,
    int? toCategoryNo,
    DateTime? fromDate,
    DateTime? toDate,
    int masterReportType = 1,
    int reportPageType = 1,
    String reportName = 'AGL077A',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = MasterAccountsOrCentersReportRequestModel(
          fromCategoryNo: fromCategoryNo,
          toCategoryNo: toCategoryNo,
          fromDate: fromDate,
          toDate: toDate,
          masterReportType: masterReportType,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.masterAccountsOrCentersReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'master_accounts_or_centers_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getCenterOnCenterAnalysisReport({
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL025A',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = CenterOnCenterAnalysisReportRequestModel(
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          fromDate: fromDate,
          toDate: toDate,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.centerOnCenterAnalysisReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'center_on_center_analysis',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getFinancialStatementsReport({
    required int financialStatementReportType,
    int reportType = 1,
    int? toMonth,
    num? costCenterNo,
    required String reportName,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = FinancialStatementReportRequestModel(
          financialStatementReportType: financialStatementReportType,
          reportType: reportType,
          toMonth: toMonth,
          costCenterNo: costCenterNo,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.financialStatementsReport,
          body: requestModel.toJson(),
          fileNamePrefix: reportName.toLowerCase(),
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getAdditionalFinalReport({
    num? costCenterNo,
    String? reportTitle,
    int? fromLineSerial,
    int? toLineSerial,
    String reportName = 'AGL037A',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = AdditionalFinalReportRequestModel(
          costCenterNo: costCenterNo,
          reportTitle: reportTitle,
          fromLineSerial: fromLineSerial,
          toLineSerial: toLineSerial,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.additionalFinalReport,
          body: requestModel.toJson(),
          fileNamePrefix: reportName.toLowerCase(),
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getCostCentersReport({
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int? fromCenterLevel,
    int? toCenterLevel,
    DateTime? fromDate,
    DateTime? toDate,
    required int costCenterType,
    required String reportName,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = CostCentersReportRequestModel(
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          fromCenterLevel: fromCenterLevel,
          toCenterLevel: toCenterLevel,
          fromDate: fromDate,
          toDate: toDate,
          costCenterType: costCenterType,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.costCentersReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'cost_centers',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getActivityCenterDataReport({
    int? fromCostCenterNo,
    int? toCostCenterNo,
    int? fromLevel,
    int? toLevel,
    int centerType = 2,
    int? fromCenterNoZero,
    int? toCenterNoZero,
    int? fromAccountNo,
    int? toAccountNo,
    String reportName = 'AGL007A',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = ActivityCenterDataReportRequestModel(
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          fromLevel: fromLevel,
          toLevel: toLevel,
          centerType: centerType,
          fromCenterNoZero: fromCenterNoZero,
          toCenterNoZero: toCenterNoZero,
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.costCentersReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'activity_center_data_report',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getCentersMonthlyBalanceReport({
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int? fromCenterLevel,
    int? toCenterLevel,
    int costCenterType = 2,
    String reportName = 'AGL008A',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = CentersMonthlyBalanceReportRequestModel(
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          fromCenterLevel: fromCenterLevel,
          toCenterLevel: toCenterLevel,
          costCenterType: costCenterType,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.centersMonthlyBalanceReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'centers_monthly_balance',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getCostCentersTransactionReport({
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    bool prepareCostCentersTree = false,
    String reportName = 'AGL028',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = CostCentersTransactionReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          fromDate: fromDate,
          toDate: toDate,
          prepareCostCentersTree: prepareCostCentersTree,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.costCentersTransactionReport,
          body: requestModel.toJson(),
          fileNamePrefix: reportName.toLowerCase(),
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getCostCentersTransactionAnnualReport({
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    String reportName = 'AGL029Y',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = CostCentersTransactionAnnualReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          fromDate: fromDate,
          toDate: toDate,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.costCentersTransactionAnnualReport,
          body: requestModel.toJson(),
          fileNamePrefix: reportName.toLowerCase(),
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getCostCentersProjectsReport({
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    required String reportName,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = CostCentersProjectsReportRequestModel(
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          fromDate: fromDate,
          toDate: toDate,
          reportName: reportName,
          exportType: exportType,
        );
        return _downloadReport(
          endpoint: EndPoints.costCentersProjectsReport,
          body: requestModel.toJson(),
          fileNamePrefix: reportName.toLowerCase(),
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getPurchaseOfProjectsReport({
    num? fromCustomerNo, num? toCustomerNo, num? fromCostCenterNo,
    num? toCostCenterNo, DateTime? fromTransDate, DateTime? toTransDate,
    String reportName = 'AGL1002', required String languageCode,
    String exportType = 'pdf',
  }) => handleDioRequest(request: () async {
    final requestModel = PurchaseOfProjectsReportRequestModel(
      fromCustomerNo: fromCustomerNo, toCustomerNo: toCustomerNo,
      fromCostCenterNo: fromCostCenterNo, toCostCenterNo: toCostCenterNo,
      fromTransDate: fromTransDate, toTransDate: toTransDate,
      reportName: reportName, exportType: exportType,
    );
    return _downloadReport(endpoint: EndPoints.purchaseOfProjectsReport,
      body: requestModel.toJson(), fileNamePrefix: 'purchase_of_projects_report',
      exportType: requestModel.exportType,
      headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'});
  });

  @override
  Future<Either<Failure, File>> getAccountCentersSummaryForMainAccountsReport({
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    DateTime? fromDate,
    DateTime? toDate,
    int accountLevel = 1,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel =
            AccountCentersSummaryForMainAccountsReportRequestModel(
              accountLevel: accountLevel,
              fromAccountNo: fromAccountNo,
              toAccountNo: toAccountNo,
              fromCostCenterNo: fromCostCenterNo,
              toCostCenterNo: toCostCenterNo,
              fromDate: fromDate,
              toDate: toDate,
              exportType: exportType,
            );
        return _downloadReport(
          endpoint: EndPoints.accountCentersSummaryForMainAccountsReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'agl0103',
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getMonthlyAccountComparisonReport({
    num? fromAccountNo,
    num? toAccountNo,
    int accountType = 3,
    String reportName = 'AGL003_Bar',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = MonthlyAccountComparisonReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          accountType: accountType,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.monthlyAccountComparisonReport,
          body: requestModel.toJson(),
          fileNamePrefix: reportName.toLowerCase(),
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getAccountsComparsionReport({
    num? fromAccountNo,
    num? toAccountNo,
    int? fromAccountLevel,
    int? toAccountLevel,
    int? fromMonth,
    int? toMonth,
    int? comparisonMonth,
    int accountType = 2,
    int financialStatementType = 4,
    int? balance = 0,
    int? periodically,
    int reportPageType = 4,
    String reportName = 'AGL052',
    bool includeMonthlyFilters = false,
    bool includeComparisonMonthFilters = false,
    bool includeBalancePeriodicallyFilters = false,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = AccountsComparisonReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromAccountLevel: fromAccountLevel,
          toAccountLevel: toAccountLevel,
          fromMonth: fromMonth,
          toMonth: toMonth,
          comparisonMonth: comparisonMonth,
          accountType: accountType,
          financialStatementType: financialStatementType,
          balance: balance,
          periodically: periodically,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
          includeMonthlyFilters: includeMonthlyFilters,
          includeComparisonMonthFilters: includeComparisonMonthFilters,
          includeBalancePeriodicallyFilters: includeBalancePeriodicallyFilters,
        );
        return _downloadReport(
          endpoint: EndPoints.accountsComparsionReport,
          body: requestModel.toJson(),
          fileNamePrefix: reportName.toLowerCase(),
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getMonthlyCostCentersComparisonReport({
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int accountType = 3,
    String reportName = 'AGL008_Chart',
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = MonthlyCostCentersComparisonReportRequestModel(
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          accountType: accountType,
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.monthlyCostCentersComparisonReport,
          body: requestModel.toJson(),
          fileNamePrefix: reportName.toLowerCase(),
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getCentersComparisonReport({
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int? fromCenterLevel,
    int? toCenterLevel,
    int? fromMonth,
    int? toMonth,
    int? comparisonMonth,
    int centerType = 2,
    int? balance,
    int? periodically,
    int reportPageType = 4,
    String reportName = 'AGL092',
    bool includeMonthFilters = false,
    bool includeComparisonMonth = false,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = CentersComparisonReportRequestModel(
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          fromCenterLevel: fromCenterLevel,
          toCenterLevel: toCenterLevel,
          fromMonth: fromMonth,
          toMonth: toMonth,
          comparisonMonth: comparisonMonth,
          centerType: centerType,
          balance: balance,
          periodically: periodically,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
          includeMonthFilters: includeMonthFilters,
          includeComparisonMonth: includeComparisonMonth,
        );

        return _downloadReport(
          endpoint: EndPoints.centersComparisonReport,
          body: requestModel.toJson(),
          fileNamePrefix: reportName.toLowerCase(),
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getAccountsCentersComparisonReport({
    num? fromAccountNo,
    num? toAccountNo,
    num? fromCostCenterNo,
    num? toCostCenterNo,
    int? fromMonth,
    int? toMonth,
    int balance = 0,
    int periodically = 0,
    int reportGroup = 0,
    int reportPageType = 1,
    required String reportName,
    bool includeBalanceAndPeriodically = true,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = AccountsCentersComparisonReportRequestModel(
          fromAccountNo: fromAccountNo,
          toAccountNo: toAccountNo,
          fromCostCenterNo: fromCostCenterNo,
          toCostCenterNo: toCostCenterNo,
          fromMonth: fromMonth,
          toMonth: toMonth,
          balance: balance,
          periodically: periodically,
          reportGroup: reportGroup,
          reportPageType: reportPageType,
          reportName: reportName,
          exportType: exportType,
          includeBalanceAndPeriodically: includeBalanceAndPeriodically,
        );

        return _downloadReport(
          endpoint: EndPoints.accountsCentersComparisonReport,
          body: requestModel.toJson(),
          fileNamePrefix: reportName.toLowerCase(),
          exportType: requestModel.exportType,
          headers: {'Accept-Language': languageCode == 'ar' ? 'ar' : 'en'},
        );
      },
    );
  }

  Future<File> _downloadReport({
    required String endpoint,
    required Map<String, dynamic> body,
    required String fileNamePrefix,
    required String exportType,
    Map<String, String>? headers,
  }) async {
    final isPdf = exportType.toLowerCase() == 'pdf';
    final response = await apiConsumer.post(
      endpoint,
      body: body,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'Accept': isPdf ? 'application/pdf' : '*/*', ...?headers},
      ),
    );

    final Uint8List bytes;
    if (response is Uint8List) {
      bytes = response;
    } else if (response is List<int>) {
      bytes = Uint8List.fromList(response);
    } else if (response is List) {
      bytes = Uint8List.fromList(response.cast<int>());
    } else {
      throw const FormatException('Invalid report binary response data.');
    }

    final dir = await getTemporaryDirectory();
    final ext = switch (exportType.toLowerCase()) {
      'pdf' => 'pdf',
      'excel' || 'excelformatted' => 'xlsx',
      'word' => 'docx',
      _ => throw ArgumentError.value(exportType, 'exportType', 'Unsupported'),
    };
    final file = File(
      '${dir.path}/${fileNamePrefix}_${DateTime.now().millisecondsSinceEpoch}.$ext',
    );
    await file.writeAsBytes(bytes);
    return file;
  }
}
