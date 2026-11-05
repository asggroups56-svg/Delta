import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

class ReportsKpiCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final List<Color> gradient;
  final List<double> sparklineData;

  const ReportsKpiCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.gradient,
    this.sparklineData = const [20, 35, 25, 45, 40, 60, 55, 80],
  });

  /// Compute a 0–1 progress from sparklineData: last value / max value.
  double get _progressFraction {
    if (sparklineData.isEmpty) return 0.0;
    final maxVal = sparklineData.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) return 0.0;
    return (sparklineData.last / maxVal).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = gradient.first;
    final positiveColor = const Color(0xFF10B981);
    final negativeColor = const Color(0xFFEF4444);
    final trendColor = isPositive ? positiveColor : negativeColor;

    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.14),
            blurRadius: 20,
            offset: const Offset(0, 7),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header: Icon + Trend Badge ───────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gradient icon with glow
              Container(
                width: 46.r,
                height: 46.r,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.5),
                      blurRadius: 14,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.2),
                      blurRadius: 24,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, size: 22.r, color: Colors.white),
              ),

              // Trend pill badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: trendColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: trendColor.withValues(alpha: 0.28),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 13.r,
                      color: trendColor,
                    ),
                    Gap(3.w),
                    Text(
                      change,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: trendColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(13.h),

          // ── Title ────────────────────────────────────────────────────────
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.darkTextColor(context),
              letterSpacing: 0.1,
            ),
          ),
          Gap(3.h),

          // ── Value (big, bold) ────────────────────────────────────────────
          Text(
            value,
            style: TextStyle(
              color: AppColor.titleFormFiledColor(context),
              fontWeight: FontWeight.w800,
              fontSize: 20.sp,
              height: 1.1,
              letterSpacing: -0.3,
            ),
          ),
          Gap(10.h),

          // ── Sparkline ────────────────────────────────────────────────────
          SizedBox(
            height: 28.h,
            width: double.infinity,
            child: CustomPaint(
              painter: _MiniSparklinePainter(
                data: sparklineData,
                lineColor: accentColor,
                fillColor: accentColor.withValues(alpha: 0.15),
              ),
            ),
          ),
          Gap(10.h),

          // ── Progress bar ─────────────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'vs last period',
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: AppColor.darkTextColor(context),
                    ),
                  ),
                  Text(
                    '${(_progressFraction * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
              Gap(4.h),
              Stack(
                children: [
                  // Track
                  Container(
                    height: 5.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  // Fill
                  FractionallySizedBox(
                    widthFactor: _progressFraction,
                    child: Container(
                      height: 5.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Sparkline Painter ──────────────────────────────────────────────────────────
class _MiniSparklinePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color fillColor;

  _MiniSparklinePainter({
    required this.data,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final double minVal = data.reduce((a, b) => a < b ? a : b);
    final double maxVal = data.reduce((a, b) => a > b ? a : b);
    final double range = maxVal - minVal == 0 ? 1 : maxVal - minVal;

    final path = Path();
    final fillPath = Path();

    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalized = (data[i] - minVal) / range;
      final y = size.height - (normalized * (size.height - 4)) - 2;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        final prevX = (i - 1) * stepX;
        final prevNorm = (data[i - 1] - minVal) / range;
        final prevY = size.height - (prevNorm * (size.height - 4)) - 2;

        final cx = (prevX + x) / 2;
        path.cubicTo(cx, prevY, cx, y, x, y);
        fillPath.cubicTo(cx, prevY, cx, y, x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [fillColor, fillColor.withValues(alpha: 0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // Draw endpoint dot
    final lastX = (data.length - 1) * stepX;
    final lastNorm = (data.last - minVal) / range;
    final lastY = size.height - (lastNorm * (size.height - 4)) - 2;
    canvas.drawCircle(
      Offset(lastX, lastY),
      3.0,
      Paint()..color = lineColor,
    );
    canvas.drawCircle(
      Offset(lastX, lastY),
      5.0,
      Paint()
        ..color = lineColor.withOpacity(0.25)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
