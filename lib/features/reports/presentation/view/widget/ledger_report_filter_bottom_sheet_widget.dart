import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';

class LedgerReportFilterSelection {
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? fromAccountNo;
  final int? toAccountNo;

  const LedgerReportFilterSelection({
    this.fromDate,
    this.toDate,
    this.fromAccountNo,
    this.toAccountNo,
  });
}

class LedgerReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;

  const LedgerReportFilterBottomSheetWidget({
    super.key,
    required this.title,
  });

  static Future<LedgerReportFilterSelection?> show(
    BuildContext context, {
    required String title,
  }) {
    return showModalBottomSheet<LedgerReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LedgerReportFilterBottomSheetWidget(
        title: title,
      ),
    );
  }

  @override
  State<LedgerReportFilterBottomSheetWidget> createState() =>
      _LedgerReportFilterBottomSheetWidgetState();
}

class _LedgerReportFilterBottomSheetWidgetState
    extends State<LedgerReportFilterBottomSheetWidget> {
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _includeDates = false;
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
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
      LedgerReportFilterSelection(
        fromDate: _includeDates ? _fromDate : null,
        toDate: _includeDates ? _toDate : null,
        fromAccountNo: _fromAccount?.accountNo,
        toAccountNo: _toAccount?.accountNo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.primaryColor(context);
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
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
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
                Gap(16.h),
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
                        Icons.menu_book_rounded,
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
                      style: AppTextStyle.formTitleStyle(context).copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
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
                  Gap(8.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocaleKey.fromDate.tr(),
                              style: TextStyle(
                                color: foreground.withValues(alpha: 0.65),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Gap(6.h),
                            _buildDateTile(
                              date: _fromDate,
                              hint: isAr ? 'من تاريخ' : 'From date',
                              onTap: () => _selectDate(isFromDate: true),
                              onClear: () => setState(() => _fromDate = null),
                              foreground: foreground,
                              accent: accent,
                            ),
                          ],
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocaleKey.toDate.tr(),
                              style: TextStyle(
                                color: foreground.withValues(alpha: 0.65),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Gap(6.h),
                            _buildDateTile(
                              date: _toDate,
                              hint: isAr ? 'إلى تاريخ' : 'To date',
                              onTap: () => _selectDate(isFromDate: false),
                              onClear: () => setState(() => _toDate = null),
                              foreground: foreground,
                              accent: accent,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                Gap(16.h),
                // ── Account Range Section ──
                ChartOfAccountDropdown(
                  title: context.locale.languageCode == 'ar'
                      ? 'من حساب (اختياري)'
                      : 'From Account (Optional)',
                  hintText: context.locale.languageCode == 'ar'
                      ? 'اختر حساب البداية...'
                      : 'Select from account...',
                  initialValue: _fromAccount,
                  onSelected: (account) {
                    setState(() => _fromAccount = account);
                  },
                ),
                Gap(12.h),
                ChartOfAccountDropdown(
                  title: context.locale.languageCode == 'ar'
                      ? 'إلى حساب (اختياري)'
                      : 'To Account (Optional)',
                  hintText: context.locale.languageCode == 'ar'
                      ? 'اختر حساب النهاية...'
                      : 'Select to account...',
                  initialValue: _toAccount,
                  onSelected: (account) {
                    setState(() => _toAccount = account);
                  },
                ),
                if (_validationMessage != null) ...[
                  Gap(12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: AppColor.roseDanger,
                        size: 16.sp,
                      ),
                      Gap(6.w),
                      Expanded(
                        child: Text(
                          _validationMessage!,
                          style: TextStyle(
                            color: AppColor.roseDanger,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                Gap(24.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocaleKey.exportPdf.tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTile({
    required DateTime? date,
    required String hint,
    required VoidCallback onTap,
    required VoidCallback onClear,
    required Color foreground,
    required Color accent,
  }) {
    final hasValue = date != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: AppColor.textFormFillColor(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: hasValue
                ? accent.withValues(alpha: 0.5)
                : foreground.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16.sp,
              color: hasValue ? accent : foreground.withValues(alpha: 0.5),
            ),
            Gap(8.w),
            Expanded(
              child: Text(
                hasValue ? _formatDate(date) : hint,
                style: hasValue
                    ? AppTextStyle.textFormStyle(context).copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      )
                    : AppTextStyle.hintStyle(context).copyWith(
                        fontSize: 13.sp,
                      ),
                overflow: TextOverflow.ellipsis,
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
                    size: 15.sp,
                    color: foreground.withValues(alpha: 0.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
