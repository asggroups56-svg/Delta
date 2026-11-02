import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';

class ChartOfAccountMonthlyBalancesFilterSelection {
  final num? fromAccountNo;
  final num? toAccountNo;
  final int? fromAccountLevel;
  final int? toAccountLevel;
  final int accountType;
  final int finalAccount;
  final int reportPageType;
  final String reportName;
  final String exportType;

  const ChartOfAccountMonthlyBalancesFilterSelection({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromAccountLevel,
    this.toAccountLevel,
    required this.accountType,
    required this.finalAccount,
    required this.reportPageType,
    required this.reportName,
    required this.exportType,
  });
}

class ChartOfAccountMonthlyBalancesFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final String initialExportType;
  final int initialAccountType;
  final int reportPageType;
  final String reportName;

  const ChartOfAccountMonthlyBalancesFilterBottomSheetWidget({
    super.key,
    required this.title,
    required this.initialExportType,
    required this.initialAccountType,
    required this.reportPageType,
    required this.reportName,
  });

  static Future<ChartOfAccountMonthlyBalancesFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
    int initialAccountType = 0,
    int reportPageType = 2,
    String reportName = 'AGL015A',
  }) {
    return showModalBottomSheet<ChartOfAccountMonthlyBalancesFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ChartOfAccountMonthlyBalancesFilterBottomSheetWidget(
            title: title,
            initialExportType: initialExportType,
            initialAccountType: initialAccountType,
            reportPageType: reportPageType,
            reportName: reportName,
          ),
    );
  }

  @override
  State<ChartOfAccountMonthlyBalancesFilterBottomSheetWidget> createState() =>
      _ChartOfAccountMonthlyBalancesFilterBottomSheetWidgetState();
}

class _ChartOfAccountMonthlyBalancesFilterBottomSheetWidgetState
    extends State<ChartOfAccountMonthlyBalancesFilterBottomSheetWidget> {
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  late int _accountType;
  int _finalAccount = 4;
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _exportType = widget.initialExportType;
    _accountType = widget.initialAccountType;
  }

  void _submit() {
    final fromNo = _fromAccount?.accountNo;
    final toNo = _toAccount?.accountNo;
    if (fromNo != null && toNo != null && fromNo > toNo) {
      setState(() {
        _validationMessage = _isArabic
            ? 'رقم الحساب من يجب أن يكون أقل من أو يساوي رقم الحساب إلى'
            : 'From account must be less than or equal to To account';
      });
      return;
    }

    Navigator.pop(
      context,
      ChartOfAccountMonthlyBalancesFilterSelection(
        fromAccountNo: fromNo,
        toAccountNo: toNo,
        fromAccountLevel: _fromAccount?.accountLevel,
        toAccountLevel: _toAccount?.accountLevel,
        accountType: _accountType,
        finalAccount: _finalAccount,
        reportPageType: widget.reportPageType,
        reportName: widget.reportName,
        exportType: _exportType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.oceanBlue;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.92,
      ),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20.w,
            12.h,
            20.w,
            24.h + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: foreground.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              Gap(14.h),
              Row(
                children: [
                  Icon(Icons.account_tree_rounded, color: accent, size: 24.r),
                  Gap(10.w),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: _isArabic ? 'إغلاق' : 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              Text(
                'Report/ChartOfAccountMonthlyBalancesOrStatementReport · ${widget.reportName}',
                style: TextStyle(
                  color: foreground.withValues(alpha: 0.5),
                  fontSize: 10.sp,
                  fontFamily: 'monospace',
                ),
              ),
              Gap(18.h),
              ChartOfAccountDropdown(
                title: _isArabic ? 'من حساب' : 'From account',
                hintText: _isArabic ? 'كل الحسابات' : 'All accounts',
                accountType: 2,
                initialValue: _fromAccount,
                onSelected: (account) {
                  setState(() {
                    _fromAccount = account;
                    _validationMessage = null;
                  });
                },
              ),
              Gap(12.h),
              ChartOfAccountDropdown(
                title: _isArabic ? 'إلى حساب' : 'To account',
                hintText: _isArabic ? 'كل الحسابات' : 'All accounts',
                accountType: 2,
                initialValue: _toAccount,
                onSelected: (account) {
                  setState(() {
                    _toAccount = account;
                    _validationMessage = null;
                  });
                },
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
                onChanged: (value) => setState(() => _accountType = value),
              ),
              Gap(12.h),
              _dropdown<int>(
                label: _isArabic ? 'القوائم النهائية' : 'Final account',
                value: _finalAccount,
                options: [
                  (0, _isArabic ? 'بدون' : 'None'),
                  (1, _isArabic ? 'متاجرة وتشغيل' : 'Trading and operating'),
                  (2, _isArabic ? 'الأرباح والخسائر' : 'Profit and loss'),
                  (3, _isArabic ? 'الميزانية' : 'Balance sheet'),
                  (4, _isArabic ? 'الجميع' : 'All'),
                ],
                onChanged: (value) => setState(() => _finalAccount = value),
              ),
              Gap(12.h),
              _dropdown<String>(
                label: _isArabic ? 'صيغة التصدير' : 'Export type',
                value: _exportType,
                options: const [
                  ('pdf', 'PDF'),
                  ('excel', 'Excel'),
                  ('excelformatted', 'Excel PRO'),
                  ('word', 'Word'),
                ],
                onChanged: (value) => setState(() => _exportType = value),
              ),
              if (_validationMessage != null) ...[
                Gap(12.h),
                Text(
                  _validationMessage!,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12.sp),
                ),
              ],
              Gap(20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(_isArabic ? 'إلغاء' : 'Cancel'),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: Text(_isArabic ? 'عرض التقرير' : 'View report'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<(T, String)> options,
    required ValueChanged<T> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      key: ValueKey('$label-$value'),
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        filled: true,
        fillColor: AppColor.textFormFillColor(context),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      items: [
        for (final (optionValue, optionLabel) in options)
          DropdownMenuItem<T>(
            value: optionValue,
            child: Text(optionLabel, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (nextValue) {
        if (nextValue != null) onChanged(nextValue);
      },
    );
  }
}
