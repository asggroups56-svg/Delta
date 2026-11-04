import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/ledger_report_request_model.dart';

void main() {
  test('serializes selected currency range', () {
    const request = LedgerReportRequestModel(
      fromCurrencyCode: '1',
      toCurrencyCode: '3',
    );

    expect(request.toJson()['FromCurrencyCode'], '1');
    expect(request.toJson()['ToCurrencyCode'], '3');
  });
}
