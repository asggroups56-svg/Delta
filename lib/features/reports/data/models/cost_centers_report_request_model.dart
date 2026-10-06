class CostCentersReportRequestModel {
  final int costCenterType;
  final String reportName;
  final String exportType;

  const CostCentersReportRequestModel({
    required this.costCenterType,
    this.reportName = 'AGL007',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'CostCenterType': costCenterType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
