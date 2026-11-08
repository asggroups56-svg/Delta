class ActivityCenterDataReportRequestModel {
  final int? fromCostCenterNo;
  final int? toCostCenterNo;
  final int? fromLevel;
  final int? toLevel;
  final int centerType;
  final int? fromCenterNoZero;
  final int? toCenterNoZero;
  final int? fromAccountNo;
  final int? toAccountNo;
  final String reportName;
  final String exportType;

  const ActivityCenterDataReportRequestModel({
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromLevel,
    this.toLevel,
    this.centerType = 2,
    this.fromCenterNoZero,
    this.toCenterNoZero,
    this.fromAccountNo,
    this.toAccountNo,
    this.reportName = 'AGL007A',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromCostCenterNo': fromCostCenterNo,
    'ToCostCenterNo': toCostCenterNo,
    'FromLevel': fromLevel,
    'ToLevel': toLevel,
    'CenterType': centerType,
    'FromCenterNoZero': fromCenterNoZero,
    'ToCenterNoZero': toCenterNoZero,
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
