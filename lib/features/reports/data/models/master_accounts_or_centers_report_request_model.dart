import 'report_date_formatter.dart';

class MasterAccountsOrCentersReportRequestModel {
  final int? fromCategoryNo;
  final int? toCategoryNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int masterReportType;
  final int reportPageType;
  final String reportName;
  final String exportType;

  const MasterAccountsOrCentersReportRequestModel({
    this.fromCategoryNo,
    this.toCategoryNo,
    this.fromDate,
    this.toDate,
    this.masterReportType = 1,
    this.reportPageType = 1,
    this.reportName = 'AGL077A',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromCAT_NO': fromCategoryNo,
    'ToCAT_NO': toCategoryNo,
    'FromDate': fromDate == null ? null : formatReportDateTime(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateTime(toDate!),
    'MasterReportType': masterReportType,
    'reportPageType': reportPageType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
