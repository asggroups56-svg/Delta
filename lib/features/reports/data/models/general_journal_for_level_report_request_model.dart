import 'report_date_formatter.dart';

class GeneralJournalForLevelReportRequestModel {
  final int? accountLevel;
  final int? fromEntrySerial;
  final int? toEntrySerial;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;

  const GeneralJournalForLevelReportRequestModel({
    this.accountLevel,
    this.fromEntrySerial,
    this.toEntrySerial,
    this.fromDate,
    this.toDate,
    this.reportName = 'AGL0104',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'AccountLevel': accountLevel,
    'FromEntrySerial': fromEntrySerial,
    'ToEntrySerial': toEntrySerial,
    'FromDate': fromDate == null ? null : formatReportDateTime(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateTime(toDate!),
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
