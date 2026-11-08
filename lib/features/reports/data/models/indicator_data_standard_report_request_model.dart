class IndicatorDataStandardReportRequestModel {
  final int? fromIndicatorCode;
  final int? toIndicatorCode;
  final String reportName;
  final String exportType;

  const IndicatorDataStandardReportRequestModel({
    this.fromIndicatorCode,
    this.toIndicatorCode,
    this.reportName = 'AGL066',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromIndicatorCODE': fromIndicatorCode,
    'ToIndicatorCODE': toIndicatorCode,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
