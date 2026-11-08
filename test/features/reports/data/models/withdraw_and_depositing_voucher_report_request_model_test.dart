import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/withdraw_and_depositing_voucher_report_request_model.dart';

void main() {
  test('serializes the default withdrawal and deposit payload', () {
    const request = WithdrawAndDepositingVoucherReportRequestModel();

    expect(request.toJson(), <String, dynamic>{
      'FromBANK_CODE': null,
      'ToBANK_CODE': null,
      'FromDate': null,
      'ToDate': null,
      'ReportName': 'AGL065',
      'ExportType': 'pdf',
    });
  });

  test('serializes dates as ISO yyyy-MM-ddTHH:mm:ss with bank range', () {
    final request = WithdrawAndDepositingVoucherReportRequestModel(
      fromBankCode: 1,
      toBankCode: 4,
      fromDate: DateTime(2026, 11, 25),
      toDate: DateTime(2026, 11, 30),
      exportType: 'excel',
    );

    expect(request.toJson(), <String, dynamic>{
      'FromBANK_CODE': 1,
      'ToBANK_CODE': 4,
      'FromDate': '2026-11-25T00:00:00',
      'ToDate': '2026-11-30T00:00:00',
      'ReportName': 'AGL065',
      'ExportType': 'excel',
    });
  });
}
