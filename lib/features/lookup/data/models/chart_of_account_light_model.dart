class ChartOfAccountLightModel {
  final int accountNo;
  final int? accountLevel;
  final String accountName;
  final int? accountParent;
  final int? cauDistributed;
  final int? currencyCode;
  final String? currencyName;
  final double? currencyExchangeRate;

  const ChartOfAccountLightModel({
    required this.accountNo,
    required this.accountLevel,
    required this.accountName,
    required this.accountParent,
    required this.cauDistributed,
    this.currencyCode,
    this.currencyName,
    this.currencyExchangeRate,
  });

  factory ChartOfAccountLightModel.fromJson(Map<String, dynamic> json) {
    return ChartOfAccountLightModel(
      accountNo:
          _parseInt(json['accountNo']) ??
          (throw const FormatException(
            'Chart of account response is missing accountNo.',
          )),
      accountLevel: _parseInt(json['accountLevel']),
      accountName: json['accountName']?.toString() ?? '',
      accountParent: _parseInt(json['accountParent']),
      cauDistributed: _parseInt(json['cauDistributed']),
      currencyCode: _parseInt(json['currencyCode']),
      currencyName: json['currencyName']?.toString(),
      currencyExchangeRate: (json['currencyExchangeRate'] as num?)?.toDouble(),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}

class ChartOfAccountLightResponse {
  final List<ChartOfAccountLightModel> chartOfAccounts;
  final bool hasMore;
  final bool success;
  final String message;
  final int totalRecords;

  const ChartOfAccountLightResponse({
    required this.chartOfAccounts,
    required this.hasMore,
    required this.success,
    required this.message,
    required this.totalRecords,
  });

  factory ChartOfAccountLightResponse.fromJson(Map<String, dynamic> json) {
    return ChartOfAccountLightResponse(
      chartOfAccounts: (json['chartOfAccounts'] as List)
          .map(
            (e) => ChartOfAccountLightModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      hasMore: json['hasMore'] as bool,
      success: json['success'] as bool,
      message: json['message'] as String,
      totalRecords: json['totalRecords'] as int,
    );
  }
}
