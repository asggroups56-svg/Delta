class ChartOfAccountMonthlyBalancesReportRequestModel {
  final num? fromAccountNo;
  final num? toAccountNo;
  final int? fromAccountLevel;
  final int? toAccountLevel;
  final int accountType;
  final int finalAccount;
  final int reportPageType;
  final String reportName;
  final String exportType;

  const ChartOfAccountMonthlyBalancesReportRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromAccountLevel,
    this.toAccountLevel,
    this.accountType = 0,
    this.finalAccount = 4,
    this.reportPageType = 2,
    this.reportName = 'AGL015A',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'FromAccountLevel': fromAccountLevel,
    'ToAccountLevel': toAccountLevel,
    'AccountType': accountType,
    'FinalAccount': finalAccount,
    'reportPageType': reportPageType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
