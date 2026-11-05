class FinancialStatementReportRequestModel {
  final int reportType;
  final int financialStatementReportType;
  final int? toMonth;
  final num? costCenterNo;
  final String reportName;
  final String exportType;

  const FinancialStatementReportRequestModel({
    this.reportType = 1,
    required this.financialStatementReportType,
    this.toMonth,
    this.costCenterNo,
    required this.reportName,
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'ToMonth': toMonth,
    'CostCenterNo': costCenterNo,
    'ReportType': reportType,
    'FinancialStatementReportType': financialStatementReportType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
