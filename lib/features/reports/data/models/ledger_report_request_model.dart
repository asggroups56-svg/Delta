import 'report_date_formatter.dart';

class LedgerReportRequestModel {
  final DateTime fromDate;
  final DateTime toDate;
  final String reportName;
  final String exportType;
  final int? fromAccountNo;
  final int? toAccountNo;

  const LedgerReportRequestModel({
    required this.fromDate,
    required this.toDate,
    this.reportName = 'AGL025',
    this.exportType = 'pdf',
    this.fromAccountNo,
    this.toAccountNo,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'FromDate': formatReportDate(fromDate),
      'ToDate': formatReportDate(toDate),
      'ReportName': reportName,
      'ExportType': exportType,
    };
    if (fromAccountNo != null) map['FromAccountNo'] = fromAccountNo;
    if (toAccountNo != null) map['ToAccountNo'] = toAccountNo;
    return map;
  }
}
