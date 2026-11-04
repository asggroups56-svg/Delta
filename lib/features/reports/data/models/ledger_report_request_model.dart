class LedgerReportRequestModel {
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;
  final int? fromAccountNo;
  final int? toAccountNo;
  final int? searchGroup;
  final bool accountsWithZeroBalances;

  const LedgerReportRequestModel({
    this.fromDate,
    this.toDate,
    this.reportName = 'AGL021C',
    this.exportType = 'pdf',
    this.fromAccountNo,
    this.toAccountNo,
    this.searchGroup,
    this.accountsWithZeroBalances = false,
  });

  Map<String, dynamic> toJson() {
    String? formatDate(DateTime? date) {
      if (date == null) return null;
      final year = date.year.toString().padLeft(4, '0');
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '$year-$month-$day';
    }

    return {
      'FromAccountNo': fromAccountNo,
      'ToAccountNo': toAccountNo,
      'SearchGroup': searchGroup,
      'FromDate': formatDate(fromDate),
      'ToDate': formatDate(toDate),
      'AccountsWithZeroBalances': accountsWithZeroBalances,
      'ReportName': reportName,
      'ExportType': exportType,
    };
  }
}
