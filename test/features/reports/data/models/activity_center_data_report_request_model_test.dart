import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/activity_center_data_report_request_model.dart';

void main() {
  test('serializes the default activity centers data payload', () {
    const request = ActivityCenterDataReportRequestModel();

    expect(request.toJson(), <String, dynamic>{
      'FromCostCenterNo': null,
      'ToCostCenterNo': null,
      'FromLevel': null,
      'ToLevel': null,
      'CenterType': 2,
      'FromCenterNoZero': null,
      'ToCenterNoZero': null,
      'FromAccountNo': null,
      'ToAccountNo': null,
      'ReportName': 'AGL007A',
      'ExportType': 'pdf',
    });
  });

  test('serializes center/account ranges, level range and export type', () {
    const request = ActivityCenterDataReportRequestModel(
      fromLevel: 1,
      toLevel: 3,
      centerType: 1,
      fromCenterNoZero: 1,
      toCenterNoZero: 5,
      fromAccountNo: 100,
      toAccountNo: 200,
      exportType: 'excelformatted',
    );

    expect(request.toJson(), <String, dynamic>{
      'FromCostCenterNo': null,
      'ToCostCenterNo': null,
      'FromLevel': 1,
      'ToLevel': 3,
      'CenterType': 1,
      'FromCenterNoZero': 1,
      'ToCenterNoZero': 5,
      'FromAccountNo': 100,
      'ToAccountNo': 200,
      'ReportName': 'AGL007A',
      'ExportType': 'excelformatted',
    });
  });
}
