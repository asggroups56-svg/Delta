import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

class CostCentersTransactionReportFilterSelection {
  final num? fromAccountNo;
  final num? toAccountNo;
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool prepareCostCentersTree;
  final String reportName;
  final String exportType;

  const CostCentersTransactionReportFilterSelection({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromDate,
    this.toDate,
    required this.prepareCostCentersTree,
    required this.reportName,
    required this.exportType,
  });
}

class CostCentersTransactionReportFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final bool isAnnual;
  final String initialReportName;

  const CostCentersTransactionReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.isAnnual = false,
    this.initialReportName = 'AGL028',
  });

  static Future<CostCentersTransactionReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    bool isAnnual = false,
    String initialReportName = 'AGL028',
  }) {
    return showModalBottomSheet<CostCentersTransactionReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CostCentersTransactionReportFilterBottomSheetWidget(
        title: title,
        isAnnual: isAnnual,
        initialReportName: initialReportName,
      ),
    );
  }

  @override
  State<CostCentersTransactionReportFilterBottomSheetWidget> createState() =>
      _CostCentersTransactionReportFilterBottomSheetWidgetState();
}

class _CostCentersTransactionReportFilterBottomSheetWidgetState
    extends State<CostCentersTransactionReportFilterBottomSheetWidget> {
  static const _reportOptions = [
    ('AGL029', 'تفصيلى مراكز الحسابات', 'Detailed centers accounts'),
    ('AGL028', 'اجمالى مراكز الحسابات', 'Centers accounts total'),
    ('AGL027', 'تفصيلى حسابات المراكز', 'Detailed center accounts'),
    ('AGL026', 'اجمالى حسابات المراكز', 'Center accounts total'),
    (
      'AGL028A',
      'الحسابات الموزعة على المراكز',
      'Accounts distributed by centers',
    ),
    ('AGL026A', 'اجمالى حسابات المراكز بالجميع', 'All center accounts total'),
    ('AGL027A', 'مصروفات وايرادات المراكز', 'Center expenses and revenues'),
    ('AGL028B', 'اجمالى مراكز الحسابات مجمع', 'Grouped centers accounts total'),
  ];

  static const _annualReportOptions = [
    ('AGL029Y', 'تفصيلى مراكز الحسابات', 'Detailed centers accounts'),
    ('AGL025Y', 'اجمالى مراكز الحسابات', 'Centers accounts total'),
    ('AGL026Y', 'تفصيلى حسابات المراكز', 'Detailed center accounts'),
    ('AGL024Y', 'اجمالى حسابات المراكز', 'Center accounts total'),
    (
      'AGL028Y',
      'الحسابات الموزعة على المراكز',
      'Accounts distributed by centers',
    ),
    ('AGL030Y', 'اجمالى حسابات المراكز بالجميع', 'All center accounts total'),
    ('AGL027Y', 'مصروفات وايرادات المراكز', 'Center expenses and revenues'),
    ('AGL031Y', 'اجمالى مراكز الحسابات مجمع', 'Grouped centers accounts total'),
  ];

  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  CostCenterLightModel? _fromCostCenter;
  CostCenterLightModel? _toCostCenter;
  DateTime? _fromDate;
  DateTime? _toDate;
  late String _reportName;
  String _exportType = 'pdf';
  bool _prepareCostCentersTree = false;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _reportName = widget.initialReportName;
  }

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

    final value = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    setState(() {
      if (isFromDate) {
        _fromDate = value;
      } else {
        _toDate = value;
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
      _showValidation(
        _isArabic
            ? 'الحساب من يجب أن يكون أقل من أو يساوي الحساب إلى'
            : 'From account must be less than or equal to To account',
      );
      return;
    }
    if (fromCostCenterNo != null &&
        toCostCenterNo != null &&
        fromCostCenterNo > toCostCenterNo) {
      _showValidation(
        _isArabic
            ? 'مركز التكلفة من يجب أن يكون أقل من أو يساوي مركز التكلفة إلى'
            : 'From cost center must be less than or equal to To cost center',
      );
      return;
    }
    if (_fromDate != null && _toDate != null && _fromDate!.isAfter(_toDate!)) {
      _showValidation(
        _isArabic
            ? 'تاريخ البداية يجب أن يسبق أو يساوي تاريخ النهاية'
            : 'From date must be before or equal to To date',
      );
      return;
    }

    Navigator.pop(
      context,
      CostCentersTransactionReportFilterSelection(
        fromAccountNo: fromAccountNo,
        toAccountNo: toAccountNo,
        fromCostCenterNo: fromCostCenterNo,
        toCostCenterNo: toCostCenterNo,
        fromDate: _fromDate,
        toDate: _toDate,
        prepareCostCentersTree: _prepareCostCentersTree,
        reportName: _reportName,
        exportType: _exportType,
      ),
    );
  }

  void _showValidation(String message) {
    setState(() => _validationMessage = message);
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.purpleAccent;

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
                  widget.isAnnual
                      ? 'Report/CostCentersTransactionAnnualReport'
                      : 'Report/CostCentersTransactionReport',
                  style: TextStyle(
                    color: foreground.withValues(alpha: 0.55),
                    fontSize: 11.sp,
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
                  _dropdown<String>(
                    label: _isArabic ? 'نوع التقرير' : 'Report type',
                    value: _reportName,
                    options:
                        (widget.isAnnual
                                ? _annualReportOptions
                                : _reportOptions)
                            .map(
                              (option) => (
                                option.$1,
                                _isArabic ? option.$2 : option.$3,
                              ),
                            )
                            .toList(),
                    onChanged: (value) => setState(() => _reportName = value),
                  ),
                  Gap(16.h),
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
                  if (!widget.isAnnual)
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _prepareCostCentersTree,
                      activeThumbColor: accent,
                      title: Text(
                        _isArabic
                            ? 'تجهيز شجرة مراكز التكلفة'
                            : 'Prepare cost centers tree',
                        style: TextStyle(color: foreground, fontSize: 13.sp),
                      ),
                      onChanged: (value) =>
                          setState(() => _prepareCostCentersTree = value),
                    ),
                  Gap(4.h),
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
                  color: AppColor.purpleAccent,
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
