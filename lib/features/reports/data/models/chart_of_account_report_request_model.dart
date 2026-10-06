class ChartOfAccountReportRequestModel {
  final String reportName;
  final String exportType;

  const ChartOfAccountReportRequestModel({
    this.reportName = 'AGL001',
    this.exportType = 'pdf',
  });

  factory ChartOfAccountReportRequestModel.fromJson(Map<String, dynamic> json) {
    return ChartOfAccountReportRequestModel(
      reportName: json['ReportName'] as String? ?? 'AGL001',
      exportType: json['ExportType'] as String? ?? 'pdf',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ReportName': reportName,
      'ExportType': exportType,
    };
  }
}
