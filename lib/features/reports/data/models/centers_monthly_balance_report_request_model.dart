class CentersMonthlyBalanceReportRequestModel {
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final int? fromCenterLevel;
  final int? toCenterLevel;
  final int costCenterType;
  final String reportName;
  final String exportType;

  const CentersMonthlyBalanceReportRequestModel({
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromCenterLevel,
    this.toCenterLevel,
    this.costCenterType = 2,
    this.reportName = 'AGL008A',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromCostCenterNo': fromCostCenterNo,
    'ToCostCenterNo': toCostCenterNo,
    'FromCenterLevel': fromCenterLevel,
    'ToCenterLevel': toCenterLevel,
    'CostCenterType': costCenterType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
