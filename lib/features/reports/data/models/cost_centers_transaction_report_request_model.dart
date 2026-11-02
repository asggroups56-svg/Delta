import 'report_date_formatter.dart';

class CostCentersTransactionReportRequestModel {
  final num? fromAccountNo;
  final num? toAccountNo;
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool prepareCostCentersTree;
  final String reportName;
  final String exportType;

  const CostCentersTransactionReportRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromDate,
    this.toDate,
    this.prepareCostCentersTree = false,
    this.reportName = 'AGL028',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'FromCostCenterNo': fromCostCenterNo,
    'ToCostCenterNo': toCostCenterNo,
    'FromDate': fromDate == null ? null : formatReportDateTime(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateTime(toDate!),
    'PrepareCostCentersTree': prepareCostCentersTree,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
