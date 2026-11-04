import 'report_date_formatter.dart';

class ConsolidatedGeneralLedgerReportRequestModel {
  final int? fromAccountNo;
  final int? toAccountNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool accountsWithZeroBalances;
  final bool prepareWithAccountRange;
  final int ledgerReportType;
  final int reportPageType;
  final String? reportName;
  final String exportType;

  const ConsolidatedGeneralLedgerReportRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromDate,
    this.toDate,
    this.accountsWithZeroBalances = false,
    this.prepareWithAccountRange = false,
    this.ledgerReportType = 1,
    this.reportPageType = 4,
    this.reportName,
    this.exportType = 'pdf',
  });

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return formatReportDateTime(date);
  }

  Map<String, dynamic> toJson() {
    final summary = ledgerReportType != 2;
    return {
      'FromAccountNo': fromAccountNo,
      'ToAccountNo': toAccountNo,
      'FromDate': _formatDate(fromDate),
      'ToDate': _formatDate(toDate),
      'AccountsWithZeroBalances': accountsWithZeroBalances,
      'PrepareWithAccountRange': prepareWithAccountRange,
      'LedgerReportType': ledgerReportType,
      'reportPageType': reportPageType,
      'ReportName': reportName ?? (summary ? 'AGL021T' : 'AGL023T'),
      'ExportType': exportType,
    };
  }
}
