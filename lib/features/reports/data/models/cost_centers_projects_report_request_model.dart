import 'report_date_formatter.dart';

class CostCentersProjectsReportRequestModel {
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;

  const CostCentersProjectsReportRequestModel({
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromDate,
    this.toDate,
    required this.reportName,
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() {
    return {
      'FromCostCenterNo': fromCostCenterNo,
      'ToCostCenterNo': toCostCenterNo,
      'FromDate': fromDate != null ? formatReportDate(fromDate!) : null,
      'ToDate': toDate != null ? formatReportDate(toDate!) : null,
      'ReportName': reportName,
      'ExportType': exportType,
    };
  }
}
