import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class DocumentsHeaderWidget extends StatelessWidget {
  const DocumentsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF171F2B),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Icon(Icons.folder_special_rounded, color: const Color(0xFF00B894), size: 22.r),
          Gap(8.w),
          Expanded(
            child: Text(
              'documentsAndFiles'.tr(),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColor.whiteColor(context)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(padding: EdgeInsets.all(6.r), child: Icon(Icons.search_rounded, color: AppColor.whiteColor(context).withValues(alpha: 0.7), size: 20.r)),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(color: const Color(0xFF6C5CE7), borderRadius: BorderRadius.circular(10.r)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, size: 14.r, color: AppColor.whiteColor(context)),
                  Gap(3.w),
                  Text('newBtn'.tr(), style: AppTextStyle.text10SDark(context).copyWith(fontWeight: FontWeight.bold, color: AppColor.whiteColor(context))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}