import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class DrawerTileWidget extends StatelessWidget {
  const DrawerTileWidget({
    super.key,
    required this.icons,
    required this.title,
    this.onTap,
    this.color,
    this.isActive = false,
    this.badge,
  });

  final IconData icons;
  final String title;
  final VoidCallback? onTap;
  final Color? color;
  final bool isActive;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? (isActive ? AppColor.emeraldTeal : AppColor.whiteColor(context).withValues(alpha: 0.85));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isActive ? AppColor.emeraldTeal.withValues(alpha: 0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
              border: isActive
                  ? Border.all(color: AppColor.emeraldTeal.withValues(alpha: 0.3), width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(7.r),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColor.emeraldTeal.withValues(alpha: 0.2)
                        : (color != null
                            ? color!.withValues(alpha: 0.12)
                            : AppColor.whiteColor(context).withValues(alpha: 0.05)),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icons, color: effectiveColor, size: 18.r),
                ),
                Gap(12.w),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyle.bodyMedium(context).copyWith(
                      color: effectiveColor,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13.5.sp,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColor.purpleAccent.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColor.purpleAccent.withValues(alpha: 0.5),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      badge!,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.purpleAccent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}