class AccountsCentersComparisonReportRequestModel {
  final num? fromAccountNo;
  final num? toAccountNo;
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final int? fromMonth;
  final int? toMonth;
  final int balance;
  final int periodically;
  final int reportGroup;
  final int reportPageType;
  final String reportName;
  final String exportType;
  final bool includeBalanceAndPeriodically;

  const AccountsCentersComparisonReportRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromMonth,
    this.toMonth,
    this.balance = 0,
    this.periodically = 0,
    this.reportGroup = 0,
    this.reportPageType = 1,
    this.reportName = 'AGL051A',
    this.exportType = 'pdf',
    this.includeBalanceAndPeriodically = true,
  });

  Map<String, dynamic> toJson() => {
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'FromCostCenterNo': fromCostCenterNo,
    'ToCostCenterNo': toCostCenterNo,
    'FromMonth': fromMonth,
    'ToMonth': toMonth,
    if (includeBalanceAndPeriodically) ...{
      'Balance': balance,
      'Periodically': periodically,
    },
    'ReportGroup': reportGroup,
    'reportPageType': reportPageType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
