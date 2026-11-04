class CurrencyDataLightModel {
  final String currencyCode;
  final String currencyName;

  const CurrencyDataLightModel({
    required this.currencyCode,
    required this.currencyName,
  });

  factory CurrencyDataLightModel.fromJson(Map<String, dynamic> json) {
    final normalized = {
      for (final entry in json.entries) entry.key.toLowerCase(): entry.value,
    };
    final code = normalized['currencycode'];
    if (code == null) {
      throw const FormatException(
        'Currency response item is missing currencyCode.',
      );
    }

    final name = normalized['currencyname'] ?? normalized['currencynameeng'];
    return CurrencyDataLightModel(
      currencyCode: code.toString(),
      currencyName: name?.toString() ?? code.toString(),
    );
  }
}

class CurrencyDataLightResponse {
  final List<CurrencyDataLightModel> currencies;

  const CurrencyDataLightResponse({required this.currencies});

  factory CurrencyDataLightResponse.fromJson(dynamic response) {
    final items = _findCurrencyList(response);
    if (items == null) {
      throw const FormatException(
        'Currency response does not contain a currency list.',
      );
    }
    return CurrencyDataLightResponse(
      currencies: items
          .map(
            (item) => CurrencyDataLightModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  static List<dynamic>? _findCurrencyList(dynamic value) {
    if (value is List) return value;
    if (value is! Map) return null;

    for (final entry in value.entries) {
      if (entry.key is String &&
          (entry.key as String).toLowerCase().contains('currency') &&
          entry.value is List) {
        return entry.value as List<dynamic>;
      }
    }
    for (final entry in value.values) {
      final nested = _findCurrencyList(entry);
      if (nested != null) return nested;
    }
    return null;
  }
}
