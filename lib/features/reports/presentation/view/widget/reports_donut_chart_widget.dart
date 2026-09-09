import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class ReportsDonutChartWidget extends StatelessWidget {
  const ReportsDonutChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> segments = [
      {'name': 'Cloud ERP & Licenses', 'pct': 42, 'color': AppColor.emeraldTeal, 'amount': '584,200'},
      {'name': 'POS & Hardware Systems', 'pct': 28, 'color': AppColor.oceanBlue, 'amount': '389,500'},
      {'name': 'Support & Maintenance', 'pct': 18, 'color': AppColor.purpleAccent, 'amount': '250,400'},
      {'name': 'Consulting & Setup', 'pct': 12, 'color': AppColor.warningOrange, 'amount': '166,900'},
    ];

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
          Text(
            AppLocaleKey.salesByCategoryTitle.tr(),
            style: TextStyle(
              color: AppColor.whiteColor(context),
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(20.h),
          Row(
            children: [
              // Custom Donut Canvas
              SizedBox(
                width: 110.r,
                height: 110.r,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(110.r, 110.r),
                      painter: _DonutChartPainter(segments: segments),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '100%',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.whiteColor(context),
                          ),
                        ),
                        Text(
                          'SAR 1.39M',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: AppColor.mintTeal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(16.w),

              // Legend Items List
              Expanded(
                child: Column(
                  children: segments.map((item) {
                    final color = item['color'] as Color;
                    final name = item['name'] as String;
                    final pct = item['pct'] as int;
                    final amount = item['amount'] as String;

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        children: [
                          Container(
                            width: 8.r,
                            height: 8.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                          ),
                          Gap(6.w),
                          Expanded(
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColor.whiteColor(context)
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                          Gap(4.w),
                          Text(
                            '$pct% ($amount)',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> segments;

  _DonutChartPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 6;
    const strokeWidth = 10.0;

    double startAngle = -pi / 2;

    for (final seg in segments) {
      final pct = seg['pct'] as int;
      final color = seg['color'] as Color;
      final sweepAngle = (pct / 100) * 2 * pi;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Draw arc with tiny gap between segments
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + 0.05,
        sweepAngle - 0.1,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
