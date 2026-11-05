import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/month_range_bottom_sheet_widget.dart';
import 'package:my_template/core/theme/app_colors.dart';

enum TrialBalanceReportMode {
  /// AGL030 — trial balance by level, with balance type filter.
  byLevel,

  /// AGL060 / AGL060A — monthly trial balance.
  monthly,

  /// AGL060H — monthly trial balance without account level.
  monthlyWithoutAccountLevel,

  /// AGL031 — trial balance with an optional account level.
  optionalAccountLevel,
}

class TrialBalanceReportFilterSelection {
  final int? accountLevel;
  final bool doNotDisplayAccountsWithZeroBalances;
  final int balanceType;
  final int? fromMonth;
  final int? toMonth;
  final bool? isGeneral;
  final int reportPageType;
  final String reportName;
  final String exportType;

  const TrialBalanceReportFilterSelection({
    required this.accountLevel,
    required this.doNotDisplayAccountsWithZeroBalances,
    required this.balanceType,
    required this.fromMonth,
    required this.toMonth,
    required this.isGeneral,
    required this.reportPageType,
    required this.reportName,
    required this.exportType,
  });
}

class TrialBalanceReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final TrialBalanceReportMode mode;
  final String initialExportType;
  final String initialReportName;

  const TrialBalanceReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    required this.mode,
    this.initialExportType = 'pdf',
    this.initialReportName = 'AGL060',
  });

  static Future<TrialBalanceReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    required TrialBalanceReportMode mode,
    String initialExportType = 'pdf',
    String initialReportName = 'AGL060',
  }) {
    return showModalBottomSheet<TrialBalanceReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TrialBalanceReportFilterBottomSheetWidget(
        title: title,
        mode: mode,
        initialExportType: initialExportType,
        initialReportName: initialReportName,
      ),
    );
  }

  @override
  State<TrialBalanceReportFilterBottomSheetWidget> createState() =>
      _TrialBalanceReportFilterBottomSheetWidgetState();
}

