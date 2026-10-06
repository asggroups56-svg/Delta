import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/account_statement_report_request_model.dart';
import '../models/chart_of_account_report_request_model.dart';
import '../models/cost_centers_report_request_model.dart';
import '../models/daily_income_and_expense_situation_report_request_model.dart';
import '../models/expenses_with_vat_report_request_model.dart';
import '../models/income_and_expense_situation_report_request_model.dart';
import '../models/ledger_report_request_model.dart';
import '../models/purchases_with_vat_report_request_model.dart';
import '../models/sales_with_vat_report_request_model.dart';
import '../models/trial_balance_by_categories_report_request_model.dart';

abstract interface class ReportsRepo {
  Future<Either<Failure, File>> getChartOfAccountReport({
    String reportName = 'AGL001',
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getIncomeAndExpenseSituationReport({
    int? fromMonth,
    int? toMonth,
  });

  Future<Either<Failure, File>> getDailyIncomeAndExpenseSituationReport({
    required DateTime fromDate,
    required DateTime toDate,
    required String languageCode,
  });

  Future<Either<Failure, File>> getExpensesWithVatReport({
    DateTime? fromVoucherDate,
    DateTime? toVoucherDate,
    required String languageCode,
  });

  Future<Either<Failure, File>> getSalesWithVatReport({
    double? fromCustomerNo,
    double? toCustomerNo,
    DateTime? fromTransDate,
    DateTime? toTransDate,
    required String languageCode,
  });

  Future<Either<Failure, File>> getPurchasesWithVatReport({
    double? fromCustomerNo,
    double? toCustomerNo,
    DateTime? fromTransDate,
    DateTime? toTransDate,
    required String languageCode,
  });

  Future<Either<Failure, File>> getLedgerReportForAllAccounts({
    required DateTime fromDate,
    required DateTime toDate,
    required String languageCode,
  });

  Future<Either<Failure, File>> getAccountStatementReport({
    int? subVoucherAccountNo,
    DateTime? subVoucherOraDate,
    required String languageCode,
    String exportType = 'pdf',
  });

  Future<Either<Failure, File>> getTrialBalanceByCategoriesReport({
    required String languageCode,
  });

  Future<Either<Failure, File>> getCostCentersReport({
    required int costCenterType,
    required String languageCode,
  });
}

class ReportsRepoImpl implements ReportsRepo {
  final ApiConsumer apiConsumer;

  ReportsRepoImpl(this.apiConsumer);

  @override
  Future<Either<Failure, File>> getChartOfAccountReport({
    String reportName = 'AGL001',
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = ChartOfAccountReportRequestModel(
          reportName: reportName,
          exportType: exportType,
        );

        return _downloadReport(
          endpoint: EndPoints.chartOfAccountReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'chart_of_account',
          exportType: exportType,
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getIncomeAndExpenseSituationReport({
    int? fromMonth,
    int? toMonth,
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = IncomeAndExpenseSituationReportRequestModel(
          fromMonth: fromMonth,
          toMonth: toMonth,
        );

        return _downloadReport(
          endpoint: EndPoints.incomeAndExpenseSituationReport,
          body: requestModel.toJson(),
          fileNamePrefix: 'income_and_expense_situation_report',
          exportType: requestModel.exportType,
        );
      },
    );
  }

  @override
  Future<Either<Failure, File>> getDailyIncomeAndExpenseSituationReport({
    required DateTime fromDate,
    required DateTime toDate,
    required String languageCode,
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = DailyIncomeAndExpenseSituationReportRequestModel(
          fromDate: fromDate,
          toDate: toDate,
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
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = ExpensesWithVatReportRequestModel(
          fromVoucherDate: fromVoucherDate,
          toVoucherDate: toVoucherDate,
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
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = SalesWithVatReportRequestModel(
          fromCustomerNo: fromCustomerNo,
          toCustomerNo: toCustomerNo,
          fromTransDate: fromTransDate,
          toTransDate: toTransDate,
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
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = PurchasesWithVatReportRequestModel(
          fromCustomerNo: fromCustomerNo,
          toCustomerNo: toCustomerNo,
          fromTransDate: fromTransDate,
          toTransDate: toTransDate,
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
    required DateTime fromDate,
    required DateTime toDate,
    required String languageCode,
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = LedgerReportRequestModel(
          fromDate: fromDate,
          toDate: toDate,
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
    required String languageCode,
  }) {
    return handleDioRequest(
      request: () async {
        const requestModel = TrialBalanceByCategoriesReportRequestModel();
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
  Future<Either<Failure, File>> getCostCentersReport({
    required int costCenterType,
    required String languageCode,
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = CostCentersReportRequestModel(
          costCenterType: costCenterType,
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
    final ext = isPdf ? 'pdf' : exportType.toLowerCase();
    final file = File(
      '${dir.path}/${fileNamePrefix}_${DateTime.now().millisecondsSinceEpoch}.$ext',
    );
    await file.writeAsBytes(bytes);
    return file;
  }
}
