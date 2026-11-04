import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/category_light_model.dart';
import 'package:my_template/features/lookup/data/repository/lookup_repo.dart';

class MasterAccountsOrCentersReportFilterSelection {
  final int? fromCategoryNo;
  final int? toCategoryNo;
  final int masterReportType;
  final String reportName;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String exportType;

  const MasterAccountsOrCentersReportFilterSelection({
    required this.fromCategoryNo,
    required this.toCategoryNo,
    required this.masterReportType,
    required this.reportName,
    required this.fromDate,
    required this.toDate,
    required this.exportType,
  });
}

class MasterAccountsOrCentersReportFilterBottomSheetWidget
    extends StatefulWidget {
  final String title;
  final String initialExportType;
  final String summarizedReportName;
  final String detailedReportName;
  final bool isCentersReport;

  const MasterAccountsOrCentersReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
    this.summarizedReportName = 'AGL076',
    this.detailedReportName = 'AGL077A',
    this.isCentersReport = false,
  });

  static Future<MasterAccountsOrCentersReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
    String summarizedReportName = 'AGL076',
    String detailedReportName = 'AGL077A',
    bool isCentersReport = false,
  }) {
    return showModalBottomSheet<MasterAccountsOrCentersReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MasterAccountsOrCentersReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
        summarizedReportName: summarizedReportName,
        detailedReportName: detailedReportName,
        isCentersReport: isCentersReport,
      ),
    );
  }

  @override
  State<MasterAccountsOrCentersReportFilterBottomSheetWidget> createState() =>
      _MasterAccountsOrCentersReportFilterBottomSheetWidgetState();
}

class _MasterAccountsOrCentersReportFilterBottomSheetWidgetState
    extends State<MasterAccountsOrCentersReportFilterBottomSheetWidget> {
  CategoryLightModel? _fromCategory;
  CategoryLightModel? _toCategory;
  Future<Either<Failure, CategoryLightResponse>>? _categoriesFuture;
  DateTime? _fromDate;
  DateTime? _toDate;
  int _masterReportType = 1;
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categoriesFuture ??= widget.isCentersReport
        ? sl<LookupRepo>().getCenterCategories(
            languageCode: Localizations.localeOf(context).languageCode,
          )
        : sl<LookupRepo>().getAccountCategoriesLight(
            languageCode: Localizations.localeOf(context).languageCode,
          );
  }

  @override
  void initState() {
    super.initState();
    _exportType = widget.initialExportType;
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

  void _submit() {
    final fromCategory = _fromCategory?.categoryNo;
    final toCategory = _toCategory?.categoryNo;
    if (fromCategory != null &&
        toCategory != null &&
        fromCategory > toCategory) {
      _showValidation(
        _isArabic
            ? 'رقم الباب من يجب أن يسبق أو يساوي رقم الباب إلى'
            : 'From category must be less than or equal to To category',
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
      MasterAccountsOrCentersReportFilterSelection(
        fromCategoryNo: fromCategory,
        toCategoryNo: toCategory,
        masterReportType: _masterReportType,
        reportName: _masterReportType == 0
            ? widget.summarizedReportName
            : widget.detailedReportName,
        fromDate: _fromDate,
        toDate: _toDate,
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
                        widget.isCentersReport
                            ? (_isArabic
                                  ? 'نطاق أبواب المراكز'
                                  : 'Center category range')
                            : (_isArabic
                                  ? 'نطاق أبواب الحسابات'
                                  : 'Account category range'),
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
                            child: _categoryDropdown(
                              _isArabic ? 'من رقم الباب' : 'From category',
                              _fromCategory,
                              (category) =>
                                  setState(() => _fromCategory = category),
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: _categoryDropdown(
                              _isArabic ? 'إلى رقم الباب' : 'To category',
                              _toCategory,
                              (category) =>
                                  setState(() => _toCategory = category),
                            ),
                          ),
                        ],
                      ),
                      Gap(14.h),
                      DropdownButtonFormField<int>(
                        initialValue: _masterReportType,
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'نوع التقرير' : 'Report type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 0,
                            child: Text(_isArabic ? 'إجمالي' : 'Summarized'),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text(_isArabic ? 'تفصيلي' : 'Detailed'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _masterReportType = value);
                          }
                        },
                      ),
                      Gap(14.h),
                      Text(
                        _isArabic ? 'فترة التقرير' : 'Report period',
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

  Widget _categoryDropdown(
    String label,
    CategoryLightModel? selected,
    ValueChanged<CategoryLightModel?> onChanged,
  ) {
    return FutureBuilder<Either<Failure, CategoryLightResponse>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        var categories = <CategoryLightModel>[];
        String? errorMessage;
        if (snapshot.hasError) {
          errorMessage = snapshot.error.toString();
        } else if (snapshot.hasData) {
          snapshot.data!.fold(
            (failure) => errorMessage = failure.errMessage,
            (response) => categories = response.categories,
          );
        } else if (!isLoading) {
          errorMessage = _isArabic
              ? 'تعذر تحميل الأبواب'
              : 'Unable to load categories';
        }

        final hasSelected = categories.any(
          (category) => category.categoryNo == selected?.categoryNo,
        );
        return DropdownButtonFormField<int>(
          initialValue: hasSelected ? selected!.categoryNo : null,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: AppColor.textFormFillColor(context),
            suffixIcon: isLoading
                ? Padding(
                    padding: EdgeInsets.all(14.r),
                    child: SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: CircularProgressIndicator(strokeWidth: 2.r),
                    ),
                  )
                : null,
            errorText: errorMessage,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          items: categories
              .map(
                (category) => DropdownMenuItem(
                  value: category.categoryNo,
                  child: Text(
                    '${category.categoryName} (${category.categoryNo})',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: isLoading || errorMessage != null || categories.isEmpty
              ? null
              : (value) => onChanged(
                  value == null
                      ? null
                      : categories.firstWhere(
                          (category) => category.categoryNo == value,
                        ),
                ),
        );
      },
    );
  }

  Widget _dateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColor.oceanBlue,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
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
                      : MaterialLocalizations.of(
                          context,
                        ).formatMediumDate(date),
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
}
