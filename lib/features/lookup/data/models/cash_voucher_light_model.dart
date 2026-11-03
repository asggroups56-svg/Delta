import 'dart:convert';

class CashVoucherLightModel {
  final String voucherNo;
  final String? description;
  final String? englishDescription;

  const CashVoucherLightModel({
    required this.voucherNo,
    this.description,
    this.englishDescription,
  });

  factory CashVoucherLightModel.fromJson(Map<String, dynamic> json) {
    final normalized = {
      for (final entry in json.entries) entry.key.toLowerCase(): entry.value,
    };
    final voucherNo = normalized['voucherno'] ??
        normalized['voucher_no'] ??
        normalized['vouchernumber'] ??
        normalized['voucherid'];
    if (voucherNo == null) {
      throw const FormatException(
        'Cash voucher response is missing its voucher number.',
      );
    }

    return CashVoucherLightModel(
      voucherNo: voucherNo.toString(),
      description: normalized['description']?.toString(),
      englishDescription:
          normalized['edescreption']?.toString() ??
          normalized['edescription']?.toString() ??
          normalized['englishdescription']?.toString(),
    );
  }
}

class CashVoucherLightResponse {
  final List<CashVoucherLightModel> vouchers;
  final bool hasMore;
  final int totalRecords;

  const CashVoucherLightResponse({
    required this.vouchers,
    required this.hasMore,
    required this.totalRecords,
  });

  factory CashVoucherLightResponse.fromJson(dynamic value) {
    final decoded = value is String ? jsonDecode(value) : value;
    final source = _findVoucherList(decoded);
    if (source == null) {
      throw const FormatException(
        'Cash voucher response does not contain a voucher list.',
      );
    }

    final vouchers = source
        .map(
          (item) => CashVoucherLightModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
    final root = decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    return CashVoucherLightResponse(
      vouchers: vouchers,
      hasMore: root?['hasMore'] as bool? ?? false,
      totalRecords: root?['totalRecords'] as int? ?? vouchers.length,
    );
  }

  static List<dynamic>? _findVoucherList(dynamic value) {
    if (value is List) return value;
    if (value is! Map) return null;

    for (final entry in value.entries) {
      if (entry.key is String &&
          (entry.key as String).toLowerCase().contains('voucher') &&
          entry.value is List) {
        return entry.value as List<dynamic>;
      }
    }
    for (final entry in value.entries) {
      if (entry.key is String &&
          const {'vouchers', 'items', 'data', 'result'}.contains(
            (entry.key as String).toLowerCase(),
          ) &&
          entry.value is List) {
        return entry.value as List<dynamic>;
      }
    }
    for (final entry in value.values) {
      final nested = _findVoucherList(entry);
      if (nested != null) return nested;
    }
    return null;
  }
}
