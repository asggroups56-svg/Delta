class CostCenterLightModel {
  final num costCenterNo;
  final String centerName;
  final int? centerParent;
  final double? debit;
  final double? credit;

  const CostCenterLightModel({
    required this.costCenterNo,
    required this.centerName,
    this.centerParent,
    this.debit,
    this.credit,
  });

  factory CostCenterLightModel.fromJson(Map<String, dynamic> json) {
    return CostCenterLightModel(
      costCenterNo: (json['costCenterNo'] as num?) ?? 0,
      centerName: (json['centerName'] as String?) ?? '',
      centerParent: json['centerParent'] as int?,
      debit: (json['debit'] as num?)?.toDouble(),
      credit: (json['credit'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'costCenterNo': costCenterNo,
    'centerName': centerName,
    'centerParent': centerParent,
    'debit': debit,
    'credit': credit,
  };
}

class CostCenterLightResponse {
  final List<CostCenterLightModel> costCenters;
  final bool hasMore;
  final bool success;
  final String message;
  final int totalRecords;

  const CostCenterLightResponse({
    required this.costCenters,
    required this.hasMore,
    required this.success,
    required this.message,
    required this.totalRecords,
  });

  factory CostCenterLightResponse.fromJson(Map<String, dynamic> json) {
    final list = json['costCenters'] as List? ?? [];
    return CostCenterLightResponse(
      costCenters: list
          .map((e) => CostCenterLightModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['hasMore'] as bool? ?? false,
      success: json['success'] as bool? ?? true,
      message: (json['message'] as String?) ?? '',
      totalRecords: (json['totalRecords'] as int?) ?? list.length,
    );
  }
}
