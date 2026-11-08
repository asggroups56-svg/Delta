import 'report_date_formatter.dart';

class WithdrawAndDepositingVoucherReportRequestModel {
  final int? fromBankCode;
  final int? toBankCode;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;

  const WithdrawAndDepositingVoucherReportRequestModel({
    this.fromBankCode,
    this.toBankCode,
    this.fromDate,
    this.toDate,
    this.reportName = 'AGL065',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromBANK_CODE': fromBankCode,
    'ToBANK_CODE': toBankCode,
    'FromDate': fromDate == null ? null : formatReportDateTime(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateTime(toDate!),
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
