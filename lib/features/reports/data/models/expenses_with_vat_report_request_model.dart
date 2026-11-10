import 'report_date_formatter.dart';

class ExpensesWithVatReportRequestModel {
  final double? fromCustomerNo;
  final double? toCustomerNo;
  final DateTime? fromVoucherDate;
  final DateTime? toVoucherDate;
  final int taxTreatment;
  final int taxPeriod;
  final String reportName;
  final String exportType;

  const ExpensesWithVatReportRequestModel({
    this.fromCustomerNo,
    this.toCustomerNo,
    this.fromVoucherDate,
    this.toVoucherDate,
    this.taxTreatment = 3,
    this.taxPeriod = 3,
    this.reportName = 'AGL1001E',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() {
    return {
      'FromCustomerNo': fromCustomerNo,
      'ToCustomerNo': toCustomerNo,
      'FromVoucherDate': fromVoucherDate == null
          ? null
          : formatReportDateOnly(fromVoucherDate!),
      'ToVoucherDate': toVoucherDate == null
          ? null
          : formatReportDateOnly(toVoucherDate!),
      'TaxTreatment': taxTreatment,
      'TaxPeriod': taxPeriod,
      'ReportName': reportName,
      'ExportType': exportType,
    };
  }
}
