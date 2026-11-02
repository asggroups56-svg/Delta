import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

class AccountCentersSummaryReportFilterSelection {
  final num? fromAccountNo;
  final num? toAccountNo;
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String exportType;

  const AccountCentersSummaryReportFilterSelection({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromDate,
    this.toDate,
    required this.exportType,
  });
}

class AccountCentersSummaryReportFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;

  const AccountCentersSummaryReportFilterBottomSheetWidget({
    super.key,
    required this.title,
  });

  static Future<AccountCentersSummaryReportFilterSelection?> show(
    BuildContext context, {
    required String title,
  }) {
    return showModalBottomSheet<AccountCentersSummaryReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          AccountCentersSummaryReportFilterBottomSheetWidget(title: title),
    );
  }

  @override
  State<AccountCentersSummaryReportFilterBottomSheetWidget> createState() =>
      _AccountCentersSummaryReportFilterBottomSheetWidgetState();
}

class _AccountCentersSummaryReportFilterBottomSheetWidgetState
    extends State<AccountCentersSummaryReportFilterBottomSheetWidget> {
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  CostCenterLightModel? _fromCostCenter;
  CostCenterLightModel? _toCostCenter;
  DateTime? _fromDate;
  DateTime? _toDate;
  String _exportType = 'pdf';
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  Future<void> _selectDateTime({required bool isFromDate}) async {
    final initial = (isFromDate ? _fromDate : _toDate) ?? DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateUtils.dateOnly(initial),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate == null || !mounted) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (selectedTime == null || !mounted) return;

    final selected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    setState(() {
      if (isFromDate) {
        _fromDate = selected;
      } else {
        _toDate = selected;
      }
      _validationMessage = null;
    });
  }

  void _submit() {
    final fromAccountNo = _fromAccount?.accountNo;
    final toAccountNo = _toAccount?.accountNo;
    final fromCostCenterNo = _fromCostCenter?.costCenterNo;
    final toCostCenterNo = _toCostCenter?.costCenterNo;

    if (fromAccountNo != null &&
        toAccountNo != null &&
        fromAccountNo > toAccountNo) {
      setState(() {
        _validationMessage = _isArabic
            ? 'الحساب من يجب أن يكون أقل من أو يساوي الحساب إلى'
            : 'From account must be less than or equal to To account';
      });
      return;
    }
    if (fromCostCenterNo != null &&
        toCostCenterNo != null &&
        fromCostCenterNo > toCostCenterNo) {
      setState(() {
        _validationMessage = _isArabic
            ? 'مركز التكلفة من يجب أن يكون أقل من أو يساوي مركز التكلفة إلى'
            : 'From cost center must be less than or equal to To cost center';
      });
      return;
    }
    if (_fromDate != null && _toDate != null && _fromDate!.isAfter(_toDate!)) {
      setState(() {
        _validationMessage = _isArabic
            ? 'تاريخ البداية يجب أن يسبق أو يساوي تاريخ النهاية'
            : 'From date must be before or equal to To date';
      });
      return;
    }

    Navigator.pop(
      context,
      AccountCentersSummaryReportFilterSelection(
        fromAccountNo: fromAccountNo,
        toAccountNo: toAccountNo,
        fromCostCenterNo: fromCostCenterNo,
        toCostCenterNo: toCostCenterNo,
        fromDate: _fromDate,
        toDate: _toDate,
        exportType: _exportType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.oceanBlue;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.9.sh),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(color: AppColor.borderColor(context)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: foreground.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                Gap(16.h),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(4.h),
                Text(
                  'Report/AccountCentersSummaryForMainAccountsReport (AGL0103)',
                  style: TextStyle(
                    color: foreground.withValues(alpha: 0.55),
                    fontSize: 10.sp,
                    fontFamily: 'monospace',
                  ),
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
                  _sectionTitle(
                    _isArabic ? 'نطاق الحسابات' : 'Account range',
                    foreground,
                  ),
                  Gap(8.h),
                  ChartOfAccountDropdown(
                    title: _isArabic ? 'من حساب' : 'From account',
                    hintText: _isArabic ? 'كل الحسابات' : 'All accounts',
                    accountType: 2,
                    initialValue: _fromAccount,
                    onSelected: (value) => setState(() {
                      _fromAccount = value;
                      _validationMessage = null;
                    }),
                  ),
                  Gap(12.h),
                  ChartOfAccountDropdown(
                    title: _isArabic ? 'إلى حساب' : 'To account',
                    hintText: _isArabic ? 'كل الحسابات' : 'All accounts',
                    accountType: 2,
                    initialValue: _toAccount,
                    onSelected: (value) => setState(() {
                      _toAccount = value;
                      _validationMessage = null;
                    }),
                  ),
                  Gap(16.h),
                  _sectionTitle(
                    _isArabic ? 'نطاق مراكز التكلفة' : 'Cost center range',
                    foreground,
                  ),
                  Gap(8.h),
                  CostCenterDropdown(
                    title: _isArabic ? 'من مركز تكلفة' : 'From cost center',
                    hintText: _isArabic ? 'كل المراكز' : 'All cost centers',
                    initialValue: _fromCostCenter,
                    onSelected: (value) => setState(() {
                      _fromCostCenter = value;
                      _validationMessage = null;
                    }),
                  ),
                  Gap(12.h),
                  CostCenterDropdown(
                    title: _isArabic ? 'إلى مركز تكلفة' : 'To cost center',
                    hintText: _isArabic ? 'كل المراكز' : 'All cost centers',
                    initialValue: _toCostCenter,
                    onSelected: (value) => setState(() {
                      _toCostCenter = value;
                      _validationMessage = null;
                    }),
                  ),
                  Gap(16.h),
                  _sectionTitle(
                    _isArabic ? 'الفترة الزمنية' : 'Date and time range',
                    foreground,
                  ),
                  Gap(8.h),
                  Row(
                    children: [
                      Expanded(
                        child: _dateTimeField(
                          label: _isArabic ? 'من تاريخ ووقت' : 'From date/time',
                          value: _fromDate,
                          onTap: () => _selectDateTime(isFromDate: true),
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: _dateTimeField(
                          label: _isArabic ? 'إلى تاريخ ووقت' : 'To date/time',
                          value: _toDate,
                          onTap: () => _selectDateTime(isFromDate: false),
                        ),
                      ),
                    ],
                  ),
                  Gap(12.h),
                  _dropdown<String>(
                    label: _isArabic ? 'صيغة التصدير' : 'Export format',
                    value: _exportType,
                    options: const [
                      ('pdf', 'PDF'),
                      ('excel', 'Excel'),
                      ('excelformatted', 'Excel formatted'),
                      ('word', 'Word'),
                    ],
                    onChanged: (value) => setState(() => _exportType = value),
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
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: _submit,
                child: Text(_isArabic ? 'عرض التقرير' : 'Show report'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) => Text(
    title,
    style: AppTextStyle.formTitleStyle(
      context,
    ).copyWith(color: color, fontWeight: FontWeight.w600, fontSize: 13.sp),
  );

  Widget _dateTimeField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    final foreground = AppColor.titleFormFiledColor(context);
    final localizations = MaterialLocalizations.of(context);
    final text = value == null
        ? (_isArabic ? 'اختر التاريخ والوقت' : 'Select date and time')
        : '${localizations.formatMediumDate(value)} '
              '${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(value))}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.formTitleStyle(context).copyWith(
            color: foreground,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
        Gap(6.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 13.h),
            decoration: BoxDecoration(
              color: AppColor.textFormFillColor(context),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: foreground.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 17.sp,
                  color: AppColor.oceanBlue,
                ),
                Gap(6.w),
                Expanded(
                  child: Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: foreground, fontSize: 11.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<(T, String)> options,
    required ValueChanged<T> onChanged,
  }) {
    final foreground = AppColor.titleFormFiledColor(context);
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: foreground.withValues(alpha: 0.65)),
        filled: true,
        fillColor: AppColor.textFormFillColor(context),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: foreground.withValues(alpha: 0.12)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      ),
      dropdownColor: AppColor.cardColor(context),
      style: TextStyle(color: foreground, fontSize: 13.sp),
      items: options
          .map(
            (option) => DropdownMenuItem<T>(
              value: option.$1,
              child: Text(
                option.$2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: foreground, fontSize: 13.sp),
              ),
            ),
          )
          .toList(),
      onChanged: (selected) {
        if (selected != null) onChanged(selected);
      },
    );
  }
}
