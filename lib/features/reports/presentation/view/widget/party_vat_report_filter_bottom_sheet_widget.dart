import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/lookup/data/models/customer_datum_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/customer_datum_dropdown.dart';

class PartyVatReportFilterSelection {
  final double? fromCustomerNo;
  final double? toCustomerNo;
  final String? fromItemCode;
  final String? toItemCode;
  final int? fromDocId;
  final int? toDocId;
  final DateTime? fromTransDate;
  final DateTime? toTransDate;
  final int documentType;
  final int accountingSystem;
  final int taxTreatment;
  final int taxPeriod;
  final String exportType;

  const PartyVatReportFilterSelection({
    this.fromCustomerNo,
    this.toCustomerNo,
    this.fromItemCode,
    this.toItemCode,
    this.fromDocId,
    this.toDocId,
    this.fromTransDate,
    this.toTransDate,
    this.documentType = 5,
    this.accountingSystem = 1,
    this.taxTreatment = 1,
    this.taxPeriod = 3,
    this.exportType = 'pdf',
  });
}

class PartyVatReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String reportCode;
  final CustomerDatumType type;

  const PartyVatReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    required this.reportCode,
    required this.type,
  });

  static Future<PartyVatReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    required String reportCode,
    required CustomerDatumType type,
  }) {
    return showModalBottomSheet<PartyVatReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PartyVatReportFilterBottomSheetWidget(
        title: title,
        reportCode: reportCode,
        type: type,
      ),
    );
  }

  @override
  State<PartyVatReportFilterBottomSheetWidget> createState() =>
      _PartyVatReportFilterBottomSheetWidgetState();
}

