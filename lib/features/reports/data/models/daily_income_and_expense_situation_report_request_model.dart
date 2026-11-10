import 'report_date_formatter.dart';

class DailyIncomeAndExpenseSituationReportRequestModel {
  final int? accountLevel;
  final bool doNotDisplayAccountsWithZeroBalances;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int reportPageType;
  final int finalAccountType;
  final String reportName;
  final String exportType;

  const DailyIncomeAndExpenseSituationReportRequestModel({
    this.accountLevel = 10,
    this.doNotDisplayAccountsWithZeroBalances = false,
    this.fromDate,
    this.toDate,
    this.reportPageType = 1,
    this.finalAccountType = 3,
    this.reportName = 'AGL300_D',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'AccountLevel': accountLevel,
    'DoNotDisplayAccountsWithZeroBalances':
        doNotDisplayAccountsWithZeroBalances,
    'FromDate': fromDate == null ? null : formatReportDate(fromDate!),
    'ToDate': toDate == null ? null : formatReportDate(toDate!),
    'reportPageType': reportPageType,
    'FinalAccountType': finalAccountType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
