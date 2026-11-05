class TrialBalancesReportForPeriodRequestModel {
  final int? fromAccountNo;
  final int? toAccountNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool doNotDisplayAccountsWithZeroBalances;
  final bool prepareTree;
  final String reportName;
  final String exportType;

  const TrialBalancesReportForPeriodRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromDate,
    this.toDate,
    this.doNotDisplayAccountsWithZeroBalances = false,
    this.prepareTree = false,
    this.reportName = 'AGL078',
    this.exportType = 'pdf',
  });

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Map<String, dynamic> toJson() => {
    'AccountLevel': null,
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'FromDate': _formatDate(fromDate),
    'ToDate': _formatDate(toDate),
    'DoNotDisplayAccountsWithZeroBalances':
        doNotDisplayAccountsWithZeroBalances,
    'PrepareTree': prepareTree,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
