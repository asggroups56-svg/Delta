class LedgerReportForMainAccountsRequestModel {
  final int? accountLevel;
  final num? fromAccountNo;
  final num? toAccountNo;
  final int? fromAnalytical;
  final int? toAnalytical;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? fromAnalytical1;
  final int? toAnalytical1;
  final int? fromSubVoucher;
  final int? toSubVoucher;
  final String reportName;
  final String exportType;

  const LedgerReportForMainAccountsRequestModel({
    this.accountLevel,
    this.fromAccountNo,
    this.toAccountNo,
    this.fromAnalytical,
    this.toAnalytical,
    this.fromDate,
    this.toDate,
    this.fromAnalytical1,
    this.toAnalytical1,
    this.fromSubVoucher,
    this.toSubVoucher,
    this.reportName = 'AGL021N',
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
    'AccountLevel': accountLevel,
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'FromANALYTICAL': fromAnalytical,
    'ToANALYTICAL': toAnalytical,
    'FromDate': _formatDate(fromDate),
    'ToDate': _formatDate(toDate),
    'FromANALYTICAL1': fromAnalytical1,
    'ToANALYTICAL1': toAnalytical1,
    'FromSUBVOUCHER': fromSubVoucher,
    'ToSUBVOUCHER': toSubVoucher,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
