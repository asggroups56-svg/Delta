import 'report_date_formatter.dart';

class JournalReportRequestModel {
  final int? fromEntrySerial;
  final int? toEntrySerial;
  final String? fromEntryNo;
  final String? toEntryNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int journalType;
  final int journalReportType;
  final int reportPageType;
  final String reportName;
  final String exportType;

  const JournalReportRequestModel({
    this.fromEntrySerial,
    this.toEntrySerial,
    this.fromEntryNo,
    this.toEntryNo,
    this.fromDate,
    this.toDate,
    this.journalType = 0,
    this.journalReportType = 5,
    this.reportPageType = 1,
    this.reportName = 'AGL009',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromENTRY_SERIAL': fromEntrySerial,
    'ToENTRY_SERIAL': toEntrySerial,
    'FromENTRY_NO': fromEntryNo,
    'ToENTRY_NO': toEntryNo,
    'FromDate': fromDate == null ? null : formatReportDateTime(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateTime(toDate!),
    'JournalType': journalType,
    'JournalReportType': journalReportType,
    'reportPageType': reportPageType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
