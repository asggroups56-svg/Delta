class AccountsComparisonReportRequestModel {
  final num? fromAccountNo;
  final num? toAccountNo;
  final int? fromAccountLevel;
  final int? toAccountLevel;
  final int? fromMonth;
  final int? toMonth;
  final int? comparisonMonth;
  final int accountType;
  final int financialStatementType;
  final int? balance;
  final int? periodically;
  final int reportPageType;
  final String reportName;
  final String exportType;
  final bool includeMonthlyFilters;
  final bool includeComparisonMonthFilters;
  final bool includeBalancePeriodicallyFilters;

  const AccountsComparisonReportRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromAccountLevel,
    this.toAccountLevel,
    this.fromMonth,
    this.toMonth,
    this.comparisonMonth,
    this.accountType = 2,
    this.financialStatementType = 4,
    this.balance = 0,
    this.periodically,
    this.reportPageType = 4,
    this.reportName = 'AGL052',
    this.exportType = 'pdf',
    this.includeMonthlyFilters = false,
    this.includeComparisonMonthFilters = false,
    this.includeBalancePeriodicallyFilters = false,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'FromAccountNo': fromAccountNo,
      'ToAccountNo': toAccountNo,
      'FromAccountLevel': fromAccountLevel,
      'ToAccountLevel': toAccountLevel,
      'AccountType': accountType,
      'FinancialStatementType': financialStatementType,
      'reportPageType': reportPageType,
      'ReportName': reportName,
      'ExportType': exportType,
    };
    if (includeMonthlyFilters) {
      json.addAll({
        'FromMonth': fromMonth,
        'ToMonth': toMonth,
        'Balance': balance,
      });
    }
    if (includeComparisonMonthFilters) {
      json.addAll({
        'ComparsionMonth': comparisonMonth,
        'Balance': balance,
        'Periodically': periodically,
      });
    }
    if (includeBalancePeriodicallyFilters) {
      json.addAll({
        'FromMonth': fromMonth,
        'ToMonth': toMonth,
        'Balance': balance,
        'Periodically': periodically,
      });
    }
    return json;
  }
}
