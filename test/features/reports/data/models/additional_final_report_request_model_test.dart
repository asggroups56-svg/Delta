import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/additional_final_report_request_model.dart';

void main() {
  test('serializes the default additional final report payload', () {
    const request = AdditionalFinalReportRequestModel();

    expect(request.toJson(), <String, dynamic>{
      'ReportSerial': null,
      'CostCenterNo': null,
      'ReportTitle': null,
      'FromLineSerial': null,
      'ToLineSerial': null,
      'ReportName': 'AGL037A',
      'ExportType': 'pdf',
    });
  });

  test('serializes every optional filter and export type', () {
    const request = AdditionalFinalReportRequestModel(
      reportSerial: 4,
      costCenterNo: 12,
      reportTitle: 'Additional report',
      fromLineSerial: 2,
      toLineSerial: 9,
      reportName: 'AGL045C',
      exportType: 'excel',
    );

    expect(request.toJson(), <String, dynamic>{
      'ReportSerial': 4,
      'CostCenterNo': 12,
      'ReportTitle': 'Additional report',
      'FromLineSerial': 2,
      'ToLineSerial': 9,
      'ReportName': 'AGL045C',
      'ExportType': 'excel',
    });
  });
}
