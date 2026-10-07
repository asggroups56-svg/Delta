import 'report_date_formatter.dart';

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
    'FromDate': fromDate == null ? null : formatReportDate(fromDate!),
    'ToDate': toDate == null ? null : formatReportDate(toDate!),
    'reportPageType': reportPageType,
    'FinalAccountType': finalAccountType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
