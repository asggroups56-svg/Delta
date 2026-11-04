class LedgerReportForAssistantAccountsRequestModel {
  final num? fromAccountNo;
  final num? toAccountNo;
  final int? centerLevel;
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final int? fromAccAnal;
  final int? toAccAnal;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? fromCentAnal;
  final int? toCentAnal;
  final int? fromAnalytical;
  final int? toAnalytical;
  final int sideType;
  final String reportName;
  final String exportType;

  const LedgerReportForAssistantAccountsRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.centerLevel,
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromAccAnal,
    this.toAccAnal,
    this.fromDate,
    this.toDate,
    this.fromCentAnal,
    this.toCentAnal,
    this.fromAnalytical,
    this.toAnalytical,
    this.sideType = 2,
    this.reportName = 'AGL094',
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
    'CenterLevel': centerLevel,
    'FromCostCenterNo': fromCostCenterNo,
    'ToCostCenterNo': toCostCenterNo,
    'FromACCANAL': fromAccAnal,
    'ToACCANAL': toAccAnal,
    'FromDate': _formatDate(fromDate),
    'ToDate': _formatDate(toDate),
    'FromCENTANAL': fromCentAnal,
    'ToCENTANAL': toCentAnal,
    'FromANALYTICAL': fromAnalytical,
    'ToANALYTICAL': toAnalytical,
    'SideType': sideType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
