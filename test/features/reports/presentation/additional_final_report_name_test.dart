import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/presentation/view/widget/additional_final_report_filter_bottom_sheet_widget.dart';

void main() {
  test('maps each selection to its additional final report name', () {
    const expected = <int, String>{
      1: 'AGL037A',
      2: 'AGL041',
      3: 'AGL045A',
      4: 'AGL041B',
      5: 'AGL045C',
      6: 'AGL045B',
    };

    for (final entry in expected.entries) {
      expect(
        additionalFinalReportName(entry.key),
        entry.value,
        reason: 'variant ${entry.key}',
      );
    }
  });

  test('falls back to AGL037A for an unknown variant', () {
    expect(additionalFinalReportName(99), 'AGL037A');
  });
}
