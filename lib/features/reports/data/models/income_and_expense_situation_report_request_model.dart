class IncomeAndExpenseSituationReportRequestModel {
  final int? fromMonth;
  final int? toMonth;
  final String reportName;
  final String exportType;

  const IncomeAndExpenseSituationReportRequestModel({
    this.fromMonth,
    this.toMonth,
    this.reportName = 'AGL300_M',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() {
    return {
      'FromMonth': fromMonth,
      'ToMonth': toMonth,
      'ReportName': reportName,
      'ExportType': exportType,
    };
  }
}
