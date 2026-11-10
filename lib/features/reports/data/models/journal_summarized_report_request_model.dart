import 'report_date_formatter.dart';

class JournalSummarizedReportRequestModel {
  final int entryType;
  final int? fromEntrySerial, toEntrySerial;
  final DateTime? fromDate, toDate;
  final String reportName, exportType;
  const JournalSummarizedReportRequestModel({this.entryType = 5, this.fromEntrySerial, this.toEntrySerial, this.fromDate, this.toDate, this.reportName = 'AGL900', this.exportType = 'pdf'});
  Map<String, dynamic> toJson() => {
    'EntryType': entryType, 'FromEntrySerial': fromEntrySerial,
    'ToEntrySerial': toEntrySerial,
    'FromDate': fromDate == null ? null : formatReportDateTime(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateTime(toDate!),
    'ReportName': reportName, 'ExportType': exportType,
  };
}
