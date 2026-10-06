class LedgerReportRequestModel {
  final DateTime fromDate;
  final DateTime toDate;
  final String reportName;
  final String exportType;
  final int? fromAccountNo;
  final int? toAccountNo;

  const LedgerReportRequestModel({
    required this.fromDate,
    required this.toDate,
    this.reportName = 'AGL025',
    this.exportType = 'pdf',
    this.fromAccountNo,
    this.toAccountNo,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'FromDate': _formatDate(fromDate),
      'ToDate': _formatDate(toDate),
      'ReportName': reportName,
      'ExportType': exportType,
    };
    if (fromAccountNo != null) map['FromAccountNo'] = fromAccountNo;
    if (toAccountNo != null) map['ToAccountNo'] = toAccountNo;
    return map;
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-${day}T00:00:00';
  }
}
