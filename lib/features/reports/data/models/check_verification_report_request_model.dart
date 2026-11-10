import 'report_date_formatter.dart';

class CheckVerificationReportRequestModel {
  final int? fromBankCode;
  final int? toBankCode;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? receiveName;
  final int checkStatus;
  final String reportName;
  final String exportType;

  const CheckVerificationReportRequestModel({
    this.fromBankCode,
    this.toBankCode,
    this.fromDate,
    this.toDate,
    this.receiveName,
    this.checkStatus = 2,
    this.reportName = 'Ams003',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromBANK_CODE': fromBankCode,
    'ToBANK_CODE': toBankCode,
    'FromDate': fromDate == null ? null : formatReportDateOnly(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateOnly(toDate!),
    'ReceiveName': receiveName,
    'CheckStatus': checkStatus,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
