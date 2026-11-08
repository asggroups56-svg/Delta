import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/activity_report_request_model.dart';

void main() {
  test('serializes the default activity report payload', () {
    const request = ActivityReportRequestModel();

    expect(request.toJson(), <String, dynamic>{
      'FromCenterNoOne': null,
      'ToCenterNoOne': null,
      'FromAccountNo': null,
      'ToAccountNo': null,
      'FromCenterNoZero': null,
      'ToCenterNoZero': null,
      'FromDate': null,
      'ToDate': null,
      'ReportName': 'AGL111',
      'ExportType': 'pdf',
    });
  });

  test('serializes ranges and ISO dates for AGL111', () {
    final request = ActivityReportRequestModel(
      fromCenterNoOne: 1,
      toCenterNoOne: 5,
      fromAccountNo: 100,
      toAccountNo: 200,
      fromCenterNoZero: 2,
      toCenterNoZero: 6,
      fromDate: DateTime(2026, 11, 25),
      toDate: DateTime(2026, 11, 30),
      exportType: 'excel',
    );

    expect(request.toJson(), <String, dynamic>{
      'FromCenterNoOne': 1,
      'ToCenterNoOne': 5,
      'FromAccountNo': 100,
      'ToAccountNo': 200,
      'FromCenterNoZero': 2,
      'ToCenterNoZero': 6,
      'FromDate': '2026-11-25T00:00:00',
      'ToDate': '2026-11-30T00:00:00',
      'ReportName': 'AGL111',
      'ExportType': 'excel',
    });
  });
}
