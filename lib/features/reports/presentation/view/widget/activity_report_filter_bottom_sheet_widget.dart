import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';
import 'package:my_template/features/reports/data/models/report_date_formatter.dart';

class ActivityReportFilterSelection {
  final int? fromCenterNoOne;
  final int? toCenterNoOne;
  final int? fromAccountNo;
  final int? toAccountNo;
  final int? fromCenterNoZero;
  final int? toCenterNoZero;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String exportType;

  const ActivityReportFilterSelection({
    required this.fromCenterNoOne,
    required this.toCenterNoOne,
    required this.fromAccountNo,
    required this.toAccountNo,
    required this.fromCenterNoZero,
    required this.toCenterNoZero,
    required this.fromDate,
    required this.toDate,
    required this.exportType,
  });
}

class ActivityReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialExportType;

  const ActivityReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<ActivityReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<ActivityReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ActivityReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<ActivityReportFilterBottomSheetWidget> createState() =>
      _ActivityReportFilterBottomSheetWidgetState();
}

class _ActivityReportFilterBottomSheetWidgetState
    extends State<ActivityReportFilterBottomSheetWidget> {
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  CostCenterLightModel? _fromCenterOne;
  CostCenterLightModel? _toCenterOne;
  CostCenterLightModel? _fromCenterZero;
  CostCenterLightModel? _toCenterZero;
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
    if (_fromAccount != null &&
        _toAccount != null &&
        _fromAccount!.accountNo > _toAccount!.accountNo) {
      _showValidation(
        _isArabic
            ? 'حساب البداية يجب أن يسبق أو يساوي حساب النهاية'
            : 'From account must be less than or equal to To account',
      );
      return;
    }
    if (!_isValidCenterRange(_fromCenterOne, _toCenterOne)) {
      _showValidation(
        _isArabic
            ? 'مركز البداية يجب أن يسبق أو يساوي مركز النهاية'
            : 'From center must be less than or equal to To center',
      );
      return;
    }
    if (!_isValidCenterRange(_fromCenterZero, _toCenterZero)) {
      _showValidation(
        _isArabic
            ? 'مركز تكلفة البداية يجب أن يسبق أو يساوي مركز تكلفة النهاية'
            : 'From cost center must be less than or equal to To cost center',
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
      ActivityReportFilterSelection(
        fromCenterNoOne: _fromCenterOne?.costCenterNo.toInt(),
        toCenterNoOne: _toCenterOne?.costCenterNo.toInt(),
        fromAccountNo: _fromAccount?.accountNo,
        toAccountNo: _toAccount?.accountNo,
        fromCenterNoZero: _fromCenterZero?.costCenterNo.toInt(),
        toCenterNoZero: _toCenterZero?.costCenterNo.toInt(),
        fromDate: _fromDate,
        toDate: _toDate,
        exportType: _exportType,
      ),
    );
  }

  bool _isValidCenterRange(
    CostCenterLightModel? from,
    CostCenterLightModel? to,
  ) {
    if (from == null || to == null) return true;
    return from.costCenterNo <= to.costCenterNo;
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
                      _isArabic ? 'نطاق الحسابات' : 'Account range',
                      foreground,
                    ),
                    Gap(8.h),
                    ChartOfAccountDropdown(
                      title: _isArabic ? 'من حساب' : 'From account',
                      accountType: 1,
                      includeAccountRangeFields: false,
                      includeAccountsHasCostCenters: null,
                      initialValue: _fromAccount,
                      onSelected: (account) {
                        setState(() => _fromAccount = account);
                      },
                    ),
                    Gap(10.h),
                    ChartOfAccountDropdown(
                      title: _isArabic ? 'إلى حساب' : 'To account',
                      accountType: 1,
                      includeAccountRangeFields: false,
                      includeAccountsHasCostCenters: null,
                      initialValue: _toAccount,
                      onSelected: (account) {
                        setState(() => _toAccount = account);
                      },
                    ),
                    Gap(14.h),
                    _sectionTitle(
                      _isArabic ? 'من مركز إلى مركز' : 'Center to center',
                      foreground,
                    ),
                    Gap(8.h),
                    CostCenterDropdown(
                      title: _isArabic ? 'من مركز' : 'From center',
                      centerType: 1,
                      centerKind: 0,
                      pageSize: 3,
                      initialValue: _fromCenterOne,
                      onSelected: (center) {
                        setState(() => _fromCenterOne = center);
                      },
                    ),
                    Gap(10.h),
                    CostCenterDropdown(
                      title: _isArabic ? 'إلى مركز' : 'To center',
                      centerType: 1,
                      centerKind: 0,
                      pageSize: 3,
                      initialValue: _toCenterOne,
                      onSelected: (center) {
                        setState(() => _toCenterOne = center);
                      },
                    ),
                    Gap(14.h),
                    _sectionTitle(
                      _isArabic
                          ? 'من مركز تكلفة إلى مركز تكلفة'
                          : 'Cost center to cost center',
                      foreground,
                    ),
                    Gap(8.h),
                    CostCenterDropdown(
                      title: _isArabic ? 'من مركز تكلفة' : 'From cost center',
                      centerType: 1,
                      centerKind: 0,
                      idAsString: '1',
                      pageSize: 3,
                      initialValue: _fromCenterZero,
                      onSelected: (center) {
                        setState(() => _fromCenterZero = center);
                      },
                    ),
                    Gap(10.h),
                    CostCenterDropdown(
                      title: _isArabic ? 'إلى مركز تكلفة' : 'To cost center',
                      centerType: 1,
                      centerKind: 0,
                      idAsString: '1',
                      pageSize: 3,
                      initialValue: _toCenterZero,
                      onSelected: (center) {
                        setState(() => _toCenterZero = center);
                      },
                    ),
                    Gap(14.h),
                    _sectionTitle(
                      _isArabic ? 'فترة التقرير' : 'Report period',
                      foreground,
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
