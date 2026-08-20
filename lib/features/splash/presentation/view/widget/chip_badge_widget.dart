import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

class ChipBadgeWidget extends StatelessWidget {
  const ChipBadgeWidget({super.key, required this.icon, required this.label});
 final IconData icon;final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: AppColor.whiteColor(context)),
          Gap(6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColor.whiteColor(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}