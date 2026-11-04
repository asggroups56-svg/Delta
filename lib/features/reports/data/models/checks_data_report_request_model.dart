import 'report_date_formatter.dart';

class ChecksDataReportRequestModel {
  final String? fromChqNo;
  final String? toChqNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? fromBankCode;
  final int? toBankCode;
  final int? fromCashAccount;
  final int? toCashAccount;
  final String reportName;
  final String exportType;

  const ChecksDataReportRequestModel({
    this.fromChqNo,
    this.toChqNo,
    this.fromDate,
    this.toDate,
    this.fromBankCode,
    this.toBankCode,
    this.fromCashAccount,
    this.toCashAccount,
    this.reportName = 'AGL019_1',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromCHQNO': fromChqNo,
    'ToCHQNO': toChqNo,
    'FromDate': fromDate == null ? null : formatReportDateTime(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateTime(toDate!),
    'FromBANK_CODE': fromBankCode,
    'ToBANK_CODE': toBankCode,
    'FromCASH_ACC': fromCashAccount,
    'ToCASH_ACC': toCashAccount,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
