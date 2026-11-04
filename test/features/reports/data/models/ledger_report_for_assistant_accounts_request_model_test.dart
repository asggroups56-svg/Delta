import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/ledger_report_for_assistant_accounts_request_model.dart';

void main() {
  test('serializes the required center level and selected ranges', () {
    const request = LedgerReportForAssistantAccountsRequestModel(
      centerLevel: 1,
      fromAccountNo: 1101,
      toAccountNo: 1200,
      fromCostCenterNo: 10,
      toCostCenterNo: 20,
    );

    final json = request.toJson();
    expect(json['CenterLevel'], 1);
    expect(json['FromAccountNo'], 1101);
    expect(json['ToAccountNo'], 1200);
    expect(json['FromCostCenterNo'], 10);
    expect(json['ToCostCenterNo'], 20);
  });
}
