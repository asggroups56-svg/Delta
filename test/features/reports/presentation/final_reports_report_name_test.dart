import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/presentation/view/widget/final_reports_filter_bottom_sheet_widget.dart';

void main() {
  test('maps every statement type and report type to its report name', () {
    const expected = <int, Map<int, String>>{
      1: {
        1: 'AGL034A',
        2: 'AGL038',
        3: 'AGL038A',
        4: 'AGL042',
        5: 'AGL042',
        6: 'AGL042',
      },
      2: {
        1: 'AGL035',
        2: 'AGL039',
        3: 'AGL039A',
        4: 'AGL043',
        5: 'AGL043',
        6: 'AGL041A',
      },
      3: {
        1: 'AGL036',
        2: 'AGL040',
        3: 'AGL040D',
        4: 'AGL044',
        5: 'AGL044',
        6: 'AGL040A',
      },
      4: {
        1: 'AGL069',
        2: 'AGL071',
        3: 'AGL068',
        4: 'AGL070',
        5: 'AGL070',
        6: 'AGL040A',
      },
      5: {
        1: 'AGL073',
        2: 'AGL075',
        3: 'AGL072',
        4: 'AGL074',
        5: 'AGL074',
        6: 'AGL040A',
      },
    };

    for (final statement in expected.entries) {
      for (final report in statement.value.entries) {
        expect(
          financialStatementReportName(
            financialStatementReportType: statement.key,
            reportType: report.key,
          ),
          report.value,
          reason: 'statement ${statement.key} with report type ${report.key}',
        );
      }
    }
  });

  test('falls back to AGL034A for an unknown combination', () {
    expect(
      financialStatementReportName(
        financialStatementReportType: 99,
        reportType: 99,
      ),
      'AGL034A',
    );
  });
}
