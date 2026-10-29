class MonthlyCostCentersComparisonReportRequestModel {
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final int accountType;
  final String reportName;
  final String exportType;

  const MonthlyCostCentersComparisonReportRequestModel({
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.accountType = 3,
    this.reportName = 'AGL008_Chart',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromCostCenterNo': fromCostCenterNo,
    'ToCostCenterNo': toCostCenterNo,
    'AccountType': accountType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
