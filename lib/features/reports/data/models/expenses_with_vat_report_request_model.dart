import 'report_date_formatter.dart';

class ExpensesWithVatReportRequestModel {
  final DateTime? fromVoucherDate;
  final DateTime? toVoucherDate;
  final DateTime? fromTransDate;
  final DateTime? toTransDate;
  final int taxTreatment;
  final int taxPeriod;
  final String reportName;
  final String exportType;

  const ExpensesWithVatReportRequestModel({
    this.fromVoucherDate,
    this.toVoucherDate,
    this.fromTransDate,
    this.toTransDate,
    this.taxTreatment = 3,
    this.taxPeriod = 3,
    this.reportName = 'AGL1001E',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'TaxTreatment': taxTreatment,
      'TaxPeriod': taxPeriod,
      'ReportName': reportName,
      'ExportType': exportType,
    };
    if (fromVoucherDate != null) {
      map['FromVoucherDate'] = formatReportDate(fromVoucherDate!);
    }
    if (toVoucherDate != null) {
      map['ToVoucherDate'] = formatReportDate(toVoucherDate!);
    }
    if (fromTransDate != null) {
      map['FromTransDate'] = formatReportDate(fromTransDate!);
    }
    if (toTransDate != null) {
      map['ToTransDate'] = formatReportDate(toTransDate!);
    }
    return map;
  }
}
