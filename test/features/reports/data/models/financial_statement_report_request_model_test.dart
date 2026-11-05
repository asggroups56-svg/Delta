import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/financial_statement_report_request_model.dart';

void main() {
  test('serializes the default trading report payload', () {
    const request = FinancialStatementReportRequestModel(
      financialStatementReportType: 1,
      reportName: 'AGL034A',
    );

    expect(request.toJson(), <String, dynamic>{
      'ToMonth': null,
      'CostCenterNo': null,
      'ReportType': 1,
      'FinancialStatementReportType': 1,
      'ReportName': 'AGL034A',
      'ExportType': 'pdf',
    });
  });

  test('serializes report type, month, cost center, and export type', () {
    const request = FinancialStatementReportRequestModel(
      financialStatementReportType: 3,
      reportType: 6,
      toMonth: 12,
      costCenterNo: 7,
      reportName: 'AGL040A',
      exportType: 'excelformatted',
    );

    expect(request.toJson(), <String, dynamic>{
      'ToMonth': 12,
      'CostCenterNo': 7,
      'ReportType': 6,
      'FinancialStatementReportType': 3,
      'ReportName': 'AGL040A',
      'ExportType': 'excelformatted',
    });
  });
}
