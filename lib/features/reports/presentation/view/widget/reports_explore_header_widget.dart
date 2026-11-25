import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

class ReportsExploreHeaderWidget extends StatelessWidget {
  final int count;

  const ReportsExploreHeaderWidget({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 12.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'استكشف التقارير' : 'Explore reports',
                  style: TextStyle(
                    color: AppColor.titleFormFiledColor(context),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Gap(2.h),
                Text(
                  isArabic
                      ? 'اختر القسم لعرض التقارير المتاحة'
                      : 'Choose a category to browse available reports',
                  style: TextStyle(
                    color: AppColor.darkTextColor(context),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColor.cardColor(context),
              border: Border.all(color: AppColor.borderColor(context)),
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: AppColor.primaryColor(context),
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
