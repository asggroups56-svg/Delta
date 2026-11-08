import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/indicator_data_standard_report_request_model.dart';

void main() {
  test('serializes the default standard indicator data payload', () {
    const request = IndicatorDataStandardReportRequestModel();

    expect(request.toJson(), <String, dynamic>{
      'FromIndicatorCODE': null,
      'ToIndicatorCODE': null,
      'ReportName': 'AGL066',
      'ExportType': 'pdf',
    });
  });

  test('serializes every optional filter and export type', () {
    const request = IndicatorDataStandardReportRequestModel(
      fromIndicatorCode: 10,
      toIndicatorCode: 25,
      reportName: 'AGL067',
      exportType: 'excel',
    );

    expect(request.toJson(), <String, dynamic>{
      'FromIndicatorCODE': 10,
      'ToIndicatorCODE': 25,
      'ReportName': 'AGL067',
      'ExportType': 'excel',
    });
  });
}
