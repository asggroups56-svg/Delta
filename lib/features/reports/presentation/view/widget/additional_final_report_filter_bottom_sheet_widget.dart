import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

/// The report variants supported by `Report/AdditionalFinalReport`, keyed by
/// the selection order shown in the filter sheet.
const Map<int, String> additionalFinalReportNames = {
  1: 'AGL037A', // With account number.
  2: 'AGL041', // Without account number.
  3: 'AGL045A', // Forecast comparison.
  4: 'AGL041B', // Vertical report.
  5: 'AGL045C', // Vertical comparison.
  6: 'AGL045B', // Previous year comparison.
};

String additionalFinalReportName(int variant) =>
    additionalFinalReportNames[variant] ?? 'AGL037A';

class AdditionalFinalReportFilterSelection {
  final int? reportSerial;
  final num? costCenterNo;
  final String? reportTitle;
  final int? fromLineSerial;
  final int? toLineSerial;
  final String reportName;
  final String exportType;

  const AdditionalFinalReportFilterSelection({
    required this.reportSerial,
    required this.costCenterNo,
    required this.reportTitle,
    required this.fromLineSerial,
    required this.toLineSerial,
    required this.reportName,
    required this.exportType,
  });
}

class AdditionalFinalReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialExportType;

  const AdditionalFinalReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<AdditionalFinalReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<AdditionalFinalReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdditionalFinalReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<AdditionalFinalReportFilterBottomSheetWidget> createState() =>
      _AdditionalFinalReportFilterBottomSheetWidgetState();
}

class _AdditionalFinalReportFilterBottomSheetWidgetState
    extends State<AdditionalFinalReportFilterBottomSheetWidget> {
  int _variant = 1;
  CostCenterLightModel? _costCenter;
  final _reportSerialController = TextEditingController();
  final _reportTitleController = TextEditingController();
  final _fromLineSerialController = TextEditingController();
  final _toLineSerialController = TextEditingController();
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
    _reportSerialController.dispose();
    _reportTitleController.dispose();
    _fromLineSerialController.dispose();
    _toLineSerialController.dispose();
    super.dispose();
  }

  int? _optionalInt(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : int.tryParse(text);
  }

  void _submit() {
    final reportSerialText = _reportSerialController.text.trim();
    final fromLineSerialText = _fromLineSerialController.text.trim();
    final toLineSerialText = _toLineSerialController.text.trim();
    final reportSerial = _optionalInt(_reportSerialController);
    final fromLineSerial = _optionalInt(_fromLineSerialController);
    final toLineSerial = _optionalInt(_toLineSerialController);
    final reportTitle = _reportTitleController.text.trim();

    if (reportSerialText.isNotEmpty && reportSerial == null) {
      setState(() {
        _validationMessage = _isArabic
            ? 'أدخل رقماً صحيحاً للتقرير'
            : 'Enter a valid report serial';
      });
      return;
    }
    if (fromLineSerialText.isNotEmpty && fromLineSerial == null) {
      setState(() {
        _validationMessage = _isArabic
            ? 'أدخل رقماً صحيحاً لسطر البداية'
            : 'Enter a valid from line serial';
      });
      return;
    }
    if (toLineSerialText.isNotEmpty && toLineSerial == null) {
      setState(() {
        _validationMessage = _isArabic
            ? 'أدخل رقماً صحيحاً لسطر النهاية'
            : 'Enter a valid to line serial';
      });
      return;
    }
    if (fromLineSerial != null &&
        toLineSerial != null &&
        fromLineSerial > toLineSerial) {
      setState(() {
        _validationMessage = _isArabic
            ? 'سطر البداية يجب أن يسبق أو يساوي سطر النهاية'
            : 'From line must be less than or equal to To line';
      });
      return;
    }

    Navigator.pop(
      context,
      AdditionalFinalReportFilterSelection(
        reportSerial: reportSerial,
        costCenterNo: _costCenter?.costCenterNo,
        reportTitle: reportTitle.isEmpty ? null : reportTitle,
        fromLineSerial: fromLineSerial,
        toLineSerial: toLineSerial,
        reportName: additionalFinalReportName(_variant),
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
                        initialValue: _variant,
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
                              _isArabic
                                  ? 'مقارنة تقديرية'
                                  : 'Forecast comparison',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text(
                              _isArabic ? 'تقرير طولي' : 'Vertical report',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text(
                              _isArabic
                                  ? 'مقارنة طولية'
                                  : 'Vertical comparison',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 6,
                            child: Text(
                              _isArabic
                                  ? 'مقارنة سنة سابقة'
                                  : 'Previous year comparison',
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _variant = value;
                              _validationMessage = null;
                            });
                          }
                        },
                      ),
                      Gap(12.h),
                      CustomFormField(
                        controller: _reportSerialController,
                        title: _isArabic ? 'رقم التقرير' : 'Report serial',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) {
                          setState(() => _validationMessage = null);
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
                      CustomFormField(
                        controller: _reportTitleController,
                        title: _isArabic ? 'عنوان التقرير' : 'Report title',
                        onChanged: (_) {
                          setState(() => _validationMessage = null);
                        },
                      ),
                      Gap(12.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomFormField(
                              controller: _fromLineSerialController,
                              title: _isArabic ? 'من سطر' : 'From line',
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
                              controller: _toLineSerialController,
                              title: _isArabic ? 'إلى سطر' : 'To line',
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
