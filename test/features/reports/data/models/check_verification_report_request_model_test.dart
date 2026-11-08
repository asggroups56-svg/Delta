import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/check_verification_report_request_model.dart';

void main() {
  test('serializes the default check verification report payload', () {
    const request = CheckVerificationReportRequestModel();

    expect(request.toJson(), <String, dynamic>{
      'FromBANK_CODE': null,
      'ToBANK_CODE': null,
      'FromDate': null,
      'ToDate': null,
      'ReceiveName': null,
      'CheckStatus': 2,
      'ReportName': 'Ams003',
      'ExportType': 'pdf',
    });
  });

  test('serializes the filters and dates in yyyy-MM-dd format', () {
    final request = CheckVerificationReportRequestModel(
      fromBankCode: 1,
      toBankCode: 4,
      fromDate: DateTime(2026, 11, 25, 16, 30),
      toDate: DateTime(2026, 11, 30, 8, 15),
      receiveName: 'Recipient',
      checkStatus: 0,
      exportType: 'excelformatted',
    );

    expect(request.toJson(), <String, dynamic>{
      'FromBANK_CODE': 1,
      'ToBANK_CODE': 4,
      'FromDate': '2026-11-25',
      'ToDate': '2026-11-30',
      'ReceiveName': 'Recipient',
      'CheckStatus': 0,
      'ReportName': 'Ams003',
      'ExportType': 'excelformatted',
    });
  });
}
