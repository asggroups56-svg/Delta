import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';

class AccountsComparisonReportFilterSelection {
  final num? fromAccountNo;
  final num? toAccountNo;
  final int? fromAccountLevel;
  final int? toAccountLevel;
  final int accountType;
  final int financialStatementType;
  final int? fromMonth;
  final int? toMonth;
  final int? comparisonMonth;
  final int? balance;
  final int? periodically;
  final String? reportName;
  final String exportType;

  const AccountsComparisonReportFilterSelection({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromAccountLevel,
    this.toAccountLevel,
    required this.accountType,
    required this.financialStatementType,
    this.fromMonth,
    this.toMonth,
    this.comparisonMonth,
    this.balance,
    this.periodically,
    this.reportName,
    required this.exportType,
  });
}

class AccountsComparisonReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final bool isMonthly;
  final bool isComparisonMonth;
  final bool isBalancePeriodically;

  const AccountsComparisonReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.isMonthly = false,
    this.isComparisonMonth = false,
    this.isBalancePeriodically = false,
  });

  static Future<AccountsComparisonReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    bool isMonthly = false,
    bool isComparisonMonth = false,
    bool isBalancePeriodically = false,
  }) {
    return showModalBottomSheet<AccountsComparisonReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AccountsComparisonReportFilterBottomSheetWidget(
        title: title,
        isMonthly: isMonthly,
        isComparisonMonth: isComparisonMonth,
        isBalancePeriodically: isBalancePeriodically,
      ),
    );
  }

  @override
  State<AccountsComparisonReportFilterBottomSheetWidget> createState() =>
      _AccountsComparisonReportFilterBottomSheetWidgetState();
}

