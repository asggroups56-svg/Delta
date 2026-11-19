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
    dynamic v(String key) {
      if (json.containsKey(key)) return json[key];
      final lower = key.toLowerCase();
      for (final e in json.entries) {
        if (e.key.toLowerCase() == lower) return e.value;
      }
      return null;
    }

    return CompanyModel(
      deltaconfig: _asString(v('deltaconfig')),
      companyName: _asString(v('companyName')),
      companyEname: _asString(v('companyEname')),
      address: _asString(v('address')),
      addressE: _asString(v('addressE')),
      fiscalYearBegin: _asDate(v('fiscalYearBegin')),
      fiscalYearEnd: _asDate(v('fiscalYearEnd')),
      countryName: _asString(v('countryName')),
      countryCode: _asInt(v('countryCode')),
      cityName: _asString(v('cityName')),
      cityCode: _asInt(v('cityCode')),
      districtName: _asString(v('districtName')),
      districtEname: _asString(v('districtEname')),
      streetName: _asString(v('streetName')),
      buildingNo: _asString(v('buildingNo')),
      postalNo: _asString(v('postalNo')),
      additionNo: _asString(v('additionNo')),
      telNo1: _asString(v('telNo1')),
      telNo2: _asString(v('telNo2')),
      telNo3: _asString(v('telNo3')),
      fax: _asString(v('fax')),
      docNature: _asInt(v('docNature')),
      tradeReg: _asString(v('tradeReg')),
      eMail: _asString(v('eMail')),
      currency: _asString(v('currency')),
      ecurrency: _asString(v('ecurrency')),
      currencyFraction: _asString(v('currencyFraction')),
      ecurrencyFraction: _asString(v('ecurrencyFraction')),
      cashAcc: _asInt(v('cashAcc')),
      currReavalAcc: _asInt(v('currReavalAcc')),
      profitLossAcctNo: _asInt(v('profitLossAcctNo')),
      taxAcc: _asInt(v('taxAcc')),
      purchRetAcc: _asInt(v('purchRetAcc')),
      purchaseAcc: _asInt(v('purchaseAcc')),
      salesAcc: _asInt(v('salesAcc')),
      salesDisAcc: _asInt(v('salesDisAcc')),
      salesRetAcc: _asInt(v('salesRetAcc')),
      purDisAcc: _asInt(v('purDisAcc')),
      cusAcc: _asInt(v('cusAcc')),
      suppAcc: _asInt(v('suppAcc')),
      salTaxAcc: _asInt(v('salTaxAcc')),
      purTaxAcc: _asInt(v('purTaxAcc')),
      advAcc: _asInt(v('advAcc')),
      retAcc: _asInt(v('retAcc')),
      taxTerm: _asInt(v('taxTerm')),
      taxVal: _asDouble(v('taxVal')),
      taxReg: _asString(v('taxReg')),
      taxNew: _asDouble(v('taxNew')),
      vouichCurrCntr: _asInt(v('vouichCurrCntr')),
      noOfLevels: _asInt(v('noOfLevels')),
      delVoucher: _asInt(v('delVoucher')),
      instAgain: _asInt(v('instAgain')),
      noOfGrids: _asInt(v('noOfGrids')),
      vouchline: _asInt(v('vouchline')),
      descCode: _asInt(v('descCode')),
      modName: _asInt(v('modName')),
      jrlUpdate: _asInt(v('jrlUpdate')),
      reportsRange: _asInt(v('reportsRange')),
      multiDiv: _asInt(v('multiDiv')),
      integral: _asInt(v('integral')),
      showAssistant: _asInt(v('showAssistant')),
      modDate: _asInt(v('modDate')),
      subMan: _asInt(v('subMan')),
      linkInvoice: _asInt(v('linkInvoice')),
      invoiceSign: _asString(v('invoiceSign')),
      debitSign: _asString(v('debitSign')),
      creditSign: _asString(v('creditSign')),
      advanceSign: _asString(v('advanceSign')),
      advCrnSign: _asString(v('advCrnSign')),
      decimal3: _asInt(v('decimal3')),
      decimal4: _asInt(v('decimal4')),
      decimal5: _asInt(v('decimal5')),
      separator: _asInt(v('separator')),
      accBal: _asInt(v('accBal')),
      cenBal: _asInt(v('cenBal')),
      cenAccBal: _asInt(v('cenAccBal')),
    );
  }
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
      dynamic findKey(Map map, String target) {
        final t = target.toLowerCase();
        for (final e in map.entries) {
          if (e.key.toString().toLowerCase() == t) return e.value;
        }
        return null;
      }

      final raw = findKey(json, 'companies') ??
          findKey(json, 'data') ??
          findKey(json, 'items');

      if (raw is List) {
        return CompanyResponse(
          companies: [
            for (final item in raw)
              if (item is Map)
                CompanyModel.fromJson(Map<String, dynamic>.from(item)),
          ],
        );
      }

      if (findKey(json, 'companyname') != null ||
          findKey(json, 'deltaconfig') != null) {
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
