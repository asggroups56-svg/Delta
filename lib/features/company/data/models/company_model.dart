/// A single company record returned by the `Company` endpoint.
class CompanyModel {
  final String? deltaconfig;
  final String? companyName;
  final String? companyEname;
  final String? address;
  final String? addressE;
  final DateTime? fiscalYearBegin;
  final DateTime? fiscalYearEnd;
  final String? countryName;
  final int? countryCode;
  final String? cityName;
  final int? cityCode;
  final String? districtName;
  final String? districtEname;
  final String? streetName;
  final String? buildingNo;
  final String? postalNo;
  final String? additionNo;
  final String? telNo1;
  final String? telNo2;
  final String? telNo3;
  final String? fax;
  final int? docNature;
  final String? tradeReg;
  final String? eMail;
  final String? currency;
  final String? ecurrency;
  final String? currencyFraction;
  final String? ecurrencyFraction;
  final int? cashAcc;
  final int? currReavalAcc;
  final int? profitLossAcctNo;
  final int? taxAcc;
  final int? purchRetAcc;
  final int? purchaseAcc;
  final int? salesAcc;
  final int? salesDisAcc;
  final int? salesRetAcc;
  final int? purDisAcc;
  final int? cusAcc;
  final int? suppAcc;
  final int? salTaxAcc;
  final int? purTaxAcc;
  final int? advAcc;
  final int? retAcc;
  final int? taxTerm;
  final double? taxVal;
  final String? taxReg;
  final double? taxNew;
  final int? vouichCurrCntr;
  final int? noOfLevels;
  final int? delVoucher;
  final int? instAgain;
  final int? noOfGrids;
  final int? vouchline;
  final int? descCode;
  final int? modName;
  final int? jrlUpdate;
  final int? reportsRange;
  final int? multiDiv;
  final int? integral;
  final int? showAssistant;
  final int? modDate;
  final int? subMan;
  final int? linkInvoice;
  final String? invoiceSign;
  final String? debitSign;
  final String? creditSign;
  final String? advanceSign;
  final String? advCrnSign;
  final int? decimal3;
  final int? decimal4;
  final int? decimal5;
  final int? separator;
  final int? accBal;
  final int? cenBal;
  final int? cenAccBal;

  const CompanyModel({
    this.deltaconfig,
    this.companyName,
    this.companyEname,
    this.address,
    this.addressE,
    this.fiscalYearBegin,
    this.fiscalYearEnd,
    this.countryName,
    this.countryCode,
    this.cityName,
    this.cityCode,
    this.districtName,
    this.districtEname,
    this.streetName,
    this.buildingNo,
    this.postalNo,
    this.additionNo,
    this.telNo1,
    this.telNo2,
    this.telNo3,
    this.fax,
    this.docNature,
    this.tradeReg,
    this.eMail,
    this.currency,
    this.ecurrency,
    this.currencyFraction,
    this.ecurrencyFraction,
    this.cashAcc,
    this.currReavalAcc,
    this.profitLossAcctNo,
    this.taxAcc,
    this.purchRetAcc,
    this.purchaseAcc,
    this.salesAcc,
    this.salesDisAcc,
    this.salesRetAcc,
    this.purDisAcc,
    this.cusAcc,
    this.suppAcc,
    this.salTaxAcc,
    this.purTaxAcc,
    this.advAcc,
    this.retAcc,
    this.taxTerm,
    this.taxVal,
    this.taxReg,
    this.taxNew,
    this.vouichCurrCntr,
    this.noOfLevels,
    this.delVoucher,
    this.instAgain,
    this.noOfGrids,
    this.vouchline,
    this.descCode,
    this.modName,
    this.jrlUpdate,
    this.reportsRange,
    this.multiDiv,
    this.integral,
    this.showAssistant,
    this.modDate,
    this.subMan,
    this.linkInvoice,
    this.invoiceSign,
    this.debitSign,
    this.creditSign,
    this.advanceSign,
    this.advCrnSign,
    this.decimal3,
    this.decimal4,
    this.decimal5,
    this.separator,
    this.accBal,
    this.cenBal,
    this.cenAccBal,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      deltaconfig: _asString(json['deltaconfig']),
      companyName: _asString(json['companyName']),
      companyEname: _asString(json['companyEname']),
      address: _asString(json['address']),
      addressE: _asString(json['addressE']),
      fiscalYearBegin: _asDate(json['fiscalYearBegin']),
      fiscalYearEnd: _asDate(json['fiscalYearEnd']),
      countryName: _asString(json['countryName']),
      countryCode: _asInt(json['countryCode']),
      cityName: _asString(json['cityName']),
      cityCode: _asInt(json['cityCode']),
      districtName: _asString(json['districtName']),
      districtEname: _asString(json['districtEname']),
      streetName: _asString(json['streetName']),
      buildingNo: _asString(json['buildingNo']),
      postalNo: _asString(json['postalNo']),
      additionNo: _asString(json['additionNo']),
      telNo1: _asString(json['telNo1']),
      telNo2: _asString(json['telNo2']),
      telNo3: _asString(json['telNo3']),
      fax: _asString(json['fax']),
      docNature: _asInt(json['docNature']),
      tradeReg: _asString(json['tradeReg']),
      eMail: _asString(json['eMail']),
      currency: _asString(json['currency']),
      ecurrency: _asString(json['ecurrency']),
      currencyFraction: _asString(json['currencyFraction']),
      ecurrencyFraction: _asString(json['ecurrencyFraction']),
      cashAcc: _asInt(json['cashAcc']),
      currReavalAcc: _asInt(json['currReavalAcc']),
      profitLossAcctNo: _asInt(json['profitLossAcctNo']),
      taxAcc: _asInt(json['taxAcc']),
      purchRetAcc: _asInt(json['purchRetAcc']),
      purchaseAcc: _asInt(json['purchaseAcc']),
      salesAcc: _asInt(json['salesAcc']),
      salesDisAcc: _asInt(json['salesDisAcc']),
      salesRetAcc: _asInt(json['salesRetAcc']),
      purDisAcc: _asInt(json['purDisAcc']),
      cusAcc: _asInt(json['cusAcc']),
      suppAcc: _asInt(json['suppAcc']),
      salTaxAcc: _asInt(json['salTaxAcc']),
      purTaxAcc: _asInt(json['purTaxAcc']),
      advAcc: _asInt(json['advAcc']),
      retAcc: _asInt(json['retAcc']),
      taxTerm: _asInt(json['taxTerm']),
      taxVal: _asDouble(json['taxVal']),
      taxReg: _asString(json['taxReg']),
      taxNew: _asDouble(json['taxNew']),
      vouichCurrCntr: _asInt(json['vouichCurrCntr']),
      noOfLevels: _asInt(json['noOfLevels']),
      delVoucher: _asInt(json['delVoucher']),
      instAgain: _asInt(json['instAgain']),
      noOfGrids: _asInt(json['noOfGrids']),
      vouchline: _asInt(json['vouchline']),
      descCode: _asInt(json['descCode']),
      modName: _asInt(json['modName']),
      jrlUpdate: _asInt(json['jrlUpdate']),
      reportsRange: _asInt(json['reportsRange']),
      multiDiv: _asInt(json['multiDiv']),
      integral: _asInt(json['integral']),
      showAssistant: _asInt(json['showAssistant']),
      modDate: _asInt(json['modDate']),
      subMan: _asInt(json['subMan']),
      linkInvoice: _asInt(json['linkInvoice']),
      invoiceSign: _asString(json['invoiceSign']),
      debitSign: _asString(json['debitSign']),
      creditSign: _asString(json['creditSign']),
      advanceSign: _asString(json['advanceSign']),
      advCrnSign: _asString(json['advCrnSign']),
      decimal3: _asInt(json['decimal3']),
      decimal4: _asInt(json['decimal4']),
      decimal5: _asInt(json['decimal5']),
      separator: _asInt(json['separator']),
      accBal: _asInt(json['accBal']),
      cenBal: _asInt(json['cenBal']),
      cenAccBal: _asInt(json['cenAccBal']),
    );
  }

