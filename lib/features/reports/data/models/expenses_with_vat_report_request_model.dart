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
      map['FromVoucherDate'] = _formatDate(fromVoucherDate!);
    }
    if (toVoucherDate != null) {
      map['ToVoucherDate'] = _formatDate(toVoucherDate!);
    }
    if (fromTransDate != null) {
      map['FromTransDate'] = _formatDate(fromTransDate!);
    }
    if (toTransDate != null) {
      map['ToTransDate'] = _formatDate(toTransDate!);
    }
    return map;
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return "$year-$month-${day}T00:00:00";
  }
}
