import 'package:easy_localization/easy_localization.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

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
          color: const Color(0xFF131B26),
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
                  'cashCard'.tr(),
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xFF00B894)),
                ),
                Icon(Icons.more_vert_rounded, color: AppColor.whiteColor(context).withValues(alpha: 0.54), size: 20.r),
              ],
            ),
            Gap(6.h),
            Text(
              'cashDesc'.tr(),
              style: TextStyle(fontSize: 11.sp, color: AppColor.whiteColor(context).withValues(alpha: 0.6), height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}