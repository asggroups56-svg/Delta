import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'banks_slider_widget.dart';

class BankCardWidget extends StatelessWidget {
  const BankCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 150),
      duration: const Duration(milliseconds: 350),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColor.darkCardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColor.whiteColor(context).withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocaleKey.bankCard.tr(),
                  style: AppTextStyle.bodyMedium(context).copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.emeraldTeal,
                  ),
                ),
                Icon(
                  Icons.more_vert_rounded,
                  color: AppColor.whiteColor(context).withValues(alpha: 0.54),
                  size: 20.r,
                ),
              ],
            ),
            Gap(6.h),
            Text(
              AppLocaleKey.bankDesc.tr(),
              style: AppTextStyle.bodySmall(context).copyWith(
                fontSize: 11.sp,
                color: AppColor.whiteColor(context).withValues(alpha: 0.6),
                height: 1.4,
              ),
            ),
            Gap(12.h),
            const BanksSliderWidget(),
            Gap(14.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColor.emeraldTeal.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColor.emeraldTeal.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppLocaleKey.connectBank.tr(),
                        style: AppTextStyle.bodySmall(context).copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.emeraldTeal,
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColor.darkSurface,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColor.whiteColor(context).withValues(alpha: 0.12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppLocaleKey.importStatement.tr(),
                        style: AppTextStyle.bodySmall(context).copyWith(
                          fontSize: 11.sp,
                          color: AppColor.whiteColor(context).withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