class _PartyVatReportFilterBottomSheetWidgetState
    extends State<PartyVatReportFilterBottomSheetWidget> {
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _includeDates = false;
  CustomerDatumLightModel? _fromParty;
  CustomerDatumLightModel? _toParty;
  final _fromItemCodeController = TextEditingController();
  final _toItemCodeController = TextEditingController();
  final _fromDocIdController = TextEditingController();
  final _toDocIdController = TextEditingController();
  int _documentType = 5;
  int _accountingSystem = 1;
  int _taxTreatment = 1;
  int _taxPeriod = 3;
  String _exportType = 'pdf';
  String? _validationMessage;

  bool get _isArabic => context.locale.languageCode == 'ar';
  bool get _isSales => widget.reportCode == 'AAR1000';
  bool get _isPurchases => widget.reportCode == 'AAR1001';
  bool get _isExpenses => widget.reportCode == 'AGL1001E';

  @override
  void initState() {
    super.initState();
    _documentType = _isSales ? 5 : 3;
    if (_isExpenses) _taxTreatment = 3;
  }

  @override
  void dispose() {
    _fromItemCodeController.dispose();
    _toItemCodeController.dispose();
    _fromDocIdController.dispose();
    _toDocIdController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({required bool isFromDate}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: (isFromDate ? _fromDate : _toDate) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected == null || !mounted) return;

    setState(() {
      if (isFromDate) {
        _fromDate = DateUtils.dateOnly(selected);
      } else {
        _toDate = DateUtils.dateOnly(selected);
      }
      _validationMessage = null;
    });
  }

  String _formatDate(DateTime date) {
    return MaterialLocalizations.of(context).formatMediumDate(date);
  }

  void _submit() {
    if (_includeDates &&
        _fromDate != null &&
        _toDate != null &&
        _fromDate!.isAfter(_toDate!)) {
      setState(() {
        _validationMessage = AppLocaleKey.invalidDateRange.tr();
      });
      return;
    }

    final fromItemCode = _fromItemCodeController.text.trim();
    final toItemCode = _toItemCodeController.text.trim();
    if (fromItemCode.isEmpty != toItemCode.isEmpty) {
      setState(() {
        _validationMessage = _isArabic
            ? 'أدخل رمز الصنف من وإلى معًا أو اتركهما فارغين'
            : 'Enter both from and to item codes, or leave both empty';
      });
      return;
    }

    final fromDocIdText = _fromDocIdController.text.trim();
    final toDocIdText = _toDocIdController.text.trim();
    final fromDocId = fromDocIdText.isEmpty
        ? null
        : int.tryParse(fromDocIdText);
    final toDocId = toDocIdText.isEmpty ? null : int.tryParse(toDocIdText);

    if (fromDocIdText.isEmpty != toDocIdText.isEmpty ||
        (fromDocIdText.isNotEmpty && fromDocId == null) ||
        (toDocIdText.isNotEmpty && toDocId == null)) {
      setState(() {
        _validationMessage = _isArabic
            ? 'أدخل معرف المستند من وإلى بشكل صحيح'
            : 'Enter a valid from and to document ID';
      });
      return;
    }
    if (fromDocId != null && toDocId != null && fromDocId > toDocId) {
      setState(() {
        _validationMessage = _isArabic
            ? 'معرف المستند (من) يجب أن يسبق أو يساوي (إلى)'
            : 'From document ID must be less than or equal to To';
      });
      return;
    }

    Navigator.pop(
      context,
      PartyVatReportFilterSelection(
        fromCustomerNo: _fromParty?.customerNo.toDouble(),
        toCustomerNo: _toParty?.customerNo.toDouble(),
        fromItemCode: fromItemCode.isNotEmpty ? fromItemCode : null,
        toItemCode: toItemCode.isNotEmpty ? toItemCode : null,
        fromDocId: fromDocId,
        toDocId: toDocId,
        fromTransDate: _includeDates ? _fromDate : null,
        toTransDate: _includeDates ? _toDate : null,
        documentType: _documentType,
        accountingSystem: _accountingSystem,
        taxTreatment: _taxTreatment,
        taxPeriod: _taxPeriod,
        exportType: _exportType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = widget.type == CustomerDatumType.customer
        ? AppColor.primaryColor(context)
        : AppColor.oceanBlue;
    final isCustomer = widget.type == CustomerDatumType.customer;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border.all(color: foreground.withValues(alpha: 0.08)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: foreground.withValues(alpha: 0.24),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                Gap(16.h),
                Row(
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        isCustomer
                            ? Icons.point_of_sale_rounded
                            : Icons.shopping_bag_rounded,
                        color: accent,
                        size: 23.r,
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: foreground,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.reportCode,
                            style: TextStyle(
                              color: foreground.withValues(alpha: 0.45),
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: AppLocaleKey.cancelAction.tr(),
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: foreground.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
                Gap(16.h),
                // ── Date Range Toggle Switch ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.locale.languageCode == 'ar'
                          ? 'تحديد فترة التاريخ'
                          : 'Filter by Date Range',
                      style: AppTextStyle.formTitleStyle(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600, fontSize: 13.sp),
                    ),
                    Switch.adaptive(
                      value: _includeDates,
                      activeThumbColor: accent,
                      onChanged: (val) => setState(() => _includeDates = val),
                    ),
                  ],
                ),
                if (_includeDates) ...[
                  Gap(8.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocaleKey.fromDate.tr(),
                              style: TextStyle(
                                color: foreground.withValues(alpha: 0.65),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Gap(6.h),
                            _buildDateTile(
                              date: _fromDate,
                              hint: context.locale.languageCode == 'ar'
                                  ? 'من تاريخ'
                                  : 'From date',
                              onTap: () => _selectDate(isFromDate: true),
                              onClear: () => setState(() => _fromDate = null),
                              foreground: foreground,
                              accent: accent,
                            ),
                          ],
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocaleKey.toDate.tr(),
                              style: TextStyle(
                                color: foreground.withValues(alpha: 0.65),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Gap(6.h),
                            _buildDateTile(
                              date: _toDate,
                              hint: context.locale.languageCode == 'ar'
                                  ? 'إلى تاريخ'
                                  : 'To date',
                              onTap: () => _selectDate(isFromDate: false),
                              onClear: () => setState(() => _toDate = null),
                              foreground: foreground,
                              accent: accent,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                Gap(16.h),
                // ── Party Range Section ──
                CustomerDatumDropdown(
                  type: widget.type,
                  title: isCustomer
                      ? (context.locale.languageCode == 'ar'
                            ? 'من عميل (اختياري)'
                            : 'From Customer (Optional)')
                      : (context.locale.languageCode == 'ar'
                            ? 'من مورد (اختياري)'
                            : 'From Supplier (Optional)'),
                  hintText: isCustomer
                      ? (context.locale.languageCode == 'ar'
                            ? 'اختر عميل البداية...'
                            : 'Select starting customer...')
                      : (context.locale.languageCode == 'ar'
                            ? 'اختر مورد البداية...'
                            : 'Select starting supplier...'),
                  initialValue: _fromParty,
                  onSelected: (party) {
                    setState(() => _fromParty = party);
                  },
                ),
                Gap(12.h),
                CustomerDatumDropdown(
                  type: widget.type,
                  title: isCustomer
                      ? (context.locale.languageCode == 'ar'
                            ? 'إلى عميل (اختياري)'
                            : 'To Customer (Optional)')
                      : (context.locale.languageCode == 'ar'
                            ? 'إلى مورد (اختياري)'
                            : 'To Supplier (Optional)'),
                  hintText: isCustomer
                      ? (context.locale.languageCode == 'ar'
                            ? 'اختر عميل النهاية...'
                            : 'Select ending customer...')
                      : (context.locale.languageCode == 'ar'
                            ? 'اختر مورد النهاية...'
                            : 'Select ending supplier...'),
                  initialValue: _toParty,
                  onSelected: (party) {
                    setState(() => _toParty = party);
                  },
                ),
                if (_isSales || _isPurchases || _isExpenses) ...[
                  Gap(16.h),
                  Text(
                    _isArabic
                        ? (_isExpenses ? 'خيارات الضريبة' : 'خيارات المستند والضريبة')
                        : (_isExpenses ? 'Tax options' : 'Document & tax options'),
                    style: AppTextStyle.formTitleStyle(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600, fontSize: 13.sp),
                  ),
                  Gap(8.h),
                  if (!_isExpenses) ...[
                    DropdownButtonFormField<int>(
                    initialValue: _documentType,
                    decoration: InputDecoration(
                      labelText: _isArabic ? 'نوع المستند' : 'Document type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    items: _isSales
                        ? [
                            DropdownMenuItem(
                              value: 1,
                              child: Text(
                                _isArabic ? 'ف. مبيعات' : 'Sales invoice',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(
                                _isArabic ? 'إشعار دائن' : 'Credit note',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text(
                                _isArabic ? 'إشعار مدين' : 'Debit note',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 4,
                              child: Text(
                                _isArabic ? 'دفعة مقدمة' : 'Advance payment',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 5,
                              child: Text(_isArabic ? 'الجميع' : 'All'),
                            ),
                          ]
                        : [
                            DropdownMenuItem(
                              value: 1,
                              child: Text(_isArabic ? 'مشتريات' : 'Purchases'),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(
                                _isArabic
                                    ? 'مرتجع مشتريات'
                                    : 'Purchase returns',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text(_isArabic ? 'الجميع' : 'All'),
                            ),
                          ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _documentType = value);
                      }
                    },
                    ),
                    Gap(12.h),
                    DropdownButtonFormField<int>(
                    initialValue: _accountingSystem,
                    decoration: InputDecoration(
                      labelText: _isArabic
                          ? 'النظام المحاسبي'
                          : 'Accounting system',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 1,
                        child: Text(
                          _isSales
                              ? (_isArabic
                                    ? 'برنامج العملاء والمبيعات'
                                    : 'Customers and sales')
                              : (_isArabic
                                    ? 'برنامج الموردين والمشتريات'
                                    : 'Suppliers and purchases'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text(
                          _isArabic
                              ? 'برنامج الحسابات العامة'
                              : 'General accounts',
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _accountingSystem = value);
                      }
                    },
                    ),
                    Gap(12.h),
                  ],
                  DropdownButtonFormField<int>(
                    initialValue: _taxTreatment,
                    decoration: InputDecoration(
                      labelText: _isArabic
                          ? 'المعالجة الضريبية'
                          : 'Tax treatment',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    items: _isExpenses
                        ? [
                            DropdownMenuItem(
                              value: 1,
                              child: Text(_isArabic ? 'خاضع' : 'Taxable'),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(_isArabic ? 'صفري' : 'Zero-rated'),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text(_isArabic ? 'الجميع' : 'All'),
                            ),
                          ]
                        : _isSales
                        ? [
                            DropdownMenuItem(
                              value: 1,
                              child: Text(_isArabic ? 'الجميع' : 'All'),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(_isArabic ? 'خاضع' : 'Taxable'),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text(_isArabic ? 'معفى' : 'Exempt'),
                            ),
                            DropdownMenuItem(
                              value: 4,
                              child: Text(_isArabic ? 'صفري' : 'Zero-rated'),
                            ),
                            DropdownMenuItem(
                              value: 5,
                              child: Text(
                                _isArabic ? 'خارج النطاق' : 'Out of scope',
                              ),
                            ),
                          ]
                        : [
                            DropdownMenuItem(
                              value: 1,
                              child: Text(_isArabic ? 'الجميع' : 'All'),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(_isArabic ? 'خاضع' : 'Taxable'),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text(_isArabic ? 'صفري' : 'Zero-rated'),
                            ),
                            DropdownMenuItem(
                              value: 4,
                              child: Text(_isArabic ? 'معفى' : 'Exempt'),
                            ),
                          ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _taxTreatment = value);
                      }
                    },
                  ),
                  Gap(12.h),
                  DropdownButtonFormField<int>(
                    initialValue: _taxPeriod,
                    decoration: InputDecoration(
                      labelText: _isArabic ? 'الفترة الضريبية' : 'Tax period',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 1,
                        child: Text(
                          _isArabic ? 'الضريبة السابقة' : 'Previous tax period',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text(
                          _isArabic ? 'الضريبة الحالية' : 'Current tax period',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Text(_isArabic ? 'الجميع' : 'All'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _taxPeriod = value);
                      }
                    },
                  ),
                  Gap(12.h),
                  if (!_isExpenses) Row(
                    children: [
                      Expanded(
                        child: CustomFormField(
                          controller: _fromItemCodeController,
                          title: _isArabic ? 'من رمز الصنف' : 'From item code',
                          onChanged: (_) {
                            setState(() => _validationMessage = null);
                          },
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: CustomFormField(
                          controller: _toItemCodeController,
                          title: _isArabic ? 'إلى رمز الصنف' : 'To item code',
                          onChanged: (_) {
                            setState(() => _validationMessage = null);
                          },
                        ),
                      ),
                    ],
                  ),
                  Gap(12.h),
                  if (!_isExpenses) Row(
                    children: [
                      Expanded(
                        child: CustomFormField(
                          controller: _fromDocIdController,
                          title: _isArabic
                              ? 'من معرف المستند'
                              : 'From document ID',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (_) {
                            setState(() => _validationMessage = null);
                          },
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: CustomFormField(
                          controller: _toDocIdController,
                          title: _isArabic
                              ? 'إلى معرف المستند'
                              : 'To document ID',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (_) {
                            setState(() => _validationMessage = null);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
                Gap(12.h),
                DropdownButtonFormField<String>(
                  initialValue: _exportType,
                  decoration: InputDecoration(
                    labelText: _isArabic ? 'صيغة التصدير' : 'Export format',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                    DropdownMenuItem(value: 'excel', child: Text('Excel')),
                    DropdownMenuItem(
                      value: 'excelformatted',
                      child: Text('Excel formatted'),
                    ),
                    DropdownMenuItem(value: 'word', child: Text('Word')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _exportType = value);
                  },
                ),
                Gap(12.h),
                if (_validationMessage != null) ...[
                  Gap(12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: AppColor.roseDanger,
                        size: 16.sp,
                      ),
                      Gap(6.w),
                      Expanded(
                        child: Text(
                          _validationMessage!,
                          style: TextStyle(
                            color: AppColor.roseDanger,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                Gap(26.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocaleKey.exportPdf.tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTile({
    required DateTime? date,
    required String hint,
    required VoidCallback onTap,
    required VoidCallback onClear,
    required Color foreground,
    required Color accent,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColor.textFormFillColor(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: date != null
                ? accent.withValues(alpha: 0.5)
                : foreground.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16.sp,
              color: date != null ? accent : foreground.withValues(alpha: 0.5),
            ),
            Gap(8.w),
            Expanded(
              child: Text(
                date != null ? _formatDate(date) : hint,
                style: date != null
                    ? AppTextStyle.textFormStyle(
                        context,
                      ).copyWith(fontSize: 13.sp, fontWeight: FontWeight.w500)
                    : AppTextStyle.hintStyle(context).copyWith(fontSize: 13.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (date != null)
              InkWell(
                onTap: onClear,
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.all(2.r),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16.sp,
                    color: foreground.withValues(alpha: 0.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
