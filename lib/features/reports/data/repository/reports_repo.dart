import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/account_statement_report_request_model.dart';
import '../models/accounts_comparison_report_request_model.dart';
import '../models/account_centers_summary_for_main_accounts_report_request_model.dart';
import '../models/accounts_centers_comparison_report_request_model.dart';
import '../models/chart_of_account_report_request_model.dart';
import '../models/chart_of_account_monthly_balances_report_request_model.dart';
import '../models/centers_comparison_report_request_model.dart';
import '../models/centers_monthly_balance_report_request_model.dart';
import '../models/cost_centers_projects_report_request_model.dart';
import '../models/cost_centers_report_request_model.dart';
import '../models/cost_centers_transaction_report_request_model.dart';
import '../models/cost_centers_transaction_annual_report_request_model.dart';
import '../models/daily_income_and_expense_situation_report_request_model.dart';
import '../models/expenses_with_vat_report_request_model.dart';
import '../models/financial_statement_report_request_model.dart';
import '../models/income_and_expense_situation_report_request_model.dart';
import '../models/ledger_report_request_model.dart';
import '../models/monthly_account_comparison_report_request_model.dart';
import '../models/monthly_cost_centers_comparison_report_request_model.dart';
import '../models/purchases_with_vat_report_request_model.dart';
import '../models/sales_with_vat_report_request_model.dart';
import '../models/trial_balance_by_categories_report_request_model.dart';

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
    int? fromMonth,
    int? toMonth,
    int? comparisonMonth,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getDailyIncomeAndExpenseSituationReport({
    DateTime? fromDate,
    DateTime? toDate,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getExpensesWithVatReport({
    DateTime? fromVoucherDate,
    DateTime? toVoucherDate,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getSalesWithVatReport({
    double? fromCustomerNo,
    double? toCustomerNo,
    DateTime? fromTransDate,
    DateTime? toTransDate,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getPurchasesWithVatReport({
    double? fromCustomerNo,
    double? toCustomerNo,
    DateTime? fromTransDate,
    DateTime? toTransDate,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getLedgerReportForAllAccounts({
    DateTime? fromDate,
    DateTime? toDate,
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

  Future<Either<Failure, File>> getFinancialStatementsReport({
    required int financialStatementReportType,
    required String reportName,
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
    int? fromMonth,
    int? toMonth,
    int? comparisonMonth,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = IncomeAndExpenseSituationReportRequestModel(
          fromMonth: fromMonth,
          toMonth: toMonth,
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
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = DailyIncomeAndExpenseSituationReportRequestModel(
          fromDate: fromDate,
          toDate: toDate,
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
  Future<Either<Failure, File>> getExpensesWithVatReport({
    DateTime? fromVoucherDate,
    DateTime? toVoucherDate,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = ExpensesWithVatReportRequestModel(
          fromVoucherDate: fromVoucherDate,
          toVoucherDate: toVoucherDate,
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
    DateTime? fromTransDate,
    DateTime? toTransDate,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = SalesWithVatReportRequestModel(
          fromCustomerNo: fromCustomerNo,
          toCustomerNo: toCustomerNo,
          fromTransDate: fromTransDate,
          toTransDate: toTransDate,
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
    DateTime? fromTransDate,
    DateTime? toTransDate,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = PurchasesWithVatReportRequestModel(
          fromCustomerNo: fromCustomerNo,
          toCustomerNo: toCustomerNo,
          fromTransDate: fromTransDate,
          toTransDate: toTransDate,
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
  Future<Either<Failure, File>> getLedgerReportForAllAccounts({
    DateTime? fromDate,
    DateTime? toDate,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = LedgerReportRequestModel(
          fromDate: fromDate,
          toDate: toDate,
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
  Future<Either<Failure, File>> getFinancialStatementsReport({
    required int financialStatementReportType,
    required String reportName,
    required String languageCode,
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = FinancialStatementReportRequestModel(
          financialStatementReportType: financialStatementReportType,
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
