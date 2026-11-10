import 'report_date_formatter.dart';

class PurchaseOfProjectsReportRequestModel {
  final num? fromCustomerNo, toCustomerNo, fromCostCenterNo, toCostCenterNo;
  final DateTime? fromTransDate, toTransDate;
  final String reportName, exportType;
  const PurchaseOfProjectsReportRequestModel({this.fromCustomerNo, this.toCustomerNo, this.fromCostCenterNo, this.toCostCenterNo, this.fromTransDate, this.toTransDate, this.reportName = 'AGL1002', this.exportType = 'pdf'});
  Map<String, dynamic> toJson() => {
    'FromCustomerNo': fromCustomerNo, 'ToCustomerNo': toCustomerNo,
    'FromCostCenterNo': fromCostCenterNo, 'ToCostCenterNo': toCostCenterNo,
    'FromTransDate': fromTransDate == null ? null : formatReportDateOnly(fromTransDate!),
    'ToTransDate': toTransDate == null ? null : formatReportDateOnly(toTransDate!),
    'ReportName': reportName, 'ExportType': exportType,
  };
}
