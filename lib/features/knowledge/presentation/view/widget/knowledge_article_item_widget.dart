import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class KnowledgeArticleItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final int readTimeMins;
  final int updatedDaysAgo;

  const KnowledgeArticleItemWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.readTimeMins,
    required this.updatedDaysAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2431),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.whiteColor(context).withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24.sp,
            ),
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.whiteColor(context),
                  ),
                ),
                Gap(4.h),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColor.whiteColor(context).withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                ),
                Gap(12.h),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14.sp,
                      color: AppColor.mintTeal,
                    ),
                    Gap(4.w),
                    Text(
                      AppLocaleKey.readTime.tr(namedArgs: {'mins': readTimeMins.toString()}),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColor.mintTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(16.w),
                    Icon(
                      Icons.update_rounded,
                      size: 14.sp,
                      color: AppColor.whiteColor(context).withValues(alpha: 0.4),
                    ),
                    Gap(4.w),
                    Text(
                      AppLocaleKey.updatedAgo.tr(namedArgs: {'days': updatedDaysAgo.toString()}),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColor.whiteColor(context).withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
