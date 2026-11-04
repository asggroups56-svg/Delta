import 'report_date_formatter.dart';

class GeneralLedgerPostingReportRequestModel {
  final int? fromAccountNo;
  final int? toAccountNo;
  final int? searchGroup;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool accountsWithZeroBalances;
  final int ledgerReportType;
  final int reportPageType;
  final String? reportName;
  final String exportType;

  const GeneralLedgerPostingReportRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.searchGroup,
    this.fromDate,
    this.toDate,
    this.accountsWithZeroBalances = false,
    this.ledgerReportType = 1,
    this.reportPageType = 5,
    this.reportName,
    this.exportType = 'pdf',
  });

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return formatReportDateTime(date);
  }

  String get _defaultReportName => switch (ledgerReportType) {
    2 => 'AGL023CLP',
    3 => 'AGL025LP',
    _ => 'AGL021CLP',
  };

  Map<String, dynamic> toJson() => {
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'SearchGroup': searchGroup,
    'FromDate': _formatDate(fromDate),
    'ToDate': _formatDate(toDate),
    'AccountsWithZeroBalances': accountsWithZeroBalances,
    'LedgerReportType': ledgerReportType,
    'reportPageType': reportPageType,
    'ReportName': reportName ?? _defaultReportName,
    'ExportType': exportType,
  };
}
