import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

class JournalReportFilterSelection {
  final int? fromEntrySerial;
  final int? toEntrySerial;
  final String? fromEntryNo;
  final String? toEntryNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int journalType;
  final int journalReportType;
  final String reportName;
  final String exportType;

  const JournalReportFilterSelection({
    required this.fromEntrySerial,
    required this.toEntrySerial,
    required this.fromEntryNo,
    required this.toEntryNo,
    required this.fromDate,
    required this.toDate,
    required this.journalType,
    required this.journalReportType,
    required this.reportName,
    required this.exportType,
  });
}

class JournalReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialExportType;
  final bool isMainAccountsReport;

  const JournalReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
    this.isMainAccountsReport = false,
  });

  static Future<JournalReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
    bool isMainAccountsReport = false,
  }) {
    return showModalBottomSheet<JournalReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => JournalReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
        isMainAccountsReport: isMainAccountsReport,
      ),
    );
  }

  @override
  State<JournalReportFilterBottomSheetWidget> createState() =>
      _JournalReportFilterBottomSheetWidgetState();
}

class _JournalReportFilterBottomSheetWidgetState
    extends State<JournalReportFilterBottomSheetWidget> {
  final _fromEntrySerialController = TextEditingController();
  final _toEntrySerialController = TextEditingController();
  final _fromEntryNoController = TextEditingController();
  final _toEntryNoController = TextEditingController();

  int _journalType = 0;
  int _journalReportType = 5;
  bool _isDaily = false;
  bool _includeCenters = false;
  bool _includeCurrency = false;
  DateTime? _fromDate;
  DateTime? _toDate;
  DateTime? _dailyDate;
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
    _fromEntrySerialController.dispose();
    _toEntrySerialController.dispose();
    _fromEntryNoController.dispose();
    _toEntryNoController.dispose();
    super.dispose();
  }

  String get _reportName {
    if (widget.isMainAccountsReport) {
      if (_journalType == 1) return 'AGL0101';
      return _includeCenters ? 'AGL0101B' : 'AGL0101C';
    }
    if (_journalType == 1) return 'AGL013';
    if (_isDaily) return 'AGL009T';
    if (_includeCenters && _includeCurrency) return 'AGL012';
    if (_includeCenters) return 'AGL011';
    if (_includeCurrency) return 'AGL010';
    return 'AGL009';
  }

  Future<void> _selectDate({required bool isFromDate}) async {
    final initialDate = _isDaily
        ? _dailyDate ?? DateTime.now()
        : (isFromDate ? _fromDate : _toDate) ?? DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateUtils.dateOnly(initialDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate == null || !mounted) return;

    final date = DateUtils.dateOnly(selectedDate);
    setState(() {
      if (_isDaily) {
        _dailyDate = date;
      } else if (isFromDate) {
        _fromDate = date;
      } else {
        _toDate = date;
      }
      _validationMessage = null;
    });
  }

  DateTime? get _selectedFromDate => _isDaily ? _dailyDate : _fromDate;
  DateTime? get _selectedToDate => _isDaily ? _dailyDate : _toDate;

  void _submit() {
    final fromEntrySerial = _parseOptionalInt(_fromEntrySerialController);
    final toEntrySerial = _parseOptionalInt(_toEntrySerialController);

    if ((_fromEntrySerialController.text.trim().isNotEmpty &&
            fromEntrySerial == null) ||
        (_toEntrySerialController.text.trim().isNotEmpty &&
            toEntrySerial == null)) {
      _showValidation(
        _isArabic ? 'أدخل رقم تسلسل صحيحًا' : 'Enter a valid entry serial',
      );
      return;
    }
    if (fromEntrySerial != null &&
        toEntrySerial != null &&
        fromEntrySerial > toEntrySerial) {
      _showValidation(
        _isArabic
            ? 'التسلسل من يجب أن يكون أقل من أو يساوي التسلسل إلى'
            : 'From serial must be less than or equal to To serial',
      );
      return;
    }
    if (!_isDaily && (_fromDate == null) != (_toDate == null)) {
      _showValidation(
        _isArabic
            ? 'اختر تاريخ البداية والنهاية معًا'
            : 'Select both the from and to dates',
      );
      return;
    }
    if (_isDaily && _dailyDate == null) {
      _showValidation(_isArabic ? 'اختر اليوم' : 'Select a day');
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
      JournalReportFilterSelection(
        fromEntrySerial: fromEntrySerial,
        toEntrySerial: toEntrySerial,
        fromEntryNo: _optionalString(_fromEntryNoController),
        toEntryNo: _optionalString(_toEntryNoController),
        fromDate: _selectedFromDate,
        toDate: _selectedToDate,
        journalType: _journalType,
        journalReportType: _journalReportType,
        reportName: _reportName,
        exportType: _exportType,
      ),
    );
  }

  int? _parseOptionalInt(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : int.tryParse(value);
  }

  String? _optionalString(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  void _showValidation(String message) {
    setState(() => _validationMessage = message);
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final isDetailed = _journalType == 0;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.92.sh),
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
                      _sectionTitle(
                        _isArabic ? 'نوع اليومية' : 'Journal type',
                        foreground,
                      ),
                      Gap(8.h),
                      _dropdown<int>(
                        label: _isArabic
                            ? 'تفصيلي / إجمالي'
                            : 'Detailed / Total',
                        value: _journalType,
                        options: [
                          (0, _isArabic ? 'تفصيلي' : 'Detailed'),
                          (1, _isArabic ? 'إجمالي' : 'Summary'),
                        ],
                        onChanged: (value) => setState(() {
                          _journalType = value;
                          _validationMessage = null;
                        }),
                      ),
                      Gap(12.h),
                      _dropdown<int>(
                        label: _isArabic ? 'حالة اليومية' : 'Journal status',
                        value: _journalReportType,
                        options: [
                          (0, _isArabic ? 'عادية' : 'Regular'),
                          (
                            2,
                            _isArabic ? 'تقييم عملة' : 'Currency revaluation',
                          ),
                          (1, _isArabic ? 'مرحلة' : 'Posted'),
                          (3, _isArabic ? 'غير مرحلة' : 'Unposted'),
                          (4, _isArabic ? 'إهلاك' : 'Depreciation'),
                          (
                            6,
                            _isArabic
                                ? 'عملاء وموردون'
                                : 'Customers and suppliers',
                          ),
                          (5, _isArabic ? 'الجميع' : 'All'),
                        ],
                        onChanged: (value) =>
                            setState(() => _journalReportType = value),
                      ),
                      Gap(16.h),
                      _sectionTitle(
                        _isArabic ? 'نطاق القيود' : 'Entry range',
                        foreground,
                      ),
                      Gap(8.h),
                      Row(
                        children: [
                          Expanded(
                            child: _textField(
                              controller: _fromEntrySerialController,
                              label: _isArabic
                                  ? 'من تسلسل القيد'
                                  : 'From entry serial',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: _textField(
                              controller: _toEntrySerialController,
                              label: _isArabic
                                  ? 'إلى تسلسل القيد'
                                  : 'To entry serial',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap(10.h),
                      Row(
                        children: [
                          Expanded(
                            child: _textField(
                              controller: _fromEntryNoController,
                              label: _isArabic
                                  ? 'من رقم القيد'
                                  : 'From entry number',
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: _textField(
                              controller: _toEntryNoController,
                              label: _isArabic
                                  ? 'إلى رقم القيد'
                                  : 'To entry number',
                            ),
                          ),
                        ],
                      ),
                      Gap(16.h),
                      _sectionTitle(
                        _isArabic ? 'فترة التقرير' : 'Report period',
                        foreground,
                      ),
                      if (isDetailed && !widget.isMainAccountsReport)
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            _isArabic ? 'تقرير يومي' : 'Daily report',
                            style: TextStyle(
                              color: foreground,
                              fontSize: 13.sp,
                            ),
                          ),
                          value: _isDaily,
                          onChanged: (value) => setState(() {
                            _isDaily = value;
                            _validationMessage = null;
                          }),
                        ),
                      if (_isDaily) ...[
                        _dateButton(
                          label: _isArabic ? 'اليوم' : 'Day',
                          date: _dailyDate,
                          onPressed: () => _selectDate(isFromDate: true),
                        ),
                      ] else ...[
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
                      ],
                      if (isDetailed &&
                          (widget.isMainAccountsReport || !_isDaily)) ...[
                        Gap(16.h),
                        _sectionTitle(
                          _isArabic
                              ? 'خيارات التقرير التفصيلي'
                              : 'Detailed report options',
                          foreground,
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            _isArabic ? 'حسب المراكز' : 'By centers',
                            style: TextStyle(
                              color: foreground,
                              fontSize: 13.sp,
                            ),
                          ),
                          value: _includeCenters,
                          onChanged: (value) =>
                              setState(() => _includeCenters = value),
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            _isArabic ? 'حسب العملة' : 'By currency',
                            style: TextStyle(
                              color: foreground,
                              fontSize: 13.sp,
                            ),
                          ),
                          value: _includeCurrency,
                          onChanged: (value) =>
                              setState(() => _includeCurrency = value),
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
                        onChanged: (value) =>
                            setState(() => _exportType = value),
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

  Widget _sectionTitle(String title, Color foreground) => Text(
    title,
    style: TextStyle(
      color: foreground,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _textField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final foreground = AppColor.titleFormFiledColor(context);
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColor.textFormFillColor(context),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      ),
      style: TextStyle(color: foreground, fontSize: 13.sp),
      onChanged: (_) => _validationMessage == null
          ? null
          : setState(() => _validationMessage = null),
    );
  }

  Widget _dateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onPressed,
  }) {
    final displayValue = date == null
        ? (_isArabic ? 'الكل' : 'All dates')
        : MaterialLocalizations.of(context).formatMediumDate(date);
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
                  displayValue,
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
        filled: true,
        fillColor: AppColor.textFormFillColor(context),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      ),
      dropdownColor: AppColor.cardColor(context),
      style: TextStyle(color: foreground, fontSize: 13.sp),
      items: options
          .map(
            (option) =>
                DropdownMenuItem<T>(value: option.$1, child: Text(option.$2)),
          )
          .toList(),
      onChanged: (selected) {
        if (selected != null) onChanged(selected);
      },
    );
  }
}
