import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/lookup/data/models/customer_datum_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/customer_datum_dropdown.dart';

class PartyVatReportFilterSelection {
  final double? fromCustomerNo;
  final double? toCustomerNo;
  final DateTime? fromTransDate;
  final DateTime? toTransDate;

  const PartyVatReportFilterSelection({
    this.fromCustomerNo,
    this.toCustomerNo,
    this.fromTransDate,
    this.toTransDate,
  });
}

class PartyVatReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String reportCode;
  final CustomerDatumType type;

  const PartyVatReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    required this.reportCode,
    required this.type,
  });

  static Future<PartyVatReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    required String reportCode,
    required CustomerDatumType type,
  }) {
    return showModalBottomSheet<PartyVatReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PartyVatReportFilterBottomSheetWidget(
        title: title,
        reportCode: reportCode,
        type: type,
      ),
    );
  }

  @override
  State<PartyVatReportFilterBottomSheetWidget> createState() =>
      _PartyVatReportFilterBottomSheetWidgetState();
}

class _PartyVatReportFilterBottomSheetWidgetState
    extends State<PartyVatReportFilterBottomSheetWidget> {
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _includeDates = false;
  CustomerDatumLightModel? _fromParty;
  CustomerDatumLightModel? _toParty;
  String? _validationMessage;

  Future<void> _selectDate({required bool isFromDate}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: (isFromDate ? _fromDate : _toDate) ?? DateTime.now(),
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
      PartyVatReportFilterSelection(
        fromCustomerNo: _fromParty?.customerNo.toDouble(),
        toCustomerNo: _toParty?.customerNo.toDouble(),
        fromTransDate: _includeDates ? _fromDate : null,
        toTransDate: _includeDates ? _toDate : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = widget.type == CustomerDatumType.customer
        ? AppColor.primaryColor(context)
        : AppColor.oceanBlue;
    final isCustomer = widget.type == CustomerDatumType.customer;

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
                        isCustomer
                            ? Icons.point_of_sale_rounded
                            : Icons.shopping_bag_rounded,
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
                            widget.reportCode,
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
                Gap(16.h),
                // ── Date Range Toggle Switch ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.locale.languageCode == 'ar'
                          ? 'تحديد فترة التاريخ'
                          : 'Filter by Date Range',
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
                              hint: context.locale.languageCode == 'ar'
                                  ? 'من تاريخ'
                                  : 'From date',
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
                              hint: context.locale.languageCode == 'ar'
                                  ? 'إلى تاريخ'
                                  : 'To date',
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
                // ── Party Range Section ──
                CustomerDatumDropdown(
                  type: widget.type,
                  title: isCustomer
                      ? (context.locale.languageCode == 'ar'
                          ? 'من عميل (اختياري)'
                          : 'From Customer (Optional)')
                      : (context.locale.languageCode == 'ar'
                          ? 'من مورد (اختياري)'
                          : 'From Supplier (Optional)'),
                  hintText: isCustomer
                      ? (context.locale.languageCode == 'ar'
                          ? 'اختر عميل البداية...'
                          : 'Select starting customer...')
                      : (context.locale.languageCode == 'ar'
                          ? 'اختر مورد البداية...'
                          : 'Select starting supplier...'),
                  initialValue: _fromParty,
                  onSelected: (party) {
                    setState(() => _fromParty = party);
                  },
                ),
                Gap(12.h),
                CustomerDatumDropdown(
                  type: widget.type,
                  title: isCustomer
                      ? (context.locale.languageCode == 'ar'
                          ? 'إلى عميل (اختياري)'
                          : 'To Customer (Optional)')
                      : (context.locale.languageCode == 'ar'
                          ? 'إلى مورد (اختياري)'
                          : 'To Supplier (Optional)'),
                  hintText: isCustomer
                      ? (context.locale.languageCode == 'ar'
                          ? 'اختر عميل النهاية...'
                          : 'Select ending customer...')
                      : (context.locale.languageCode == 'ar'
                          ? 'اختر مورد النهاية...'
                          : 'Select ending supplier...'),
                  initialValue: _toParty,
                  onSelected: (party) {
                    setState(() => _toParty = party);
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

  Widget _buildDateTile({
    required DateTime? date,
    required String hint,
    required VoidCallback onTap,
    required VoidCallback onClear,
    required Color foreground,
    required Color accent,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColor.textFormFillColor(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: date != null
                ? accent.withValues(alpha: 0.5)
                : foreground.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16.sp,
              color: date != null ? accent : foreground.withValues(alpha: 0.5),
            ),
            Gap(8.w),
            Expanded(
              child: Text(
                date != null ? _formatDate(date) : hint,
                style: date != null
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
            if (date != null)
              InkWell(
                onTap: onClear,
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.all(2.r),
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
    );
  }
}
