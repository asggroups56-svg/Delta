class CustomerDatumLightModel {
  final int customerNo;
  final String customerName;
  final String customerNameEng;
  final String? currencyName;
  final int? currencyCode;
  final double exchangeRate;
  final String? custTaxNo;

  const CustomerDatumLightModel({
    required this.customerNo,
    required this.customerName,
    required this.customerNameEng,
    this.currencyName,
    this.currencyCode,
    required this.exchangeRate,
    this.custTaxNo,
  });

  factory CustomerDatumLightModel.fromJson(Map<String, dynamic> json) {
    return CustomerDatumLightModel(
      customerNo: json['customerNo'] as int,
      customerName: json['customerName'] as String,
      customerNameEng: json['customerNameEng'] as String,
      currencyName: json['currencyName'] as String?,
      currencyCode: json['currencyCode'] as int?,
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      custTaxNo: json['custTaxNo'] as String?,
    );
  }
}

class CustomerDatumLightResponse {
  final List<CustomerDatumLightModel> customerDatas;
  final bool hasMore;
  final bool success;
  final String message;
  final int totalRecords;

  const CustomerDatumLightResponse({
    required this.customerDatas,
    required this.hasMore,
    required this.success,
    required this.message,
    required this.totalRecords,
  });

  factory CustomerDatumLightResponse.fromJson(Map<String, dynamic> json) {
    return CustomerDatumLightResponse(
      customerDatas: (json['customerDatas'] as List)
          .map((e) => CustomerDatumLightModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['hasMore'] as bool,
      success: json['success'] as bool,
      message: json['message'] as String,
      totalRecords: json['totalRecords'] as int,
    );
  }
}
