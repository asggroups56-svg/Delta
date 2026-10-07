import 'report_date_formatter.dart';

class PurchasesWithVatReportRequestModel {
  final double? fromCustomerNo;
  final double? toCustomerNo;

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
    this.fromTransDate,
    this.toTransDate,
    this.documentType = 3,
    this.taxTreatment = 1,
    this.taxPeriod = 3,
    this.accountingSystem = 2,
    this.reportName = 'AAR1001',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() {
    return {
      'FromCustomerNo': fromCustomerNo,
      'ToCustomerNo': toCustomerNo,
      'FromTransDate': fromTransDate != null
          ? formatReportDate(fromTransDate!)
          : null,
      'ToTransDate': toTransDate != null
          ? formatReportDate(toTransDate!)
          : null,
      'DocumentType': documentType,
      'TaxTreatment': taxTreatment,
      'TaxPeriod': taxPeriod,
      'AccountingSystem': accountingSystem,
      'ReportName': reportName,
      'ExportType': exportType,
    };
  }
}
