import 'report_date_formatter.dart';

class InvoicesApprovedStatusReportRequestModel {
  final double? fromCustomerNo;
  final double? toCustomerNo;
  final DateTime? fromTransDate;
  final DateTime? toTransDate;
  final int invoiceType;
  final String reportName;
  final String exportType;

  const InvoicesApprovedStatusReportRequestModel({
    this.fromCustomerNo,
    this.toCustomerNo,
    this.fromTransDate,
    this.toTransDate,
    this.invoiceType = 4,
    this.reportName = 'AAR206',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromCustomerNo': fromCustomerNo,
    'ToCustomerNo': toCustomerNo,
    'FromTransDate': fromTransDate == null
        ? null
        : formatReportDateOnly(fromTransDate!),
    'ToTransDate': toTransDate == null
        ? null
        : formatReportDateOnly(toTransDate!),
    'InvoiceType': invoiceType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
