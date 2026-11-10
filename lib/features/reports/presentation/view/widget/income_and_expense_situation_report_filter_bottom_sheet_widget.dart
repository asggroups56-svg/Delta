import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

class IncomeAndExpenseSituationReportFilterSelection {
  final int? accountLevel;
  final int? fromMonth;
  final int? toMonth;
  final int? fromCostCenterNo;
  final int? toCostCenterNo;
  final int? yearQuarter;
  final int finalAccountType;
  final int reportPageType;
  final String reportName;
  final String exportType;

  const IncomeAndExpenseSituationReportFilterSelection({
    this.accountLevel,
    this.fromMonth,
    this.toMonth,
    this.fromCostCenterNo,
    this.toCostCenterNo,
    this.yearQuarter,
    this.finalAccountType = 3,
    this.reportPageType = 2,
    this.reportName = 'AGL300_M',
    this.exportType = 'pdf',
  });
}

class IncomeAndExpenseSituationReportFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final String initialExportType;
  final String initialReportName;
  final int initialReportPageType;
  final int? initialAccountLevel;
  final int initialYearQuarter;

  const IncomeAndExpenseSituationReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
    this.initialReportName = 'AGL300_M',
    this.initialReportPageType = 2,
    this.initialAccountLevel = 15,
    this.initialYearQuarter = 5,
  });

  static Future<IncomeAndExpenseSituationReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
    String initialReportName = 'AGL300_M',
    int initialReportPageType = 2,
    int? initialAccountLevel = 15,
    int initialYearQuarter = 5,
  }) {
    return showModalBottomSheet<IncomeAndExpenseSituationReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IncomeAndExpenseSituationReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
        initialReportName: initialReportName,
        initialReportPageType: initialReportPageType,
        initialAccountLevel: initialAccountLevel,
        initialYearQuarter: initialYearQuarter,
      ),
    );
  }

  @override
  State<IncomeAndExpenseSituationReportFilterBottomSheetWidget> createState() =>
      _IncomeAndExpenseSituationReportFilterBottomSheetWidgetState();
}