  /// Primary name for the requested language.
  String name(bool isArabic) {
    final primary = isArabic ? companyName : companyEname;
    final secondary = isArabic ? companyEname : companyName;
    return primary ?? secondary ?? '';
  }

  /// Secondary name for subtitle display.
  String? secondaryName(bool isArabic) {
    final primary = isArabic ? companyName : companyEname;
    final secondary = isArabic ? companyEname : companyName;
    final value = secondary ?? '';
    if (value.isEmpty || value == primary) return null;
    return value;
  }

  /// Combined full street address.
  String? fullAddress(bool isArabic) {
    final parts = <String?>[
      isArabic ? address : (addressE ?? address),
      streetName,
      isArabic ? districtName : (districtEname ?? districtName),
      cityName,
      countryName,
    ].where((part) => part != null && part.trim().isNotEmpty).toList();
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  /// Available phone numbers.
  List<String> get phones => [telNo1, telNo2, telNo3]
      .where((phone) => phone != null && phone.trim().isNotEmpty)
      .cast<String>()
      .toList();

  /// Currency with fraction, e.g. "ريال سعودي (هلله)".
  String? get currencyLabel {
    final name = currency ?? ecurrency;
    if (name == null) return null;
    final fraction = currencyFraction ?? ecurrencyFraction;
    return fraction == null ? name : '$name ($fraction)';
  }

  String? get taxValLabel => _formatRate(taxVal);
  String? get taxNewLabel => _formatRate(taxNew);
}

String? _formatRate(double? value) {
  if (value == null) return null;
  final text = value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toString();
  return '$text%';
}

/// Wrapper for `{ "companies": [ ... ] }`.
class CompanyResponse {
  final List<CompanyModel> companies;

  const CompanyResponse({required this.companies});

  factory CompanyResponse.fromJson(dynamic json) {
    if (json == null) return const CompanyResponse(companies: []);

    if (json is List) {
      return CompanyResponse(
        companies: [
          for (final item in json)
            if (item is Map)
              CompanyModel.fromJson(Map<String, dynamic>.from(item)),
        ],
      );
    }

    if (json is Map) {
      final raw = json['companies'] ?? json['Companies'] ?? json['data'] ?? json['items'];
      if (raw is List) {
        return CompanyResponse(
          companies: [
            for (final item in raw)
              if (item is Map)
                CompanyModel.fromJson(Map<String, dynamic>.from(item)),
          ],
        );
      }

      if (json.containsKey('companyName') ||
          json.containsKey('companyname') ||
          json.containsKey('deltaconfig')) {
        return CompanyResponse(
          companies: [CompanyModel.fromJson(Map<String, dynamic>.from(json))],
        );
      }
    }

    return const CompanyResponse(companies: []);
  }

  bool get isEmpty => companies.isEmpty;
  CompanyModel? get first => companies.isEmpty ? null : companies.first;
}

String? _asString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString().trim());
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString().trim());
}

DateTime? _asDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString().trim());
}
