import 'package:easy_localization/easy_localization.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class TaxReturnsCardWidget extends StatelessWidget {
  const TaxReturnsCardWidget({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final steps = [
      AppLocaleKey.taxReturnStep1.tr(),
      AppLocaleKey.taxReturnStep2.tr(),
      AppLocaleKey.taxReturnStep3.tr(),
    ];
    return FadeInUp(
      delay: const Duration(milliseconds: 300),
      duration: const Duration(milliseconds: 350),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColor.darkCardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocaleKey.taxReturnsCard.tr(),
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColor.emeraldTeal),
                ),
                Icon(Icons.more_vert_rounded, color: AppColor.whiteColor(context).withValues(alpha: 0.54), size: 20.r),
              ],
            ),
            Gap(14.h),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [const Color(0xFF8E44AD), AppColor.purpleAccent]),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [BoxShadow(color: AppColor.purpleAccent.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: Text(
                    AppLocaleKey.newBtn.tr(),
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColor.whiteColor(context)),
                  ),
                ),
              ),
            ),
            Gap(16.h),
            Column(
              children: steps.map((step) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C3E50),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.emeraldTeal, width: 2),
                        ),
                      ),
                      Gap(10.w),
                      Text(
                        step,
                        style: AppTextStyle.text12SDark(context).copyWith(
                          color: AppColor.emeraldTeal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}