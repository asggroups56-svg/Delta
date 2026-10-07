import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

class CostCentersProjectsReportFilterSelection {
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;

  const CostCentersProjectsReportFilterSelection({
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromDate,
    this.toDate,
    required this.reportName,
  });
}

class CostCentersProjectsReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialReportName;

  const CostCentersProjectsReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialReportName = 'Agl026_Project2',
  });

  static Future<CostCentersProjectsReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialReportName = 'Agl026_Project2',
  }) {
    return showModalBottomSheet<CostCentersProjectsReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CostCentersProjectsReportFilterBottomSheetWidget(
        title: title,
        initialReportName: initialReportName,
      ),
    );
  }

  @override
  State<CostCentersProjectsReportFilterBottomSheetWidget> createState() =>
      _CostCentersProjectsReportFilterBottomSheetWidgetState();
}

class _CostCentersProjectsReportFilterBottomSheetWidgetState
    extends State<CostCentersProjectsReportFilterBottomSheetWidget> {
  late String _selectedReportName;
  CostCenterLightModel? _fromCostCenter;
  CostCenterLightModel? _toCostCenter;
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _includeDates = false;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    _selectedReportName = widget.initialReportName;
  }

  Future<void> _selectDate({required bool isFromDate}) async {
    final initial = (isFromDate ? _fromDate : _toDate) ?? DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: initial,
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

    Navigator.pop(
      context,
      CostCentersProjectsReportFilterSelection(
        reportName: _selectedReportName,
        fromCostCenterNo: _fromCostCenter?.costCenterNo,
        toCostCenterNo: _toCostCenter?.costCenterNo,
        fromDate: _includeDates ? _fromDate : null,
        toDate: _includeDates ? _toDate : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.purpleAccent;
    final isAr = context.locale.languageCode == 'ar';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
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
                // Grab Handle
                Center(
                  child: Container(
                    width: 44.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: foreground.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                Gap(14.h),

                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.business_outlined,
                        color: accent,
                        size: 22.sp,
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style:
                                AppTextStyle.formTitleStyle(context).copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(2.h),
                          Text(
                            'Report/CostCentersProjectsReport',
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              color: foreground.withValues(alpha: 0.55),
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: foreground.withValues(alpha: 0.6),
                        size: 22.sp,
                      ),
                    ),
                  ],
                ),
                Gap(16.h),

                // Report Type Selector
                Text(
                  isAr ? 'نوع التقرير' : 'Report Type',
                  style: AppTextStyle.formTitleStyle(context).copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                Gap(8.h),
                Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: AppColor.textFormFillColor(context),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: foreground.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _reportTypeTab(
                          label: isAr
                              ? 'ملخص مراكز المشاريع'
                              : 'Projects Summary',
                          code: 'Agl026_Project2',
                          isSelected: _selectedReportName == 'Agl026_Project2',
                          accent: accent,
                          foreground: foreground,
                        ),
                      ),
                      Gap(6.w),
                      Expanded(
                        child: _reportTypeTab(
                          label: isAr
                              ? 'مراكز تكلفة المشاريع'
                              : 'Projects Detailed',
                          code: 'Agl026_Project',
                          isSelected: _selectedReportName == 'Agl026_Project',
                          accent: accent,
                          foreground: foreground,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(16.h),

                // Cost Center Range
                CostCenterDropdown(
                  title: isAr ? 'من مركز تكلفة' : 'From Cost Center',
                  hintText: isAr ? 'جميع مراكز التكلفة' : 'All Cost Centers',
                  initialValue: _fromCostCenter,
                  onSelected: (val) => setState(() => _fromCostCenter = val),
                ),
                Gap(12.h),
                CostCenterDropdown(
                  title: isAr ? 'إلى مركز تكلفة' : 'To Cost Center',
                  hintText: isAr ? 'جميع مراكز التكلفة' : 'All Cost Centers',
                  initialValue: _toCostCenter,
                  onSelected: (val) => setState(() => _toCostCenter = val),
                ),
                Gap(16.h),

                // Date Filter Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'تحديد فترة التاريخ' : 'Filter by Date Range',
                      style: AppTextStyle.formTitleStyle(context).copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
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
                        child: _datePickerField(
                          label: AppLocaleKey.fromDate.tr(),
                          date: _fromDate,
                          onTap: () => _selectDate(isFromDate: true),
                          foreground: foreground,
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: _datePickerField(
                          label: AppLocaleKey.toDate.tr(),
                          date: _toDate,
                          onTap: () => _selectDate(isFromDate: false),
                          foreground: foreground,
                        ),
                      ),
                    ],
                  ),
                ],

                if (_validationMessage != null) ...[
                  Gap(12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 16.sp,
                          color: Colors.redAccent,
                        ),
                        Gap(8.w),
                        Expanded(
                          child: Text(
                            _validationMessage!,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Gap(22.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                          foregroundColor: foreground,
                          side: BorderSide(
                            color: foreground.withValues(alpha: 0.2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          AppLocaleKey.cancelAction.tr(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                        label: Text(
                          isAr ? 'عرض / تصدير التقرير' : 'View / Export Report',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _reportTypeTab({
    required String label,
    required String code,
    required bool isSelected,
    required Color accent,
    required Color foreground,
  }) {
    return InkWell(
      onTap: () => setState(() => _selectedReportName = code),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? accent : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : foreground,
                fontSize: 11.5.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            Gap(2.h),
            Text(
              code,
              style: TextStyle(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.85)
                    : foreground.withValues(alpha: 0.5),
                fontSize: 9.5.sp,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datePickerField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required Color foreground,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
            color: foreground,
          ),
        ),
        Gap(6.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: AppColor.textFormFillColor(context),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: foreground.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 15.sp,
                  color: AppColor.purpleAccent,
                ),
                Gap(8.w),
                Expanded(
                  child: Text(
                    date != null ? _formatDate(date) : '-',
                    style: AppTextStyle.textFormStyle(context).copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
