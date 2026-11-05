import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';

class TrialBalancesReportForPeriodFilterSelection {
  final int? fromAccountNo;
  final int? toAccountNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool doNotDisplayAccountsWithZeroBalances;
  final bool prepareTree;
  final String exportType;

  const TrialBalancesReportForPeriodFilterSelection({
    required this.fromAccountNo,
    required this.toAccountNo,
    required this.fromDate,
    required this.toDate,
    required this.doNotDisplayAccountsWithZeroBalances,
    required this.prepareTree,
    required this.exportType,
  });
}

class TrialBalancesReportForPeriodFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final String initialExportType;

  const TrialBalancesReportForPeriodFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<TrialBalancesReportForPeriodFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<TrialBalancesReportForPeriodFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TrialBalancesReportForPeriodFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<TrialBalancesReportForPeriodFilterBottomSheetWidget> createState() =>
      _TrialBalancesReportForPeriodFilterBottomSheetWidgetState();
}

class _TrialBalancesReportForPeriodFilterBottomSheetWidgetState
    extends State<TrialBalancesReportForPeriodFilterBottomSheetWidget> {
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  final _accountLevelController = TextEditingController(text: '1');
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _doNotDisplayAccountsWithZeroBalances = false;
  bool _prepareTree = false;
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
    super.dispose();
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
    if (int.tryParse(_accountLevelController.text.trim()) == null) {
      setState(() {
        _validationMessage = _isArabic
            ? 'أدخل مستوى حساب صحيحاً'
            : 'Enter a valid account level';
      });
      return;
    }
    if (_fromAccount != null &&
        _toAccount != null &&
        _fromAccount!.accountNo > _toAccount!.accountNo) {
      setState(() {
        _validationMessage = _isArabic
            ? 'حساب البداية يجب أن يسبق أو يساوي حساب النهاية'
            : 'From account must be less than or equal to To account';
      });
      return;
    }
    if (_fromDate != null && _toDate != null && _fromDate!.isAfter(_toDate!)) {
      setState(() {
        _validationMessage = _isArabic
            ? 'تاريخ البداية يجب أن يسبق أو يساوي تاريخ النهاية'
            : 'From date must be before or equal to To date';
      });
      return;
    }

    Navigator.pop(
      context,
      TrialBalancesReportForPeriodFilterSelection(
        fromAccountNo: _fromAccount?.accountNo,
        toAccountNo: _toAccount?.accountNo,
        fromDate: _fromDate,
        toDate: _toDate,
        doNotDisplayAccountsWithZeroBalances:
            _doNotDisplayAccountsWithZeroBalances,
        prepareTree: _prepareTree,
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
                    children: [
                      CustomFormField(
                        controller: _accountLevelController,
                        title: _isArabic ? 'مستوى الحساب' : 'Account level',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) {
                          setState(() {
                            _fromAccount = null;
                            _toAccount = null;
                            _validationMessage = null;
                          });
                        },
                      ),
                      Gap(10.h),
                      ChartOfAccountDropdown(
                        key: ValueKey(
                          'from-account-${_accountLevelController.text}',
                        ),
                        title: _isArabic ? 'من حساب' : 'From account',
                        accountType: null,
                        accountLevel: int.tryParse(
                          _accountLevelController.text.trim(),
                        ),
                        includeAccountRangeFields: false,
                        includeAccountsHasCostCenters: null,
                        initialValue: _fromAccount,
                        onSelected: (account) {
                          setState(() => _fromAccount = account);
                        },
                      ),
                      Gap(10.h),
                      ChartOfAccountDropdown(
                        key: ValueKey(
                          'to-account-${_accountLevelController.text}',
                        ),
                        title: _isArabic ? 'إلى حساب' : 'To account',
                        accountType: null,
                        accountLevel: int.tryParse(
                          _accountLevelController.text.trim(),
                        ),
                        includeAccountRangeFields: false,
                        includeAccountsHasCostCenters: null,
                        initialValue: _toAccount,
                        onSelected: (account) {
                          setState(() => _toAccount = account);
                        },
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
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        value: _prepareTree,
                        activeThumbColor: accent,
                        title: Text(
                          _isArabic
                              ? 'تحديث شجرة الحسابات'
                              : 'Update accounts tree',
                          style: TextStyle(
                            color: foreground,
                            fontSize: 13.sp,
                          ),
                        ),
                        onChanged: (value) =>
                            setState(() => _prepareTree = value),
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
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            _validationMessage!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                            ),
                          ),
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

  Widget _dateButton({
    required String label,
    required DateTime? date,
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
                    : MaterialLocalizations.of(context).formatMediumDate(date),
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
