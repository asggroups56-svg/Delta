import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/account_centers_trial_balances_report_request_model.dart';

void main() {
  test('serializes the account centers trial balances report request', () {
    final request = AccountCentersTrialBalancesReportRequestModel(
      accountLevel: 1,
      fromAccountNo: 100,
      toAccountNo: 200,
      fromCostCenterNo: 10,
      toCostCenterNo: 20,
      fromDate: DateTime(2025, 1, 2),
      toDate: DateTime(2025, 3, 4),
    );

    expect(request.toJson(), <String, dynamic>{
      'AccountLevel': 1,
      'FromAccountNo': 100,
      'ToAccountNo': 200,
      'FromCostCenterNo': 10,
      'ToCostCenterNo': 20,
      'FromDate': '2025-01-02',
      'ToDate': '2025-03-04',
      'ReportName': 'AGL026C',
      'ExportType': 'pdf',
    });
  });

  test('keeps optional filters null and serializes the export type', () {
    final request = AccountCentersTrialBalancesReportRequestModel(
      accountLevel: 2,
      exportType: 'excel',
    );

    final json = request.toJson();

    expect(json['AccountLevel'], 2);
    expect(json['FromAccountNo'], isNull);
    expect(json['ToAccountNo'], isNull);
    expect(json['FromCostCenterNo'], isNull);
    expect(json['ToCostCenterNo'], isNull);
    expect(json['FromDate'], isNull);
    expect(json['ToDate'], isNull);
    expect(json['ReportName'], 'AGL026C');
    expect(json['ExportType'], 'excel');
  });
}
