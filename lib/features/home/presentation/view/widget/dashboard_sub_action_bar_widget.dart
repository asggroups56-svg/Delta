import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

class DashboardSubActionBarWidget extends StatelessWidget {
  const DashboardSubActionBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: AppColor.cardColor(context),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColor.cardSurfaceColor(context),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColor.whiteColor(context).withValues(alpha: 0.08),
              ),
            ),
            child: Icon(
              Icons.search_rounded,
              color: AppColor.darkTextColor(context),
              size: 18.r,
            ),
          ),
          Gap(8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColor.cardSurfaceColor(context),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColor.whiteColor(context).withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: AppColor.darkTextColor(context),
                    size: 22.r,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Gap(8.w),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColor.darkTextColor(context),
                    size: 22.r,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColor.cardSurfaceColor(context),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColor.whiteColor(context).withValues(alpha: 0.08),
              ),
            ),
            child: Icon(
              Icons.settings_outlined,
              color: AppColor.darkTextColor(context),
              size: 18.r,
            ),
          ),
        ],
      ),
    );
  }
}
