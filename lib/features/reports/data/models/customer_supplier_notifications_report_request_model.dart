import 'report_date_formatter.dart';

class CustomerSupplierNotificationsReportRequestModel {
  final int dealingType;
  final double? fromCustomerNo;
  final double? toCustomerNo;
  final String? fromVoucherNo;
  final String? toVoucherNo;
  final int? fromTransNo;
  final int? toTransNo;
  final DateTime? fromTransDate;
  final DateTime? toTransDate;
  final int? fromAnalysisNo;
  final int? toAnalysisNo;
  final int typeTransacition;
  final int accountingSystemType;
  final int impactType;
  final int paymentType;
  final String reportName;
  final String exportType;

  const CustomerSupplierNotificationsReportRequestModel({
    this.dealingType = 1,
    this.fromCustomerNo,
    this.toCustomerNo,
    this.fromVoucherNo,
    this.toVoucherNo,
    this.fromTransNo,
    this.toTransNo,
    this.fromTransDate,
    this.toTransDate,
    this.fromAnalysisNo,
    this.toAnalysisNo,
    this.typeTransacition = 7,
    this.accountingSystemType = 1,
    this.impactType = 3,
    this.paymentType = 3,
    this.reportName = 'AAR020V',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'DealingType': dealingType,
    'FromCustomerNo': fromCustomerNo,
    'ToCustomerNo': toCustomerNo,
    'FromVoucherNo': fromVoucherNo,
    'ToVoucherNo': toVoucherNo,
    'FromTRANSNO': fromTransNo,
    'ToTRANSNO': toTransNo,
    'FromTransDate': fromTransDate == null
        ? null
        : formatReportDateOnly(fromTransDate!),
    'ToTransDate': toTransDate == null
        ? null
        : formatReportDateOnly(toTransDate!),
    'FromAnalisyisNo': fromAnalysisNo,
    'ToAnalisyisNo': toAnalysisNo,
    'TypeTransacition': typeTransacition,
    'AccountingSystemType': accountingSystemType,
    'ImpactType': impactType,
    'PaymentType': paymentType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
