class ChartOfAccountReportRequestModel {
  final num? fromAccountNo;
  final num? toAccountNo;
  final String? fromCurrencyCode;
  final String? toCurrencyCode;
  final int? fromAccountLevel;
  final int? toAccountLevel;
  final int accountType;
  final int finalAccount;
  final String reportName;
  final String exportType;

  const ChartOfAccountReportRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCurrencyCode,
    this.toCurrencyCode,
    this.fromAccountLevel,
    this.toAccountLevel,
    this.accountType = 2,
    this.finalAccount = 4,
    this.reportName = 'AGL004',
    this.exportType = 'pdf',
  });

  factory ChartOfAccountReportRequestModel.fromJson(Map<String, dynamic> json) {
    return ChartOfAccountReportRequestModel(
      fromAccountNo: json['FromAccountNo'] as num?,
      toAccountNo: json['ToAccountNo'] as num?,
      fromCurrencyCode: json['FromCurrencyCode'] as String?,
      toCurrencyCode: json['ToCurrencyCode'] as String?,
      fromAccountLevel: json['FromAccountLevel'] as int?,
      toAccountLevel: json['ToAccountLevel'] as int?,
      accountType: json['AccountType'] as int? ?? 2,
      finalAccount: json['FinalAccount'] as int? ?? 4,
      reportName: json['ReportName'] as String? ?? 'AGL004',
      exportType: json['ExportType'] as String? ?? 'pdf',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FromAccountNo': fromAccountNo,
      'ToAccountNo': toAccountNo,
      'FromCurrencyCode': fromCurrencyCode,
      'ToCurrencyCode': toCurrencyCode,
      'FromAccountLevel': fromAccountLevel,
      'ToAccountLevel': toAccountLevel,
      'AccountType': accountType,
      'FinalAccount': finalAccount,
      'ReportName': reportName,
      'ExportType': exportType,
    };
  }
}
