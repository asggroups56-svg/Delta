import 'dart:convert';
import 'package:equatable/equatable.dart';

class BANKSDATAModel extends Equatable {
  final int? bankCode;
  final String? bankName;
  final String? bankNameEng;
  final String? currencyName;
  final String? notes;
  final String? telNo1;
  final String? telNo2;
  final String? telNo3;
  final String? faxNo1;
  final String? faxNo2;
  final String? address;
  final String? collectPeriod;
  final double? bankAccNo;
  final String? currencyCode;
  final String? poBox;
  final String? sambleBox;
  final String? analLytical;
  final String? city;
  final String? email;

  const BANKSDATAModel({
    this.bankCode,
    this.bankName,
    this.bankNameEng,
    this.currencyName,
    this.notes,
    this.telNo1,
    this.telNo2,
    this.telNo3,
    this.faxNo1,
    this.faxNo2,
    this.address,
    this.collectPeriod,
    this.bankAccNo,
    this.currencyCode,
    this.poBox,
    this.sambleBox,
    this.analLytical,
    this.city,
    this.email,
  });

  factory BANKSDATAModel.fromJson(Map<String, dynamic> json) {
    final normalized = {
      for (final entry in json.entries)
        entry.key.toLowerCase().replaceAll('_', ''): entry.value,
    };
    dynamic value(String key) =>
        normalized[key.toLowerCase().replaceAll('_', '')];
    int? intValue(String key) {
      final raw = value(key);
      if (raw is int) return raw;
      if (raw is num) return raw.toInt();
      return int.tryParse(raw?.toString() ?? '');
    }

    double? doubleValue(String key) {
      final raw = value(key);
      if (raw is num) return raw.toDouble();
      return double.tryParse(raw?.toString() ?? '');
    }

    String? stringValue(String key) {
      final raw = value(key);
      return raw?.toString();
    }

    return BANKSDATAModel(
      bankCode: intValue('BANK_CODE'),
      bankName: stringValue('BANK_NAME'),
      bankNameEng: stringValue('BANK_NAME_ENG'),
      currencyName: stringValue('CURRENCY_NAME'),
      notes: stringValue('NOTES'),
      telNo1: stringValue('TEL_NO1'),
      telNo2: stringValue('TEL_NO2'),
      telNo3: stringValue('TEL_NO3'),
      faxNo1: stringValue('FAX_NO1'),
      faxNo2: stringValue('FAX_NO2'),
      address: stringValue('ADDRESS'),
      collectPeriod: stringValue('COLLECT_PERIOD'),
      bankAccNo: doubleValue('BANK_ACC_NO'),
      currencyCode: stringValue('CURRENCY_CODE'),
      poBox: stringValue('P_O_BOX'),
      sambleBox: stringValue('SAMBLE_BOX'),
      analLytical: stringValue('ANALLYTICAL'),
      city: stringValue('CITY'),
      email: stringValue('EMAIL'),
    );
  }

  static List<BANKSDATAModel> listFromResponse(dynamic data) {
    if (data == null) {
      return [];
    }

    final decoded = data is String ? jsonDecode(data) : data;
    final jsonList = _findBankList(decoded);
    if (jsonList == null) {
      throw const FormatException(
        'Bank response does not contain a bank list.',
      );
    }

    return jsonList
        .map((e) => BANKSDATAModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<dynamic>? _findBankList(dynamic value) {
    if (value is List) return value;
    if (value is! Map) return null;

    for (final entry in value.entries) {
      if (entry.key is String &&
          (entry.key as String).toLowerCase().contains('bank') &&
          entry.value is List) {
        return entry.value as List<dynamic>;
      }
    }
    for (final entry in value.values) {
      final nested = _findBankList(entry);
      if (nested != null) return nested;
    }
    return null;
  }

  /// Default sample banks extracted from API response for fallback
  static List<BANKSDATAModel> get sampleBanks {
    const rawResponseData =
        "[{\"BANK_CODE\":1,\"BANK_NAME\":\"الانماء\",\"BANK_NAME_ENG\":\"Alinma Bank\",\"BANK_ACC_NO\":12012081.0},{\"BANK_CODE\":2,\"BANK_NAME\":\"الراجحي\",\"BANK_NAME_ENG\":\"Al Rajhi Bank\",\"BANK_ACC_NO\":12012011.0},{\"BANK_CODE\":3,\"BANK_NAME\":\"البنك الاهلي\",\"BANK_NAME_ENG\":\"SNB Bank\",\"BANK_ACC_NO\":12012071.0}]";
    return listFromResponse(rawResponseData);
  }

  @override
  List<Object?> get props => [
    bankCode,
    bankName,
    bankNameEng,
    currencyName,
    notes,
    telNo1,
    telNo2,
    telNo3,
    faxNo1,
    faxNo2,
    address,
    collectPeriod,
    bankAccNo,
    currencyCode,
    poBox,
    sambleBox,
    analLytical,
    city,
    email,
  ];
}
