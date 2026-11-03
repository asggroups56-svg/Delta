import 'report_date_formatter.dart';

class CashInCashOutVoucherReportRequestModel {
  final int receiptType;
  final String? fromVoucherNo;
  final String? toVoucherNo;
  final int? fromBankCode;
  final int? toBankCode;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;

  const CashInCashOutVoucherReportRequestModel({
    this.receiptType = 1,
    this.fromVoucherNo,
    this.toVoucherNo,
    this.fromBankCode,
    this.toBankCode,
    this.fromDate,
    this.toDate,
    this.reportName = 'AGL019',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'receiptType': receiptType,
    'FromVOUCHER_NO': fromVoucherNo,
    'ToVOUCHER_NO': toVoucherNo,
    'FromBANK_CODE': fromBankCode,
    'ToBANK_CODE': toBankCode,
    'FromDate': fromDate == null ? null : formatReportDateTime(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateTime(toDate!),
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