class _IncomeAndExpenseSituationReportFilterBottomSheetWidgetState
    extends State<IncomeAndExpenseSituationReportFilterBottomSheetWidget> {
  static const _months = [
    AppLocaleKey.monthJanuary,
    AppLocaleKey.monthFebruary,
    AppLocaleKey.monthMarch,
    AppLocaleKey.monthApril,
    AppLocaleKey.monthMay,
    AppLocaleKey.monthJune,
    AppLocaleKey.monthJuly,
    AppLocaleKey.monthAugust,
    AppLocaleKey.monthSeptember,
    AppLocaleKey.monthOctober,
    AppLocaleKey.monthNovember,
    AppLocaleKey.monthDecember,
  ];

  final _accountLevelController = TextEditingController();
  CostCenterLightModel? _fromCostCenter;
  CostCenterLightModel? _toCostCenter;
  int _fromMonthValue = 0;
  int _toMonthValue = 0;
  late int _yearQuarter;
  int _finalAccountType = 3;
  late String _reportName;
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';
  bool get _isQuarterly => widget.initialReportPageType == 4;
  bool get _isCostCenter => widget.initialReportPageType == 5;

  @override
  void initState() {
    super.initState();
    _reportName = widget.initialReportName;
    _exportType = widget.initialExportType;
    _yearQuarter = widget.initialYearQuarter;
    _accountLevelController.text = widget.initialAccountLevel?.toString() ?? '';
  }

  @override
  void dispose() {
    _accountLevelController.dispose();
    super.dispose();
  }

  void _submit() {
    final accountLevelText = _accountLevelController.text.trim();
    final accountLevel = accountLevelText.isEmpty
        ? null
        : int.tryParse(accountLevelText);

    if (accountLevelText.isNotEmpty && accountLevel == null) {
      setState(() {
        _validationMessage = _isArabic
            ? 'أدخل مستوى حساب صحيحاً'
            : 'Enter a valid account level';
      });
      return;
    }

    final fromMonth = _fromMonthValue == 0 ? null : _fromMonthValue;
    final toMonth = _toMonthValue == 0 ? null : _toMonthValue;
    if (!_isQuarterly) {
      if ((fromMonth == null) != (toMonth == null)) {
        setState(() {
          _validationMessage = AppLocaleKey.chooseBothMonths.tr();
        });
        return;
      }
      if (fromMonth != null && toMonth != null && fromMonth > toMonth) {
        setState(() {
          _validationMessage = AppLocaleKey.invalidMonthRange.tr();
        });
        return;
      }
    }

    final fromCostCenterNo = _fromCostCenter?.costCenterNo.toInt();
    final toCostCenterNo = _toCostCenter?.costCenterNo.toInt();

    if (_isCostCenter) {
      if ((_fromCostCenter == null) != (_toCostCenter == null)) {
        setState(() {
          _validationMessage = _isArabic
              ? 'اختر مركزي التكلفة من وإلى'
              : 'Select both from and to cost centers';
        });
        return;
      }
      if (fromCostCenterNo != null &&
          toCostCenterNo != null &&
          fromCostCenterNo > toCostCenterNo) {
        setState(() {
          _validationMessage = _isArabic
              ? 'مركز التكلفة (من) يجب أن يكون أصغر من (إلى)'
              : 'From cost center must be less than to cost center';
        });
        return;
      }
    }

    Navigator.pop(
      context,
      IncomeAndExpenseSituationReportFilterSelection(
        accountLevel: accountLevel,
        fromMonth: _isQuarterly ? null : fromMonth,
        toMonth: _isQuarterly ? null : toMonth,
        fromCostCenterNo: _isCostCenter ? fromCostCenterNo : null,
        toCostCenterNo: _isCostCenter ? toCostCenterNo : null,
        yearQuarter: _isQuarterly ? _yearQuarter : null,
        finalAccountType: _finalAccountType,
        reportPageType: widget.initialReportPageType,
        reportName: _reportName,
        exportType: _exportType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.emeraldTeal;
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
                          setState(() => _validationMessage = null);
                        },
                      ),
                      Gap(12.h),
                      if (_isQuarterly)
                        DropdownButtonFormField<int>(
                          initialValue: _yearQuarter,
                          decoration: InputDecoration(
                            labelText: _isArabic ? 'الربع' : 'Quarter',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 1,
                              child: Text(
                                _isArabic ? 'الربع الأول' : 'First quarter',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(
                                _isArabic ? 'الربع الثاني' : 'Second quarter',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text(
                                _isArabic ? 'الربع الثالث' : 'Third quarter',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 4,
                              child: Text(
                                _isArabic ? 'الربع الرابع' : 'Fourth quarter',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 5,
                              child: Text(_isArabic ? 'الجميع' : 'All'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _yearQuarter = value);
                            }
                          },
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                initialValue: _fromMonthValue,
                                decoration: InputDecoration(
                                  labelText: AppLocaleKey.fromMonth.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                items: _monthItems(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _fromMonthValue = value;
                                      _validationMessage = null;
                                    });
                                  }
                                },
                              ),
                            ),
                            Gap(10.w),
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                initialValue: _toMonthValue,
                                decoration: InputDecoration(
                                  labelText: AppLocaleKey.toMonth.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                items: _monthItems(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _toMonthValue = value;
                                      _validationMessage = null;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      Gap(12.h),
                      if (_isCostCenter) ...[
                        CostCenterDropdown(
                          title: _isArabic
                              ? 'من مركز تكلفة'
                              : 'From cost center',
                          hintText: _isArabic
                              ? 'اختر مركز التكلفة'
                              : 'Select cost center',
                          centerType: null,
                          centerKind: null,
                          centerLevel: 1,
                          accountType: 1,
                          pageSize: 10,
                          initialValue: _fromCostCenter,
                          onSelected: (value) => setState(() {
                            _fromCostCenter = value;
                            _validationMessage = null;
                          }),
                        ),
                        Gap(12.h),
                        CostCenterDropdown(
                          title: _isArabic
                              ? 'إلى مركز تكلفة'
                              : 'To cost center',
                          hintText: _isArabic
                              ? 'اختر مركز التكلفة'
                              : 'Select cost center',
                          centerType: null,
                          centerKind: null,
                          centerLevel: 1,
                          accountType: 1,
                          pageSize: 10,
                          initialValue: _toCostCenter,
                          onSelected: (value) => setState(() {
                            _toCostCenter = value;
                            _validationMessage = null;
                          }),
                        ),
                        Gap(12.h),
                      ],
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
                              _isArabic
                                  ? 'الأرباح والخسائر'
                                  : 'Profit and loss',
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

  List<DropdownMenuItem<int>> _monthItems() {
    return [
      DropdownMenuItem(value: 0, child: Text(AppLocaleKey.allMonths.tr())),
      for (var index = 0; index < _months.length; index++)
        DropdownMenuItem(value: index + 1, child: Text(_months[index].tr())),
    ];
  }
}
