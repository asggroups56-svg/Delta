import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/trial_balance_report_request_model.dart';

void main() {
  test('serializes AGL030 with level, zero balances, and balance type', () {
    final request = TrialBalanceReportRequestModel(
      accountLevel: 5,
      doNotDisplayAccountsWithZeroBalances: false,
      balanceType: 3,
      reportPageType: 1,
      reportName: 'AGL030',
    );

    expect(request.toJson(), <String, dynamic>{
      'AccountLevel': 5,
      'DoNotDisplayAccountsWithZeroBalances': false,
      'balanceType': 3,
      'reportPageType': 1,
      'ReportName': 'AGL030',
      'ExportType': 'pdf',
    });
  });

  test('serializes AGL060 and AGL060A with month range and general flag', () {
    final request = TrialBalanceReportRequestModel(
      accountLevel: null,
      fromMonth: 1,
      toMonth: 6,
      isGeneral: null,
      reportPageType: 2,
      reportName: 'AGL060A',
      exportType: 'excel',
    );

    expect(request.toJson(), <String, dynamic>{
      'AccountLevel': null,
      'FromMonth': 1,
      'ToMonth': 6,
      'ISGeneral': null,
      'reportPageType': 2,
      'ReportName': 'AGL060A',
      'ExportType': 'excel',
    });
  });

  test('serializes AGL060H without an account level', () {
    final request = TrialBalanceReportRequestModel(
      fromMonth: 2,
      toMonth: 4,
      reportPageType: 3,
      reportName: 'AGL060H',
      exportType: 'excelformatted',
    );

    expect(request.toJson(), <String, dynamic>{
      'FromMonth': 2,
      'ToMonth': 4,
      'reportPageType': 3,
      'ReportName': 'AGL060H',
      'ExportType': 'excelformatted',
    });
  });

  test('serializes AGL031 with a nullable account level', () {
    final request = TrialBalanceReportRequestModel(
      accountLevel: null,
      reportPageType: 4,
      reportName: 'AGL031',
      exportType: 'word',
    );

    expect(request.toJson(), <String, dynamic>{
      'AccountLevel': null,
      'reportPageType': 4,
      'ReportName': 'AGL031',
      'ExportType': 'word',
    });
  });
}
