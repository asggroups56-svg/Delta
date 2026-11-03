class ChartOfAccountLightModel {
  final int accountNo;
  final int accountLevel;
  final String accountName;
  final int accountParent;
  final int cauDistributed;
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
      accountNo: json['accountNo'] as int,
      accountLevel: json['accountLevel'] as int,
      accountName: json['accountName'] as String,
      accountParent: json['accountParent'] as int,
      cauDistributed: json['cauDistributed'] as int,
      currencyCode: json['currencyCode'] as int?,
      currencyName: json['currencyName'] as String?,
      currencyExchangeRate: (json['currencyExchangeRate'] as num?)?.toDouble(),
    );
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
          .map((e) => ChartOfAccountLightModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['hasMore'] as bool,
      success: json['success'] as bool,
      message: json['message'] as String,
      totalRecords: json['totalRecords'] as int,
    );
  }
}