class _TrialBalanceReportFilterBottomSheetWidgetState
    extends State<TrialBalanceReportFilterBottomSheetWidget> {
  final _accountLevelController = TextEditingController(text: '1');
  int _balanceType = 3;
  bool _doNotDisplayAccountsWithZeroBalances = false;
  int? _fromMonth;
  int? _toMonth;
  late String _reportName;
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  bool get _showAccountLevel =>
      widget.mode == TrialBalanceReportMode.byLevel ||
      widget.mode == TrialBalanceReportMode.monthly ||
      widget.mode == TrialBalanceReportMode.optionalAccountLevel;

  bool get _accountLevelRequired =>
      widget.mode == TrialBalanceReportMode.byLevel;

  bool get _showBalanceType => widget.mode == TrialBalanceReportMode.byLevel;

  bool get _showHideZeroBalances =>
      widget.mode == TrialBalanceReportMode.byLevel;

  bool get _showMonths =>
      widget.mode == TrialBalanceReportMode.monthly ||
      widget.mode == TrialBalanceReportMode.monthlyWithoutAccountLevel;

  bool get _showReportName => widget.mode == TrialBalanceReportMode.monthly;

  int get _reportPageType {
    switch (widget.mode) {
      case TrialBalanceReportMode.byLevel:
        return 1;
      case TrialBalanceReportMode.monthly:
        return 2;
      case TrialBalanceReportMode.monthlyWithoutAccountLevel:
        return 3;
      case TrialBalanceReportMode.optionalAccountLevel:
        return 4;
    }
  }

  @override
  void initState() {
    super.initState();
    _reportName = widget.initialReportName;
    _exportType = widget.initialExportType;
  }

  @override
  void dispose() {
    _accountLevelController.dispose();
    super.dispose();
  }

  Future<void> _selectMonthRange() async {
    final selection = await MonthRangeBottomSheetWidget.show(
      context,
      title: _isArabic ? 'نطاق الشهور' : 'Month range',
      initialFromMonth: _fromMonth,
      initialToMonth: _toMonth,
    );
    if (selection == null || !mounted) return;
    setState(() {
      _fromMonth = selection.fromMonth;
      _toMonth = selection.toMonth;
      _validationMessage = null;
    });
  }

  void _submit() {
    final accountLevelText = _accountLevelController.text.trim();
    final accountLevel = accountLevelText.isEmpty
        ? null
        : int.tryParse(accountLevelText);

    if (_accountLevelRequired && accountLevel == null) {
      setState(() {
        _validationMessage = _isArabic
            ? 'مستوى الحساب مطلوب'
            : 'Account level is required';
      });
      return;
    }
    if (accountLevelText.isNotEmpty && accountLevel == null) {
      setState(() {
        _validationMessage = _isArabic
            ? 'أدخل مستوى حساب صحيحاً'
            : 'Enter a valid account level';
      });
      return;
    }

    Navigator.pop(
      context,
      TrialBalanceReportFilterSelection(
        accountLevel: _showAccountLevel ? accountLevel : null,
        doNotDisplayAccountsWithZeroBalances: _showHideZeroBalances
            ? _doNotDisplayAccountsWithZeroBalances
            : false,
        balanceType: _showBalanceType ? _balanceType : 3,
        fromMonth: _fromMonth,
        toMonth: _toMonth,
        isGeneral: null,
        reportPageType: _reportPageType,
        reportName: _reportName,
        exportType: _exportType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.primaryColor(context);
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
                      if (_showReportName) ...[
                        DropdownButtonFormField<String>(
                          initialValue: _reportName,
                          decoration: InputDecoration(
                            labelText: _isArabic
                                ? 'نسخة التقرير'
                                : 'Report variant',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'AGL060',
                              child: Text('AGL060'),
                            ),
                            DropdownMenuItem(
                              value: 'AGL060A',
                              child: Text('AGL060A'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _reportName = value);
                            }
                          },
                        ),
                        Gap(12.h),
                      ],
                      if (_showAccountLevel) ...[
                        CustomFormField(
                          controller: _accountLevelController,
                          title: _isArabic ? 'مستوى الحساب' : 'Account level',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (_) {
                            setState(() => _validationMessage = null);
                          },
                        ),
                        Gap(12.h),
                      ],
                      if (_showMonths) ...[
                        OutlinedButton.icon(
                          onPressed: _selectMonthRange,
                          icon: const Icon(Icons.date_range_rounded, size: 16),
                          label: Text(
                            _fromMonth == null && _toMonth == null
                                ? (_isArabic ? 'كل الشهور' : 'All months')
                                : '${_fromMonth ?? '-'} - ${_toMonth ?? '-'}',
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColor.oceanBlue,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                        Gap(12.h),
                      ],
                      if (_showBalanceType) ...[
                        DropdownButtonFormField<int>(
                          initialValue: _balanceType,
                          decoration: InputDecoration(
                            labelText: _isArabic
                                ? 'نوع الرصيد'
                                : 'Balance type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 1,
                              child: Text(_isArabic ? 'المدينة' : 'Debit'),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(_isArabic ? 'الدائنة' : 'Credit'),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text(_isArabic ? 'الجميع' : 'All'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _balanceType = value);
                            }
                          },
                        ),
                        Gap(6.h),
                      ],
                      if (_showHideZeroBalances)
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          value: _doNotDisplayAccountsWithZeroBalances,
                          activeThumbColor: accent,
                          title: Text(
                            _isArabic
                                ? 'عدم عرض الحسابات ذات الأرصدة الصفرية'
                                : 'Hide accounts with zero balances',
                            style: TextStyle(
                              color: foreground,
                              fontSize: 13.sp,
                            ),
                          ),
                          onChanged: (value) => setState(
                            () => _doNotDisplayAccountsWithZeroBalances = value,
                          ),
                        ),
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
                      backgroundColor: accent,
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
}
