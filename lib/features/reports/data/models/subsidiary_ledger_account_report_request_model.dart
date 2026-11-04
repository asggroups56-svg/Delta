import 'report_date_formatter.dart';

class SubsidiaryLedgerAccountReportRequestModel {
  final int? fromAccountNo;
  final int? toAccountNo;
  final int? fromMainAccountNo;
  final int? toMainAccountNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool accountsWithZeroBalances;
  final int ledgerReportType;
  final int reportPageType;
  final String? reportName;
  final String exportType;

  const SubsidiaryLedgerAccountReportRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromMainAccountNo,
    this.toMainAccountNo,
    this.fromDate,
    this.toDate,
    this.accountsWithZeroBalances = false,
    this.ledgerReportType = 1,
    this.reportPageType = 6,
    this.reportName,
    this.exportType = 'pdf',
  });

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return formatReportDateTime(date);
  }

  String get _defaultReportName =>
      ledgerReportType == 2 ? 'AGL023AS' : 'AGL021AS';

  Map<String, dynamic> toJson() => {
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'FromMainAccountNo': fromMainAccountNo,
    'ToMainAccountNo': toMainAccountNo,
    'FromDate': _formatDate(fromDate),
    'ToDate': _formatDate(toDate),
    'AccountsWithZeroBalances': accountsWithZeroBalances,
    'LedgerReportType': ledgerReportType,
    'reportPageType': reportPageType,
    'ReportName': reportName ?? _defaultReportName,
    'ExportType': exportType,
  };
}
