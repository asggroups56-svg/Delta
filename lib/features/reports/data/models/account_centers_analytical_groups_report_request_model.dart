import 'report_date_formatter.dart';

class AccountCentersAnalyticalGroupsReportRequestModel {
  final int? levelCenter;
  final num? fromAccountNo, toAccountNo, fromCostCenterNo, toCostCenterNo;
  final DateTime? fromDate, toDate;
  final String reportName, exportType;

  const AccountCentersAnalyticalGroupsReportRequestModel({
    this.levelCenter,
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromDate,
    this.toDate,
    required this.reportName,
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'LevelCenter': levelCenter,
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'FromCostCenterNo': fromCostCenterNo,
    'ToCostCenterNo': toCostCenterNo,
    'FromDate': fromDate == null ? null : formatReportDateOnly(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateOnly(toDate!),
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
