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

class LedgerReportForAssistantAccountsFilterSelection {
  final num? fromAccountNo;
  final num? toAccountNo;
  final int centerLevel;
  final num? fromCostCenterNo;
  final num? toCostCenterNo;
  final int? fromAccAnal;
  final int? toAccAnal;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? fromCentAnal;
  final int? toCentAnal;
  final int? fromAnalytical;
  final int? toAnalytical;
  final int sideType;
  final String reportName;
  final String exportType;

  const LedgerReportForAssistantAccountsFilterSelection({
    required this.fromAccountNo,
    required this.toAccountNo,
    required this.centerLevel,
    required this.fromCostCenterNo,
    required this.toCostCenterNo,
    required this.fromAccAnal,
    required this.toAccAnal,
    required this.fromDate,
    required this.toDate,
    required this.fromCentAnal,
    required this.toCentAnal,
    required this.fromAnalytical,
    required this.toAnalytical,
    required this.sideType,
    required this.reportName,
    required this.exportType,
  });
}

class LedgerReportForAssistantAccountsFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final String initialExportType;

  const LedgerReportForAssistantAccountsFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<LedgerReportForAssistantAccountsFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<
      LedgerReportForAssistantAccountsFilterSelection
    >(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LedgerReportForAssistantAccountsFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<LedgerReportForAssistantAccountsFilterBottomSheetWidget>
  createState() =>
      _LedgerReportForAssistantAccountsFilterBottomSheetWidgetState();
}

