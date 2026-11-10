import 'report_date_formatter.dart';

class AccountCentersAnalyticalDetailsReportRequestModel {
  final num? fromAccountNo;
  final num? toAccountNo;
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final int? fromAccAnal;
  final int? toAccAnal;
  final int? fromCentAnal;
  final int? toCentAnal;
  final int? fromAnalytical;
  final int? toAnalytical;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;

  const AccountCentersAnalyticalDetailsReportRequestModel({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromAccAnal,
    this.toAccAnal,
    this.fromCentAnal,
    this.toCentAnal,
    this.fromAnalytical,
    this.toAnalytical,
    this.fromDate,
    this.toDate,
    this.reportName = 'AGL098',
    this.exportType = 'pdf',
  });

  Map<String, dynamic> toJson() => {
    'FromAccountNo': fromAccountNo,
    'ToAccountNo': toAccountNo,
    'FromCostCenterNo': fromCostCenterNo,
    'ToCostCenterNo': toCostCenterNo,
    'FromACCANAL': fromAccAnal,
    'ToACCANAL': toAccAnal,
    'FromCENTANAL': fromCentAnal,
    'ToCENTANAL': toCentAnal,
    'FromAnalytical': fromAnalytical,
    'ToAnalytical': toAnalytical,
    'FromDate': fromDate == null ? null : formatReportDateOnly(fromDate!),
    'ToDate': toDate == null ? null : formatReportDateOnly(toDate!),
    'ReportName': reportName,
    'ExportType': exportType,
  };
}
