import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

class CostCentersReportFilterSelection {
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final int? fromCenterLevel;
  final int? toCenterLevel;
  final int? fromMonth;
  final int? toMonth;
  final int? comparisonMonth;
  final int? balance;
  final int? periodically;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int costCenterType;
  final String reportName;
  final String exportType;

  const CostCentersReportFilterSelection({
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromCenterLevel,
    this.toCenterLevel,
    this.fromMonth,
    this.toMonth,
    this.comparisonMonth,
    this.balance,
    this.periodically,
    this.fromDate,
    this.toDate,
    required this.costCenterType,
    required this.reportName,
    required this.exportType,
  });
}

class CostCentersReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String? endpointPath;
  final String initialReportName;
  final bool showReportNameSelector;
  final bool showDateFilter;
  final bool showMonthFilters;
  final bool showComparisonMonth;
  final bool showBalancePeriodicallyFilters;

  const CostCentersReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.endpointPath,
    this.initialReportName = 'AGL008',
    this.showReportNameSelector = true,
    this.showDateFilter = true,
    this.showMonthFilters = false,
    this.showComparisonMonth = false,
    this.showBalancePeriodicallyFilters = false,
  });

  static Future<CostCentersReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String? endpointPath,
    String initialReportName = 'AGL008',
    bool showReportNameSelector = true,
    bool showDateFilter = true,
    bool showMonthFilters = false,
    bool showComparisonMonth = false,
    bool showBalancePeriodicallyFilters = false,
  }) {
    return showModalBottomSheet<CostCentersReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CostCentersReportFilterBottomSheetWidget(
        title: title,
        endpointPath: endpointPath,
        initialReportName: initialReportName,
        showReportNameSelector: showReportNameSelector,
        showDateFilter: showDateFilter,
        showMonthFilters: showMonthFilters,
        showComparisonMonth: showComparisonMonth,
        showBalancePeriodicallyFilters: showBalancePeriodicallyFilters,
      ),
    );
  }

  @override
  State<CostCentersReportFilterBottomSheetWidget> createState() =>
      _CostCentersReportFilterBottomSheetWidgetState();
}

