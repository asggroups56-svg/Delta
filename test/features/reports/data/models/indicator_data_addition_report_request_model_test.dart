import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/indicator_data_addition_report_request_model.dart';

void main() {
  test('serializes the default additional indicator data payload', () {
    const request = IndicatorDataAdditionReportRequestModel();

    expect(request.toJson(), <String, dynamic>{
      'FromIndicatorCODE': null,
      'ToIndicatorCODE': null,
      'ReportName': 'AGL800A',
      'ExportType': 'pdf',
    });
  });

  test('serializes every optional filter and export type', () {
    const request = IndicatorDataAdditionReportRequestModel(
      fromIndicatorCode: 3,
      toIndicatorCode: 18,
      reportName: 'AGL800',
      exportType: 'word',
    );

    expect(request.toJson(), <String, dynamic>{
      'FromIndicatorCODE': 3,
      'ToIndicatorCODE': 18,
      'ReportName': 'AGL800',
      'ExportType': 'word',
    });
  });
}
