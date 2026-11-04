import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';

class GeneralLedgerReportFilterSelection {
  final int? fromAccountNo;
  final int? toAccountNo;
  final String? fromCurrencyCode;
  final String? toCurrencyCode;
  final int? fromAnalytical;
  final int? toAnalytical;
  final int? fromAnalytical1;
  final int? toAnalytical1;
  final int? fromSubVoucher;
  final int? toSubVoucher;
  final int? fromSubDescId;
  final int? toSubDescId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool accountsWithZeroBalances;
  final String reportName;
  final String exportType;

  const GeneralLedgerReportFilterSelection({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCurrencyCode,
    this.toCurrencyCode,
    this.fromAnalytical,
    this.toAnalytical,
    this.fromAnalytical1,
    this.toAnalytical1,
    this.fromSubVoucher,
    this.toSubVoucher,
    this.fromSubDescId,
    this.toSubDescId,
    this.fromDate,
    this.toDate,
    this.accountsWithZeroBalances = false,
    this.reportName = 'AGL100',
    this.exportType = 'pdf',
  });
}

class GeneralLedgerReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialExportType;

  const GeneralLedgerReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<GeneralLedgerReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<GeneralLedgerReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GeneralLedgerReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<GeneralLedgerReportFilterBottomSheetWidget> createState() =>
      _GeneralLedgerReportFilterBottomSheetWidgetState();
}

class _GeneralLedgerReportFilterBottomSheetWidgetState
    extends State<GeneralLedgerReportFilterBottomSheetWidget> {
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  final _fromCurrencyController = TextEditingController();
  final _toCurrencyController = TextEditingController();
  final _fromAnalyticalController = TextEditingController();
  final _toAnalyticalController = TextEditingController();
  final _fromAnalytical1Controller = TextEditingController();
  final _toAnalytical1Controller = TextEditingController();
  final _fromSubVoucherController = TextEditingController();
  final _toSubVoucherController = TextEditingController();
  final _fromSubDescIdController = TextEditingController();
  final _toSubDescIdController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _accountsWithZeroBalances = false;
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
    _fromCurrencyController.dispose();
    _toCurrencyController.dispose();
    _fromAnalyticalController.dispose();
    _toAnalyticalController.dispose();
    _fromAnalytical1Controller.dispose();
    _toAnalytical1Controller.dispose();
    _fromSubVoucherController.dispose();
    _toSubVoucherController.dispose();
    _fromSubDescIdController.dispose();
    _toSubDescIdController.dispose();
    super.dispose();
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

  int? _optionalInt(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : int.tryParse(text);
  }

  String? _optionalText(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  void _submit() {
    final fromAnalytical = _optionalInt(_fromAnalyticalController);
    final toAnalytical = _optionalInt(_toAnalyticalController);
    final fromAnalytical1 = _optionalInt(_fromAnalytical1Controller);
    final toAnalytical1 = _optionalInt(_toAnalytical1Controller);
    final fromSubVoucher = _optionalInt(_fromSubVoucherController);
    final toSubVoucher = _optionalInt(_toSubVoucherController);
    final fromSubDescId = _optionalInt(_fromSubDescIdController);
    final toSubDescId = _optionalInt(_toSubDescIdController);
    final numericFields = [
      (_fromAnalyticalController, fromAnalytical),
      (_toAnalyticalController, toAnalytical),
      (_fromAnalytical1Controller, fromAnalytical1),
      (_toAnalytical1Controller, toAnalytical1),
      (_fromSubVoucherController, fromSubVoucher),
      (_toSubVoucherController, toSubVoucher),
      (_fromSubDescIdController, fromSubDescId),
      (_toSubDescIdController, toSubDescId),
    ];
    if (numericFields.any(
      (field) => field.$1.text.trim().isNotEmpty && field.$2 == null,
    )) {
      _showValidation(
        _isArabic ? 'أدخل أرقامًا صحيحة في الحقول' : 'Enter valid numbers',
      );
      return;
    }

    final fromAccountNo = _fromAccount?.accountNo;
    final toAccountNo = _toAccount?.accountNo;
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
      GeneralLedgerReportFilterSelection(
        fromAccountNo: fromAccountNo,
        toAccountNo: toAccountNo,
        fromCurrencyCode: _optionalText(_fromCurrencyController),
        toCurrencyCode: _optionalText(_toCurrencyController),
        fromAnalytical: fromAnalytical,
        toAnalytical: toAnalytical,
        fromAnalytical1: fromAnalytical1,
        toAnalytical1: toAnalytical1,
        fromSubVoucher: fromSubVoucher,
        toSubVoucher: toSubVoucher,
        fromSubDescId: fromSubDescId,
        toSubDescId: toSubDescId,
        fromDate: _fromDate,
        toDate: _toDate,
        accountsWithZeroBalances: _accountsWithZeroBalances,
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
                      ChartOfAccountDropdown(
                        title: isAr ? 'من حساب' : 'From account',
                        accountType: null,
                        initialValue: _fromAccount,
                        onSelected: (account) {
                          setState(() => _fromAccount = account);
                        },
                      ),
                      Gap(12.h),
                      ChartOfAccountDropdown(
                        title: isAr ? 'إلى حساب' : 'To account',
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
                            child: _textField(
                              isAr ? 'من عملة' : 'From currency',
                              _fromCurrencyController,
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: _textField(
                              isAr ? 'إلى عملة' : 'To currency',
                              _toCurrencyController,
                            ),
                          ),
                        ],
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
                      Gap(12.h),
                      _numberRange(
                        isAr ? 'من تحليل' : 'From analytical',
                        _fromAnalyticalController,
                        isAr ? 'إلى تحليل' : 'To analytical',
                        _toAnalyticalController,
                      ),
                      Gap(12.h),
                      _numberRange(
                        isAr ? 'من تحليل 1' : 'From analytical 1',
                        _fromAnalytical1Controller,
                        isAr ? 'إلى تحليل 1' : 'To analytical 1',
                        _toAnalytical1Controller,
                      ),
                      Gap(12.h),
                      _numberRange(
                        isAr ? 'من رقم السند الفرعي' : 'From sub-voucher',
                        _fromSubVoucherController,
                        isAr ? 'إلى رقم السند الفرعي' : 'To sub-voucher',
                        _toSubVoucherController,
                      ),
                      Gap(12.h),
                      _numberRange(
                        isAr
                            ? 'من معرف الوصف الفرعي'
                            : 'From sub-description ID',
                        _fromSubDescIdController,
                        isAr
                            ? 'إلى معرف الوصف الفرعي'
                            : 'To sub-description ID',
                        _toSubDescIdController,
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

  Widget _textField(String label, TextEditingController controller) =>
      CustomFormField(
        width: double.infinity,
        radius: 12.r,
        controller: controller,
        title: label,
        textCapitalization: TextCapitalization.characters,
      );

  Widget _numberField(String label, TextEditingController controller) =>
      CustomFormField(
        width: double.infinity,
        radius: 12.r,
        controller: controller,
        title: label,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      );

  Widget _numberRange(
    String fromLabel,
    TextEditingController fromController,
    String toLabel,
    TextEditingController toController,
  ) => Row(
    children: [
      Expanded(child: _numberField(fromLabel, fromController)),
      Gap(10.w),
      Expanded(child: _numberField(toLabel, toController)),
    ],
  );

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
