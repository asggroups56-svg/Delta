class TrialBalanceByCategoriesReportRequestModel {
  final String reportName;
  final String exportType;

  const TrialBalanceByCategoriesReportRequestModel({
    this.reportName = 'AGL055',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
