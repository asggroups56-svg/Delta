import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

class AccountsCentersComparisonReportFilterSelection {
  final num? fromAccountNo;
  final num? toAccountNo;
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final int balance;
  final int periodically;
  final int reportGroup;
  final String exportType;

  const AccountsCentersComparisonReportFilterSelection({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCostCenterNo,
    this.toCostCenterNo,
    required this.balance,
    required this.periodically,
    required this.reportGroup,
    required this.exportType,
  });
}

class AccountsCentersComparisonReportFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final bool showBalanceFilter;
  final bool showPeriodFilter;
  final bool showReportGroupFilter;

  const AccountsCentersComparisonReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.showBalanceFilter = true,
    this.showPeriodFilter = true,
    this.showReportGroupFilter = true,
  });

  static Future<AccountsCentersComparisonReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    bool showBalanceFilter = true,
    bool showPeriodFilter = true,
    bool showReportGroupFilter = true,
  }) {
    return showModalBottomSheet<AccountsCentersComparisonReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AccountsCentersComparisonReportFilterBottomSheetWidget(
        title: title,
        showBalanceFilter: showBalanceFilter,
        showPeriodFilter: showPeriodFilter,
        showReportGroupFilter: showReportGroupFilter,
      ),
    );
  }

  @override
  State<AccountsCentersComparisonReportFilterBottomSheetWidget> createState() =>
      _AccountsCentersComparisonReportFilterBottomSheetWidgetState();
}

class _AccountsCentersComparisonReportFilterBottomSheetWidgetState
    extends State<AccountsCentersComparisonReportFilterBottomSheetWidget> {
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  CostCenterLightModel? _fromCostCenter;
  CostCenterLightModel? _toCostCenter;
  int _balance = 0;
  int _periodically = 0;
  int _reportGroup = 0;
  String _exportType = 'pdf';
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

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

    Navigator.pop(
      context,
      AccountsCentersComparisonReportFilterSelection(
        fromAccountNo: fromAccountNo,
        toAccountNo: toAccountNo,
        fromCostCenterNo: fromCostCenterNo,
        toCostCenterNo: toCostCenterNo,
        balance: _balance,
        periodically: _periodically,
        reportGroup: _reportGroup,
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
                  'Report/AccountsCentersComparisonReport',
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
                  Text(
                    _isArabic ? 'نطاق الحسابات' : 'Account range',
                    style: TextStyle(
                      color: foreground,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
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
                  Text(
                    _isArabic ? 'نطاق مراكز التكلفة' : 'Cost center range',
                    style: TextStyle(
                      color: foreground,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
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
                  if (widget.showBalanceFilter) ...[
                    _dropdown<int>(
                      label: _isArabic ? 'نوع الرصيد' : 'Balance type',
                      value: _balance,
                      options: [
                        (0, _isArabic ? 'الرصيد السابق' : 'Previous balance'),
                        (1, _isArabic ? 'الرصيد التقديري' : 'Budget balance'),
                      ],
                      onChanged: (value) => setState(() => _balance = value),
                    ),
                    Gap(12.h),
                  ],
                  if (widget.showPeriodFilter) ...[
                    _dropdown<int>(
                      label: _isArabic ? 'الفترة' : 'Period',
                      value: _periodically,
                      options: [
                        (0, _isArabic ? 'إجمالي' : 'Total'),
                        (1, _isArabic ? 'شهري' : 'Monthly'),
                      ],
                      onChanged: (value) =>
                          setState(() => _periodically = value),
                    ),
                    Gap(12.h),
                  ],
                  if (widget.showReportGroupFilter) ...[
                    _dropdown<int>(
                      label: _isArabic ? 'نوع المقارنة' : 'Comparison group',
                      value: _reportGroup,
                      options: [
                        (0, _isArabic ? 'حسابات المراكز' : 'Center accounts'),
                        (1, _isArabic ? 'مراكز الحسابات' : 'Account centers'),
                      ],
                      onChanged: (value) =>
                          setState(() => _reportGroup = value),
                    ),
                    Gap(12.h),
                  ],
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
                  backgroundColor: AppColor.oceanBlue,
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
