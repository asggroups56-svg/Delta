import 'report_date_formatter.dart';

class PurchasesWithVatReportRequestModel {
  final double? fromCustomerNo;
  final double? toCustomerNo;
  final String? fromItemCode;
  final String? toItemCode;
  final int? fromDocId;
  final int? toDocId;
  final DateTime? fromTransDate;
  final DateTime? toTransDate;
  final int documentType;
  final int taxTreatment;
  final int taxPeriod;
  final int accountingSystem;
  final String reportName;
  final String exportType;

  const PurchasesWithVatReportRequestModel({
    this.fromCustomerNo,
    this.toCustomerNo,
    this.fromItemCode,
    this.toItemCode,
    this.fromDocId,
    this.toDocId,
    this.fromTransDate,
    this.toTransDate,
    this.documentType = 3,
    this.taxTreatment = 1,
    this.taxPeriod = 3,
    this.accountingSystem = 1,
    this.reportName = 'AAR1001',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() {
    return {
      'FromCustomerNo': fromCustomerNo,
      'ToCustomerNo': toCustomerNo,
      'FromItemCode': fromItemCode,
      'ToItemCode': toItemCode,
      'FromDocId': fromDocId,
      'ToDocId': toDocId,
      'FromTransDate': fromTransDate != null
          ? formatReportDateOnly(fromTransDate!)
          : null,
      'ToTransDate': toTransDate != null
          ? formatReportDateOnly(toTransDate!)
          : null,
      'DocumentType': documentType,
      'AccountingSystem': accountingSystem,
      'TaxTreatment': taxTreatment,
      'TaxPeriod': taxPeriod,
      'ReportName': reportName,
      'ExportType': exportType,
    };
  }
}
