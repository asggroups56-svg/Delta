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
    return BANKSDATAModel(
      bankCode: json['BANK_CODE'] as int?,
      bankName: json['BANK_NAME'] as String?,
      bankNameEng: json['BANK_NAME_ENG'] as String?,
      currencyName: json['CURRENCY_NAME'] as String?,
      notes: json['NOTES'] as String?,
      telNo1: json['TEL_NO1'] as String?,
      telNo2: json['TEL_NO2'] as String?,
      telNo3: json['TEL_NO3'] as String?,
      faxNo1: json['FAX_NO1'] as String?,
      faxNo2: json['FAX_NO2'] as String?,
      address: json['ADDRESS'] as String?,
      collectPeriod: json['COLLECT_PERIOD'] as String?,
      bankAccNo: (json['BANK_ACC_NO'] as num?)?.toDouble(),
      currencyCode: json['CURRENCY_CODE'] as String?,
      poBox: json['P_O_BOX'] as String?,
      sambleBox: json['SAMBLE_BOX'] as String?,
      analLytical: json['ANALLYTICAL'] as String?,
      city: json['CITY'] as String?,
      email: json['EMAIL'] as String?,
    );
  }

  static List<BANKSDATAModel> listFromResponse(dynamic data) {
    if (data == null) {
      return [];
    }

    final List<dynamic> jsonList =
        data is String ? jsonDecode(data) as List<dynamic> : data as List<dynamic>;

    return jsonList
        .map(
          (e) => BANKSDATAModel.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Default sample banks extracted from API response for fallback
  static List<BANKSDATAModel> get sampleBanks {
    const rawResponseData = "[{\"BANK_CODE\":1,\"BANK_NAME\":\"الانماء\",\"BANK_NAME_ENG\":\"Alinma Bank\",\"BANK_ACC_NO\":12012081.0},{\"BANK_CODE\":2,\"BANK_NAME\":\"الراجحي\",\"BANK_NAME_ENG\":\"Al Rajhi Bank\",\"BANK_ACC_NO\":12012011.0},{\"BANK_CODE\":3,\"BANK_NAME\":\"البنك الاهلي\",\"BANK_NAME_ENG\":\"SNB Bank\",\"BANK_ACC_NO\":12012071.0}]";
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