class _CostCentersReportFilterBottomSheetWidgetState
    extends State<CostCentersReportFilterBottomSheetWidget> {
  final _fromLevelController = TextEditingController();
  final _toLevelController = TextEditingController();
  CostCenterLightModel? _fromCostCenter;
  CostCenterLightModel? _toCostCenter;
  DateTime? _fromDate;
  DateTime? _toDate;
  int? _fromMonth;
  int? _toMonth;
  int _comparisonMonth = 1;
  int _balance = 0;
  int _periodically = 0;
  int _costCenterType = 2;
  late String _reportName;
  String _exportType = 'pdf';
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _reportName = widget.initialReportName;
  }

  @override
  void dispose() {
    _fromLevelController.dispose();
    _toLevelController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime({required bool isFromDate}) async {
    final current = (isFromDate ? _fromDate : _toDate) ?? DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateUtils.dateOnly(current),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate == null || !mounted) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (selectedTime == null || !mounted) return;

    final dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    setState(() {
      if (isFromDate) {
        _fromDate = dateTime;
      } else {
        _toDate = dateTime;
      }
      _validationMessage = null;
    });
  }

  void _submit() {
    final fromLevel = _parseLevel(_fromLevelController);
    final toLevel = _parseLevel(_toLevelController);

    if ((_fromLevelController.text.trim().isNotEmpty && fromLevel == null) ||
        (_toLevelController.text.trim().isNotEmpty && toLevel == null)) {
      setState(() {
        _validationMessage = _isArabic
            ? 'أدخل مستوى مركز تكلفة صحيحاً'
            : 'Enter a valid cost center level';
      });
      return;
    }

    final fromNo = _fromCostCenter?.costCenterNo;
    final toNo = _toCostCenter?.costCenterNo;
    if (fromNo != null && toNo != null && fromNo > toNo) {
      setState(() {
        _validationMessage = _isArabic
            ? 'مركز البداية يجب أن يكون أقل من أو يساوي مركز النهاية'
            : 'From cost center must be less than or equal to To cost center';
      });
      return;
    }
    if (fromLevel != null && toLevel != null && fromLevel > toLevel) {
      setState(() {
        _validationMessage = _isArabic
            ? 'مستوى البداية يجب أن يكون أقل من أو يساوي مستوى النهاية'
            : 'From level must be less than or equal to To level';
      });
      return;
    }
    if (widget.showMonthFilters &&
        _fromMonth != null &&
        _toMonth != null &&
        _fromMonth! > _toMonth!) {
      setState(() {
        _validationMessage = _isArabic
            ? 'شهر البداية يجب أن يسبق أو يساوي شهر النهاية'
            : 'From month must be before or equal to To month';
      });
      return;
    }
    if (widget.showDateFilter &&
        _fromDate != null &&
        _toDate != null &&
        _fromDate!.isAfter(_toDate!)) {
      setState(() {
        _validationMessage = _isArabic
            ? 'تاريخ ووقت البداية يجب أن يسبق أو يساوي تاريخ ووقت النهاية'
            : 'From date and time must be before or equal to To date and time';
      });
      return;
    }

    Navigator.pop(
      context,
      CostCentersReportFilterSelection(
        fromCostCenterNo: fromNo,
        toCostCenterNo: toNo,
        fromCenterLevel: fromLevel,
        toCenterLevel: toLevel,
        fromMonth: widget.showMonthFilters ? _fromMonth : null,
        toMonth: widget.showMonthFilters ? _toMonth : null,
        comparisonMonth: widget.showComparisonMonth ? _comparisonMonth : null,
        balance:
            widget.showMonthFilters || widget.showBalancePeriodicallyFilters
            ? _balance
            : null,
        periodically: widget.showBalancePeriodicallyFilters
            ? _periodically
            : null,
        fromDate: widget.showDateFilter ? _fromDate : null,
        toDate: widget.showDateFilter ? _toDate : null,
        costCenterType: _costCenterType,
        reportName: _reportName,
        exportType: _exportType,
      ),
    );
  }

  int? _parseLevel(TextEditingController controller) =>
      int.tryParse(controller.text.trim());

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
                  widget.endpointPath ??
                      (widget.showReportNameSelector
                          ? 'Report/CostCentersReport'
                          : 'Report/CentersMonthlyBalanceReport'),
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
                  if (widget.showReportNameSelector)
                    _dropdown<String>(
                      label: _isArabic ? 'نوع التقرير' : 'Report type',
                      value: _reportName,
                      options: [
                        (
                          'AGL007',
                          _isArabic
                              ? 'دليل مراكز التكلفة'
                              : 'Cost centers directory',
                        ),
                        (
                          'AGL008',
                          _isArabic
                              ? 'دليل المراكز بالأرصدة الشهرية'
                              : 'Cost centers with monthly balances',
                        ),
                        (
                          'AGL025C',
                          _isArabic
                              ? 'إجمالي مراكز التكلفة'
                              : 'Cost centers total',
                        ),
                      ],
                      onChanged: (value) => setState(() => _reportName = value),
                    ),
                  Gap(12.h),
                  _dropdown<int>(
                    label: _isArabic ? 'نوع مراكز التكلفة' : 'Cost center type',
                    value: _costCenterType,
                    options: [
                      (0, _isArabic ? 'رئيسي' : 'Main'),
                      (1, _isArabic ? 'فرعي' : 'Sub'),
                      (2, _isArabic ? 'الجميع' : 'All'),
                    ],
                    onChanged: (value) =>
                        setState(() => _costCenterType = value),
                  ),
                  Gap(16.h),
                  _sectionTitle(
                    _isArabic ? 'نطاق مراكز التكلفة' : 'Cost center range',
                    foreground,
                  ),
                  Gap(8.h),
                  CostCenterDropdown(
                    title: _isArabic ? 'من مركز' : 'From cost center',
                    hintText: _isArabic ? 'كل المراكز' : 'All cost centers',
                    initialValue: _fromCostCenter,
                    onSelected: (value) => setState(() {
                      _fromCostCenter = value;
                      _validationMessage = null;
                    }),
                  ),
                  Gap(12.h),
                  CostCenterDropdown(
                    title: _isArabic ? 'إلى مركز' : 'To cost center',
                    hintText: _isArabic ? 'كل المراكز' : 'All cost centers',
                    initialValue: _toCostCenter,
                    onSelected: (value) => setState(() {
                      _toCostCenter = value;
                      _validationMessage = null;
                    }),
                  ),
                  Gap(12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _levelField(
                          _fromLevelController,
                          _isArabic ? 'من مستوى' : 'From level',
                          foreground,
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: _levelField(
                          _toLevelController,
                          _isArabic ? 'إلى مستوى' : 'To level',
                          foreground,
                        ),
                      ),
                    ],
                  ),
                  Gap(12.h),
                  if (widget.showDateFilter) ...[
                    _sectionTitle(
                      _isArabic ? 'الفترة الزمنية' : 'Date and time range',
                      foreground,
                    ),
                    Gap(8.h),
                    Row(
                      children: [
                        Expanded(
                          child: _dateTimeField(
                            label: _isArabic
                                ? 'من تاريخ ووقت'
                                : 'From date/time',
                            value: _fromDate,
                            onTap: () => _selectDateTime(isFromDate: true),
                          ),
                        ),
                        Gap(10.w),
                        Expanded(
                          child: _dateTimeField(
                            label: _isArabic
                                ? 'إلى تاريخ ووقت'
                                : 'To date/time',
                            value: _toDate,
                            onTap: () => _selectDateTime(isFromDate: false),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (widget.showMonthFilters) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _monthDropdown(
                            label: _isArabic ? 'من شهر' : 'From month',
                            value: _fromMonth,
                            onChanged: (value) => setState(() {
                              _fromMonth = value;
                              _validationMessage = null;
                            }),
                          ),
                        ),
                        Gap(10.w),
                        Expanded(
                          child: _monthDropdown(
                            label: _isArabic ? 'إلى شهر' : 'To month',
                            value: _toMonth,
                            onChanged: (value) => setState(() {
                              _toMonth = value;
                              _validationMessage = null;
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (widget.showComparisonMonth) ...[
                    _monthDropdown(
                      label: _isArabic ? 'شهر المقارنة' : 'Comparison month',
                      value: _comparisonMonth,
                      allowAllMonths: false,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _comparisonMonth = value;
                            _validationMessage = null;
                          });
                        }
                      },
                    ),
                    Gap(12.h),
                  ],
                  if (widget.showMonthFilters ||
                      widget.showBalancePeriodicallyFilters) ...[
                    Gap(12.h),
                    _dropdown<int>(
                      label: _isArabic ? 'نوع الرصيد' : 'Balance type',
                      value: _balance,
                      options: [
                        (0, _isArabic ? 'السابق' : 'Previous'),
                        (1, _isArabic ? 'التقديري' : 'Estimated'),
                      ],
                      onChanged: (value) => setState(() => _balance = value),
                    ),
                  ],
                  if (widget.showBalancePeriodicallyFilters) ...[
                    Gap(12.h),
                    _dropdown<int>(
                      label: _isArabic ? 'نوع الفترة' : 'Period type',
                      value: _periodically,
                      options: [
                        (0, _isArabic ? 'إجمالي' : 'Summary'),
                        (1, _isArabic ? 'شهري' : 'Monthly'),
                      ],
                      onChanged: (value) =>
                          setState(() => _periodically = value),
                    ),
                  ],
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

  Widget _levelField(
    TextEditingController controller,
    String label,
    Color foreground,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      ),
      onChanged: (_) => setState(() => _validationMessage = null),
    );
  }

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
            fontSize: 13.sp,
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

  Widget _monthDropdown({
    required String label,
    required int? value,
    bool allowAllMonths = true,
    required ValueChanged<int?> onChanged,
  }) {
    final foreground = AppColor.titleFormFiledColor(context);
    return DropdownButtonFormField<int>(
      initialValue: value ?? (allowAllMonths ? 0 : 1),
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
      items: [
        if (allowAllMonths)
          DropdownMenuItem<int>(
            value: 0,
            child: Text(_isArabic ? 'كل الشهور' : 'All months'),
          ),
        ...List.generate(
          12,
          (index) => DropdownMenuItem<int>(
            value: index + 1,
            child: Text('${_isArabic ? 'شهر' : 'Month'} ${index + 1}'),
          ),
        ),
      ],
      onChanged: (selected) =>
          onChanged(selected == null || selected == 0 ? null : selected),
    );
  }
}
