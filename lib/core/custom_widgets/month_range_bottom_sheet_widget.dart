import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

@immutable
class MonthRangeSelection {
  final int? fromMonth;
  final int? toMonth;

  const MonthRangeSelection({
    this.fromMonth,
    this.toMonth,
  });
}

class MonthRangeBottomSheetWidget extends StatefulWidget {
  final String title;
  final String? confirmLabel;

  const MonthRangeBottomSheetWidget({
    super.key,
    required this.title,
    this.confirmLabel,
  });

  static Future<MonthRangeSelection?> show(
    BuildContext context, {
    required String title,
    String? confirmLabel,
  }) {
    return showModalBottomSheet<MonthRangeSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MonthRangeBottomSheetWidget(
        title: title,
        confirmLabel: confirmLabel,
      ),
    );
  }

  @override
  State<MonthRangeBottomSheetWidget> createState() =>
      _MonthRangeBottomSheetWidgetState();
}

class _MonthRangeBottomSheetWidgetState
    extends State<MonthRangeBottomSheetWidget> {
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

  int? _fromMonth;
  int? _toMonth;
  bool _selectingFromMonth = true;
  String? _validationMessage;

  int? get _activeMonth => _selectingFromMonth ? _fromMonth : _toMonth;

  String _monthName(int? month) {
    if (month == null) return AppLocaleKey.allMonths.tr();
    return _months[month - 1].tr();
  }

  void _selectMonth(int month) {
    setState(() {
      if (_selectingFromMonth) {
        _fromMonth = month;
        _selectingFromMonth = false;
      } else {
        _toMonth = month;
      }
      _validationMessage = null;
    });
  }

  void _selectAllMonths() {
    setState(() {
      _fromMonth = null;
      _toMonth = null;
      _validationMessage = null;
    });
  }

  void _submit() {
    if ((_fromMonth == null) != (_toMonth == null)) {
      setState(() {
        _validationMessage = AppLocaleKey.chooseBothMonths.tr();
      });
      return;
    }

    if (_fromMonth != null && _fromMonth! > _toMonth!) {
      setState(() {
        _validationMessage = AppLocaleKey.invalidMonthRange.tr();
      });
      return;
    }

    Navigator.pop(
      context,
      MonthRangeSelection(fromMonth: _fromMonth, toMonth: _toMonth),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.emeraldTeal;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.82,
        ),
        decoration: BoxDecoration(
          color: AppColor.cardColor(context),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: Border.all(
            color: foreground.withValues(alpha: 0.08),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 18.h),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: foreground,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(4.h),
                        Text(
                          AppLocaleKey.chooseBothMonths.tr(),
                          style: TextStyle(
                            color: foreground.withValues(alpha: 0.58),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
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
              Gap(20.h),
              Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  color: foreground.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _RangeSideButton(
                        label: AppLocaleKey.fromMonth.tr(),
                        month: _monthName(_fromMonth),
                        selected: _selectingFromMonth,
                        onTap: () => setState(() {
                          _selectingFromMonth = true;
                          _validationMessage = null;
                        }),
                      ),
                    ),
                    Gap(6.w),
                    Expanded(
                      child: _RangeSideButton(
                        label: AppLocaleKey.toMonth.tr(),
                        month: _monthName(_toMonth),
                        selected: !_selectingFromMonth,
                        onTap: () => setState(() {
                          _selectingFromMonth = false;
                          _validationMessage = null;
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(18.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectingFromMonth
                          ? AppLocaleKey.fromMonth.tr()
                          : AppLocaleKey.toMonth.tr(),
                      style: TextStyle(
                        color: foreground,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _selectAllMonths,
                    icon: Icon(Icons.clear_all_rounded, size: 17.r),
                    label: Text(AppLocaleKey.allMonths.tr()),
                    style: TextButton.styleFrom(
                      foregroundColor: foreground.withValues(alpha: 0.65),
                      textStyle: TextStyle(fontSize: 11.sp),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
              Gap(8.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _months.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 9.h,
                  crossAxisSpacing: 9.w,
                  childAspectRatio: 2.15,
                ),
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final isSelected = _activeMonth == month;
                  return Material(
                    color: isSelected
                        ? accent.withValues(alpha: 0.18)
                        : foreground.withValues(alpha: 0.045),
                    borderRadius: BorderRadius.circular(12.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () => _selectMonth(month),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isSelected
                                ? accent.withValues(alpha: 0.75)
                                : foreground.withValues(alpha: 0.07),
                          ),
                        ),
                        child: Text(
                          _months[index].tr(),
                          style: TextStyle(
                            color: isSelected
                                ? accent
                                : foreground.withValues(alpha: 0.86),
                            fontSize: 11.sp,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _RangeSideButton extends StatelessWidget {
  final String label;
  final String month;
  final bool selected;
  final VoidCallback onTap;

  const _RangeSideButton({
    required this.label,
    required this.month,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.emeraldTeal;

    return Material(
      color: selected ? accent.withValues(alpha: 0.14) : Colors.transparent,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected
                  ? accent.withValues(alpha: 0.55)
                  : Colors.transparent,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: foreground.withValues(alpha: 0.6),
                  fontSize: 10.sp,
                ),
              ),
              Gap(4.h),
              Text(
                month,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? accent : foreground,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
