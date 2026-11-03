import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

class CenterOnCenterAnalysisReportFilterSelection {
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;

  const CenterOnCenterAnalysisReportFilterSelection({
    required this.fromCostCenterNo,
    required this.toCostCenterNo,
    required this.fromDate,
    required this.toDate,
    required this.reportName,
    required this.exportType,
  });
}

class CenterOnCenterAnalysisReportFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final String initialExportType;

  const CenterOnCenterAnalysisReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<CenterOnCenterAnalysisReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<CenterOnCenterAnalysisReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CenterOnCenterAnalysisReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<CenterOnCenterAnalysisReportFilterBottomSheetWidget> createState() =>
      _CenterOnCenterAnalysisReportFilterBottomSheetWidgetState();
}

class _CenterOnCenterAnalysisReportFilterBottomSheetWidgetState
    extends State<CenterOnCenterAnalysisReportFilterBottomSheetWidget> {
  CostCenterLightModel? _fromCenter;
  CostCenterLightModel? _toCenter;
  DateTime? _fromDate;
  DateTime? _toDate;
  String _reportName = 'AGL025A';
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
    if (_fromCenter != null &&
        _toCenter != null &&
        _fromCenter!.costCenterNo > _toCenter!.costCenterNo) {
      setState(() {
        _validationMessage = _isArabic
            ? 'مركز البداية يجب أن يسبق أو يساوي مركز النهاية'
            : 'From center must be less than or equal to To center';
      });
      return;
    }
    if ((_fromDate == null) != (_toDate == null)) {
      setState(() {
        _validationMessage = _isArabic
            ? 'اختر تاريخ البداية والنهاية معًا أو اتركهما فارغين'
            : 'Select both dates or leave both empty';
      });
      return;
    }
    if (_fromDate != null && _fromDate!.isAfter(_toDate!)) {
      setState(() {
        _validationMessage = _isArabic
            ? 'تاريخ البداية يجب أن يسبق أو يساوي تاريخ النهاية'
            : 'From date must be before or equal to To date';
      });
      return;
    }

    Navigator.pop(
      context,
      CenterOnCenterAnalysisReportFilterSelection(
        fromCostCenterNo: _fromCenter?.costCenterNo,
        toCostCenterNo: _toCenter?.costCenterNo,
        fromDate: _fromDate,
        toDate: _toDate,
        reportName: _reportName,
        exportType: _exportType,
      ),
    );
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
                      CostCenterDropdown(
                        title: _isArabic ? 'من مركز' : 'From center',
                        initialValue: _fromCenter,
                        onSelected: (center) {
                          setState(() => _fromCenter = center);
                        },
                      ),
                      Gap(10.h),
                      CostCenterDropdown(
                        title: _isArabic ? 'إلى مركز' : 'To center',
                        initialValue: _toCenter,
                        onSelected: (center) {
                          setState(() => _toCenter = center);
                        },
                      ),
                      Gap(14.h),
                      DropdownButtonFormField<String>(
                        initialValue: _reportName,
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'نوع التقرير' : 'Report type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'AGL025A',
                            child: Text(_isArabic ? 'إجمالي' : 'Summary'),
                          ),
                          DropdownMenuItem(
                            value: 'AGL025B',
                            child: Text(_isArabic ? 'تفصيلي' : 'Detailed'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _reportName = value);
                          }
                        },
                      ),
                      Gap(14.h),
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
