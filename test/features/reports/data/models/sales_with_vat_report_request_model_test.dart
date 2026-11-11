import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/sales_with_vat_report_request_model.dart';

void main() {
  test('serializes the AAR1000 sales with VAT payload', () {
    const request = SalesWithVatReportRequestModel();

    expect(request.toJson(), <String, dynamic>{
      'FromCustomerNo': null,
      'ToCustomerNo': null,
      'FromItemCode': null,
      'ToItemCode': null,
      'FromDocId': null,
      'ToDocId': null,
      'FromTransDate': null,
      'ToTransDate': null,
      'DocumentType': 5,
      'AccountingSystem': 1,
      'TaxTreatment': 1,
      'TaxPeriod': 3,
      'ReportName': 'AAR1000',
      'ExportType': 'pdf',
    });
  });

  test('serializes ranges, ISO dates and tax options for AAR1000', () {
    final request = SalesWithVatReportRequestModel(
      fromCustomerNo: 10,
      toCustomerNo: 20,
      fromItemCode: 'A-1',
      toItemCode: 'A-9',
      fromDocId: 100,
      toDocId: 200,
      fromTransDate: DateTime(2026, 1, 1),
      toTransDate: DateTime(2026, 1, 31),
      documentType: 1,
      accountingSystem: 2,
      taxTreatment: 2,
      taxPeriod: 1,
      exportType: 'excel',
    );

    expect(request.toJson(), <String, dynamic>{
      'FromCustomerNo': 10.0,
      'ToCustomerNo': 20.0,
      'FromItemCode': 'A-1',
      'ToItemCode': 'A-9',
      'FromDocId': 100,
      'ToDocId': 200,
      'FromTransDate': '2026-01-01T00:00:00',
      'ToTransDate': '2026-01-31T00:00:00',
      'DocumentType': 1,
      'AccountingSystem': 2,
      'TaxTreatment': 2,
      'TaxPeriod': 1,
      'ReportName': 'AAR1000',
      'ExportType': 'excel',
    });
  });
}
