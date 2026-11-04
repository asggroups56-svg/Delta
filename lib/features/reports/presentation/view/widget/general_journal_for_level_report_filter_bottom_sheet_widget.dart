import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

class GeneralJournalForLevelReportFilterSelection {
  final int? accountLevel;
  final int? fromEntrySerial;
  final int? toEntrySerial;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String exportType;

  const GeneralJournalForLevelReportFilterSelection({
    required this.accountLevel,
    required this.fromEntrySerial,
    required this.toEntrySerial,
    required this.fromDate,
    required this.toDate,
    required this.exportType,
  });
}

class GeneralJournalForLevelReportFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final String initialExportType;

  const GeneralJournalForLevelReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<GeneralJournalForLevelReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<GeneralJournalForLevelReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GeneralJournalForLevelReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<GeneralJournalForLevelReportFilterBottomSheetWidget> createState() =>
      _GeneralJournalForLevelReportFilterBottomSheetWidgetState();
}

class _GeneralJournalForLevelReportFilterBottomSheetWidgetState
    extends State<GeneralJournalForLevelReportFilterBottomSheetWidget> {
  final _accountLevelController = TextEditingController();
  final _fromEntrySerialController = TextEditingController();
  final _toEntrySerialController = TextEditingController();
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
    _accountLevelController.dispose();
    _fromEntrySerialController.dispose();
    _toEntrySerialController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({required bool isFromDate}) async {
    final current = isFromDate ? _fromDate : _toDate;
    final selected = await showDatePicker(
      context: context,
      initialDate: DateUtils.dateOnly(current ?? DateTime.now()),
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

  int? _parseOptionalInt(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : int.tryParse(text);
  }

  void _submit() {
    final accountLevel = _parseOptionalInt(_accountLevelController);
    final fromEntrySerial = _parseOptionalInt(_fromEntrySerialController);
    final toEntrySerial = _parseOptionalInt(_toEntrySerialController);

    if ((_accountLevelController.text.trim().isNotEmpty &&
            accountLevel == null) ||
        (_fromEntrySerialController.text.trim().isNotEmpty &&
            fromEntrySerial == null) ||
        (_toEntrySerialController.text.trim().isNotEmpty &&
            toEntrySerial == null)) {
      _showValidation(_isArabic ? 'أدخل أرقامًا صحيحة' : 'Enter valid numbers');
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
    if ((_fromDate == null) != (_toDate == null)) {
      _showValidation(
        _isArabic
            ? 'اختر تاريخ البداية والنهاية معًا أو اتركهما فارغين'
            : 'Select both dates or leave both empty',
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
      GeneralJournalForLevelReportFilterSelection(
        accountLevel: accountLevel,
        fromEntrySerial: fromEntrySerial,
        toEntrySerial: toEntrySerial,
        fromDate: _fromDate,
        toDate: _toDate,
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
                      _field(
                        controller: _accountLevelController,
                        label: _isArabic ? 'مستوى الحساب' : 'Account level',
                      ),
                      Gap(12.h),
                      Row(
                        children: [
                          Expanded(
                            child: _field(
                              controller: _fromEntrySerialController,
                              label: _isArabic
                                  ? 'من تسلسل القيد'
                                  : 'From entry serial',
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: _field(
                              controller: _toEntrySerialController,
                              label: _isArabic
                                  ? 'إلى تسلسل القيد'
                                  : 'To entry serial',
                            ),
                          ),
                        ],
                      ),
                      Gap(12.h),
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
                      Gap(12.h),
                      DropdownButtonFormField<String>(
                        initialValue: _exportType,
                        decoration: InputDecoration(
                          labelText: _isArabic
                              ? 'صيغة التصدير'
                              : 'Export format',
                          filled: true,
                          fillColor: AppColor.textFormFillColor(context),
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

  Widget _field({
    required TextEditingController controller,
    required String label,
  }) {
    final foreground = AppColor.titleFormFiledColor(context);
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColor.textFormFillColor(context),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      ),
      style: TextStyle(color: foreground, fontSize: 13.sp),
      onChanged: (_) {
        if (_validationMessage != null) {
          setState(() => _validationMessage = null);
        }
      },
    );
  }

  Widget _dateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onPressed,
  }) {
    final foreground = AppColor.titleFormFiledColor(context);
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
                  style: TextStyle(color: foreground, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
