import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/income_and_expense_situation_report_request_model.dart';

void main() {
  test('serializes the AGL300_M monthly income and expense payload', () {
    const request = IncomeAndExpenseSituationReportRequestModel(
      accountLevel: 15,
      finalAccountType: 3,
      reportPageType: 2,
      reportName: 'AGL300_M',
      exportType: 'pdf',
    );

    expect(request.toJson(), <String, dynamic>{
      'AccountLevel': 15,
      'FromMonth': null,
      'ToMonth': null,
      'FinalAccountType': 3,
      'reportPageType': 2,
      'ReportName': 'AGL300_M',
      'ExportType': 'pdf',
    });
  });

  test('serializes the AGL300_MS multi-month income and expense payload', () {
    const request = IncomeAndExpenseSituationReportRequestModel(
      accountLevel: 10,
      finalAccountType: 3,
      reportPageType: 3,
      reportName: 'AGL300_MS',
      exportType: 'pdf',
    );

    expect(request.toJson(), <String, dynamic>{
      'AccountLevel': 10,
      'FromMonth': null,
      'ToMonth': null,
      'FinalAccountType': 3,
      'reportPageType': 3,
      'ReportName': 'AGL300_MS',
      'ExportType': 'pdf',
    });
  });

  test('serializes the AGL300_QS quarterly income and expense payload', () {
    const request = IncomeAndExpenseSituationReportRequestModel(
      accountLevel: null,
      yearQuarter: 5,
      finalAccountType: 3,
      reportPageType: 4,
      reportName: 'AGL300_QS',
      exportType: 'pdf',
    );

    expect(request.toJson(), <String, dynamic>{
      'AccountLevel': null,
      'YearQuarter': 5,
      'FinalAccountType': 3,
      'reportPageType': 4,
      'ReportName': 'AGL300_QS',
      'ExportType': 'pdf',
    });
  });

  test('serializes the AGL300C cost center income and expense payload', () {
    const request = IncomeAndExpenseSituationReportRequestModel(
      accountLevel: null,
      fromMonth: null,
      toMonth: null,
      fromCostCenterNo: null,
      toCostCenterNo: null,
      finalAccountType: 3,
      reportPageType: 5,
      reportName: 'AGL300C',
      exportType: 'pdf',
    );

    expect(request.toJson(), <String, dynamic>{
      'AccountLevel': null,
      'FromMonth': null,
      'ToMonth': null,
      'FromCostCenterNo': null,
      'ToCostCenterNo': null,
      'FinalAccountType': 3,
      'reportPageType': 5,
      'ReportName': 'AGL300C',
      'ExportType': 'pdf',
    });
  });

  test('serializes the AGL0400 monthly expenses payload', () {
    const request = IncomeAndExpenseSituationReportRequestModel(
      fromAccountNo: null,
      toAccountNo: null,
      fromCostCenterNo: null,
      toCostCenterNo: null,
      fromChartAnaly: null,
      toChartAnaly: null,
      finalAccountType: 3,
      mainAccountsFilter: 1,
      reportPageType: 6,
      reportName: 'AGL0400',
      exportType: 'pdf',
    );

    expect(request.toJson(), <String, dynamic>{
      'FromAccountNo': null,
      'ToAccountNo': null,
      'FromCostCenterNo': null,
      'ToCostCenterNo': null,
      'FromChartAnaly': null,
      'ToChartAnaly': null,
      'FinalAccountType': 3,
      'MainAccountsFilter': 1,
      'reportPageType': 6,
      'ReportName': 'AGL0400',
      'ExportType': 'pdf',
    });
  });

  test('serializes the selected month range and export format', () {
    const request = IncomeAndExpenseSituationReportRequestModel(
      accountLevel: null,
      fromMonth: 3,
      toMonth: 5,
      finalAccountType: 2,
      reportPageType: 2,
      reportName: 'AGL300_M',
      exportType: 'excel',
    );

    expect(request.toJson(), <String, dynamic>{
      'AccountLevel': null,
      'FromMonth': 3,
      'ToMonth': 5,
      'FinalAccountType': 2,
      'reportPageType': 2,
      'ReportName': 'AGL300_M',
      'ExportType': 'excel',
    });
  });
}
