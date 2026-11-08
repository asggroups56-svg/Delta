import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';

class IndicatorDataAdditionReportFilterSelection {
  final int? fromIndicatorCode;
  final int? toIndicatorCode;
  final String reportName;
  final String exportType;

  const IndicatorDataAdditionReportFilterSelection({
    required this.fromIndicatorCode,
    required this.toIndicatorCode,
    required this.reportName,
    required this.exportType,
  });
}

class IndicatorDataAdditionReportFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final String initialReportName;
  final String initialExportType;

  const IndicatorDataAdditionReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialReportName = 'AGL800A',
    this.initialExportType = 'pdf',
  });

  static Future<IndicatorDataAdditionReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialReportName = 'AGL800A',
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<IndicatorDataAdditionReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IndicatorDataAdditionReportFilterBottomSheetWidget(
        title: title,
        initialReportName: initialReportName,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<IndicatorDataAdditionReportFilterBottomSheetWidget> createState() =>
      _IndicatorDataAdditionReportFilterBottomSheetWidgetState();
}

class _IndicatorDataAdditionReportFilterBottomSheetWidgetState
    extends State<IndicatorDataAdditionReportFilterBottomSheetWidget> {
  final _fromIndicatorCodeController = TextEditingController();
  final _toIndicatorCodeController = TextEditingController();
  late String _reportName;
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _reportName = widget.initialReportName;
    _exportType = widget.initialExportType;
  }

  @override
  void dispose() {
    _fromIndicatorCodeController.dispose();
    _toIndicatorCodeController.dispose();
    super.dispose();
  }

  int? _parseOptionalInt(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : int.tryParse(trimmed);
  }

  void _submit() {
    final fromIndicatorCode = _parseOptionalInt(
      _fromIndicatorCodeController.text,
    );
    final toIndicatorCode = _parseOptionalInt(_toIndicatorCodeController.text);
    if ((_fromIndicatorCodeController.text.trim().isNotEmpty &&
            fromIndicatorCode == null) ||
        (_toIndicatorCodeController.text.trim().isNotEmpty &&
            toIndicatorCode == null)) {
      _showValidation(
        _isArabic
            ? 'رمز المؤشر يجب أن يكون رقمًا صحيحًا'
            : 'Indicator codes must be whole numbers',
      );
      return;
    }
    if (fromIndicatorCode != null &&
        toIndicatorCode != null &&
        fromIndicatorCode > toIndicatorCode) {
      _showValidation(
        _isArabic
            ? 'رمز البداية يجب أن يسبق أو يساوي رمز النهاية'
            : 'From indicator code must be less than or equal to To indicator code',
      );
      return;
    }

    Navigator.pop(
      context,
      IndicatorDataAdditionReportFilterSelection(
        fromIndicatorCode: fromIndicatorCode,
        toIndicatorCode: toIndicatorCode,
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
                      Text(
                        _isArabic ? 'نوع التقرير' : 'Report type',
                        style: TextStyle(
                          color: foreground,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(8.h),
                      DropdownButtonFormField<String>(
                        initialValue: _reportName,
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'طريقة العرض' : 'Display mode',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'AGL800A',
                            child: Text(
                              _isArabic
                                  ? 'إجمالي (AGL800A)'
                                  : 'Total (AGL800A)',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'AGL800',
                            child: Text(
                              _isArabic
                                  ? 'تفصيلي (AGL800)'
                                  : 'Detailed (AGL800)',
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _reportName = value;
                              _validationMessage = null;
                            });
                          }
                        },
                      ),
                      Gap(14.h),
                      Text(
                        _isArabic
                            ? 'نطاق رموز المؤشرات'
                            : 'Indicator code range',
                        style: TextStyle(
                          color: foreground,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(8.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomFormField(
                              width: double.infinity,
                              radius: 12.r,
                              controller: _fromIndicatorCodeController,
                              title: _isArabic ? 'من رمز' : 'From code',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: CustomFormField(
                              width: double.infinity,
                              radius: 12.r,
                              controller: _toIndicatorCodeController,
                              title: _isArabic ? 'إلى رمز' : 'To code',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
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
}
