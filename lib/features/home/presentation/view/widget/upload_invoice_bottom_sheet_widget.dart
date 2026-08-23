import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class UploadInvoiceBottomSheetWidget extends StatelessWidget {
  const UploadInvoiceBottomSheetWidget({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const UploadInvoiceBottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColor.darkCardBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        border: Border.all(
          color: AppColor.whiteColor(context).withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context).withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          Gap(14.h),
          Text(
            AppLocaleKey.uploadInvoiceDoc.tr(),
            style: AppTextStyle.text16SDark(context).copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.whiteColor(context),
            ),
          ),
          Gap(16.h),
          // Upload Drop Area
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 28.h),
            decoration: BoxDecoration(
              color: AppColor.darkSurface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColor.purpleAccent.withValues(alpha: 0.5),
                style: BorderStyle.solid,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_rounded,
                  color: AppColor.purpleAccent,
                  size: 42.r,
                ),
                Gap(10.h),
                Text(
                  AppLocaleKey.tapToSelectFile.tr(),
                  style: AppTextStyle.text12SDark(context).copyWith(
                    fontSize: 12.sp,
                    color: AppColor.whiteColor(context).withValues(alpha: 0.7),
                  ),
                ),
                Gap(4.h),
                Text(
                  AppLocaleKey.maxSize10Mb.tr(),
                  style: AppTextStyle.text10SDark(context).copyWith(
                    fontSize: 10.sp,
                    color: AppColor.whiteColor(context).withValues(alpha: 0.38),
                  ),
                ),
              ],
            ),
          ),
          Gap(20.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.purpleAccent,
              minimumSize: Size(double.infinity, 44.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocaleKey.aiScanningDoc.tr()),
                backgroundColor: AppColor.purpleAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ));
            },
            child: Text(
              AppLocaleKey.scanAndUpload.tr(),
              style: AppTextStyle.bodyMedium( context).copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.whiteColor(context),
              ),
            ),
          ),
          Gap(10.h),
        ],
      ),
    );
  }
}
