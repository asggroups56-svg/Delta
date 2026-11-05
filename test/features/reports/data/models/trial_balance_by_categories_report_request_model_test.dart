import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/trial_balance_by_categories_report_request_model.dart';

void main() {
  test('defaults to the unordered report and PDF export', () {
    final request = TrialBalanceByCategoriesReportRequestModel();

    expect(request.toJson(), <String, dynamic>{
      'ReportName': 'AGL055',
      'ExportType': 'pdf',
    });
  });

  test('supports the numeric ordering report and other export formats', () {
    final request = TrialBalanceByCategoriesReportRequestModel(
      reportName: 'AGL055H',
      exportType: 'excelformatted',
    );

    expect(request.toJson(), <String, dynamic>{
      'ReportName': 'AGL055H',
      'ExportType': 'excelformatted',
    });
  });
}
