import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/features/home/data/models/sales_and_returns_chart_model.dart';
import 'package:my_template/features/home/data/repository/home_repo.dart';

class NetSalesAnnualCardWidget extends StatefulWidget {
  const NetSalesAnnualCardWidget({super.key});

  @override
  State<NetSalesAnnualCardWidget> createState() => _NetSalesAnnualCardWidgetState();
}

class _NetSalesAnnualCardWidgetState extends State<NetSalesAnnualCardWidget> {
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
  List<MonthlySalesAndReturns> _monthlySales = const [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final response = await sl<HomeRepo>().getSalesAndReturnsChart();
      if (!mounted) return;
      final bestMonthIndex = response.months.indexed
          .reduce((best, month) =>
              month.$2.netSales > best.$2.netSales ? month : best)
          .$1;
      final mostRecentActiveMonth = response.months.lastIndexWhere(
        (month) => month.sales > 0 || month.salesReturns > 0,
      );
      setState(() {
        _monthlySales = response.months;
        _selectedMonthIndex = mostRecentActiveMonth >= 0
            ? mostRecentActiveMonth
            : DateTime.now().month - 1;
        _bestMonthIndex = bestMonthIndex;
        _isLoading = false;
      });
    } on DioException {
      _showLoadError();
    } on FormatException {
      _showLoadError();
    }
  }

  int _bestMonthIndex = 0;

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
    final numberFormat = NumberFormat('#,###', isArabic ? 'ar' : 'en');
    final totalNetSales = _monthlySales.fold<double>(
      0,
      (total, month) => total + month.netSales,
    );
    final highestNetSales = _monthlySales.fold<double>(
      0,
      (highest, month) => highest > month.netSales ? highest : month.netSales,
    );
    final chartScale = highestNetSales <= 0 ? 1.0 : highestNetSales;
    final axisNumberFormat = NumberFormat.compact(locale: isArabic ? 'ar' : 'en');

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: borderColor,
            width: 1.2,
          ),
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
            // ── Top Header Row ───────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'أداء المبيعات' : 'Sales Performance',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.primaryColor(context),
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      isArabic ? 'صافي المبيعات' : 'Net Sales',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        color: titleColor,
                      ),
                    ),
                  ],
                ),
                // Upward Trend Icon Container
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: selectedSurfaceColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1E40AF)
                          : const Color(0xFFBFDBFE),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.trending_up_rounded,
                    color: const Color(0xFF2563EB),
                    size: 20.r,
                  ),
                ),
              ],
            ),

            Gap(14.h),

            if (_isLoading)
              SizedBox(
                height: 240.h,
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (_hasError)
              SizedBox(
                height: 240.h,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isArabic
                            ? 'تعذر تحميل بيانات المبيعات والمرتجعات'
                            : 'Could not load sales and returns',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: mutedColor,
                        ),
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
            // ── Metric & Trophy Highlight Box ────────────────────────────────
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: softSurfaceColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Best month trophy badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: selectedSurfaceColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E40AF)
                            : const Color(0xFF93C5FD),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.emoji_events_rounded,
                          size: 15.r,
                          color: AppColor.primaryColor(context),
                        ),
                        Gap(5.w),
                        Text(
                          isArabic
                              ? 'أفضل شهر: ${_monthsAr[_bestMonthIndex]}'
                              : 'Top Month: ${_monthsEn[_bestMonthIndex]}',
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w800,
                            color: selectedTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Total Net Sales Metric
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isArabic ? 'إجمالي صافي المبيعات' : 'Total Net Sales',
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w600,
                          color: mutedColor,
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        '${numberFormat.format(totalNetSales)} ${isArabic ? 'ر.س' : 'SAR'}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: titleColor,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Gap(14.h),

            // ── Interactive Selected Month Tooltip ───────────────────────────
            if (_selectedMonthIndex != null)
              Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 14.r,
                          color: const Color(0xFF2563EB),
                        ),
                        Gap(5.w),
                        Text(
                          isArabic
                              ? '${_monthsAr[_selectedMonthIndex!]}:'
                              : '${_monthsEn[_selectedMonthIndex!]}:',
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w700,
                            color: selectedTextColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${numberFormat.format(_monthlySales[_selectedMonthIndex!].netSales)} ${isArabic ? 'ر.س' : 'SAR'}',
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        Text(
                          '${isArabic ? 'مبيعات' : 'Sales'}: ${numberFormat.format(_monthlySales[_selectedMonthIndex!].sales)}  ·  ${isArabic ? 'مرتجعات' : 'Returns'}: ${numberFormat.format(_monthlySales[_selectedMonthIndex!].salesReturns)}',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: mutedColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // ── 12-Month Bar Chart ───────────────────────────────────────────
            SizedBox(
              height: 190.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Y-Axis Scale
                  SizedBox(
                    width: 44.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(
                          6,
                          (index) => _buildYAxisLabel(
                            context,
                            axisNumberFormat.format(chartScale * (5 - index) / 5),
                          ),
                        ),
                        Gap(20.h), // spacing for month label row
                      ],
                    ),
                  ),

                  // Bars Area
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, _) {
                        final monthWidths = List.generate(
                          _monthlySales.length,
                          (index) {
                            final label = isArabic
                                ? _monthsAr[index]
                                : _monthsEn[index];
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
                          },
                        );
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
                                      6,
                                      (index) => Container(
                                        height: 1,
                                        color: gridColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: List.generate(
                                      _monthlySales.length,
                                      (index) {
                                        final item = _monthlySales[index];
                                        final factor = item.netSales <= 0
                                            ? 0.0
                                            : (item.netSales / chartScale)
                                                  .clamp(0.0, 1.0)
                                                  .toDouble();
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
                                                TweenAnimationBuilder<double>(
                                                  tween: Tween<double>(
                                                    begin: 0,
                                                    end: factor,
                                                  ),
                                                  duration: Duration(
                                                    milliseconds:
                                                        400 + (index * 40),
                                                  ),
                                                  curve: Curves.easeOutCubic,
                                                  builder:
                                                      (
                                                        context,
                                                        animatedFactor,
                                                        child,
                                                      ) {
                                                        return Container(
                                                          width: 14.w,
                                                          height:
                                                              120.h *
                                                              animatedFactor,
                                                          decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                              colors: isSelected
                                                                  ? const [
                                                                      Color(
                                                                        0xFF1E40AF,
                                                                      ),
                                                                      Color(
                                                                        0xFF2563EB,
                                                                      ),
                                                                    ]
                                                                  : [
                                                                      const Color(
                                                                        0xFF2563EB,
                                                                      ).withValues(
                                                                        alpha:
                                                                            0.85,
                                                                      ),
                                                                      const Color(
                                                                        0xFF60A5FA,
                                                                      ).withValues(
                                                                        alpha:
                                                                            0.85,
                                                                      ),
                                                                    ],
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  4.r,
                                                                ),
                                                            border: Border.all(
                                                              color: isSelected
                                                                  ? const Color(
                                                                      0xFF1E40AF,
                                                                    )
                                                                  : Colors
                                                                        .transparent,
                                                              width: 1.2,
                                                            ),
                                                            boxShadow: isSelected
                                                                ? [
                                                                    BoxShadow(
                                                                      color: const Color(
                                                                        0xFF2563EB,
                                                                      ).withValues(
                                                                        alpha:
                                                                            0.35,
                                                                      ),
                                                                      blurRadius:
                                                                          8.r,
                                                                      spreadRadius:
                                                                          1,
                                                                    ),
                                                                  ]
                                                                : [],
                                                          ),
                                                        );
                                                      },
                                                ),
                                                Gap(6.h),
                                                SizedBox(
                                                  height: 34.h,
                                                  child: Text(
                                                    isArabic
                                                        ? _monthsAr[index]
                                                        : _monthsEn[index],
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
                                      },
                                    ),
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
