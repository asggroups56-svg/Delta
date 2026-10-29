class MonthlyAccountComparisonReportRequestModel {
  final num? fromAccountNo;
  final num? toAccountNo;
  final int accountType;
  final String reportName;
  final String exportType;

  const MonthlyAccountComparisonReportRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.accountType = 3,
    this.reportName = 'AGL003_Bar',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'AccountType': accountType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
