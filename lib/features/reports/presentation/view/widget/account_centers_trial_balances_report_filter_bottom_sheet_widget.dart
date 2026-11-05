import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

class AccountCentersTrialBalancesReportFilterSelection {
  final int accountLevel;
  final num? fromAccountNo;
  final num? toAccountNo;
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String exportType;

  const AccountCentersTrialBalancesReportFilterSelection({
    required this.accountLevel,
    required this.fromAccountNo,
    required this.toAccountNo,
    required this.fromCostCenterNo,
    required this.toCostCenterNo,
    required this.fromDate,
    required this.toDate,
    required this.exportType,
  });
}

class AccountCentersTrialBalancesReportFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final String initialExportType;

  const AccountCentersTrialBalancesReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<AccountCentersTrialBalancesReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<
      AccountCentersTrialBalancesReportFilterSelection
    >(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AccountCentersTrialBalancesReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<AccountCentersTrialBalancesReportFilterBottomSheetWidget>
  createState() =>
      _AccountCentersTrialBalancesReportFilterBottomSheetWidgetState();
}

class _AccountCentersTrialBalancesReportFilterBottomSheetWidgetState
    extends State<AccountCentersTrialBalancesReportFilterBottomSheetWidget> {
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  CostCenterLightModel? _fromCostCenter;
  CostCenterLightModel? _toCostCenter;
  final _accountLevelController = TextEditingController(text: '1');
  DateTime? _fromDate;
  DateTime? _toDate;
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  int? get _accountLevel => int.tryParse(_accountLevelController.text.trim());

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
    final accountLevel = _accountLevel;
    if (accountLevel == null) {
      setState(() {
        _validationMessage = _isArabic
            ? 'مستوى الحساب مطلوب'
            : 'Account level is required';
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
    if (_fromCostCenter != null &&
        _toCostCenter != null &&
        _fromCostCenter!.costCenterNo > _toCostCenter!.costCenterNo) {
      setState(() {
        _validationMessage = _isArabic
            ? 'مركز البداية يجب أن يسبق أو يساوي مركز النهاية'
            : 'From cost center must be less than or equal to To cost center';
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
      AccountCentersTrialBalancesReportFilterSelection(
        accountLevel: accountLevel,
        fromAccountNo: _fromAccount?.accountNo,
        toAccountNo: _toAccount?.accountNo,
        fromCostCenterNo: _fromCostCenter?.costCenterNo,
        toCostCenterNo: _toCostCenter?.costCenterNo,
        fromDate: _fromDate,
        toDate: _toDate,
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
                      CustomFormField(
                        controller: _accountLevelController,
                        title: _isArabic ? 'مستوى الحساب' : 'Account level',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) {
                          setState(() {
                            _fromCostCenter = null;
                            _toCostCenter = null;
                            _validationMessage = null;
                          });
                        },
                      ),
                      Gap(14.h),
                      _sectionTitle(
                        _isArabic ? 'نطاق الحسابات' : 'Account range',
                        foreground,
                      ),
                      Gap(8.h),
                      ChartOfAccountDropdown(
                        title: _isArabic ? 'من حساب' : 'From account',
                        accountType: null,
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
                        accountType: null,
                        includeAccountRangeFields: false,
                        includeAccountsHasCostCenters: null,
                        initialValue: _toAccount,
                        onSelected: (account) {
                          setState(() => _toAccount = account);
                        },
                      ),
                      Gap(14.h),
                      _sectionTitle(
                        _isArabic ? 'نطاق مراكز التكلفة' : 'Cost center range',
                        foreground,
                      ),
                      Gap(8.h),
                      // Centers are loaded with the account level as their
                      // `CenterLevel` (AccountType = 1), so the picker only
                      // shows centers that belong to the selected level.
                      CostCenterDropdown(
                        key: ValueKey(
                          'from-center-${_accountLevelController.text}',
                        ),
                        title: _isArabic ? 'من مركز' : 'From center',
                        centerType: null,
                        centerKind: null,
                        centerLevel: _accountLevel ?? 1,
                        accountType: 1,
                        pageSize: 10,
                        initialValue: _fromCostCenter,
                        onSelected: (center) {
                          setState(() => _fromCostCenter = center);
                        },
                      ),
                      Gap(10.h),
                      CostCenterDropdown(
                        key: ValueKey(
                          'to-center-${_accountLevelController.text}',
                        ),
                        title: _isArabic ? 'إلى مركز' : 'To center',
                        centerType: null,
                        centerKind: null,
                        centerLevel: _accountLevel ?? 1,
                        accountType: 1,
                        pageSize: 10,
                        initialValue: _toCostCenter,
                        onSelected: (center) {
                          setState(() => _toCostCenter = center);
                        },
                      ),
                      Gap(14.h),
                      _sectionTitle(
                        _isArabic ? 'الفترة الزمنية' : 'Date range',
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
