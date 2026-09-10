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
  final int views;
  final String? badge;

  const KnowledgeArticleItemWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.readTimeMins,
    required this.updatedDaysAgo,
    this.views = 0,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF151D2B),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColor.whiteColor(context).withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: () {},
          splashColor: iconColor.withValues(alpha: 0.08),
          highlightColor: iconColor.withValues(alpha: 0.04),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container with gradient overlay
                Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        iconColor.withValues(alpha: 0.2),
                        iconColor.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 22.sp,
                  ),
                ),
                Gap(14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row with optional badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColor.whiteColor(context),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          if (badge != null) ...[
                            Gap(8.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: badge == AppLocaleKey.kbNew.tr()
                                    ? AppColor.emeraldTeal.withValues(alpha: 0.15)
                                    : AppColor.warningOrange.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: badge == AppLocaleKey.kbNew.tr()
                                      ? AppColor.emeraldTeal.withValues(alpha: 0.3)
                                      : AppColor.warningOrange.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                badge!,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                  color: badge == AppLocaleKey.kbNew.tr()
                                      ? AppColor.emeraldTeal
                                      : AppColor.warningOrange,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Gap(5.h),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          color: AppColor.whiteColor(context).withValues(alpha: 0.5),
                          height: 1.45,
                        ),
                      ),
                      Gap(10.h),
                      // Meta info row
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: _buildMetaChip(
                                    context,
                                    Icons.schedule_rounded,
                                    AppLocaleKey.readTime.tr(namedArgs: {'mins': readTimeMins.toString()}),
                                    AppColor.mintTeal,
                                  ),
                                ),
                                Gap(8.w),
                                Flexible(
                                  child: _buildMetaChip(
                                    context,
                                    Icons.update_rounded,
                                    AppLocaleKey.updatedAgo.tr(namedArgs: {'days': updatedDaysAgo.toString()}),
                                    AppColor.whiteColor(context).withValues(alpha: 0.35),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap(6.w),
                          Icon(
                            context.locale.languageCode == 'ar'
                                ? Icons.chevron_left_rounded
                                : Icons.chevron_right_rounded,
                            color: AppColor.whiteColor(context).withValues(alpha: 0.25),
                            size: 16.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaChip(BuildContext context, IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12.sp, color: color),
        Gap(3.w),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
