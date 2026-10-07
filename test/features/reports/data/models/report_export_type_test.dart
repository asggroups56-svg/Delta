import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/account_statement_report_request_model.dart';
import 'package:my_template/features/reports/data/models/chart_of_account_report_request_model.dart';
import 'package:my_template/features/reports/data/models/cost_centers_report_request_model.dart';
import 'package:my_template/features/reports/data/models/daily_income_and_expense_situation_report_request_model.dart';
import 'package:my_template/features/reports/data/models/expenses_with_vat_report_request_model.dart';
import 'package:my_template/features/reports/data/models/income_and_expense_situation_report_request_model.dart';
import 'package:my_template/features/reports/data/models/ledger_report_request_model.dart';
import 'package:my_template/features/reports/data/models/purchases_with_vat_report_request_model.dart';
import 'package:my_template/features/reports/data/models/sales_with_vat_report_request_model.dart';
import 'package:my_template/features/reports/data/models/trial_balance_by_categories_report_request_model.dart';

void main() {
  test('all report request models serialize supported export types', () {
    final date = DateTime(2026, 10, 6);
    final requestModels = <Map<String, dynamic> Function(String)>[
      (type) => AccountStatementReportRequestModel(exportType: type).toJson(),
      (type) => ChartOfAccountReportRequestModel(exportType: type).toJson(),
      (type) => CostCentersReportRequestModel(
        costCenterType: 2,
        exportType: type,
      ).toJson(),
      (type) => DailyIncomeAndExpenseSituationReportRequestModel(
        exportType: type,
      ).toJson(),
      (type) => ExpensesWithVatReportRequestModel(exportType: type).toJson(),
      (type) =>
          IncomeAndExpenseSituationReportRequestModel(exportType: type).toJson(),
      (type) => LedgerReportRequestModel(
        fromDate: date,
        toDate: date,
        exportType: type,
      ).toJson(),
      (type) => PurchasesWithVatReportRequestModel(exportType: type).toJson(),
      (type) => SalesWithVatReportRequestModel(exportType: type).toJson(),
      (type) =>
          TrialBalanceByCategoriesReportRequestModel(exportType: type).toJson(),
    ];
    const exportTypes = ['pdf', 'excel', 'word', 'excelformatted'];

    for (final buildRequest in requestModels) {
      for (final exportType in exportTypes) {
        expect(buildRequest(exportType)['ExportType'], exportType);
      }
    }
  });
}
