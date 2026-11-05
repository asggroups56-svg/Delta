import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

/// The financial statements report names supported by
/// `Report/FinancialStatementsReport`, keyed by
/// `FinancialStatementReportType` and then `ReportType`.
const Map<int, Map<int, String>> financialStatementReportNames = {
  // Trading and operating.
  1: {
    1: 'AGL034A',
    2: 'AGL038',
    3: 'AGL038A',
    4: 'AGL042',
    5: 'AGL042',
    6: 'AGL042',
  },
  // Profit and loss.
  2: {
    1: 'AGL035',
    2: 'AGL039',
    3: 'AGL039A',
    4: 'AGL043',
    5: 'AGL043',
    6: 'AGL041A',
  },
  // Balance sheet.
  3: {
    1: 'AGL036',
    2: 'AGL040',
    3: 'AGL040D',
    4: 'AGL044',
    5: 'AGL044',
    6: 'AGL040A',
  },
  // Income statement.
  4: {
    1: 'AGL069',
    2: 'AGL071',
    3: 'AGL068',
    4: 'AGL070',
    5: 'AGL070',
    6: 'AGL040A',
  },
  // Cash flow.
  5: {
    1: 'AGL073',
    2: 'AGL075',
    3: 'AGL072',
    4: 'AGL074',
    5: 'AGL074',
    6: 'AGL040A',
  },
};

/// Resolves the report name for a financial statement type and report type.
String financialStatementReportName({
  required int financialStatementReportType,
  required int reportType,
}) {
  return financialStatementReportNames[financialStatementReportType]?[reportType] ??
      'AGL034A';
}

class FinalReportsFilterSelection {
  final int financialStatementReportType;
  final int reportType;
  final int? toMonth;
  final num? costCenterNo;
  final String reportName;
  final String exportType;

  const FinalReportsFilterSelection({
    required this.financialStatementReportType,
    required this.reportType,
    required this.toMonth,
    required this.costCenterNo,
    required this.reportName,
    required this.exportType,
  });
}

class FinalReportsFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialExportType;

  const FinalReportsFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<FinalReportsFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<FinalReportsFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FinalReportsFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<FinalReportsFilterBottomSheetWidget> createState() =>
      _FinalReportsFilterBottomSheetWidgetState();
}

class _FinalReportsFilterBottomSheetWidgetState
    extends State<FinalReportsFilterBottomSheetWidget> {
  int _financialStatementReportType = 1;
  int _reportType = 1;
  int _toMonth = 0;
  CostCenterLightModel? _costCenter;
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _exportType = widget.initialExportType;
  }

  void _submit() {
    Navigator.pop(
      context,
      FinalReportsFilterSelection(
        financialStatementReportType: _financialStatementReportType,
        reportType: _reportType,
        toMonth: _toMonth == 0 ? null : _toMonth,
        costCenterNo: _costCenter?.costCenterNo,
        reportName: financialStatementReportName(
          financialStatementReportType: _financialStatementReportType,
          reportType: _reportType,
        ),
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
                      DropdownButtonFormField<int>(
                        initialValue: _financialStatementReportType,
                        decoration: InputDecoration(
                          labelText: _isArabic
                              ? 'نوع القائمة المالية'
                              : 'Financial statement',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: Text(
                              _isArabic
                                  ? 'المتاجرة والتشغيل'
                                  : 'Trading and operating',
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
                            child: Text(
                              _isArabic
                                  ? 'الميزانية العمومية'
                                  : 'Balance sheet',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text(
                              _isArabic ? 'قائمة الدخل' : 'Income statement',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text(
                              _isArabic ? 'التدفقات النقدية' : 'Cash flow',
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _financialStatementReportType = value;
                              _validationMessage = null;
                            });
                          }
                        },
                      ),
                      Gap(12.h),
                      DropdownButtonFormField<int>(
                        initialValue: _reportType,
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'نوع التقرير' : 'Report type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: Text(
                              _isArabic ? 'برقم حساب' : 'With account number',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text(
                              _isArabic
                                  ? 'بدون رقم حساب'
                                  : 'Without account number',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text(
                              _isArabic ? 'تقرير طولي' : 'Vertical report',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text(
                              _isArabic
                                  ? 'مقارنة تقديرية'
                                  : 'Forecast comparison',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text(
                              _isArabic
                                  ? 'مقارنة سنة سابقة'
                                  : 'Previous year comparison',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 6,
                            child: Text(
                              _isArabic
                                  ? 'مقارنة طولية'
                                  : 'Vertical comparison',
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _reportType = value;
                              _validationMessage = null;
                            });
                          }
                        },
                      ),
                      Gap(12.h),
                      CostCenterDropdown(
                        title: _isArabic ? 'مركز التكلفة' : 'Cost center',
                        hintText: _isArabic ? 'كل المراكز' : 'All centers',
                        initialValue: _costCenter,
                        onSelected: (center) {
                          setState(() {
                            _costCenter = center;
                            _validationMessage = null;
                          });
                        },
                      ),
                      Gap(12.h),
                      DropdownButtonFormField<int>(
                        initialValue: _toMonth,
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'إلى شهر' : 'To month',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 0,
                            child: Text(_isArabic ? 'كل الشهور' : 'All months'),
                          ),
                          ...List.generate(
                            12,
                            (index) => DropdownMenuItem(
                              value: index + 1,
                              child: Text('${index + 1}'),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _toMonth = value;
                              _validationMessage = null;
                            });
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
}
