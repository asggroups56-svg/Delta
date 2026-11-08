class IndicatorDataAdditionReportRequestModel {
  final int? fromIndicatorCode;
  final int? toIndicatorCode;
  final String reportName;
  final String exportType;

  const IndicatorDataAdditionReportRequestModel({
    this.fromIndicatorCode,
    this.toIndicatorCode,
    this.reportName = 'AGL800A',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromIndicatorCODE': fromIndicatorCode,
    'ToIndicatorCODE': toIndicatorCode,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
