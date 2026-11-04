class GeneralLedgerReportRequestModel {
  final int? fromAccountNo;
  final int? toAccountNo;
  final String? fromCurrencyCode;
  final String? toCurrencyCode;
  final int? fromAnalytical;
  final int? toAnalytical;
  final int? fromAnalytical1;
  final int? toAnalytical1;
  final int? fromSubVoucher;
  final int? toSubVoucher;
  final int? fromSubDescId;
  final int? toSubDescId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool? accountsWithZeroBalances;
  final int reportPageType;
  final String reportName;
  final String exportType;

  const GeneralLedgerReportRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCurrencyCode,
    this.toCurrencyCode,
    this.fromAnalytical,
    this.toAnalytical,
    this.fromAnalytical1,
    this.toAnalytical1,
    this.fromSubVoucher,
    this.toSubVoucher,
    this.fromSubDescId,
    this.toSubDescId,
    this.fromDate,
    this.toDate,
    this.accountsWithZeroBalances,
    this.reportPageType = 1,
    this.reportName = 'AGL100',
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
    'FromCurrencyCode': fromCurrencyCode,
    'ToCurrencyCode': toCurrencyCode,
    'FromANALYTICAL': fromAnalytical,
    'ToANALYTICAL': toAnalytical,
    'FromANALYTICAL1': fromAnalytical1,
    'ToANALYTICAL1': toAnalytical1,
    'FromSUBVOUCHER': fromSubVoucher,
    'ToSUBVOUCHER': toSubVoucher,
    'FromSUBDESCID': fromSubDescId,
    'ToSUBDESCID': toSubDescId,
    'FromDate': _formatDate(fromDate),
    'ToDate': _formatDate(toDate),
    'AccountsWithZeroBalances': accountsWithZeroBalances,
    'reportPageType': reportPageType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
