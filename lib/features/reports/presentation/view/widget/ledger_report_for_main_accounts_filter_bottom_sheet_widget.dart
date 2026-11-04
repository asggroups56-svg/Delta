import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';

class LedgerReportForMainAccountsFilterSelection {
  final int? accountLevel;
  final num? fromAccountNo;
  final num? toAccountNo;
  final int? fromAnalytical;
  final int? toAnalytical;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? fromAnalytical1;
  final int? toAnalytical1;
  final int? fromSubVoucher;
  final int? toSubVoucher;
  final String reportName;
  final String exportType;

  const LedgerReportForMainAccountsFilterSelection({
    required this.accountLevel,
    required this.fromAccountNo,
    required this.toAccountNo,
    required this.fromAnalytical,
    required this.toAnalytical,
    required this.fromDate,
    required this.toDate,
    required this.fromAnalytical1,
    required this.toAnalytical1,
    required this.fromSubVoucher,
    required this.toSubVoucher,
    required this.reportName,
    required this.exportType,
  });
}

class LedgerReportForMainAccountsFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final String initialExportType;

  const LedgerReportForMainAccountsFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<LedgerReportForMainAccountsFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<LedgerReportForMainAccountsFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LedgerReportForMainAccountsFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<LedgerReportForMainAccountsFilterBottomSheetWidget> createState() =>
      _LedgerReportForMainAccountsFilterBottomSheetWidgetState();
}

class _LedgerReportForMainAccountsFilterBottomSheetWidgetState
    extends State<LedgerReportForMainAccountsFilterBottomSheetWidget> {
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  final _accountLevelController = TextEditingController();
  final _fromAnalyticalController = TextEditingController();
  final _toAnalyticalController = TextEditingController();
  final _fromAnalytical1Controller = TextEditingController();
  final _toAnalytical1Controller = TextEditingController();
  final _fromSubVoucherController = TextEditingController();
  final _toSubVoucherController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _isDetailed = false;
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';
  String get _reportName => _isDetailed ? 'AGL023D' : 'AGL021N';

  @override
  void initState() {
    super.initState();
    _exportType = widget.initialExportType;
  }

  @override
  void dispose() {
    _accountLevelController.dispose();
    _fromAnalyticalController.dispose();
    _toAnalyticalController.dispose();
    _fromAnalytical1Controller.dispose();
    _toAnalytical1Controller.dispose();
    _fromSubVoucherController.dispose();
    _toSubVoucherController.dispose();
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

  int? _parseOptionalInt(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : int.tryParse(text);
  }

  void _submit() {
    final accountLevel = _parseOptionalInt(_accountLevelController);
    final fromAnalytical = _parseOptionalInt(_fromAnalyticalController);
    final toAnalytical = _parseOptionalInt(_toAnalyticalController);
    final fromAnalytical1 = _parseOptionalInt(_fromAnalytical1Controller);
    final toAnalytical1 = _parseOptionalInt(_toAnalytical1Controller);
    final fromSubVoucher = _parseOptionalInt(_fromSubVoucherController);
    final toSubVoucher = _parseOptionalInt(_toSubVoucherController);
    final fields = [
      (_accountLevelController, accountLevel),
      (_fromAnalyticalController, fromAnalytical),
      (_toAnalyticalController, toAnalytical),
      (_fromAnalytical1Controller, fromAnalytical1),
      (_toAnalytical1Controller, toAnalytical1),
      (_fromSubVoucherController, fromSubVoucher),
      (_toSubVoucherController, toSubVoucher),
    ];
    if (fields.any(
      (field) => field.$1.text.trim().isNotEmpty && field.$2 == null,
    )) {
      _showValidation(
        _isArabic ? 'أدخل أرقامًا صحيحة في الحقول' : 'Enter valid numbers',
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
      LedgerReportForMainAccountsFilterSelection(
        accountLevel: accountLevel,
        fromAccountNo: _fromAccount?.accountNo,
        toAccountNo: _toAccount?.accountNo,
        fromAnalytical: fromAnalytical,
        toAnalytical: toAnalytical,
        fromDate: _fromDate,
        toDate: _toDate,
        fromAnalytical1: fromAnalytical1,
        toAnalytical1: toAnalytical1,
        fromSubVoucher: fromSubVoucher,
        toSubVoucher: toSubVoucher,
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
                      DropdownButtonFormField<bool>(
                        initialValue: _isDetailed,
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'نوع التقرير' : 'Report type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: false,
                            child: Text(_isArabic ? 'إجمالي' : 'Summary'),
                          ),
                          DropdownMenuItem(
                            value: true,
                            child: Text(_isArabic ? 'تفصيلي' : 'Detailed'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _isDetailed = value);
                          }
                        },
                      ),
                      Gap(12.h),
                      _numberField(
                        _isArabic ? 'مستوى الحساب' : 'Account level',
                        _accountLevelController,
                        onChanged: (_) => setState(() {}),
                      ),
                      Gap(12.h),
                      ChartOfAccountDropdown(
                        title: _isArabic ? 'من حساب' : 'From account',
                        accountType: null,
                        accountLevel: _parseOptionalInt(
                          _accountLevelController,
                        ),
                        initialValue: _fromAccount,
                        onSelected: (account) {
                          setState(() => _fromAccount = account);
                        },
                      ),
                      Gap(8.h),
                      ChartOfAccountDropdown(
                        title: _isArabic ? 'إلى حساب' : 'To account',
                        accountType: null,
                        accountLevel: _parseOptionalInt(
                          _accountLevelController,
                        ),
                        initialValue: _toAccount,
                        onSelected: (account) {
                          setState(() => _toAccount = account);
                        },
                      ),
                      Gap(12.h),
                      _numberRange(
                        _isArabic ? 'من تحليل' : 'From analytical',
                        _fromAnalyticalController,
                        _isArabic ? 'إلى تحليل' : 'To analytical',
                        _toAnalyticalController,
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
                      Gap(12.h),
                      _numberRange(
                        _isArabic ? 'من تحليل 1' : 'From analytical 1',
                        _fromAnalytical1Controller,
                        _isArabic ? 'إلى تحليل 1' : 'To analytical 1',
                        _toAnalytical1Controller,
                      ),
                      Gap(12.h),
                      _numberRange(
                        _isArabic ? 'من رقم السند الفرعي' : 'From sub-voucher',
                        _fromSubVoucherController,
                        _isArabic ? 'إلى رقم السند الفرعي' : 'To sub-voucher',
                        _toSubVoucherController,
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
                      backgroundColor: AppColor.oceanBlue,
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

  Widget _numberField(
    String label,
    TextEditingController controller, {
    void Function(String)? onChanged,
  }) => CustomFormField(
    width: double.infinity,
    radius: 12.r,
    controller: controller,
    onChanged: onChanged,
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
