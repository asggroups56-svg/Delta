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
  int _selectedMonthIndex = 5;
  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
  final List<double> _revenues = [120, 145, 130, 180, 165, 215]; // in k SAR
  final List<double> _expenses = [80, 95, 88, 110, 105, 125];

  static const double _maxVal = 250.0;

  // Y-axis labels from bottom to top
  static const List<String> _yLabels = [
    '0',
    '50k',
    '100k',
    '150k',
    '200k',
    '250k',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title & Legends ───────────────────────────────────────────────
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
                        color: AppColor.titleFormFiledColor(context),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(3.h),
                    Text(
                      'SAR (${_revenues[_selectedMonthIndex].toInt()}K Rev'
                      ' / ${_expenses[_selectedMonthIndex].toInt()}K Exp)',
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
          Gap(20.h),

          // ── Chart area: Y-axis + bars ─────────────────────────────────────
          SizedBox(
            height: 182.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Y-axis labels
                _YAxisLabels(
                  labels: _yLabels,
                  context: context,
                ),
                Gap(6.w),

                // Bars with grid lines
                Expanded(
                  child: Stack(
                    children: [
                      // Horizontal grid lines
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _GridLinePainter(
                            lineCount: _yLabels.length,
                            lineColor:
                                AppColor.borderColor(context),
                          ),
                        ),
                      ),

                      // Bar groups
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: 24.h),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: List.generate(
                            _months.length,
                            (index) => _BarGroup(
                              isSelected:
                                  _selectedMonthIndex == index,
                              month: _months[index],
                              revenue: _revenues[index],
                              expense: _expenses[index],
                              maxVal: _maxVal,
                              onTap: () => setState(
                                () => _selectedMonthIndex = index,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
            color: AppColor.darkTextColor(context),
          ),
        ),
      ],
    );
  }
}

// ── Y-Axis Labels ──────────────────────────────────────────────────────────────
class _YAxisLabels extends StatelessWidget {
  final List<String> labels;
  final BuildContext context;

  const _YAxisLabels({required this.labels, required this.context});

  @override
  Widget build(BuildContext _) {
    return SizedBox(
      width: 34.w,
      child: Padding(
        padding: EdgeInsets.only(bottom: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: labels.reversed
              .map(
                (l) => Text(
                  l,
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: AppColor.darkTextColor(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ── Grid Line Painter ─────────────────────────────────────────────────────────
class _GridLinePainter extends CustomPainter {
  final int lineCount;
  final Color lineColor;

  const _GridLinePainter({required this.lineCount, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final chartHeight = size.height - 24; // subtract month label area
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.7;

    for (int i = 0; i < lineCount; i++) {
      final y = chartHeight - (i / (lineCount - 1)) * chartHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Individual Bar Group ──────────────────────────────────────────────────────
class _BarGroup extends StatelessWidget {
  final bool isSelected;
  final String month;
  final double revenue;
  final double expense;
  final double maxVal;
  final VoidCallback onTap;

  const _BarGroup({
    required this.isSelected,
    required this.month,
    required this.revenue,
    required this.expense,
    required this.maxVal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Available bar height = total 182.h minus 24.h label area minus 20.h tooltip area
    final availableBarH = 182.h - 24.h - 22.h;
    final revHeight = (revenue / maxVal) * availableBarH;
    final expHeight = (expense / maxVal) * availableBarH;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Tooltip bubble
          if (isSelected)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 9.w,
                vertical: 4.h,
              ),
              margin: EdgeInsets.only(bottom: 5.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                ),
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.royalIndigo.withValues(alpha: 0.45),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                '${revenue.toInt()}k · ${expense.toInt()}k',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          else
            SizedBox(height: 22.h),

          // Bar pair
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Revenue bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOut,
                width: 16.w,
                height: revHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSelected
                        ? [
                            AppColor.royalIndigo,
                            AppColor.electricCyan,
                          ]
                        : [
                            AppColor.royalIndigo.withValues(alpha: 0.38),
                            AppColor.electricCyan.withValues(alpha: 0.38),
                          ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.royalIndigo.withValues(alpha: 0.45),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
              Gap(4.w),
              // Expense bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOut,
                width: 16.w,
                height: expHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSelected
                        ? [
                            AppColor.roseDanger,
                            const Color(0xFFFB7185),
                          ]
                        : [
                            AppColor.roseDanger.withValues(alpha: 0.38),
                            const Color(0xFFFB7185).withValues(alpha: 0.38),
                          ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.roseDanger.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),

          Gap(6.h),
          // Month label
          Text(
            month,
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.w400,
              color: isSelected
                  ? AppColor.titleFormFiledColor(context)
                  : AppColor.darkTextColor(context),
            ),
          ),
        ],
      ),
    );
  }
}
