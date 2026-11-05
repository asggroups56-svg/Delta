class AdditionalFinalReportRequestModel {
  final int? reportSerial;
  final num? costCenterNo;
  final String? reportTitle;
  final int? fromLineSerial;
  final int? toLineSerial;
  final String reportName;
  final String exportType;

  const AdditionalFinalReportRequestModel({
    this.reportSerial,
    this.costCenterNo,
    this.reportTitle,
    this.fromLineSerial,
    this.toLineSerial,
    this.reportName = 'AGL037A',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'ReportSerial': reportSerial,
    'CostCenterNo': costCenterNo,
    'ReportTitle': reportTitle,
    'FromLineSerial': fromLineSerial,
    'ToLineSerial': toLineSerial,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
