class CentersComparisonReportRequestModel {
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final int? fromCenterLevel;
  final int? toCenterLevel;
  final int? fromMonth;
  final int? toMonth;
  final int? comparisonMonth;
  final int centerType;
  final int? balance;
  final int? periodically;
  final int reportPageType;
  final String reportName;
  final String exportType;
  final bool includeMonthFilters;
  final bool includeComparisonMonth;

  const CentersComparisonReportRequestModel({
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromCenterLevel,
    this.toCenterLevel,
    this.fromMonth,
    this.toMonth,
    this.comparisonMonth,
    this.centerType = 2,
    this.balance,
    this.periodically,
    this.reportPageType = 4,
    this.reportName = 'AGL092',
    this.exportType = 'pdf',
    this.includeMonthFilters = false,
    this.includeComparisonMonth = false,
  });

  Map<String, dynamic> toJson() => {
    'FromCostCenterNo': fromCostCenterNo,
    'ToCostCenterNo': toCostCenterNo,
    'FromCenterLevel': fromCenterLevel,
    'ToCenterLevel': toCenterLevel,
    if (includeMonthFilters) ...{
      'FromMonth': fromMonth,
      'ToMonth': toMonth,
    },
    if (includeComparisonMonth) 'ComparsionMonth': comparisonMonth,
    'CenterType': centerType,
    if (!includeComparisonMonth) 'Balance': balance,
    if (!includeComparisonMonth) 'Periodically': periodically,
    'reportPageType': reportPageType,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
