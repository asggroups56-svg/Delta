import 'report_date_formatter.dart';

class IntegratedVouchersStatusReportRequestModel {
  final DateTime? fromDate;
  final DateTime? toDate;
  final int integratedVouchersStatusType;
  final int programType;
  final String reportName;
  final String exportType;

  const IntegratedVouchersStatusReportRequestModel({
    this.fromDate,
    this.toDate,
    this.integratedVouchersStatusType = 3,
    this.programType = 6,
    this.reportName = 'AGL111T',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromDate': fromDate == null ? null : formatReportDateOnly(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateOnly(toDate!),
    'IntegratedVouchersStatusType': integratedVouchersStatusType,
    'ProgramType': programType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