class _LedgerReportForAssistantAccountsFilterBottomSheetWidgetState
    extends State<LedgerReportForAssistantAccountsFilterBottomSheetWidget> {
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  CostCenterLightModel? _fromCostCenter;
  CostCenterLightModel? _toCostCenter;
  final _centerLevelController = TextEditingController(text: '1');
  final _fromAccAnalController = TextEditingController();
  final _toAccAnalController = TextEditingController();
  final _fromCentAnalController = TextEditingController();
  final _toCentAnalController = TextEditingController();
  final _fromAnalyticalController = TextEditingController();
  final _toAnalyticalController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  int _sideType = 2;
  bool _isAssistantAccountLedger = false;
  bool _isDetailed = true;
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  String get _reportName {
    if (_isDetailed) return _isAssistantAccountLedger ? 'AGL093' : 'AGL094';
    return _isAssistantAccountLedger ? 'AGL0106' : 'AGL095';
  }

  @override
  void initState() {
    super.initState();
    _exportType = widget.initialExportType;
  }

  @override
  void dispose() {
    _centerLevelController.dispose();
    _fromAccAnalController.dispose();
    _toAccAnalController.dispose();
    _fromCentAnalController.dispose();
    _toCentAnalController.dispose();
    _fromAnalyticalController.dispose();
    _toAnalyticalController.dispose();
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
    final centerLevel = _parseOptionalInt(_centerLevelController);
    final fromAccAnal = _parseOptionalInt(_fromAccAnalController);
    final toAccAnal = _parseOptionalInt(_toAccAnalController);
    final fromCentAnal = _parseOptionalInt(_fromCentAnalController);
    final toCentAnal = _parseOptionalInt(_toCentAnalController);
    final fromAnalytical = _parseOptionalInt(_fromAnalyticalController);
    final toAnalytical = _parseOptionalInt(_toAnalyticalController);

    final numericFields = [
      (_centerLevelController, centerLevel),
      (_fromAccAnalController, fromAccAnal),
      (_toAccAnalController, toAccAnal),
      (_fromCentAnalController, fromCentAnal),
      (_toCentAnalController, toCentAnal),
      (_fromAnalyticalController, fromAnalytical),
      (_toAnalyticalController, toAnalytical),
    ];
    if (numericFields.any(
      (field) => field.$1.text.trim().isNotEmpty && field.$2 == null,
    )) {
      _showValidation(
        _isArabic ? 'أدخل أرقامًا صحيحة في الحقول' : 'Enter valid numbers',
      );
      return;
    }
    if (centerLevel == null) {
      _showValidation(
        _isArabic ? 'مستوى المركز مطلوب' : 'Center level is required',
      );
      return;
    }

    if ((_fromDate == null) != (_toDate == null)) {
      _showValidation(
        _isArabic
            ? 'اختر تاريخ البداية والنهاية معًا أو اتركهما فارغين'
            : 'Select both dates or leave both empty',
      );
      return;
    }
    if (_fromDate != null && _fromDate!.isAfter(_toDate!)) {
      _showValidation(
        _isArabic
            ? 'تاريخ البداية يجب أن يسبق أو يساوي تاريخ النهاية'
            : 'From date must be before or equal to To date',
      );
      return;
    }

    Navigator.pop(
      context,
      LedgerReportForAssistantAccountsFilterSelection(
        fromAccountNo: _fromAccount?.accountNo,
        toAccountNo: _toAccount?.accountNo,
        centerLevel: centerLevel,
        fromCostCenterNo: _fromCostCenter?.costCenterNo,
        toCostCenterNo: _toCostCenter?.costCenterNo,
        fromAccAnal: fromAccAnal,
        toAccAnal: toAccAnal,
        fromDate: _fromDate,
        toDate: _toDate,
        fromCentAnal: fromCentAnal,
        toCentAnal: toCentAnal,
        fromAnalytical: fromAnalytical,
        toAnalytical: toAnalytical,
        sideType: _sideType,
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
                        initialValue: _isAssistantAccountLedger,
                        decoration: InputDecoration(
                          labelText: _isArabic
                              ? 'نوع دفتر الأستاذ'
                              : 'Ledger account type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: false,
                            child: Text(
                              _isArabic
                                  ? 'أستاذ مساعد حسابات'
                                  : 'Assistant accounts ledger',
                            ),
                          ),
                          DropdownMenuItem(
                            value: true,
                            child: Text(
                              _isArabic
                                  ? 'حسابات أستاذ مساعد'
                                  : 'Accounts assistant ledger',
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _isAssistantAccountLedger = value);
                          }
                        },
                      ),
                      Gap(12.h),
                      DropdownButtonFormField<bool>(
                        initialValue: _isDetailed,
                        decoration: InputDecoration(
                          labelText: _isArabic
                              ? 'شكل التقرير'
                              : 'Report format',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: true,
                            child: Text(_isArabic ? 'تفصيلي' : 'Detailed'),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text(_isArabic ? 'إجمالي' : 'Summary'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _isDetailed = value);
                          }
                        },
                      ),
                      Gap(12.h),
                      DropdownButtonFormField<int>(
                        initialValue: _sideType,
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'جانب القيد' : 'Entry side',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: Text(
                              _isArabic
                                  ? 'جانبي توزيع المراكز'
                                  : 'Cost center distribution side',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text(
                              _isArabic
                                  ? 'الجانب الأيمن من القيد'
                                  : 'Right side of entry',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text(
                              _isArabic
                                  ? 'الجانب الأيسر من القيد'
                                  : 'Left side of entry',
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _sideType = value);
                        },
                      ),
                      Gap(14.h),
                      _rangeTitle(
                        _isArabic ? 'نطاق الحسابات' : 'Account range',
                        foreground,
                      ),
                      Gap(8.h),
                      ChartOfAccountDropdown(
                        title: _isArabic ? 'من حساب' : 'From account',
                        accountType: 1,
                        includeAccountRangeFields: false,
                        includeAccountsHasCostCenters: null,
                        initialValue: _fromAccount,
                        onSelected: (account) {
                          setState(() => _fromAccount = account);
                        },
                      ),
                      Gap(8.h),
                      ChartOfAccountDropdown(
                        title: _isArabic ? 'إلى حساب' : 'To account',
                        accountType: 1,
                        includeAccountRangeFields: false,
                        includeAccountsHasCostCenters: null,
                        initialValue: _toAccount,
                        onSelected: (account) {
                          setState(() => _toAccount = account);
                        },
                      ),
                      Gap(12.h),
                      _numberField(
                        _isArabic ? 'مستوى المركز' : 'Center level',
                        _centerLevelController,
                        onChanged: (_) => setState(() {}),
                      ),
                      Gap(12.h),
                      _rangeTitle(
                        _isArabic ? 'نطاق مراكز التكلفة' : 'Cost center range',
                        foreground,
                      ),
                      Gap(8.h),
                      CostCenterDropdown(
                        title: _isArabic ? 'من مركز' : 'From center',
                        centerType: null,
                        centerKind: null,
                        centerLevel:
                            _parseOptionalInt(_centerLevelController) ?? 1,
                        accountType: 1,
                        pageSize: 10,
                        initialValue: _fromCostCenter,
                        onSelected: (center) {
                          setState(() => _fromCostCenter = center);
                        },
                      ),
                      Gap(8.h),
                      CostCenterDropdown(
                        title: _isArabic ? 'إلى مركز' : 'To center',
                        centerType: null,
                        centerKind: null,
                        centerLevel:
                            _parseOptionalInt(_centerLevelController) ?? 1,
                        accountType: 1,
                        pageSize: 10,
                        initialValue: _toCostCenter,
                        onSelected: (center) {
                          setState(() => _toCostCenter = center);
                        },
                      ),
                      Gap(12.h),
                      _rangeTitle(
                        _isArabic ? 'تحليل الحساب' : 'Account analysis',
                        foreground,
                      ),
                      Gap(8.h),
                      _numberRange(
                        _isArabic ? 'من تحليل الحساب' : 'From account analysis',
                        _fromAccAnalController,
                        _isArabic ? 'إلى تحليل الحساب' : 'To account analysis',
                        _toAccAnalController,
                      ),
                      Gap(12.h),
                      _rangeTitle(
                        _isArabic ? 'تحليل المركز' : 'Center analysis',
                        foreground,
                      ),
                      Gap(8.h),
                      _numberRange(
                        _isArabic ? 'من تحليل المركز' : 'From center analysis',
                        _fromCentAnalController,
                        _isArabic ? 'إلى تحليل المركز' : 'To center analysis',
                        _toCentAnalController,
                      ),
                      Gap(12.h),
                      _rangeTitle(
                        _isArabic ? 'التحليل' : 'Analytical range',
                        foreground,
                      ),
                      Gap(8.h),
                      _numberRange(
                        _isArabic ? 'من تحليل' : 'From analytical',
                        _fromAnalyticalController,
                        _isArabic ? 'إلى تحليل' : 'To analytical',
                        _toAnalyticalController,
                      ),
                      Gap(14.h),
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

  Widget _rangeTitle(String title, Color foreground) => Text(
    title,
    style: TextStyle(
      color: foreground,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
    ),
  );

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