class _AccountsComparisonReportFilterBottomSheetWidgetState
    extends State<AccountsComparisonReportFilterBottomSheetWidget> {
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  int _accountType = 2;
  int _financialStatementType = 4;
  int _fromMonth = 0;
  int _toMonth = 0;
  int _balance = 0;
  int _periodically = 0;
  int _comparisonMonth = 1;
  String _exportType = 'pdf';
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  String get _balancePeriodicallyReportName {
    if (_periodically == 0) {
      return _balance == 0 ? 'AGL006' : 'AGL005';
    }
    return _balance == 0 ? 'AGL049' : 'AGL046';
  }

  void _submit() {
    final fromNo = _fromAccount?.accountNo;
    final toNo = _toAccount?.accountNo;
    if (fromNo != null && toNo != null && fromNo > toNo) {
      setState(() {
        _validationMessage = _isArabic
            ? 'الحساب من يجب أن يكون أقل من أو يساوي الحساب إلى'
            : 'From account must be less than or equal to To account';
      });
      return;
    }
    if (widget.isMonthly &&
        _fromMonth != 0 &&
        _toMonth != 0 &&
        _fromMonth > _toMonth) {
      setState(() {
        _validationMessage = _isArabic
            ? 'شهر البداية يجب أن يسبق أو يساوي شهر النهاية'
            : 'From month must be before or equal to To month';
      });
      return;
    }
    if (widget.isBalancePeriodically &&
        _fromMonth != 0 &&
        _toMonth != 0 &&
        _fromMonth > _toMonth) {
      setState(() {
        _validationMessage = _isArabic
            ? 'شهر البداية يجب أن يسبق أو يساوي شهر النهاية'
            : 'From month must be before or equal to To month';
      });
      return;
    }

    final reportName = widget.isBalancePeriodically
        ? _balancePeriodicallyReportName
        : null;

    Navigator.pop(
      context,
      AccountsComparisonReportFilterSelection(
        fromAccountNo: fromNo,
        toAccountNo: toNo,
        fromAccountLevel: _fromAccount?.accountLevel,
        toAccountLevel: _toAccount?.accountLevel,
        accountType: _accountType,
        financialStatementType: _financialStatementType,
        fromMonth: _fromMonth == 0 ? null : _fromMonth,
        toMonth: _toMonth == 0 ? null : _toMonth,
        comparisonMonth: widget.isComparisonMonth ? _comparisonMonth : null,
        balance: widget.isComparisonMonth
            ? null
            : widget.isMonthly || widget.isBalancePeriodically
            ? _balance
            : null,
        periodically: widget.isBalancePeriodically ? _periodically : null,
        reportName: reportName,
        exportType: _exportType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.oceanBlue;

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
                  widget.isBalancePeriodically
                      ? 'Report/AccountsComparsionReport '
                            '($_balancePeriodicallyReportName)'
                      : widget.isComparisonMonth
                      ? 'Report/AccountsComparsionReport (AGL054)'
                      : widget.isMonthly
                      ? 'Report/AccountsComparsionReport (AGL053)'
                      : 'Report/AccountsComparsionReport (AGL052)',
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
                  ChartOfAccountDropdown(
                    title: _isArabic ? 'من حساب' : 'From account',
                    hintText: _isArabic ? 'كل الحسابات' : 'All accounts',
                    accountType: _accountType,
                    initialValue: _fromAccount,
                    onSelected: (account) => setState(() {
                      _fromAccount = account;
                      _validationMessage = null;
                    }),
                  ),
                  Gap(12.h),
                  ChartOfAccountDropdown(
                    title: _isArabic ? 'إلى حساب' : 'To account',
                    hintText: _isArabic ? 'كل الحسابات' : 'All accounts',
                    accountType: _accountType,
                    initialValue: _toAccount,
                    onSelected: (account) => setState(() {
                      _toAccount = account;
                      _validationMessage = null;
                    }),
                  ),
                  Gap(12.h),
                  _dropdown<int>(
                    label: _isArabic ? 'نوع الحساب' : 'Account type',
                    value: _accountType,
                    options: [
                      (0, _isArabic ? 'رئيسي' : 'Main'),
                      (1, _isArabic ? 'فرعي' : 'Sub'),
                      (2, _isArabic ? 'الجميع' : 'All'),
                    ],
                    onChanged: (value) => setState(() {
                      _accountType = value;
                      _fromAccount = null;
                      _toAccount = null;
                    }),
                  ),
                  Gap(12.h),
                  _dropdown<int>(
                    label: _isArabic
                        ? 'نوع القوائم المالية'
                        : 'Financial statement type',
                    value: _financialStatementType,
                    options: [
                      (0, _isArabic ? 'بدون' : 'None'),
                      (1, _isArabic ? 'متاجرة' : 'Trading'),
                      (2, _isArabic ? 'أرباح وخسائر' : 'Profit and loss'),
                      (3, _isArabic ? 'ميزانية' : 'Balance sheet'),
                      (4, _isArabic ? 'الجميع' : 'All'),
                    ],
                    onChanged: (value) =>
                        setState(() => _financialStatementType = value),
                  ),
                  if (widget.isBalancePeriodically) ...[
                    Gap(12.h),
                    Row(
                      children: [
                        Expanded(
                          child: _dropdown<int>(
                            label: _isArabic ? 'من شهر' : 'From month',
                            value: _fromMonth,
                            options: _monthOptions,
                            onChanged: (value) => setState(() {
                              _fromMonth = value;
                              _validationMessage = null;
                            }),
                          ),
                        ),
                        Gap(10.w),
                        Expanded(
                          child: _dropdown<int>(
                            label: _isArabic ? 'إلى شهر' : 'To month',
                            value: _toMonth,
                            options: _monthOptions,
                            onChanged: (value) => setState(() {
                              _toMonth = value;
                              _validationMessage = null;
                            }),
                          ),
                        ),
                      ],
                    ),
                    Gap(12.h),
                    _dropdown<int>(
                      label: _isArabic ? 'الرصيد' : 'Balance',
                      value: _balance,
                      options: [
                        (0, _isArabic ? 'السابق' : 'Previous'),
                        (1, _isArabic ? 'التقديري' : 'Estimated'),
                      ],
                      onChanged: (value) => setState(() => _balance = value),
                    ),
                    Gap(12.h),
                    _dropdown<int>(
                      label: _isArabic ? 'الفترة' : 'Period',
                      value: _periodically,
                      options: [
                        (0, _isArabic ? 'إجمالي' : 'Summary'),
                        (1, _isArabic ? 'شهري' : 'Monthly'),
                      ],
                      onChanged: (value) =>
                          setState(() => _periodically = value),
                    ),
                  ] else if (widget.isComparisonMonth) ...[
                    Gap(12.h),
                    _dropdown<int>(
                      label: _isArabic ? 'شهر المقارنة' : 'Comparison month',
                      value: _comparisonMonth,
                      options: _comparisonMonthOptions,
                      onChanged: (value) =>
                          setState(() => _comparisonMonth = value),
                    ),
                  ] else if (widget.isMonthly) ...[
                    Gap(12.h),
                    Row(
                      children: [
                        Expanded(
                          child: _dropdown<int>(
                            label: _isArabic ? 'من شهر' : 'From month',
                            value: _fromMonth,
                            options: _monthOptions,
                            onChanged: (value) => setState(() {
                              _fromMonth = value;
                              _validationMessage = null;
                            }),
                          ),
                        ),
                        Gap(10.w),
                        Expanded(
                          child: _dropdown<int>(
                            label: _isArabic ? 'إلى شهر' : 'To month',
                            value: _toMonth,
                            options: _monthOptions,
                            onChanged: (value) => setState(() {
                              _toMonth = value;
                              _validationMessage = null;
                            }),
                          ),
                        ),
                      ],
                    ),
                    Gap(12.h),
                    _dropdown<int>(
                      label: _isArabic ? 'الرصيد' : 'Balance',
                      value: _balance,
                      options: [
                        (0, _isArabic ? 'السابق' : 'Previous'),
                        (1, _isArabic ? 'التقديري' : 'Estimated'),
                      ],
                      onChanged: (value) => setState(() => _balance = value),
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

  List<(int, String)> get _monthOptions => [
    (0, _isArabic ? 'كل الشهور' : 'All months'),
    (1, _isArabic ? 'يناير' : 'January'),
    (2, _isArabic ? 'فبراير' : 'February'),
    (3, _isArabic ? 'مارس' : 'March'),
    (4, _isArabic ? 'أبريل' : 'April'),
    (5, _isArabic ? 'مايو' : 'May'),
    (6, _isArabic ? 'يونيو' : 'June'),
    (7, _isArabic ? 'يوليو' : 'July'),
    (8, _isArabic ? 'أغسطس' : 'August'),
    (9, _isArabic ? 'سبتمبر' : 'September'),
    (10, _isArabic ? 'أكتوبر' : 'October'),
    (11, _isArabic ? 'نوفمبر' : 'November'),
    (12, _isArabic ? 'ديسمبر' : 'December'),
  ];

  List<(int, String)> get _comparisonMonthOptions =>
      _monthOptions.where((option) => option.$1 != 0).toList();
}
