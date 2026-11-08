import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/home/data/models/banks_data_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/bank_picker.dart';
import 'package:my_template/features/reports/data/models/report_date_formatter.dart';

class WithdrawAndDepositingVoucherReportFilterSelection {
  final int? fromBankCode;
  final int? toBankCode;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String exportType;

  const WithdrawAndDepositingVoucherReportFilterSelection({
    required this.fromBankCode,
    required this.toBankCode,
    required this.fromDate,
    required this.toDate,
    required this.exportType,
  });
}

class WithdrawAndDepositingVoucherReportFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final String initialExportType;

  const WithdrawAndDepositingVoucherReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<WithdrawAndDepositingVoucherReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<
      WithdrawAndDepositingVoucherReportFilterSelection
    >(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WithdrawAndDepositingVoucherReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<WithdrawAndDepositingVoucherReportFilterBottomSheetWidget>
  createState() =>
      _WithdrawAndDepositingVoucherReportFilterBottomSheetWidgetState();
}

class _WithdrawAndDepositingVoucherReportFilterBottomSheetWidgetState
    extends State<WithdrawAndDepositingVoucherReportFilterBottomSheetWidget> {
  BANKSDATAModel? _fromBank;
  BANKSDATAModel? _toBank;
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

  Future<void> _selectBank({required bool isFromBank}) async {
    final bank = await showBankPicker(context);
    if (!mounted || bank == null) return;
    setState(() {
      if (isFromBank) {
        _fromBank = bank;
      } else {
        _toBank = bank;
      }
      _validationMessage = null;
    });
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
      WithdrawAndDepositingVoucherReportFilterSelection(
        fromBankCode: _fromBank?.bankCode,
        toBankCode: _toBank?.bankCode,
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
                      Text(
                        _isArabic ? 'نطاق البنوك' : 'Bank range',
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
                            child: _pickButton(
                              label: _isArabic ? 'من بنك' : 'From bank',
                              value: _bankLabel(_fromBank),
                              onPressed: () => _selectBank(isFromBank: true),
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: _pickButton(
                              label: _isArabic ? 'إلى بنك' : 'To bank',
                              value: _bankLabel(_toBank),
                              onPressed: () => _selectBank(isFromBank: false),
                            ),
                          ),
                        ],
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

  String? _bankLabel(BANKSDATAModel? bank) {
    if (bank == null) return null;
    return bankDisplayName(bank, isArabic: _isArabic);
  }

  Widget _pickButton({
    required String label,
    required String? value,
    required VoidCallback onPressed,
  }) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColor.oceanBlue,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
    child: Row(
      children: [
        const Icon(Icons.search_rounded, size: 16),
        Gap(6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 10.sp)),
              Gap(2.h),
              Text(
                value ?? (_isArabic ? 'الكل' : 'All'),
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
                      : formatReportDateTime(date),
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
