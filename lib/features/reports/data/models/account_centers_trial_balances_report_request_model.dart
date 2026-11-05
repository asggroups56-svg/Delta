class AccountCentersTrialBalancesReportRequestModel {
  final int accountLevel;
  final num? fromAccountNo;
  final num? toAccountNo;
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;

  const AccountCentersTrialBalancesReportRequestModel({
    required this.accountLevel,
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromDate,
    this.toDate,
    this.reportName = 'AGL026C',
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
    'FromCostCenterNo': fromCostCenterNo,
    'ToCostCenterNo': toCostCenterNo,
    'FromDate': _formatDate(fromDate),
    'ToDate': _formatDate(toDate),
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
