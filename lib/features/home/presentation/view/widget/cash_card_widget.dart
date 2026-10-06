import 'package:easy_localization/easy_localization.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class CashCardWidget extends StatelessWidget {
  const CashCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      duration: const Duration(milliseconds: 350),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColor.cardColor(context),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColor.borderColor(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'cashCard'.tr(),
                  style: AppTextStyle.bodyMedium(context).copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF00B894),
                  ),
                ),
                Icon(
                  Icons.more_vert_rounded,
                  color: AppColor.darkTextColor(context),
                  size: 20.r,
                ),
              ],
            ),
            Gap(6.h),
            Text(
              'cashDesc'.tr(),
              style: AppTextStyle.bodySmall(context).copyWith(
                fontSize: 11.sp,
                color: AppColor.darkTextColor(context),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
