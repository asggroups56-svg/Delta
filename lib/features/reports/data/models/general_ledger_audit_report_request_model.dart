import 'report_date_formatter.dart';

class GeneralLedgerAuditReportRequestModel {
  final int? fromAccountNo;
  final int? toAccountNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool accountsWithZeroBalances;
  final int reportPageType;
  final String reportName;
  final String exportType;

  const GeneralLedgerAuditReportRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromDate,
    this.toDate,
    this.accountsWithZeroBalances = false,
    this.reportPageType = 1,
    this.reportName = 'AGL100',
    this.exportType = 'pdf',
  });

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return formatReportDateTime(date);
  }

  Map<String, dynamic> toJson() => {
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'FromDate': _formatDate(fromDate),
    'ToDate': _formatDate(toDate),
    'AccountsWithZeroBalances': accountsWithZeroBalances,
    'reportPageType': reportPageType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
