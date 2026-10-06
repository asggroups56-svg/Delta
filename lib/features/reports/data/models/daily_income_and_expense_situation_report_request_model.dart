class DailyIncomeAndExpenseSituationReportRequestModel {
  final DateTime? fromDate;
  final DateTime? toDate;
  final int reportPageType;
  final int finalAccountType;
  final String reportName;
  final String exportType;

  const DailyIncomeAndExpenseSituationReportRequestModel({
    this.fromDate,
    this.toDate,
    this.reportPageType = 1,
    this.finalAccountType = 3,
    this.reportName = 'AGL300_D',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromDate': _formatDate(fromDate),
    'ToDate': _formatDate(toDate),
    'reportPageType': reportPageType,
    'FinalAccountType': finalAccountType,
    'ReportName': reportName,
    'ExportType': exportType,
  };

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-${day}T00:00:00';
  }
}
