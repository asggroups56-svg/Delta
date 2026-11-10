import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/customer_datum_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/customer_datum_dropdown.dart';

class CustomerSupplierNotificationsReportFilter {
  final int dealingType;
  final double? fromCustomerNo;
  final double? toCustomerNo;
  final String? fromVoucherNo;
  final String? toVoucherNo;
  final int? fromTransNo;
  final int? toTransNo;
  final DateTime? fromTransDate;
  final DateTime? toTransDate;
  final int? fromAnalysisNo;
  final int? toAnalysisNo;
  final int typeTransacition;
  final int accountingSystemType;
  final int impactType;
  final int paymentType;
  final String exportType;

  const CustomerSupplierNotificationsReportFilter({
    required this.dealingType,
    required this.fromCustomerNo,
    required this.toCustomerNo,
    required this.fromVoucherNo,
    required this.toVoucherNo,
    required this.fromTransNo,
    required this.toTransNo,
    required this.fromTransDate,
    required this.toTransDate,
    required this.fromAnalysisNo,
    required this.toAnalysisNo,
    required this.typeTransacition,
    required this.accountingSystemType,
    required this.impactType,
    required this.paymentType,
    required this.exportType,
  });
}

class CustomerSupplierNotificationsReportFilterWidget extends StatefulWidget {
  final String title;

  const CustomerSupplierNotificationsReportFilterWidget({
    super.key,
    required this.title,
  });

  static Future<CustomerSupplierNotificationsReportFilter?> show(
    BuildContext context, {
    required String title,
  }) {
    return showModalBottomSheet<CustomerSupplierNotificationsReportFilter>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomerSupplierNotificationsReportFilterWidget(
        title: title,
      ),
    );
  }

  @override
  State<CustomerSupplierNotificationsReportFilterWidget> createState() =>
      _CustomerSupplierNotificationsReportFilterWidgetState();
}

