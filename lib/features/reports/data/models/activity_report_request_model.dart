import 'report_date_formatter.dart';

class ActivityReportRequestModel {
  final int? fromCenterNoOne;
  final int? toCenterNoOne;
  final int? fromAccountNo;
  final int? toAccountNo;
  final int? fromCenterNoZero;
  final int? toCenterNoZero;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;

  const ActivityReportRequestModel({
    this.fromCenterNoOne,
    this.toCenterNoOne,
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCenterNoZero,
    this.toCenterNoZero,
    this.fromDate,
    this.toDate,
    this.reportName = 'AGL111',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromCenterNoOne': fromCenterNoOne,
    'ToCenterNoOne': toCenterNoOne,
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'FromCenterNoZero': fromCenterNoZero,
    'ToCenterNoZero': toCenterNoZero,
    'FromDate': fromDate == null ? null : formatReportDateTime(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateTime(toDate!),
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
