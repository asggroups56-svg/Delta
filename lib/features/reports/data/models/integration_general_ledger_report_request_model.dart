import 'report_date_formatter.dart';

class IntegrationGeneralLedgerReportRequestModel {
  final int? fromAccountNo;
  final int? toAccountNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool accountsWithZeroBalances;
  final int ledgerReportType;
  final int reportPageType;
  final String? reportName;
  final String exportType;

  const IntegrationGeneralLedgerReportRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromDate,
    this.toDate,
    this.accountsWithZeroBalances = false,
    this.ledgerReportType = 1,
    this.reportPageType = 3,
    this.reportName,
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
    'LedgerReportType': ledgerReportType,
    'reportPageType': reportPageType,
    'ReportName': reportName ?? (ledgerReportType == 3 ? 'AGLT26' : 'AGLT26C'),
    'ExportType': exportType,
  };
}
