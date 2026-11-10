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

class MonthlyExpensesReportFilterSelection {
  final int? fromAccountNo;
  final int? toAccountNo;
  final int? fromCostCenterNo;
  final int? toCostCenterNo;
  final int? fromChartAnaly;
  final int? toChartAnaly;
  final int finalAccountType;
  final int mainAccountsFilter;
  final String exportType;

  const MonthlyExpensesReportFilterSelection({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.fromChartAnaly,
    this.toChartAnaly,
    this.finalAccountType = 3,
    this.mainAccountsFilter = 1,
    this.exportType = 'pdf',
  });
}

class MonthlyExpensesReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialExportType;

  const MonthlyExpensesReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<MonthlyExpensesReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<MonthlyExpensesReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MonthlyExpensesReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<MonthlyExpensesReportFilterBottomSheetWidget> createState() =>
      _MonthlyExpensesReportFilterBottomSheetWidgetState();
}

class _MonthlyExpensesReportFilterBottomSheetWidgetState
    extends State<MonthlyExpensesReportFilterBottomSheetWidget> {
  final _fromChartAnalyController = TextEditingController();
  final _toChartAnalyController = TextEditingController();

  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  CostCenterLightModel? _fromCostCenter;
  CostCenterLightModel? _toCostCenter;
  int _finalAccountType = 3;
  int _mainAccountsFilter = 1;
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
    _fromChartAnalyController.dispose();
    _toChartAnalyController.dispose();
    super.dispose();
  }

  int? _optionalInt(TextEditingController controller) {
    final text = controller.text.trim();
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  void _submit() {
    if (_fromAccount != null &&
        _toAccount != null &&
        _fromAccount!.accountNo > _toAccount!.accountNo) {
      _showValidation(
        _isArabic
            ? 'حساب البداية يجب أن يسبق أو يساوي حساب النهاية'
            : 'From account must be less than or equal to To account',
      );
      return;
    }

    if (!_isValidCostCenterRange(_fromCostCenter, _toCostCenter)) {
      _showValidation(
        _isArabic
            ? 'مركز التكلفة (من) يجب أن يسبق أو يساوي (إلى)'
            : 'From cost center must be less than or equal to To cost center',
      );
      return;
    }

    final fromChartAnaly = _optionalInt(_fromChartAnalyController);
    final toChartAnaly = _optionalInt(_toChartAnalyController);

    if ((_fromChartAnalyController.text.trim().isEmpty) !=
            (_toChartAnalyController.text.trim().isEmpty) ||
        (_fromChartAnalyController.text.trim().isNotEmpty &&
            fromChartAnaly == null) ||
        (_toChartAnalyController.text.trim().isNotEmpty &&
            toChartAnaly == null)) {
      _showValidation(
        _isArabic
            ? 'أدخل تحليل الحساب من وإلى بشكل صحيح'
            : 'Enter a valid from and to account analysis',
      );
      return;
    }

    if (fromChartAnaly != null &&
        toChartAnaly != null &&
        fromChartAnaly > toChartAnaly) {
      _showValidation(
        _isArabic
            ? 'تحليل الحساب (من) يجب أن يسبق أو يساوي (إلى)'
            : 'From account analysis must be less than or equal to To',
      );
      return;
    }

    Navigator.pop(
      context,
      MonthlyExpensesReportFilterSelection(
        fromAccountNo: _fromAccount?.accountNo,
        toAccountNo: _toAccount?.accountNo,
        fromCostCenterNo: _fromCostCenter?.costCenterNo.toInt(),
        toCostCenterNo: _toCostCenter?.costCenterNo.toInt(),
        fromChartAnaly: fromChartAnaly,
        toChartAnaly: toChartAnaly,
        finalAccountType: _finalAccountType,
        mainAccountsFilter: _mainAccountsFilter,
        exportType: _exportType,
      ),
    );
  }

  bool _isValidCostCenterRange(
    CostCenterLightModel? from,
    CostCenterLightModel? to,
  ) {
    if (from == null || to == null) return true;
    return from.costCenterNo <= to.costCenterNo;
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
                    _sectionTitle(
                      _isArabic ? 'نطاق الحسابات' : 'Account range',
                      foreground,
                    ),
                    Gap(8.h),
                    ChartOfAccountDropdown(
                      title: _isArabic ? 'من حساب' : 'From account',
                      accountType: null,
                      includeAccountRangeFields: false,
                      includeAccountsHasCostCenters: false,
                      initialValue: _fromAccount,
                      onSelected: (account) {
                        setState(() {
                          _fromAccount = account;
                          _validationMessage = null;
                        });
                      },
                    ),
                    Gap(10.h),
                    ChartOfAccountDropdown(
                      title: _isArabic ? 'إلى حساب' : 'To account',
                      accountType: null,
                      includeAccountRangeFields: false,
                      includeAccountsHasCostCenters: false,
                      initialValue: _toAccount,
                      onSelected: (account) {
                        setState(() {
                          _toAccount = account;
                          _validationMessage = null;
                        });
                      },
                    ),
                    Gap(14.h),
                    _sectionTitle(
                      _isArabic ? 'نطاق مراكز التكلفة' : 'Cost center range',
                      foreground,
                    ),
                    Gap(8.h),
                    CostCenterDropdown(
                      title: _isArabic ? 'من مركز تكلفة' : 'From cost center',
                      centerType: null,
                      centerKind: null,
                      centerLevel: 1,
                      accountType: 1,
                      pageSize: 10,
                      initialValue: _fromCostCenter,
                      onSelected: (center) {
                        setState(() {
                          _fromCostCenter = center;
                          _validationMessage = null;
                        });
                      },
                    ),
                    Gap(10.h),
                    CostCenterDropdown(
                      title: _isArabic ? 'إلى مركز تكلفة' : 'To cost center',
                      centerType: null,
                      centerKind: null,
                      centerLevel: 1,
                      accountType: 1,
                      pageSize: 10,
                      initialValue: _toCostCenter,
                      onSelected: (center) {
                        setState(() {
                          _toCostCenter = center;
                          _validationMessage = null;
                        });
                      },
                    ),
                    Gap(14.h),
                    _sectionTitle(
                      _isArabic ? 'تحليل الحساب' : 'Account analysis',
                      foreground,
                    ),
                    Gap(8.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomFormField(
                            controller: _fromChartAnalyController,
                            title: _isArabic ? 'من تحليل' : 'From analysis',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (_) {
                              setState(() => _validationMessage = null);
                            },
                          ),
                        ),
                        Gap(10.w),
                        Expanded(
                          child: CustomFormField(
                            controller: _toChartAnalyController,
                            title: _isArabic ? 'إلى تحليل' : 'To analysis',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (_) {
                              setState(() => _validationMessage = null);
                            },
                          ),
                        ),
                      ],
                    ),
                    Gap(14.h),
                    DropdownButtonFormField<int>(
                      initialValue: _finalAccountType,
                      decoration: InputDecoration(
                        labelText: _isArabic
                            ? 'نوع الحساب الختامي'
                            : 'Final account type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: Text(
                            _isArabic
                                ? 'متاجرة وتشغيل'
                                : 'Trading and operations',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text(
                            _isArabic ? 'الأرباح والخسائر' : 'Profit and loss',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: Text(_isArabic ? 'الجميع' : 'All'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _finalAccountType = value);
                        }
                      },
                    ),
                    Gap(12.h),
                    DropdownButtonFormField<int>(
                      initialValue: _mainAccountsFilter,
                      decoration: InputDecoration(
                        labelText: _isArabic
                            ? 'الحسابات الرئيسية'
                            : 'Main accounts',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: Text(_isArabic ? 'إظهار' : 'Show'),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text(_isArabic ? 'إخفاء' : 'Hide'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _mainAccountsFilter = value);
                        }
                      },
                    ),
                    Gap(12.h),
                    DropdownButtonFormField<String>(
                      initialValue: _exportType,
                      decoration: InputDecoration(
                        labelText: _isArabic ? 'صيغة التصدير' : 'Export format',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                        DropdownMenuItem(value: 'excel', child: Text('Excel')),
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
                    backgroundColor: AppColor.emeraldTeal,
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
}
