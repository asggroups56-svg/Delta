import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/trial_balances_report_for_period_request_model.dart';

void main() {
  test('serializes the period trial balance request fields', () {
    final request = TrialBalancesReportForPeriodRequestModel(
      fromAccountNo: 100,
      toAccountNo: 200,
      fromDate: DateTime(2025, 1, 2),
      toDate: DateTime(2025, 3, 4),
    );

    expect(request.toJson(), <String, dynamic>{
      'AccountLevel': null,
      'FromAccountNo': 100,
      'ToAccountNo': 200,
      'FromDate': '2025-01-02',
      'ToDate': '2025-03-04',
      'DoNotDisplayAccountsWithZeroBalances': false,
      'PrepareTree': false,
      'ReportName': 'AGL078',
      'ExportType': 'pdf',
    });
  });

  test('serializes optional report settings and export type', () {
    final request = TrialBalancesReportForPeriodRequestModel(
      doNotDisplayAccountsWithZeroBalances: true,
      prepareTree: true,
      exportType: 'excel',
    );

    expect(request.toJson()['AccountLevel'], isNull);
    expect(request.toJson()['DoNotDisplayAccountsWithZeroBalances'], isTrue);
    expect(request.toJson()['PrepareTree'], isTrue);
    expect(request.toJson()['ExportType'], 'excel');
  });
}
