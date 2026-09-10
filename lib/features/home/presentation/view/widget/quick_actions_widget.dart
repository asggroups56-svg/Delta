import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onAiTap;

  const QuickActionsWidget({super.key, required this.onAiTap});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'title': AppLocaleKey.createInvoice.tr(),
        'icon': Icons.receipt_long_rounded,
        'color': AppColor.royalIndigo,
        'onTap': () => NavigatorMethods.pushNamed(context, RoutesName.createInvoiceScreen),
      },
      {
        'title': 'عميل جديد',
        'icon': Icons.person_add_alt_1_rounded,
        'color': AppColor.electricCyan,
        'onTap': () => NavigatorMethods.pushNamed(context, RoutesName.addLeadScreen),
      },
      {
        'title': AppLocaleKey.scanAndUpload.tr(),
        'icon': Icons.document_scanner_outlined,
        'color': AppColor.emeraldTeal,
        'onTap': () => NavigatorMethods.pushNamed(context, RoutesName.scanUploadScreen),
      },
      {
        'title': 'AI Copilot',
        'icon': Icons.auto_awesome_rounded,
        'color': AppColor.purpleAccent,
        'onTap': () => NavigatorMethods.pushNamed(context, RoutesName.aiCopilotScreen),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocaleKey.quickActions.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.whiteColor(context).withValues(alpha: 0.75),
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'Shortcuts',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.emeraldTeal,
                ),
              ),
            ],
          ),
        ),
        Gap(10.h),
        Row(
          children: actions.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final color = item['color'] as Color;

            return Expanded(
              child: FadeInLeft(
                delay: Duration(milliseconds: 60 * idx),
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: item['onTap'] as VoidCallback,
                      borderRadius: BorderRadius.circular(14.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141D2B),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: color.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(7.r),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                size: 18.r,
                                color: color,
                              ),
                            ),
                            Gap(6.h),
                            Text(
                              item['title'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColor.whiteColor(context).withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
