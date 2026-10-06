class AccountStatementReportRequestModel {
  final int? subVoucherAccountNo;
  final DateTime? subVoucherOraDate;
  final String reportName;
  final String exportType;

  const AccountStatementReportRequestModel({
    this.subVoucherAccountNo,
    this.subVoucherOraDate,
    this.reportName = 'AGL079',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() {
    return {
      'SubVoucherAccountNO': subVoucherAccountNo,
      'SubVoucherOraDate': subVoucherOraDate != null
          ? _formatDate(subVoucherOraDate!)
          : null,
      'ReportName': reportName,
      'ExportType': exportType,
    };
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-${day}T00:00:00';
  }
}
