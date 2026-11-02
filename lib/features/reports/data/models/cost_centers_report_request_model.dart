import 'report_date_formatter.dart';

class CostCentersReportRequestModel {
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final int? fromCenterLevel;
  final int? toCenterLevel;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int costCenterType;
  final String reportName;
  final String exportType;

  const CostCentersReportRequestModel({
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromCenterLevel,
    this.toCenterLevel,
    this.fromDate,
    this.toDate,
    required this.costCenterType,
    this.reportName = 'AGL008',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromCostCenterNo': fromCostCenterNo,
    'ToCostCenterNo': toCostCenterNo,
    'FromCenterLevel': fromCenterLevel,
    'ToCenterLevel': toCenterLevel,
    'FromDate': fromDate == null ? null : formatReportDateTime(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateTime(toDate!),
    'CostCenterType': costCenterType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
