import 'report_date_formatter.dart';

class AccountCentersSummaryForMainAccountsReportRequestModel {
  final int accountLevel;
  final num? fromAccountNo;
  final num? toAccountNo;
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;

  const AccountCentersSummaryForMainAccountsReportRequestModel({
    this.accountLevel = 1,
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromDate,
    this.toDate,
    this.reportName = 'AGL0103',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'AccountLevel': accountLevel,
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'FromCostCenterNo': fromCostCenterNo,
    'ToCostCenterNo': toCostCenterNo,
    'FromDate': fromDate == null ? null : formatReportDateTime(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateTime(toDate!),
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
