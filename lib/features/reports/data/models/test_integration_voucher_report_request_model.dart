import 'report_date_formatter.dart';

class TestIntegrationVoucherReportRequestModel {
  final num? fromEntrySerial;
  final num? toEntrySerial;
  final int? entryType;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;

  const TestIntegrationVoucherReportRequestModel({
    this.fromEntrySerial,
    this.toEntrySerial,
    this.entryType,
    this.fromDate,
    this.toDate,
    this.reportName = 'AGL063',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    if (entryType != null) 'EntryType': entryType,
    'FromEntrySerial': fromEntrySerial,
    'ToEntrySerial': toEntrySerial,
    'FromDate': fromDate == null ? null : formatReportDateOnly(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateOnly(toDate!),
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
