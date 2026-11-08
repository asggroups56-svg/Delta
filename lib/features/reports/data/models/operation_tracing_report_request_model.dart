import 'report_date_formatter.dart';

class OperationTracingReportRequestModel {
  final int? fromEntrySerial;
  final int? toEntrySerial;
  final String? fromEntryNo;
  final String? toEntryNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String exportType;

  const OperationTracingReportRequestModel({this.fromEntrySerial, this.toEntrySerial, this.fromEntryNo, this.toEntryNo, this.fromDate, this.toDate, this.exportType = 'pdf'});

  Map<String, dynamic> toJson() => {
    'FromEntrySerial': fromEntrySerial,
    'ToEntrySerial': toEntrySerial,
    'FromEntryNo': fromEntryNo,
    'ToEntryNo': toEntryNo,
    'FromDate': fromDate == null
        ? null
        : '${formatReportDateOnly(fromDate!)}T00:00:00',
    'ToDate': toDate == null ? null : '${formatReportDateOnly(toDate!)}T00:00:00',
    'ReportName': 'AGL038T',
    'ExportType': exportType,
  };
}
