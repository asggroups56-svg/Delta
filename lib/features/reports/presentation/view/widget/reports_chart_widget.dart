import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class ReportsChartWidget extends StatefulWidget {
  const ReportsChartWidget({super.key});

  @override
  State<ReportsChartWidget> createState() => _ReportsChartWidgetState();
}

class _ReportsChartWidgetState extends State<ReportsChartWidget> {
  int _selectedMonthIndex = 5; // Default selected to current month (Jun)

  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
  final List<double> _revenues = [120, 145, 130, 180, 165, 215]; // in k SAR
  final List<double> _expenses = [80, 95, 88, 110, 105, 125];

  @override
  Widget build(BuildContext context) {
    final maxVal = 250.0;

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColor.darkCardBackground,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColor.whiteColor(context).withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Legends
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocaleKey.revenueExpensesTrend.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColor.whiteColor(context),
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(3.h),
                    Text(
                      'SAR (${_revenues[_selectedMonthIndex].toInt()}K Rev / ${_expenses[_selectedMonthIndex].toInt()}K Exp)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        color: AppColor.mintTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegendDot(
                    color: AppColor.royalIndigo,
                    label: AppLocaleKey.revenueLegend.tr(),
                  ),
                  Gap(8.w),
                  _buildLegendDot(
                    color: AppColor.roseDanger,
                    label: AppLocaleKey.expensesLegend.tr(),
                  ),
                ],
              ),
            ],
          ),
          Gap(24.h),

          // Chart Bars & Tooltip
          SizedBox(
            height: 160.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_months.length, (index) {
                final isSelected = _selectedMonthIndex == index;
                final revHeight = (_revenues[index] / maxVal) * 120.h;
                final expHeight = (_expenses[index] / maxVal) * 120.h;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMonthIndex = index;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Active Tooltip Bubble
                      if (isSelected)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          margin: EdgeInsets.only(bottom: 4.h),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4F46E5),
                                Color(0xFF06B6D4),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.royalIndigo
                                    .withValues(alpha: 0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Text(
                            '${_revenues[index].toInt()}k',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      else
                        SizedBox(height: 17.h),

                      // Multi-Bar Pair
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Revenue Bar
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 12.w,
                            height: revHeight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isSelected
                                    ? [AppColor.royalIndigo, AppColor.electricCyan]
                                    : [
                                        AppColor.royalIndigo
                                            .withValues(alpha: 0.4),
                                        AppColor.electricCyan
                                            .withValues(alpha: 0.4)
                                      ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(6.r),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColor.royalIndigo
                                            .withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                          Gap(4.w),
                          // Expense Bar
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 12.w,
                            height: expHeight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isSelected
                                    ? [
                                        AppColor.roseDanger,
                                        const Color(0xFFFB7185),
                                      ]
                                    : [
                                        AppColor.roseDanger
                                            .withValues(alpha: 0.4),
                                        const Color(0xFFFB7185)
                                            .withValues(alpha: 0.4)
                                      ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ],
                      ),
                      Gap(8.h),
                      Text(
                        _months[index],
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? AppColor.whiteColor(context)
                              : AppColor.whiteColor(context)
                                  .withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        Gap(4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColor.whiteColor(context).withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
