import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

class TrialBalanceByCategoriesReportFilterSelection {
  final String reportName;
  final String exportType;

  const TrialBalanceByCategoriesReportFilterSelection({
    required this.reportName,
    required this.exportType,
  });
}

class TrialBalanceByCategoriesReportFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final String initialExportType;

  const TrialBalanceByCategoriesReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<TrialBalanceByCategoriesReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<TrialBalanceByCategoriesReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TrialBalanceByCategoriesReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<TrialBalanceByCategoriesReportFilterBottomSheetWidget> createState() =>
      _TrialBalanceByCategoriesReportFilterBottomSheetWidgetState();
}

class _TrialBalanceByCategoriesReportFilterBottomSheetWidgetState
    extends State<TrialBalanceByCategoriesReportFilterBottomSheetWidget> {
  String _reportName = 'AGL055';
  late String _exportType;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _exportType = widget.initialExportType;
  }

  void _submit() {
    Navigator.pop(
      context,
      TrialBalanceByCategoriesReportFilterSelection(
        reportName: _reportName,
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
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _reportName,
                    decoration: InputDecoration(
                      labelText: _isArabic
                          ? 'طريقة ترتيب ميزان المراجعة'
                          : 'Trial balance ordering',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'AGL055',
                        child: Text(
                          _isArabic
                              ? 'بدون ترتيب (AGL055)'
                              : 'No ordering (AGL055)',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'AGL055H',
                        child: Text(
                          _isArabic
                              ? 'ترتيب رقمي (AGL055H)'
                              : 'Numeric ordering (AGL055H)',
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _reportName = value);
                      }
                    },
                  ),
                  Gap(14.h),
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
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
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
    );
  }
}
