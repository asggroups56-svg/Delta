import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/company/data/models/company_model.dart';
import 'package:my_template/features/company/data/models/journal_config.dart';

void main() {
  group('JournalConfig.fromId', () {
    test('id=1 disables currency and cost centers', () {
      final config = JournalConfig.fromId(1);

      expect(config.id, 1);
      expect(config.usesCurrency, isFalse);
      expect(config.costCenters, CostCenterMode.none);
      expect(config.usesCostCenters, isFalse);
      expect(config.isKnown, isTrue);
    });

    test('id=2 enables currency without cost centers', () {
      final config = JournalConfig.fromId(2);

      expect(config.usesCurrency, isTrue);
      expect(config.costCenters, CostCenterMode.none);
      expect(config.usesCostCenters, isFalse);
      expect(config.isKnown, isTrue);
    });

    test('id=3 disables currency and cost centers', () {
      final config = JournalConfig.fromId(3);

      expect(config.usesCurrency, isFalse);
      expect(config.costCenters, CostCenterMode.none);
      expect(config.usesCostCenters, isFalse);
      expect(config.isKnown, isTrue);
    });

    test('id=4 enables currency and multiple cost centers', () {
      final config = JournalConfig.fromId(4);

      expect(config.usesCurrency, isTrue);
      expect(config.costCenters, CostCenterMode.multiple);
      expect(config.usesCostCenters, isTrue);
      expect(config.isKnown, isTrue);
    });

    test('id=5 enables currency and a single cost center', () {
      final config = JournalConfig.fromId(5);

      expect(config.usesCurrency, isTrue);
      expect(config.costCenters, CostCenterMode.single);
      expect(config.usesCostCenters, isTrue);
      expect(config.isKnown, isTrue);
    });

    test('id=6 disables currency and cost centers', () {
      final config = JournalConfig.fromId(6);

      expect(config.usesCurrency, isFalse);
      expect(config.costCenters, CostCenterMode.none);
      expect(config.usesCostCenters, isFalse);
      expect(config.isKnown, isTrue);
    });

    test('unknown or missing ids fall back to the plain configuration', () {
      for (final id in [null, 0, 7, 99]) {
        final config = JournalConfig.fromId(id);

        expect(config.id, id);
        expect(config.usesCurrency, isFalse);
        expect(config.costCenters, CostCenterMode.none);
        expect(config.isKnown, isFalse);
      }
    });
  });

  test('CompanyModel derives the journal config from vouichCurrCntr', () {
    final company = CompanyModel(vouichCurrCntr: 4);

    expect(company.journalConfig.id, 4);
    expect(company.journalConfig.usesCurrency, isTrue);
    expect(company.journalConfig.costCenters, CostCenterMode.multiple);
  });
}
