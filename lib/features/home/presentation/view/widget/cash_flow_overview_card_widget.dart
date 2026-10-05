import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/features/home/data/models/income_and_expenses_chart_model.dart';
import 'package:my_template/features/home/data/repository/home_repo.dart';

class CashFlowOverviewCardWidget extends StatefulWidget {
  const CashFlowOverviewCardWidget({super.key});

  @override
  State<CashFlowOverviewCardWidget> createState() =>
      _CashFlowOverviewCardWidgetState();
}

class _CashFlowOverviewCardWidgetState
    extends State<CashFlowOverviewCardWidget> {
  static const List<String> _monthsAr = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  static const List<String> _monthsEn = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  int? _selectedMonthIndex = DateTime.now().month - 1;
  List<MonthlyIncomeAndExpenses>? _monthlyFlow;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    if (_isLoading) {
      _hasError = false;
    } else {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }
    try {
      final response = await sl<HomeRepo>().getIncomeAndExpensesChart();
      if (!mounted) return;
      final latestActiveMonth = response.months.lastIndexWhere(
        (month) => month.income > 0 || month.expenses > 0,
      );
      setState(() {
        _monthlyFlow = response.months;
        _selectedMonthIndex = latestActiveMonth >= 0
            ? latestActiveMonth
            : DateTime.now().month - 1;
        _isLoading = false;
      });
    } on DioException {
      _showLoadError();
    } on FormatException {
      _showLoadError();
    }
  }

  void _showLoadError() {
    if (!mounted) return;
    setState(() {
      _hasError = true;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = AppColor.cardColor(context);
    final titleColor = AppColor.titleFormFiledColor(context);
    final mutedColor = AppColor.darkTextColor(context);
    final borderColor = AppColor.borderColor(context);
    final softSurfaceColor = isDark
        ? const Color(0xFF263449)
        : const Color(0xFFF8FAFC);
    final gridColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFF1F5F9);
    final selectedSurfaceColor = isDark
        ? const Color(0xFF172554)
        : const Color(0xFFEFF6FF);
    final selectedTextColor = isDark
        ? const Color(0xFFBFDBFE)
        : const Color(0xFF1E40AF);
    final locale = isArabic ? 'ar' : 'en';
    final numberFormat = NumberFormat('#,##0.##', locale);
    final monthlyFlow = _monthlyFlow ?? const <MonthlyIncomeAndExpenses>[];
    final totalIncome = monthlyFlow.fold<double>(
      0,
      (total, month) => total + month.income,
    );
    final totalExpenses = monthlyFlow.fold<double>(
      0,
      (total, month) => total + month.expenses,
    );
    final netFlow = totalIncome - totalExpenses;
    final chartMaxValue = monthlyFlow.fold<double>(
      0,
      (maximum, month) => maximum > month.income && maximum > month.expenses
          ? maximum
          : (month.income > month.expenses ? month.income : month.expenses),
    );
    final chartScale = chartMaxValue == 0 ? 1.0 : chartMaxValue;
    final selectedMonth = _selectedMonthIndex == null || monthlyFlow.isEmpty
        ? null
        : monthlyFlow[_selectedMonthIndex!];

    return FadeInUp(
      duration: const Duration(milliseconds: 450),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04),
              blurRadius: 18.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              SizedBox(
                height: 250.h,
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (_hasError)
              SizedBox(
                height: 250.h,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isArabic
                            ? 'تعذر تحميل بيانات الإيرادات والمصروفات'
                            : 'Could not load income and expenses',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13.sp, color: mutedColor),
                      ),
                      Gap(8.h),
                      TextButton.icon(
                        onPressed: _loadChartData,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              // ── Top Header Row ───────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'التدفقات النقدية' : 'Cash Flow',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF059669),
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        isArabic
                            ? 'الإيرادات والمصروفات'
                            : 'Revenues & Expenses',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: titleColor,
                        ),
                      ),
                    ],
                  ),
                  // Scales / Balance Icon Container
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xFFA7F3D0),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.balance_rounded,
                      color: Color(0xFF059669),
                      size: 20,
                    ),
                  ),
                ],
              ),

              Gap(12.h),

              // ── Legend Row ───────────────────────────────────────────────────
              Row(
                children: [
                  _buildLegendItem(
                    context,
                    color: const Color(0xFF2563EB), // Blue for Revenues
                    label: isArabic ? 'الإيرادات' : 'Revenues',
                  ),
                  Gap(16.w),
                  _buildLegendItem(
                    context,
                    color: const Color(0xFFEF4444), // Crimson/Red for Expenses
                    label: isArabic ? 'المصروفات' : 'Expenses',
                  ),
                ],
              ),

              Gap(14.h),

              // ── 3 Summary KPI Boxes ──────────────────────────────────────────
              Row(
                children: [
                  // 1. Total Revenues
                  Expanded(
                    child: _buildSummaryBox(
                      context,
                      label: isArabic ? 'إجمالي الإيرادات' : 'Total Revenues',
                      value:
                          '${numberFormat.format(totalIncome)} ${isArabic ? 'ر.س' : 'SAR'}',
                      valueColor: titleColor,
                      bgColor: softSurfaceColor,
                      borderColor: borderColor,
                      accentColor: const Color(0xFF2563EB),
                    ),
                  ),
                  Gap(8.w),
                  // 2. Total Expenses
                  Expanded(
                    child: _buildSummaryBox(
                      context,
                      label: isArabic ? 'إجمالي المصروفات' : 'Total Expenses',
                      value:
                          '${numberFormat.format(totalExpenses)} ${isArabic ? 'ر.س' : 'SAR'}',
                      valueColor: titleColor,
                      bgColor: softSurfaceColor,
                      borderColor: borderColor,
                      accentColor: const Color(0xFFEF4444),
                    ),
                  ),
                  Gap(8.w),
                  // 3. Net Cash Flow
                  Expanded(
                    child: _buildSummaryBox(
                      context,
                      label: isArabic ? 'صافي التدفق' : 'Net Flow',
                      value:
                          '${netFlow < 0 ? '-' : ''}${numberFormat.format(netFlow.abs())} ${isArabic ? 'ر.س' : 'SAR'}',
                      valueColor: netFlow < 0
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF059669),
                      bgColor: netFlow < 0
                          ? (isDark
                                ? const Color(0xFF3B1D2A)
                                : const Color(0xFFFEF2F2))
                          : (isDark
                                ? const Color(0xFF12352D)
                                : const Color(0xFFECFDF5)),
                      borderColor: netFlow < 0
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF059669),
                      accentColor: netFlow < 0
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF059669),
                    ),
                  ),
                ],
              ),

              Gap(14.h),

              // ── Interactive Selected Month Info Tooltip ──────────────────────
              if (selectedMonth != null)
                Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: selectedSurfaceColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1E40AF)
                          : const Color(0xFFBFDBFE),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isArabic
                            ? '${_monthsAr[selectedMonth.monthNumber - 1]}:'
                            : '${_monthsEn[selectedMonth.monthNumber - 1]}:',
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w700,
                          color: selectedTextColor,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${isArabic ? 'إيرادات' : 'Income'}: ${numberFormat.format(selectedMonth.income)} · ${isArabic ? 'مصروفات' : 'Expenses'}: ${numberFormat.format(selectedMonth.expenses)} ${isArabic ? 'ر.س' : 'SAR'}',
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800,
                            color: titleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ── 12-Month Chart ───────────────────────────────────────────────
              SizedBox(
                height: 190.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Y-Axis Scale
                    SizedBox(
                      width: 48.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final fraction in [1.0, 0.75, 0.5, 0.25, 0.0])
                            _buildYAxisLabel(
                              context,
                              NumberFormat.compact(
                                locale: locale,
                              ).format(chartMaxValue * fraction),
                            ),
                          Gap(20.h), // spacing for month label row
                        ],
                      ),
                    ),

                    // Bars Area
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, _) {
                          final monthWidths = monthlyFlow.map((month) {
                            final label = isArabic
                                ? _monthsAr[month.monthNumber - 1]
                                : _monthsEn[month.monthNumber - 1];
                            final painter = TextPainter(
                              text: TextSpan(
                                text: label,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              textDirection: Directionality.of(context),
                              maxLines: 1,
                            )..layout();
                            return painter.width + 8.w;
                          }).toList();
                          final chartWidth = monthWidths.fold<double>(
                            0,
                            (total, width) => total + width,
                          );

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: chartWidth,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    bottom: 40.h,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(
                                        5,
                                        (index) => Container(
                                          height: 1,
                                          color: gridColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: List.generate(monthlyFlow.length, (
                                        index,
                                      ) {
                                        final item = monthlyFlow[index];
                                        final isSelected =
                                            _selectedMonthIndex == index;

                                        return SizedBox(
                                          width: monthWidths[index],
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              setState(() {
                                                _selectedMonthIndex = index;
                                              });
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    _buildMonthlyBar(
                                                      value: item.income,
                                                      chartScale: chartScale,
                                                      color: const Color(
                                                        0xFF2563EB,
                                                      ),
                                                      isSelected: isSelected,
                                                    ),
                                                    Gap(2.w),
                                                    _buildMonthlyBar(
                                                      value: item.expenses,
                                                      chartScale: chartScale,
                                                      color: const Color(
                                                        0xFFEF4444,
                                                      ),
                                                      isSelected: isSelected,
                                                    ),
                                                  ],
                                                ),
                                                Gap(6.h),
                                                SizedBox(
                                                  height: 34.h,
                                                  child: Text(
                                                    isArabic
                                                        ? _monthsAr[item
                                                                  .monthNumber -
                                                              1]
                                                        : _monthsEn[item
                                                                  .monthNumber -
                                                              1],
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 9.sp,
                                                      color: isSelected
                                                          ? selectedTextColor
                                                          : mutedColor,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w900
                                                          : FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyBar({
    required double value,
    required double chartScale,
    required Color color,
    required bool isSelected,
  }) {
    final targetHeight = value == 0 ? 3.h : 120.h * value / chartScale;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: targetHeight),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, animatedHeight, child) {
        return Container(
          width: 5.w,
          height: animatedHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(3.r)),
            border: isSelected
                ? Border.all(color: color.withValues(alpha: 0.7), width: 0.7)
                : null,
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Gap(5.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.darkTextColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryBox(
    BuildContext context, {
    required String label,
    required String value,
    required Color valueColor,
    required Color bgColor,
    required Color borderColor,
    required Color accentColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 5.r,
                height: 5.r,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              Gap(4.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.darkTextColor(context),
                  ),
                ),
              ),
            ],
          ),
          Gap(4.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYAxisLabel(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 8.5.sp,
        color: AppColor.darkTextColor(context),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