class _CustomerSupplierNotificationsReportFilterWidgetState
    extends State<CustomerSupplierNotificationsReportFilterWidget> {
  final _fromVoucherController = TextEditingController();
  final _toVoucherController = TextEditingController();
  final _fromTransController = TextEditingController();
  final _toTransController = TextEditingController();
  final _fromAnalysisController = TextEditingController();
  final _toAnalysisController = TextEditingController();
  int _dealingType = 1;
  int _typeTransaction = 7;
  int _accountingSystemType = 1;
  int _impactType = 3;
  int _paymentType = 3;
  String _exportType = 'pdf';
  DateTime? _fromDate;
  DateTime? _toDate;
  CustomerDatumLightModel? _fromParty;
  CustomerDatumLightModel? _toParty;
  String? _error;

  bool get _isArabic => context.locale.languageCode == 'ar';
  CustomerDatumType get _partyType => _dealingType == 1
      ? CustomerDatumType.customer
      : CustomerDatumType.supplier;

  @override
  void dispose() {
    _fromVoucherController.dispose();
    _toVoucherController.dispose();
    _fromTransController.dispose();
    _toTransController.dispose();
    _fromAnalysisController.dispose();
    _toAnalysisController.dispose();
    super.dispose();
  }

  Future<void> _chooseDate({required bool from}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: (from ? _fromDate : _toDate) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (from) {
        _fromDate = DateUtils.dateOnly(selected);
      } else {
        _toDate = DateUtils.dateOnly(selected);
      }
      _error = null;
    });
  }

  int? _parseInt(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : int.tryParse(value);
  }

  void _submit() {
    if (_fromDate != null &&
        _toDate != null &&
        _fromDate!.isAfter(_toDate!)) {
      setState(() {
        _error = _isArabic
            ? 'تاريخ البداية يجب أن يسبق تاريخ النهاية'
            : 'From date must be before To date';
      });
      return;
    }

    final fromTrans = _parseInt(_fromTransController);
    final toTrans = _parseInt(_toTransController);
    final fromAnalysis = _parseInt(_fromAnalysisController);
    final toAnalysis = _parseInt(_toAnalysisController);
    final invalidNumeric = [
      (_fromTransController, fromTrans),
      (_toTransController, toTrans),
      (_fromAnalysisController, fromAnalysis),
      (_toAnalysisController, toAnalysis),
    ].any((entry) => entry.$1.text.trim().isNotEmpty && entry.$2 == null);
    if (invalidNumeric) {
      setState(() {
        _error = _isArabic
            ? 'تحقق من أرقام الحركات والتحليلات'
            : 'Check transaction and analysis numbers';
      });
      return;
    }

    Navigator.pop(
      context,
      CustomerSupplierNotificationsReportFilter(
        dealingType: _dealingType,
        fromCustomerNo: _fromParty?.customerNo.toDouble(),
        toCustomerNo: _toParty?.customerNo.toDouble(),
        fromVoucherNo: _emptyToNull(_fromVoucherController.text),
        toVoucherNo: _emptyToNull(_toVoucherController.text),
        fromTransNo: fromTrans,
        toTransNo: toTrans,
        fromTransDate: _fromDate,
        toTransDate: _toDate,
        fromAnalysisNo: fromAnalysis,
        toAnalysisNo: toAnalysis,
        typeTransacition: _typeTransaction,
        accountingSystemType: _accountingSystemType,
        impactType: _impactType,
        paymentType: _paymentType,
        exportType: _exportType,
      ),
    );
  }

  String? _emptyToNull(String value) => value.trim().isEmpty ? null : value.trim();

  String _dateLabel(DateTime? date, String hint) => date == null
      ? hint
      : MaterialLocalizations.of(context).formatMediumDate(date);

  Widget _numberRange(
    TextEditingController from,
    TextEditingController to, {
    required String fromLabel,
    required String toLabel,
    bool numeric = true,
  }) =>
      Row(
        children: [
          Expanded(
            child: CustomFormField(
              controller: from,
              title: fromLabel,
              keyboardType: numeric ? TextInputType.number : TextInputType.text,
              inputFormatters: numeric
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
            ),
          ),
          Gap(10.w),
          Expanded(
            child: CustomFormField(
              controller: to,
              title: toLabel,
              keyboardType: numeric ? TextInputType.number : TextInputType.text,
              inputFormatters: numeric
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
            ),
          ),
        ],
      );

  Widget _select<T extends Object>(
    String label,
    T value,
    List<DropdownMenuItem<T>> items,
    ValueChanged<T?> onChanged,
  ) =>
      DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        items: items,
        onChanged: onChanged,
      );

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.oceanBlue;
    final partyName = _dealingType == 1
        ? (_isArabic ? 'عميل' : 'Customer')
        : (_isArabic ? 'مورد' : 'Supplier');

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .92),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _select<int>(
                        _isArabic ? 'المتعامل' : 'Party type',
                        _dealingType,
                        [
                          DropdownMenuItem(
                            value: 1,
                            child: Text(_isArabic ? 'عملاء' : 'Customers'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text(_isArabic ? 'موردون' : 'Suppliers'),
                          ),
                        ],
                        (value) {
                          if (value != null && value != _dealingType) {
                            setState(() {
                              _dealingType = value;
                              _fromParty = null;
                              _toParty = null;
                            });
                          }
                        },
                      ),
                      Gap(12.h),
                      CustomerDatumDropdown(
                        key: ValueKey('from-party-$_dealingType'),
                        type: _partyType,
                        title: _isArabic ? 'من $partyName' : 'From $partyName',
                        hintText: _isArabic ? 'اختر $partyName' : 'Select $partyName',
                        initialValue: _fromParty,
                        onSelected: (value) => setState(() => _fromParty = value),
                      ),
                      Gap(12.h),
                      CustomerDatumDropdown(
                        key: ValueKey('to-party-$_dealingType'),
                        type: _partyType,
                        title: _isArabic ? 'إلى $partyName' : 'To $partyName',
                        hintText: _isArabic ? 'اختر $partyName' : 'Select $partyName',
                        initialValue: _toParty,
                        onSelected: (value) => setState(() => _toParty = value),
                      ),
                      Gap(12.h),
                      _numberRange(
                        _fromVoucherController,
                        _toVoucherController,
                        fromLabel: _isArabic ? 'من رقم الإشعار' : 'From voucher no.',
                        toLabel: _isArabic ? 'إلى رقم الإشعار' : 'To voucher no.',
                        numeric: false,
                      ),
                      Gap(12.h),
                      _numberRange(
                        _fromTransController,
                        _toTransController,
                        fromLabel: _isArabic ? 'من رقم الحركة' : 'From transaction no.',
                        toLabel: _isArabic ? 'إلى رقم الحركة' : 'To transaction no.',
                      ),
                      Gap(12.h),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _chooseDate(from: true),
                              icon: const Icon(Icons.calendar_today_rounded),
                              label: Text(_dateLabel(
                                _fromDate,
                                _isArabic ? 'من تاريخ' : 'From date',
                              )),
                            ),
                          ),
                          Gap(8.w),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _chooseDate(from: false),
                              icon: const Icon(Icons.calendar_today_rounded),
                              label: Text(_dateLabel(
                                _toDate,
                                _isArabic ? 'إلى تاريخ' : 'To date',
                              )),
                            ),
                          ),
                        ],
                      ),
                      Gap(12.h),
                      _numberRange(
                        _fromAnalysisController,
                        _toAnalysisController,
                        fromLabel: _isArabic ? 'من رقم التحليل' : 'From analysis no.',
                        toLabel: _isArabic ? 'إلى رقم التحليل' : 'To analysis no.',
                      ),
                      Gap(12.h),
                      _select<int>(
                        _isArabic ? 'نوع الحركة' : 'Transaction type',
                        _typeTransaction,
                        [
                          _item(1, _isArabic ? 'نقدًا' : 'Cash'),
                          _item(2, _isArabic ? 'أ. قبض' : 'Receipt voucher'),
                          _item(3, _isArabic ? 'أ. دفع' : 'Payment voucher'),
                          _item(4, _isArabic ? 'خصم' : 'Discount'),
                          _item(5, _isArabic ? 'إضافة' : 'Addition'),
                          _item(6, _isArabic ? 'كوبون' : 'Coupon'),
                          _item(7, _isArabic ? 'الجميع' : 'All'),
                        ],
                        (value) => setState(() => _typeTransaction = value ?? 7),
                      ),
                      Gap(12.h),
                      _select<int>(
                        _isArabic ? 'النظام المحاسبي' : 'Accounting system',
                        _accountingSystemType,
                        [
                          _item(1, _isArabic ? 'برنامج العملاء والموردين' : 'Customers and suppliers'),
                          _item(2, _isArabic ? 'برنامج الحسابات العامة' : 'General accounts'),
                        ],
                        (value) => setState(() => _accountingSystemType = value ?? 1),
                      ),
                      Gap(12.h),
                      _select<int>(
                        _isArabic ? 'نوع التأثير' : 'Impact type',
                        _impactType,
                        [
                          _item(1, _isArabic ? 'متحصلات' : 'Receipts'),
                          _item(2, _isArabic ? 'مدفوعات' : 'Payments'),
                          _item(3, _isArabic ? 'الجميع' : 'All'),
                        ],
                        (value) => setState(() => _impactType = value ?? 3),
                      ),
                      Gap(12.h),
                      _select<int>(
                        _isArabic ? 'نوع الدفع' : 'Payment type',
                        _paymentType,
                        [
                          _item(1, _isArabic ? 'دفعة مقدمة' : 'Advance payment'),
                          _item(2, _isArabic ? 'دفعة عادية' : 'Regular payment'),
                          _item(3, _isArabic ? 'الجميع' : 'All'),
                        ],
                        (value) => setState(() => _paymentType = value ?? 3),
                      ),
                      Gap(12.h),
                      _select<String>(
                        _isArabic ? 'صيغة التصدير' : 'Export format',
                        _exportType,
                        const [
                          DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                          DropdownMenuItem(value: 'excel', child: Text('Excel')),
                          DropdownMenuItem(value: 'excelformatted', child: Text('Excel formatted')),
                          DropdownMenuItem(value: 'word', child: Text('Word')),
                        ],
                        (value) => setState(() => _exportType = value ?? 'pdf'),
                      ),
                      Gap(12.h),
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'اسم التقرير' : 'Report name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: const Text('AAR020V'),
                      ),
                      if (_error != null) ...[
                        Gap(12.h),
                        Text(_error!, style: TextStyle(color: Colors.red, fontSize: 12.sp)),
                      ],
                      Gap(16.h),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                          ),
                          child: Text(_isArabic ? 'عرض التقرير' : 'Show report'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<int> _item(int value, String label) =>
      DropdownMenuItem(value: value, child: Text(label));
}
