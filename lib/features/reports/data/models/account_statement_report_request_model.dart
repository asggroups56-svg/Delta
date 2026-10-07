import 'report_date_formatter.dart';

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
          ? formatReportDate(subVoucherOraDate!)
          : null,
      'ReportName': reportName,
      'ExportType': exportType,
    };
  }
}
