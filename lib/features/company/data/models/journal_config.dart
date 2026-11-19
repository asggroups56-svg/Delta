import 'company_model.dart';

/// Cost-center handling configured for journals/vouchers.
enum CostCenterMode {
  /// Journals never ask for a cost center.
  none,

  /// Journals can use any cost center.
  multiple,

  /// Journals are limited to a single cost center.
  single,
}

/// Journal (voucher) configuration derived from the company setting
/// `vouichCurrCntr`.
///
/// The id decides whether vouchers carry a currency and/or cost centers:
///
/// | id | Currency | Cost centers |
/// |----|----------|--------------|
/// | 1  | no       | none         |
/// | 2  | yes      | none         |
/// | 3  | no       | none         |
/// | 4  | yes      | multiple     |
/// | 5  | yes      | one          |
/// | 6  | no       | none         |
class JournalConfig {
  /// Raw configuration id (`vouichCurrCntr`).
  final int? id;

  /// Whether vouchers use a currency field.
  final bool usesCurrency;

  /// Which cost-center mode vouchers use.
  final CostCenterMode costCenters;

  const JournalConfig({
    required this.id,
    required this.usesCurrency,
    required this.costCenters,
  });

  factory JournalConfig.fromId(int? id) {
    switch (id) {
      case 2:
        return const JournalConfig(
          id: 2,
          usesCurrency: true,
          costCenters: CostCenterMode.none,
        );
      case 4:
        return const JournalConfig(
          id: 4,
          usesCurrency: true,
          costCenters: CostCenterMode.multiple,
        );
      case 5:
        return const JournalConfig(
          id: 5,
          usesCurrency: true,
          costCenters: CostCenterMode.single,
        );
      // ids 1, 3 and 6 share the plain configuration; unknown ids fall back
      // to the safest option instead of enabling features that may not exist.
      case 1:
      case 3:
      case 6:
      default:
        return JournalConfig(
          id: id,
          usesCurrency: false,
          costCenters: CostCenterMode.none,
        );
    }
  }

  /// Whether any cost-center mode is active.
  bool get usesCostCenters => costCenters != CostCenterMode.none;

  /// Whether [id] is one of the six documented configurations.
  bool get isKnown => id != null && id! >= 1 && id! <= 6;
}

extension CompanyJournalConfig on CompanyModel {
  /// Journal configuration stored on the company record.
  JournalConfig get journalConfig => JournalConfig.fromId(vouichCurrCntr);
}
