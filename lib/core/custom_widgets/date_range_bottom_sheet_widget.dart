import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class DateRangeSelection {
  final DateTime? fromDate;
  final DateTime? toDate;

  const DateRangeSelection({this.fromDate, this.toDate});
}

class DateRangeBottomSheetWidget extends StatefulWidget {
  final String title;
  final String? confirmLabel;
  final bool allowAllDates;

  const DateRangeBottomSheetWidget({
    super.key,
    required this.title,
    this.confirmLabel,
    this.allowAllDates = false,
  });

  static Future<DateRangeSelection?> show(
    BuildContext context, {
    required String title,
    String? confirmLabel,
    bool allowAllDates = false,
  }) {
    return showModalBottomSheet<DateRangeSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DateRangeBottomSheetWidget(
        title: title,
        confirmLabel: confirmLabel,
        allowAllDates: allowAllDates,
      ),
    );
  }

  @override
  State<DateRangeBottomSheetWidget> createState() =>
      _DateRangeBottomSheetWidgetState();
}

class _DateRangeBottomSheetWidgetState
    extends State<DateRangeBottomSheetWidget> {
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _includeDates = false;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate({required bool isFromDate}) async {
    final initial = (isFromDate ? _fromDate : _toDate) ?? DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: initial,
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

  String _formatDate(DateTime date) {
    return MaterialLocalizations.of(context).formatMediumDate(date);
  }

  void _submit() {
    if (_includeDates &&
        _fromDate != null &&
        _toDate != null &&
        _fromDate!.isAfter(_toDate!)) {
      setState(() {
        _validationMessage = AppLocaleKey.invalidDateRange.tr();
      });
      return;
    }

    Navigator.pop(
      context,
      DateRangeSelection(
        fromDate: _includeDates ? _fromDate : null,
        toDate: _includeDates ? _toDate : null,
      ),
    );
  }

  void _submitAllDates() {
    Navigator.pop(context, const DateRangeSelection());
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.emeraldTeal;
    final isAr = context.locale.languageCode == 'ar';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border.all(color: foreground.withValues(alpha: 0.08)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: foreground.withValues(alpha: 0.24),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              Gap(20.h),
              Row(
                children: [
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      Icons.date_range_rounded,
                      color: accent,
                      size: 23.r,
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: AppLocaleKey.cancelAction.tr(),
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: foreground.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              // ── Date Range Toggle Switch ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'تحديد فترة التاريخ' : 'Filter by Date Range',
                    style: TextStyle(
                      color: foreground,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Switch.adaptive(
                    value: _includeDates,
                    activeThumbColor: accent,
                    onChanged: (val) => setState(() => _includeDates = val),
                  ),
                ],
              ),
              if (_includeDates) ...[
                Gap(12.h),
                Text(
                  AppLocaleKey.fromDate.tr(),
                  style: TextStyle(
                    color: foreground.withValues(alpha: 0.65),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(8.h),
                _DateSelectionTile(
                  date: _fromDate != null ? _formatDate(_fromDate!) : null,
                  hint: isAr ? 'من تاريخ' : 'From date',
                  onTap: () => _selectDate(isFromDate: true),
                  onClear: () => setState(() => _fromDate = null),
                ),
                Gap(16.h),
                Text(
                  AppLocaleKey.toDate.tr(),
                  style: TextStyle(
                    color: foreground.withValues(alpha: 0.65),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(8.h),
                _DateSelectionTile(
                  date: _toDate != null ? _formatDate(_toDate!) : null,
                  hint: isAr ? 'إلى تاريخ' : 'To date',
                  onTap: () => _selectDate(isFromDate: false),
                  onClear: () => setState(() => _toDate = null),
                ),
              ],
              if (_validationMessage != null) ...[
                Gap(12.h),
                Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Colors.redAccent,
                      size: 17.r,
                    ),
                    Gap(6.w),
                    Expanded(
                      child: Text(
                        _validationMessage!,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              Gap(20.h),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  label: Text(
                    widget.confirmLabel ?? AppLocaleKey.exportPdf.tr(),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    textStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (widget.allowAllDates) ...[
                Gap(8.h),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _submitAllDates,
                    child: Text(AppLocaleKey.allDates.tr()),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DateSelectionTile extends StatelessWidget {
  final String? date;
  final String hint;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _DateSelectionTile({
    required this.date,
    required this.hint,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final hasValue = date != null && date!.isNotEmpty;

    return Material(
      color: foreground.withValues(alpha: 0.045),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: hasValue
                  ? AppColor.emeraldTeal.withValues(alpha: 0.4)
                  : foreground.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: hasValue
                    ? AppColor.emeraldTeal
                    : foreground.withValues(alpha: 0.5),
                size: 20.r,
              ),
              Gap(10.w),
              Expanded(
                child: Text(
                  hasValue ? date! : hint,
                  style: hasValue
                      ? TextStyle(
                          color: foreground,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        )
                      : TextStyle(
                          color: foreground.withValues(alpha: 0.45),
                          fontSize: 13.sp,
                        ),
                ),
              ),
              if (hasValue)
                InkWell(
                  onTap: onClear,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.all(2.r),
                    child: Icon(
                      Icons.close_rounded,
                      color: foreground.withValues(alpha: 0.5),
                      size: 17.r,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.edit_calendar_rounded,
                  color: foreground.withValues(alpha: 0.55),
                  size: 18.r,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
