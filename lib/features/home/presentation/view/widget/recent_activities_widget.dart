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
        'desc': 'INV-2026-089 • 12,450.00 ر.س',
        'time': 'منذ 10 دقائق',
        'icon': Icons.receipt_rounded,
        'color': const Color(0xFF2563EB),
      },
      {
        'title': AppLocaleKey.stockUpdated.tr(),
        'desc': 'المستودع الرئيسي • توريد 45 صنف',
        'time': 'منذ ساعة',
        'icon': Icons.inventory_2_rounded,
        'color': const Color(0xFF059669),
      },
      {
        'title': AppLocaleKey.newLeadAdded.tr(),
        'desc': 'مجموعة دلتا الدولية • فئة المؤسسات',
        'time': 'منذ 3 ساعات',
        'icon': Icons.hub_rounded,
        'color': const Color(0xFF7C3AED),
      },
    ];

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColor.cardColor(context),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColor.borderColor(context), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.history_rounded,
                      size: 18,
                      color: Color(0xFF2563EB),
                    ),
                    Gap(6.w),
                    Text(
                      AppLocaleKey.recentActivities.tr(),
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColor.titleFormFiledColor(context),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Live Feed',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            Gap(14.h),
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
                          color: color.withValues(alpha: 0.12),
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
                                fontWeight: FontWeight.w700,
                                color: AppColor.titleFormFiledColor(context),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Gap(2.h),
                            Text(
                              item['desc'] as String,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColor.darkTextColor(context),
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
                          color: AppColor.hintColor(context),
                        ),
                      ),
                    ],
                  ),
                  if (!isLast)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Divider(
                        color: AppColor.borderColor(context),
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
