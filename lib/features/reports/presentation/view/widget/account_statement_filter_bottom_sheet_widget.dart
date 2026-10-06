import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';

class AccountStatementFilterSelection {
  final int? subVoucherAccountNo;
  final DateTime? subVoucherOraDate;

  const AccountStatementFilterSelection({
    this.subVoucherAccountNo,
    this.subVoucherOraDate,
  });
}

class AccountStatementFilterBottomSheetWidget extends StatefulWidget {
  final String title;

  const AccountStatementFilterBottomSheetWidget({
    super.key,
    required this.title,
  });

  static Future<AccountStatementFilterSelection?> show(
    BuildContext context, {
    required String title,
  }) {
    return showModalBottomSheet<AccountStatementFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AccountStatementFilterBottomSheetWidget(
        title: title,
      ),
    );
  }

  @override
  State<AccountStatementFilterBottomSheetWidget> createState() =>
      _AccountStatementFilterBottomSheetWidgetState();
}

class _AccountStatementFilterBottomSheetWidgetState
    extends State<AccountStatementFilterBottomSheetWidget> {
  DateTime? _selectedDate;
  ChartOfAccountLightModel? _selectedAccount;

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected == null || !mounted) return;

    setState(() {
      _selectedDate = DateUtils.dateOnly(selected);
    });
  }

  String _formatDate(DateTime date) {
    return MaterialLocalizations.of(context).formatMediumDate(date);
  }

  void _submit() {
    Navigator.pop(
      context,
      AccountStatementFilterSelection(
        subVoucherAccountNo: _selectedAccount?.accountNo,
        subVoucherOraDate: _selectedDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.oceanBlue;

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
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
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
                        Icons.receipt_long_rounded,
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
                          Text(
                            'Report/AccountStatementReport (AGL079)',
                            style: TextStyle(
                              color: foreground.withValues(alpha: 0.45),
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
                // ── Account Selector ──
                ChartOfAccountDropdown(
                  title: context.locale.languageCode == 'ar'
                      ? 'الحساب (اختياري)'
                      : 'Account (Optional)',
                  hintText: context.locale.languageCode == 'ar'
                      ? 'اختر الحساب لكشف الحساب...'
                      : 'Select account for statement...',
                  initialValue: _selectedAccount,
                  onSelected: (account) {
                    setState(() => _selectedAccount = account);
                  },
                ),
                Gap(16.h),
                // ── Date Selector ──
                Text(
                  context.locale.languageCode == 'ar'
                      ? 'تاريخ السند (اختياري)'
                      : 'Voucher Date (Optional)',
                  style: TextStyle(
                    color: foreground.withValues(alpha: 0.7),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(6.h),
                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.textFormFillColor(context),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: _selectedDate != null
                            ? accent.withValues(alpha: 0.5)
                            : foreground.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 18.sp,
                          color: _selectedDate != null
                              ? accent
                              : foreground.withValues(alpha: 0.5),
                        ),
                        Gap(10.w),
                        Expanded(
                          child: Text(
                            _selectedDate != null
                                ? _formatDate(_selectedDate!)
                                : (context.locale.languageCode == 'ar'
                                    ? 'كل التواريخ (اختياري)'
                                    : 'All Dates (Optional)'),
                            style: _selectedDate != null
                                ? AppTextStyle.textFormStyle(context).copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  )
                                : AppTextStyle.hintStyle(context).copyWith(
                                    fontSize: 13.sp,
                                  ),
                          ),
                        ),
                        if (_selectedDate != null)
                          InkWell(
                            onTap: () => setState(() => _selectedDate = null),
                            borderRadius: BorderRadius.circular(12.r),
                            child: Padding(
                              padding: EdgeInsets.all(4.r),
                              child: Icon(
                                Icons.close_rounded,
                                size: 16.sp,
                                color: foreground.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Gap(26.h),
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
}
