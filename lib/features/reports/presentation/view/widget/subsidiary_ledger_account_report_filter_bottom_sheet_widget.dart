import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';

class SubsidiaryLedgerAccountReportFilterSelection {
  final int? fromAccountNo;
  final int? toAccountNo;
  final int? fromMainAccountNo;
  final int? toMainAccountNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool accountsWithZeroBalances;
  final int ledgerReportType;
  final String reportName;
  final String exportType;

  const SubsidiaryLedgerAccountReportFilterSelection({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromMainAccountNo,
    this.toMainAccountNo,
    this.fromDate,
    this.toDate,
    this.accountsWithZeroBalances = false,
    this.ledgerReportType = 1,
    this.reportName = 'AGL021AS',
    this.exportType = 'pdf',
  });
}

class SubsidiaryLedgerAccountReportFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final String initialExportType;

  const SubsidiaryLedgerAccountReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<SubsidiaryLedgerAccountReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<SubsidiaryLedgerAccountReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SubsidiaryLedgerAccountReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<SubsidiaryLedgerAccountReportFilterBottomSheetWidget> createState() =>
      _SubsidiaryLedgerAccountReportFilterBottomSheetWidgetState();
}

class _SubsidiaryLedgerAccountReportFilterBottomSheetWidgetState
    extends State<SubsidiaryLedgerAccountReportFilterBottomSheetWidget> {
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  ChartOfAccountLightModel? _fromMainAccount;
  ChartOfAccountLightModel? _toMainAccount;
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _accountsWithZeroBalances = false;
  int _ledgerReportType = 1;
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  String get _reportName => _ledgerReportType == 2 ? 'AGL023AS' : 'AGL021AS';

  @override
  void initState() {
    super.initState();
    _exportType = widget.initialExportType;
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

  void _submit() {
    final fromAccountNo = _fromAccount?.accountNo;
    final toAccountNo = _toAccount?.accountNo;
    final fromMainAccountNo = _fromMainAccount?.accountNo;
    final toMainAccountNo = _toMainAccount?.accountNo;

    if (fromMainAccountNo != null &&
        toMainAccountNo != null &&
        fromMainAccountNo > toMainAccountNo) {
      _showValidation(
        _isArabic
            ? 'رقم الحساب الرئيسي من يجب أن يكون أقل من أو يساوي الحساب الرئيسي إلى'
            : 'From main account must be less than or equal to To main account',
      );
      return;
    }
    if (fromAccountNo != null &&
        toAccountNo != null &&
        fromAccountNo > toAccountNo) {
      _showValidation(
        _isArabic
            ? 'رقم الحساب من يجب أن يكون أقل من أو يساوي رقم الحساب إلى'
            : 'From account must be less than or equal to To account',
      );
      return;
    }
    if (_fromDate != null && _toDate != null && _fromDate!.isAfter(_toDate!)) {
      _showValidation(
        _isArabic
            ? 'تاريخ البداية يجب أن يسبق أو يساوي تاريخ النهاية'
            : 'From date must be before or equal to To date',
      );
      return;
    }

    Navigator.pop(
      context,
      SubsidiaryLedgerAccountReportFilterSelection(
        fromAccountNo: fromAccountNo,
        toAccountNo: toAccountNo,
        fromMainAccountNo: fromMainAccountNo,
        toMainAccountNo: toMainAccountNo,
        fromDate: _fromDate,
        toDate: _toDate,
        accountsWithZeroBalances: _accountsWithZeroBalances,
        ledgerReportType: _ledgerReportType,
        reportName: _reportName,
        exportType: _exportType,
      ),
    );
  }

  void _showValidation(String message) {
    setState(() => _validationMessage = message);
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.primaryColor(context);
    final isAr = _isArabic;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
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
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: foreground.withValues(alpha: 0.24),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    Gap(16.h),
                    Row(
                      children: [
                        Container(
                          width: 44.r,
                          height: 44.r,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            color: accent,
                            size: 23.r,
                          ),
                        ),
                        Gap(12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                  color: foreground,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gap(2.h),
                              Text(
                                _reportName,
                                style: TextStyle(
                                  color: foreground.withValues(alpha: 0.55),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close_rounded,
                            color: foreground.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<int>(
                        initialValue: _ledgerReportType,
                        decoration: InputDecoration(
                          labelText: isAr ? 'نوع الأستاذ' : 'Ledger type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: Text(
                              isAr ? 'ح/الأستاذ ملخص' : 'Ledger summary',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text(
                              isAr ? 'ح/الأستاذ تفصيلي' : 'Ledger detailed',
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _ledgerReportType = value);
                          }
                        },
                      ),
                      Gap(12.h),
                      ChartOfAccountDropdown(
                        title: isAr ? 'من الحساب الرئيسي' : 'From main account',
                        accountType: null,
                        initialValue: _fromMainAccount,
                        onSelected: (account) {
                          setState(() => _fromMainAccount = account);
                        },
                      ),
                      Gap(12.h),
                      ChartOfAccountDropdown(
                        title: isAr ? 'إلى الحساب الرئيسي' : 'To main account',
                        accountType: null,
                        initialValue: _toMainAccount,
                        onSelected: (account) {
                          setState(() => _toMainAccount = account);
                        },
                      ),
                      Gap(12.h),
                      ChartOfAccountDropdown(
                        title: isAr ? 'من الحساب الفرعي' : 'From account',
                        accountType: null,
                        initialValue: _fromAccount,
                        onSelected: (account) {
                          setState(() => _fromAccount = account);
                        },
                      ),
                      Gap(12.h),
                      ChartOfAccountDropdown(
                        title: isAr ? 'إلى الحساب الفرعي' : 'To account',
                        accountType: null,
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
                              label: isAr ? 'من تاريخ' : 'From date',
                              date: _fromDate,
                              onPressed: () => _selectDate(isFromDate: true),
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: _dateButton(
                              label: isAr ? 'إلى تاريخ' : 'To date',
                              date: _toDate,
                              onPressed: () => _selectDate(isFromDate: false),
                            ),
                          ),
                        ],
                      ),
                      Gap(8.h),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        value: _accountsWithZeroBalances,
                        activeThumbColor: accent,
                        title: Text(
                          isAr
                              ? 'عرض الحسابات ذات الأرصدة الصفرية'
                              : 'Include accounts with zero balances',
                          style: AppTextStyle.formTitleStyle(context).copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() => _accountsWithZeroBalances = value);
                        },
                      ),
                      Gap(8.h),
                      DropdownButtonFormField<String>(
                        initialValue: _exportType,
                        decoration: InputDecoration(
                          labelText: isAr ? 'صيغة التصدير' : 'Export format',
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
                        Gap(12.h),
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: AppColor.roseDanger,
                              size: 16.sp,
                            ),
                            Gap(6.w),
                            Expanded(
                              child: Text(
                                _validationMessage!,
                                style: TextStyle(
                                  color: AppColor.roseDanger,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
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
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isAr ? 'عرض التقرير' : 'Show report',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.primaryColor(context);
    final hasValue = date != null;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: AppColor.textFormFillColor(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: hasValue
                ? accent.withValues(alpha: 0.5)
                : foreground.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16.sp,
              color: hasValue ? accent : foreground.withValues(alpha: 0.5),
            ),
            Gap(8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 10.sp)),
                  Gap(2.h),
                  Text(
                    hasValue
                        ? MaterialLocalizations.of(
                            context,
                          ).formatMediumDate(date)
                        : (Localizations.localeOf(context).languageCode == 'ar'
                              ? 'الكل'
                              : 'All dates'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: hasValue
                          ? foreground
                          : foreground.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            if (hasValue)
              Icon(
                Icons.close_rounded,
                size: 14.sp,
                color: foreground.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }
}
