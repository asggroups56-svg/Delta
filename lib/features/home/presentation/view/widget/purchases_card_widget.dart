import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'upload_invoice_bottom_sheet_widget.dart';
import 'vendor_bill_bottom_sheet_widget.dart';

class PurchasesCardWidget extends StatelessWidget {
  const PurchasesCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 100),
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
                  AppLocaleKey.purchasesCard.tr(),
                  style: TextStyle(
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
              AppLocaleKey.purchasesDesc.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColor.whiteColor(context).withValues(alpha: 0.6),
                height: 1.4,
              ),
            ),
            Gap(20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Manual Vendor Bill Option
                Expanded(
                  child: GestureDetector(
                    onTap: () => VendorBillBottomSheetWidget.show(context),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: AppColor.darkSurface,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColor.skyBlue.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Icon(
                            Icons.receipt_long_rounded,
                            color: AppColor.skyBlue,
                            size: 36.r,
                          ),
                        ),
                        Gap(8.h),
                        Text(
                          AppLocaleKey.createVendorBill.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.emeraldTeal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    AppLocaleKey.orLabel.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColor.whiteColor(context).withValues(alpha: 0.38),
                    ),
                  ),
                ),
                // Upload File Option
                Expanded(
                  child: GestureDetector(
                    onTap: () => UploadInvoiceBottomSheetWidget.show(context),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: AppColor.darkSurface,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(0xFFFDCB6E).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Icon(
                            Icons.folder_zip_rounded,
                            color: const Color(0xFFFDCB6E),
                            size: 36.r,
                          ),
                        ),
                        Gap(8.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [const Color(0xFF8E44AD), AppColor.purpleAccent],
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            AppLocaleKey.uploadBtn.tr(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.whiteColor(context),
                            ),
                          ),
                        ),
                      ],
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
