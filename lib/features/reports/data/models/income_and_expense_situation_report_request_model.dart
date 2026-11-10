class IncomeAndExpenseSituationReportRequestModel {
  final int? accountLevel;
  final int? fromMonth;
  final int? toMonth;
  final int? fromAccountNo;
  final int? toAccountNo;
  final int? fromCostCenterNo;
  final int? toCostCenterNo;
  final int? fromChartAnaly;
  final int? toChartAnaly;
  final int? yearQuarter;
  final int finalAccountType;
  final int mainAccountsFilter;
  final int reportPageType;
  final String reportName;
  final String exportType;

  const IncomeAndExpenseSituationReportRequestModel({
    this.accountLevel,
    this.fromMonth,
    this.toMonth,
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromChartAnaly,
    this.toChartAnaly,
    this.yearQuarter,
    this.finalAccountType = 3,
    this.mainAccountsFilter = 1,
    this.reportPageType = 2,
    this.reportName = 'AGL300_M',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() {
    if (reportPageType == 4) {
      return {
        'AccountLevel': accountLevel,
        'YearQuarter': yearQuarter,
        'FinalAccountType': finalAccountType,
        'reportPageType': reportPageType,
        'ReportName': reportName,
        'ExportType': exportType,
      };
    }

    if (reportPageType == 5) {
      return {
        'AccountLevel': accountLevel,
        'FromMonth': fromMonth,
        'ToMonth': toMonth,
        'FromCostCenterNo': fromCostCenterNo,
        'ToCostCenterNo': toCostCenterNo,
        'FinalAccountType': finalAccountType,
        'reportPageType': reportPageType,
        'ReportName': reportName,
        'ExportType': exportType,
      };
    }

    if (reportPageType == 6) {
      return {
        'FromAccountNo': fromAccountNo,
        'ToAccountNo': toAccountNo,
        'FromCostCenterNo': fromCostCenterNo,
        'ToCostCenterNo': toCostCenterNo,
        'FromChartAnaly': fromChartAnaly,
        'ToChartAnaly': toChartAnaly,
        'FinalAccountType': finalAccountType,
        'MainAccountsFilter': mainAccountsFilter,
        'reportPageType': reportPageType,
        'ReportName': reportName,
        'ExportType': exportType,
      };
    }

    return {
      'AccountLevel': accountLevel,
      'FromMonth': fromMonth,
      'ToMonth': toMonth,
      'FinalAccountType': finalAccountType,
      'reportPageType': reportPageType,
      'ReportName': reportName,
      'ExportType': exportType,
    };
  }
}
