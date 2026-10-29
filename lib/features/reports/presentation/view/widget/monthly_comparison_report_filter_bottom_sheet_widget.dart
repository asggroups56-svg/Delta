import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

enum MonthlyComparisonReportMode { accounts, costCenters }

class MonthlyComparisonReportFilterSelection {
  final num? fromNo;
  final num? toNo;
  final int accountType;
  final String reportName;

  const MonthlyComparisonReportFilterSelection({
    this.fromNo,
    this.toNo,
    required this.accountType,
    required this.reportName,
  });
}

class MonthlyComparisonReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final MonthlyComparisonReportMode mode;

  const MonthlyComparisonReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    required this.mode,
  });

  static Future<MonthlyComparisonReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    required MonthlyComparisonReportMode mode,
  }) {
    return showModalBottomSheet<MonthlyComparisonReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MonthlyComparisonReportFilterBottomSheetWidget(
        title: title,
        mode: mode,
      ),
    );
  }

  @override
  State<MonthlyComparisonReportFilterBottomSheetWidget> createState() =>
      _MonthlyComparisonReportFilterBottomSheetWidgetState();
}

class _MonthlyComparisonReportFilterBottomSheetWidgetState
    extends State<MonthlyComparisonReportFilterBottomSheetWidget> {
  static const List<String> _accountReportNames = [
    'AGL003_Bar',
    'AGL003_Line',
    'AGL003_Pie',
  ];

  static const List<String> _costCenterReportNames = [
    'AGL008_Chart',
    'AGL008_Line',
    'AGL008_Pie',
  ];

  int _selectedChartIndex = 0;
  int _accountType = 3;
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  CostCenterLightModel? _fromCostCenter;
  CostCenterLightModel? _toCostCenter;
  String? _validationMessage;

  bool get _isAccounts => widget.mode == MonthlyComparisonReportMode.accounts;

  List<String> get _reportNames =>
      _isAccounts ? _accountReportNames : _costCenterReportNames;

  String get _selectedReportName => _reportNames[_selectedChartIndex];

  void _submit() {
    final fromNo = _isAccounts
        ? _fromAccount?.accountNo
        : _fromCostCenter?.costCenterNo;
    final toNo = _isAccounts
        ? _toAccount?.accountNo
        : _toCostCenter?.costCenterNo;

    if (fromNo != null && toNo != null && fromNo > toNo) {
      setState(() {
        _validationMessage = context.locale.languageCode == 'ar'
            ? 'يجب أن يكون رقم البداية أقل من أو يساوي رقم النهاية'
            : 'The start number must be less than or equal to the end number';
      });
      return;
    }

    Navigator.pop(
      context,
      MonthlyComparisonReportFilterSelection(
        fromNo: fromNo,
        toNo: toNo,
        accountType: _accountType,
        reportName: _selectedReportName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = _isAccounts ? AppColor.oceanBlue : AppColor.purpleAccent;
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
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        _isAccounts
                            ? Icons.compare_arrows_rounded
                            : Icons.business_outlined,
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
                            style: AppTextStyle.formTitleStyle(context)
                                .copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Gap(2.h),
                          Text(
                            _isAccounts
                                ? 'Report/MonthlyAccountComparsionReport'
                                : 'Report/MonthlyCostCentersComparsionReport',
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

                // ── Chart Type ──
                _sectionLabel(context, AppLocaleKey.comparisonReportType.tr()),
                Gap(8.h),
                Row(
                  children: [
                    Expanded(
                      child: _chartTypeCard(
                        index: 0,
                        icon: Icons.bar_chart_rounded,
                        label: AppLocaleKey.chartBar.tr(),
                        accent: accent,
                        foreground: foreground,
                      ),
                    ),
                    Gap(8.w),
                    Expanded(
                      child: _chartTypeCard(
                        index: 1,
                        icon: Icons.show_chart_rounded,
                        label: AppLocaleKey.chartLine.tr(),
                        accent: accent,
                        foreground: foreground,
                      ),
                    ),
                    Gap(8.w),
                    Expanded(
                      child: _chartTypeCard(
                        index: 2,
                        icon: Icons.pie_chart_rounded,
                        label: AppLocaleKey.chartPie.tr(),
                        accent: accent,
                        foreground: foreground,
                      ),
                    ),
                  ],
                ),
                Gap(16.h),

                // ── Account / Cost Center Type ──
                _sectionLabel(
                  context,
                  _isAccounts
                      ? AppLocaleKey.selectAccountType.tr()
                      : AppLocaleKey.selectCostCenterType.tr(),
                ),
                Gap(8.h),
                Row(
                  children: [
                    Expanded(
                      child: _typeChip(
                        value: 3,
                        label: _isAccounts
                            ? AppLocaleKey.allAccounts.tr()
                            : AppLocaleKey.allCostCenters.tr(),
                        accent: accent,
                        foreground: foreground,
                      ),
                    ),
                    Gap(8.w),
                    Expanded(
                      child: _typeChip(
                        value: 1,
                        label: _isAccounts
                            ? AppLocaleKey.mainAccounts.tr()
                            : AppLocaleKey.mainCostCenters.tr(),
                        accent: accent,
                        foreground: foreground,
                      ),
                    ),
                    Gap(8.w),
                    Expanded(
                      child: _typeChip(
                        value: 2,
                        label: _isAccounts
                            ? AppLocaleKey.subAccounts.tr()
                            : AppLocaleKey.subCostCenters.tr(),
                        accent: accent,
                        foreground: foreground,
                      ),
                    ),
                  ],
                ),
                Gap(16.h),

                // ── Range ──
                // Account-to-account selection is loaded from
                // ChartOfAccount/GetLight through ChartOfAccountDropdown
                // (LookupRepo.getChartOfAccountLight).
                if (_isAccounts) ...[
                  ChartOfAccountDropdown(
                    title: isAr ? 'من حساب' : 'From Account',
                    hintText: isAr ? 'جميع الحسابات' : 'All accounts',
                    initialValue: _fromAccount,
                    onSelected: (value) => setState(() {
                      _fromAccount = value;
                      _validationMessage = null;
                    }),
                  ),
                  Gap(12.h),
                  ChartOfAccountDropdown(
                    title: isAr ? 'إلى حساب' : 'To Account',
                    hintText: isAr ? 'جميع الحسابات' : 'All accounts',
                    initialValue: _toAccount,
                    onSelected: (value) => setState(() {
                      _toAccount = value;
                      _validationMessage = null;
                    }),
                  ),
                ] else ...[
                  // Cost-center-to-cost-center selection is loaded from
                  // CostCenter/GetLight through CostCenterDropdown
                  // (LookupRepo.getCostCenterLight).
                  CostCenterDropdown(
                    title: isAr ? 'من مركز تكلفة' : 'From Cost Center',
                    hintText: isAr ? 'جميع مراكز التكلفة' : 'All Cost Centers',
                    initialValue: _fromCostCenter,
                    onSelected: (value) => setState(() {
                      _fromCostCenter = value;
                      _validationMessage = null;
                    }),
                  ),
                  Gap(12.h),
                  CostCenterDropdown(
                    title: isAr ? 'إلى مركز تكلفة' : 'To Cost Center',
                    hintText: isAr ? 'جميع مراكز التكلفة' : 'All Cost Centers',
                    initialValue: _toCostCenter,
                    onSelected: (value) => setState(() {
                      _toCostCenter = value;
                      _validationMessage = null;
                    }),
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
                        icon: const Icon(
                          Icons.picture_as_pdf_rounded,
                          size: 18,
                        ),
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

  Widget _sectionLabel(BuildContext context, String label) {
    return Text(
      label,
      style: AppTextStyle.formTitleStyle(
        context,
      ).copyWith(fontWeight: FontWeight.w600, fontSize: 13.sp),
    );
  }

  Widget _chartTypeCard({
    required int index,
    required IconData icon,
    required String label,
    required Color accent,
    required Color foreground,
  }) {
    final isSelected = _selectedChartIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedChartIndex = index),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? accent.withValues(alpha: 0.14)
              : AppColor.textFormFillColor(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? accent : foreground.withValues(alpha: 0.12),
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: isSelected ? accent : foreground.withValues(alpha: 0.55),
            ),
            Gap(4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? accent : foreground,
              ),
            ),
            Gap(2.h),
            Text(
              _isAccounts ? 'AGL003' : 'AGL008',
              style: TextStyle(
                fontSize: 9.5.sp,
                fontFamily: 'monospace',
                color: isSelected
                    ? accent.withValues(alpha: 0.75)
                    : foreground.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeChip({
    required int value,
    required String label,
    required Color accent,
    required Color foreground,
  }) {
    final isSelected = _accountType == value;

    return InkWell(
      onTap: () => setState(() => _accountType = value),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: isSelected ? accent : AppColor.textFormFillColor(context),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? accent : foreground.withValues(alpha: 0.12),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? Colors.white : foreground,
            fontSize: 11.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
