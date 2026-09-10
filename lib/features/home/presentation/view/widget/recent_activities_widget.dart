import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class RecentActivitiesWidget extends StatelessWidget {
  const RecentActivitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'title': AppLocaleKey.newInvoiceIssued.tr(),
        'desc': 'INV-2026-089 • \$12,450.00',
        'time': '10 min ago',
        'icon': Icons.receipt_rounded,
        'color': AppColor.emeraldTeal,
      },
      {
        'title': AppLocaleKey.stockUpdated.tr(),
        'desc': 'Warehouse A • 45 Items replenished',
        'time': '1 hr ago',
        'icon': Icons.inventory_2_rounded,
        'color': AppColor.oceanBlue,
      },
      {
        'title': AppLocaleKey.newLeadAdded.tr(),
        'desc': 'Acme Corp • Enterprise Tier',
        'time': '3 hrs ago',
        'icon': Icons.hub_rounded,
        'color': AppColor.purpleAccent,
      },
    ];

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFF141D2B),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: AppColor.whiteColor(context).withValues(alpha: 0.07),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 18.r,
                      color: AppColor.emeraldTeal,
                    ),
                    Gap(6.w),
                    Text(
                      AppLocaleKey.recentActivities.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.whiteColor(context),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Live Feed',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.mintTeal,
                  ),
                ),
              ],
            ),
            Gap(12.h),
            ...activities.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              final isLast = idx == activities.length - 1;
              final color = item['color'] as Color;

              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          size: 16.r,
                          color: color,
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColor.whiteColor(context),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Gap(2.h),
                            Text(
                              item['desc'] as String,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColor.whiteColor(context).withValues(alpha: 0.5),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Gap(6.w),
                      Text(
                        item['time'] as String,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColor.whiteColor(context).withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                  if (!isLast)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Divider(
                        color: AppColor.whiteColor(context).withValues(alpha: 0.05),
                        height: 1,
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
