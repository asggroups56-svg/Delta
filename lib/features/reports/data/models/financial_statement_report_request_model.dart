class FinancialStatementReportRequestModel {
  final int reportType;
  final int financialStatementReportType;
  final String reportName;
  final String exportType;

  const FinancialStatementReportRequestModel({
    this.reportType = 1,
    required this.financialStatementReportType,
    required this.reportName,
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'ReportType': reportType,
    'FinancialStatementReportType': financialStatementReportType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
