class LedgerReportPerUsersRequestModel {
  final num? fromAccountNo;
  final num? toAccountNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;

  const LedgerReportPerUsersRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromDate,
    this.toDate,
    this.reportName = 'AGL021',
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
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'FromDate': _formatDate(fromDate),
    'ToDate': _formatDate(toDate),
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
