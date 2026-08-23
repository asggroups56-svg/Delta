import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/onboarding/presentation/view/widget/chart_bar_widget.dart';

class AnalyticsIllustrationWidget extends StatelessWidget {
  const AnalyticsIllustrationWidget({super.key, required this.color});
 final Color color;
  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: EdgeInsets.all(20.r),
        width: 280.w,
        decoration: BoxDecoration(
          color: AppColor.whiteColor(context),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 25,
              offset: const Offset(0, 10),
            )
          ],
          border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.analytics_rounded,
                          size: 20.r, color: color),
                    ),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'weeklySales'.tr(),
                          style: AppTextStyle.bodyMedium(context).copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'updatedNow'.tr(),
                          style: AppTextStyle.bodySmall(context).copyWith(
                            fontSize: 10.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up_rounded,
                          size: 14.r, color: Colors.green),
                      Gap(4.w),
                      Text(
                        '+28%',
                        style: AppTextStyle.bodySmall(context).copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(20.h),

            // Animated Bar Chart Simulation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ChartBarWidget(height: 40.h, color: color.withValues(alpha: 0.4)),
                ChartBarWidget(height: 70.h, color: color.withValues(alpha: 0.6)),
                ChartBarWidget(height: 50.h, color: color.withValues(alpha: 0.5)),
                ChartBarWidget(height: 95.h, color: color),
                ChartBarWidget(height: 65.h, color: color.withValues(alpha: 0.7)),
              ],
            ),
            Gap(16.h),

            // Metrics Summary Line
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('totalProfit'.tr(),
                      style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[700])),
                  Text('\$48,920.00',
                      style: AppTextStyle.bodySmall(context).copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}