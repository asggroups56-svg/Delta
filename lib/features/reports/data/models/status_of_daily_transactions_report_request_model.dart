import 'report_date_formatter.dart';

class StatusOfDailyTransactionsReportRequestModel {
  final DateTime? fromDate;
  final DateTime? toDate;
  final int transactionType;
  final String reportName;
  final String exportType;

  const StatusOfDailyTransactionsReportRequestModel({
    this.fromDate,
    this.toDate,
    this.transactionType = 12,
    this.reportName = 'AGL2000',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromDate': fromDate == null ? null : formatReportDateTime(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateTime(toDate!),
    'TransactionType': transactionType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
