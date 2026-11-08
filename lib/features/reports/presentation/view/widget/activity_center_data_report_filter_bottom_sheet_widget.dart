import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

class ActivityCenterDataReportFilterSelection {
  final int? fromCostCenterNo;
  final int? toCostCenterNo;
  final int? fromLevel;
  final int? toLevel;
  final int centerType;
  final int? fromCenterNoZero;
  final int? toCenterNoZero;
  final String exportType;

  const ActivityCenterDataReportFilterSelection({
    required this.fromCostCenterNo,
    required this.toCostCenterNo,
    required this.fromLevel,
    required this.toLevel,
    required this.centerType,
    required this.fromCenterNoZero,
    required this.toCenterNoZero,
    required this.exportType,
  });
}

class ActivityCenterDataReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialExportType;

  const ActivityCenterDataReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<ActivityCenterDataReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<ActivityCenterDataReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ActivityCenterDataReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<ActivityCenterDataReportFilterBottomSheetWidget> createState() =>
      _ActivityCenterDataReportFilterBottomSheetWidgetState();
}

class _ActivityCenterDataReportFilterBottomSheetWidgetState
    extends State<ActivityCenterDataReportFilterBottomSheetWidget> {
  final _fromLevelController = TextEditingController();
  final _toLevelController = TextEditingController();
  CostCenterLightModel? _fromCenterZero;
  CostCenterLightModel? _toCenterZero;
  int _centerType = 0;
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
    _fromLevelController.dispose();
    _toLevelController.dispose();
    super.dispose();
  }

  void _submit() {
    final fromLevel = _parseOptionalInt(_fromLevelController.text);
    final toLevel = _parseOptionalInt(_toLevelController.text);
    if ((_fromLevelController.text.trim().isNotEmpty && fromLevel == null) ||
        (_toLevelController.text.trim().isNotEmpty && toLevel == null)) {
      _showValidation(
        _isArabic
            ? 'المستوى يجب أن يكون رقمًا صحيحًا'
            : 'Levels must be whole numbers',
      );
      return;
    }
    if (_fromCenterZero != null &&
        _toCenterZero != null &&
        _fromCenterZero!.costCenterNo > _toCenterZero!.costCenterNo) {
      _showValidation(
        _isArabic
            ? 'مركز البداية يجب أن يسبق أو يساوي مركز النهاية'
            : 'From center must be less than or equal to To center',
      );
      return;
    }
    if (fromLevel != null && toLevel != null && fromLevel > toLevel) {
      _showValidation(
        _isArabic
            ? 'المستوى من يجب أن يسبق أو يساوي المستوى إلى'
            : 'From level must be less than or equal to To level',
      );
      return;
    }

    Navigator.pop(
      context,
      ActivityCenterDataReportFilterSelection(
        fromCostCenterNo: null,
        toCostCenterNo: null,
        fromLevel: fromLevel,
        toLevel: toLevel,
        centerType: _centerType,
        fromCenterNoZero: _fromCenterZero?.costCenterNo.toInt(),
        toCenterNoZero: _toCenterZero?.costCenterNo.toInt(),
        exportType: _exportType,
      ),
    );
  }

  int? _parseOptionalInt(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : int.tryParse(trimmed);
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
                      _sectionTitle(
                        _isArabic ? 'نوع المركز' : 'Center type',
                        foreground,
                      ),
                      Gap(8.h),
                      DropdownButtonFormField<int>(
                        initialValue: _centerType,
                        decoration: InputDecoration(
                          labelText: _isArabic
                              ? 'نوع مركز التكلفة'
                              : 'Cost center type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 0,
                            child: Text(_isArabic ? 'رئيسي' : 'Main'),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text(_isArabic ? 'فرعي' : 'Sub'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text(_isArabic ? 'الجميع' : 'All'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _centerType = value);
                          }
                        },
                      ),
                      Gap(14.h),
                      _sectionTitle(
                        _isArabic
                            ? 'من مركز إلى مركز (رئيسي)'
                            : 'Center to center (main)',
                        foreground,
                      ),
                      Gap(8.h),
                      CostCenterDropdown(
                        title: _isArabic ? 'من مركز' : 'From center',
                        hintText: _isArabic ? 'كل المراكز' : 'All centers',
                        centerType: 1,
                        centerKind: 0,
                        idAsString: '1',
                        pageSize: 3,
                        initialValue: _fromCenterZero,
                        onSelected: (center) {
                          setState(() {
                            _fromCenterZero = center;
                            _validationMessage = null;
                          });
                        },
                      ),
                      Gap(10.h),
                      CostCenterDropdown(
                        title: _isArabic ? 'إلى مركز' : 'To center',
                        hintText: _isArabic ? 'كل المراكز' : 'All centers',
                        centerType: 1,
                        centerKind: 0,
                        idAsString: '1',
                        pageSize: 3,
                        initialValue: _toCenterZero,
                        onSelected: (center) {
                          setState(() {
                            _toCenterZero = center;
                            _validationMessage = null;
                          });
                        },
                      ),
                      Gap(14.h),
                      _sectionTitle(
                        _isArabic ? 'نطاق المستويات' : 'Level range',
                        foreground,
                      ),
                      Gap(8.h),
                      Row(
                        children: [
                          Expanded(
                            child: _levelField(
                              _fromLevelController,
                              _isArabic ? 'من مستوى' : 'From level',
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: _levelField(
                              _toLevelController,
                              _isArabic ? 'إلى مستوى' : 'To level',
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

  Widget _sectionTitle(String title, Color foreground) => Text(
    title,
    style: TextStyle(
      color: foreground,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _levelField(TextEditingController controller, String label) {
    return CustomFormField(
      width: double.infinity,
      radius: 12.r,
      controller: controller,
      title: label,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (_) => setState(() => _validationMessage = null),
    );
  }
}
