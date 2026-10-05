import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'cash_flow_overview_card_widget.dart';
import 'net_sales_annual_card_widget.dart';

class AnnualFinancialOverviewWidget extends StatefulWidget {
  const AnnualFinancialOverviewWidget({super.key});

  @override
  State<AnnualFinancialOverviewWidget> createState() =>
      _AnnualFinancialOverviewWidgetState();
}

class _AnnualFinancialOverviewWidgetState
    extends State<AnnualFinancialOverviewWidget> {
  String _selectedPeriod = 'current_year';

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final titleColor = AppColor.titleFormFiledColor(context);
    final subtitleColor = AppColor.darkTextColor(context);
    final cardColor = AppColor.cardColor(context);
    final borderColor = AppColor.borderColor(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header Row ───────────────────────────────────────────────
        FadeInDown(
          duration: const Duration(milliseconds: 350),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Subtitle Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Eyebrow Tag
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor(context),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Gap(5.w),
                        Text(
                          isArabic ? 'ملخص الأداء' : 'Performance Summary',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColor.primaryColor(context),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    Gap(4.h),
                    Text(
                      isArabic
                          ? 'نظرة مالية على مدار العام'
                          : 'Annual Financial Overview',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w900,
                        color: titleColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Gap(3.h),
                    Text(
                      isArabic
                          ? 'مقارنة شهرية مختصرة تساعدك على متابعة التدفقات والمبيعات بسهولة.'
                          : 'A concise monthly comparison to easily monitor sales & cash flows.',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: subtitleColor,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              Gap(8.w),

              // Filter Dropdown / Pill Button
              PopupMenuButton<String>(
                initialValue: _selectedPeriod,
                onSelected: (val) {
                  setState(() {
                    _selectedPeriod = val;
                  });
                },
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  side: BorderSide(color: borderColor),
                ),
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'current_year',
                    child: Text(
                      isArabic ? 'السنة الحالية (2026)' : 'Current Year (2026)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: titleColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'prev_year',
                    child: Text(
                      isArabic
                          ? 'السنة السابقة (2025)'
                          : 'Previous Year (2025)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: subtitleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: borderColor, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.16 : 0.03,
                        ),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 14,
                        color: AppColor.primaryColor(context),
                      ),
                      Gap(5.w),
                      Text(
                        _selectedPeriod == 'current_year'
                            ? (isArabic ? 'السنة الحالية' : 'Current Year')
                            : (isArabic ? 'السنة السابقة' : 'Prev Year'),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: titleColor,
                        ),
                      ),
                      Gap(3.w),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: subtitleColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Gap(16.h),

        // ── Card 1: Net Sales Card ───────────────────────────────────────────
        const NetSalesAnnualCardWidget(),

        Gap(16.h),

        // ── Card 2: Cash Flow (Revenues & Expenses) Card ─────────────────────
        const CashFlowOverviewCardWidget(),
      ],
    );
  }
}
