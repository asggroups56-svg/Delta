class TrialBalanceReportRequestModel {
  final int? accountLevel;
  final bool? doNotDisplayAccountsWithZeroBalances;
  final int? balanceType;
  final int? fromMonth;
  final int? toMonth;
  final bool? isGeneral;
  final int reportPageType;
  final String reportName;
  final String exportType;

  const TrialBalanceReportRequestModel({
    this.accountLevel,
    this.doNotDisplayAccountsWithZeroBalances,
    this.balanceType,
    this.fromMonth,
    this.toMonth,
    this.isGeneral,
    this.reportPageType = 1,
    this.reportName = 'AGL030',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() {
    final common = <String, dynamic>{
      'reportPageType': reportPageType,
      'ReportName': reportName,
      'ExportType': exportType,
    };

    switch (reportPageType) {
      case 1:
        return <String, dynamic>{
          'AccountLevel': accountLevel,
          'DoNotDisplayAccountsWithZeroBalances':
              doNotDisplayAccountsWithZeroBalances,
          'balanceType': balanceType,
          ...common,
        };
      case 2:
        return <String, dynamic>{
          'AccountLevel': accountLevel,
          'FromMonth': fromMonth,
          'ToMonth': toMonth,
          'ISGeneral': isGeneral,
          ...common,
        };
      case 3:
        return <String, dynamic>{
          'FromMonth': fromMonth,
          'ToMonth': toMonth,
          ...common,
        };
      case 4:
        return <String, dynamic>{'AccountLevel': accountLevel, ...common};
      default:
        return <String, dynamic>{'AccountLevel': accountLevel, ...common};
    }
  }
}
