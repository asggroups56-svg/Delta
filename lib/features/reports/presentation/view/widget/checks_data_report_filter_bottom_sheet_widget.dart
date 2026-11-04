import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';

class ChecksDataReportFilterSelection {
  final String? fromChqNo;
  final String? toChqNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? fromBankCode;
  final int? toBankCode;
  final int? fromCashAccount;
  final int? toCashAccount;
  final String exportType;

  const ChecksDataReportFilterSelection({
    required this.fromChqNo,
    required this.toChqNo,
    required this.fromDate,
    required this.toDate,
    required this.fromBankCode,
    required this.toBankCode,
    required this.fromCashAccount,
    required this.toCashAccount,
    required this.exportType,
  });
}

class ChecksDataReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialExportType;

  const ChecksDataReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<ChecksDataReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<ChecksDataReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChecksDataReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<ChecksDataReportFilterBottomSheetWidget> createState() =>
      _ChecksDataReportFilterBottomSheetWidgetState();
}

class _ChecksDataReportFilterBottomSheetWidgetState
    extends State<ChecksDataReportFilterBottomSheetWidget> {
  final _fromBankCodeController = TextEditingController();
  final _toBankCodeController = TextEditingController();
  final _fromCashAccountController = TextEditingController();
  final _toCashAccountController = TextEditingController();
  ChartOfAccountLightModel? _fromCheck;
  ChartOfAccountLightModel? _toCheck;
  DateTime? _fromDate;
  DateTime? _toDate;
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _exportType = widget.initialExportType;
  }

  @override
  void dispose() {
    _fromBankCodeController.dispose();
    _toBankCodeController.dispose();
    _fromCashAccountController.dispose();
    _toCashAccountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({required bool isFromDate}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateUtils.dateOnly(
        (isFromDate ? _fromDate : _toDate) ?? DateTime.now(),
      ),
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

  void _submit() {
    final fromBankCode = _parseOptionalInt(_fromBankCodeController.text);
    final toBankCode = _parseOptionalInt(_toBankCodeController.text);
    final fromCashAccount = _parseOptionalInt(_fromCashAccountController.text);
    final toCashAccount = _parseOptionalInt(_toCashAccountController.text);
    if ((_fromBankCodeController.text.trim().isNotEmpty &&
            fromBankCode == null) ||
        (_toBankCodeController.text.trim().isNotEmpty && toBankCode == null) ||
        (_fromCashAccountController.text.trim().isNotEmpty &&
            fromCashAccount == null) ||
        (_toCashAccountController.text.trim().isNotEmpty &&
            toCashAccount == null)) {
      _showValidation(
        _isArabic
            ? 'رمز البنك والحساب يجب أن يكونا رقمًا صحيحًا'
            : 'Bank and cash account values must be whole numbers',
      );
      return;
    }
    if ((_fromDate == null) != (_toDate == null)) {
      _showValidation(
        _isArabic
            ? 'اختر تاريخ البداية والنهاية معًا أو اتركهما فارغين'
            : 'Select both dates or leave both empty',
      );
      return;
    }
    if (_fromDate != null && _fromDate!.isAfter(_toDate!)) {
      _showValidation(
        _isArabic
            ? 'تاريخ البداية يجب أن يسبق أو يساوي تاريخ النهاية'
            : 'From date must be before or equal to To date',
      );
      return;
    }

    Navigator.pop(
      context,
      ChecksDataReportFilterSelection(
        fromChqNo: _fromCheck?.accountNo.toString(),
        toChqNo: _toCheck?.accountNo.toString(),
        fromDate: _fromDate,
        toDate: _toDate,
        fromBankCode: fromBankCode,
        toBankCode: toBankCode,
        fromCashAccount: fromCashAccount,
        toCashAccount: toCashAccount,
        exportType: _exportType,
      ),
    );
  }

  int? _parseOptionalInt(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : int.tryParse(trimmed);
  }

  void _showValidation(String message) {
    setState(() => _validationMessage = message);
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    return Container(
      constraints: BoxConstraints(maxHeight: 0.9.sh),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 12.h),
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isArabic ? 'نطاق الشيكات' : 'Check range',
                        style: TextStyle(
                          color: foreground,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(8.h),
                      ChartOfAccountDropdown(
                        title: _isArabic ? 'من شيك' : 'From check',
                        hintText: _isArabic
                            ? 'اختر بداية نطاق الشيك'
                            : 'Select first check',
                        accountType: null,
                        includeAccountsHasCostCenters: true,
                        initialValue: _fromCheck,
                        onSelected: (account) {
                          setState(() => _fromCheck = account);
                        },
                      ),
                      Gap(10.h),
                      ChartOfAccountDropdown(
                        title: _isArabic ? 'إلى شيك' : 'To check',
                        hintText: _isArabic
                            ? 'اختر نهاية نطاق الشيك'
                            : 'Select last check',
                        accountType: null,
                        includeAccountsHasCostCenters: true,
                        initialValue: _toCheck,
                        onSelected: (account) {
                          setState(() => _toCheck = account);
                        },
                      ),
                      Gap(14.h),
                      _rangeFields(
                        _isArabic ? 'نطاق البنوك' : 'Bank range',
                        _isArabic ? 'من رمز البنك' : 'From bank code',
                        _fromBankCodeController,
                        _isArabic ? 'إلى رمز البنك' : 'To bank code',
                        _toBankCodeController,
                        numeric: true,
                      ),
                      Gap(14.h),
                      Text(
                        _isArabic
                            ? 'نطاق حسابات النقدية'
                            : 'Cash account range',
                        style: TextStyle(
                          color: foreground,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(8.h),
                      _rangeFields(
                        _isArabic
                            ? 'نطاق حسابات النقدية'
                            : 'Cash account range',
                        _isArabic ? 'من حساب' : 'From account',
                        _fromCashAccountController,
                        _isArabic ? 'إلى حساب' : 'To account',
                        _toCashAccountController,
                        numeric: true,
                      ),
                      Gap(14.h),
                      Text(
                        _isArabic ? 'فترة التقرير' : 'Report period',
                        style: TextStyle(
                          color: foreground,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(8.h),
                      Row(
                        children: [
                          Expanded(
                            child: _dateButton(
                              label: _isArabic ? 'من تاريخ' : 'From date',
                              date: _fromDate,
                              onPressed: () => _selectDate(isFromDate: true),
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: _dateButton(
                              label: _isArabic ? 'إلى تاريخ' : 'To date',
                              date: _toDate,
                              onPressed: () => _selectDate(isFromDate: false),
                            ),
                          ),
                        ],
                      ),
                      Gap(14.h),
                      DropdownButtonFormField<String>(
                        initialValue: _exportType,
                        decoration: InputDecoration(
                          labelText: _isArabic
                              ? 'صيغة التصدير'
                              : 'Export format',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                          DropdownMenuItem(
                            value: 'excel',
                            child: Text('Excel'),
                          ),
                          DropdownMenuItem(
                            value: 'excelformatted',
                            child: Text('Excel formatted'),
                          ),
                          DropdownMenuItem(value: 'word', child: Text('Word')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _exportType = value);
                          }
                        },
                      ),
                      if (_validationMessage != null) ...[
                        Gap(10.h),
                        Text(
                          _validationMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColor.oceanBlue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(_isArabic ? 'عرض التقرير' : 'Show report'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rangeFields(
    String title,
    String fromLabel,
    TextEditingController fromController,
    String toLabel,
    TextEditingController toController, {
    bool numeric = false,
  }) {
    final foreground = AppColor.titleFormFiledColor(context);
    final inputFormatters = numeric
        ? [FilteringTextInputFormatter.digitsOnly]
        : <TextInputFormatter>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: foreground,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(8.h),
        Row(
          children: [
            Expanded(
              child: _textField(
                label: fromLabel,
                controller: fromController,
                inputFormatters: inputFormatters,
              ),
            ),
            Gap(10.w),
            Expanded(
              child: _textField(
                label: toLabel,
                controller: toController,
                inputFormatters: inputFormatters,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    required List<TextInputFormatter> inputFormatters,
  }) {
    return CustomFormField(
      width: double.infinity,
      radius: 12.r,
      controller: controller,
      title: label,
      keyboardType: inputFormatters.isEmpty
          ? TextInputType.text
          : TextInputType.number,
      inputFormatters: inputFormatters,
    );
  }

  Widget _dateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColor.oceanBlue,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_rounded, size: 16),
          Gap(8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10.sp)),
                Gap(2.h),
                Text(
                  date == null
                      ? (_isArabic ? 'الكل' : 'All dates')
                      : MaterialLocalizations.of(
                          context,
                        ).formatMediumDate(date),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
