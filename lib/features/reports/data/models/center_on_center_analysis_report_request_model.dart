import 'report_date_formatter.dart';

class CenterOnCenterAnalysisReportRequestModel {
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;

  const CenterOnCenterAnalysisReportRequestModel({
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromDate,
    this.toDate,
    this.reportName = 'AGL025A',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromCostCenterNo': fromCostCenterNo,
    'ToCostCenterNo': toCostCenterNo,
    'FromDate': fromDate == null ? null : formatReportDateTime(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateTime(toDate!),
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
