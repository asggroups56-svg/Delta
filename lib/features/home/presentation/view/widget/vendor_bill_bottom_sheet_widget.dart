import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'custom_erp_input_field_widget.dart';

class VendorBillBottomSheetWidget extends StatelessWidget {
  const VendorBillBottomSheetWidget({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const VendorBillBottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vendorController = TextEditingController();
    final billNoController = TextEditingController();
    final totalController = TextEditingController();
    final taxController = TextEditingController(text: '15%');
    final descController = TextEditingController();

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      color: AppColor.skyBlue,
                      size: 20.r,
                    ),
                    Gap(8.w),
                    Text(
                      AppLocaleKey.createVendorBill.tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.whiteColor(context),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColor.whiteColor(context).withValues(alpha: 0.7),
                    size: 20.r,
                  ),
                ),
              ],
            ),
            Divider(
              color: AppColor.whiteColor(context).withValues(alpha: 0.1),
              height: 20.h,
            ),
            CustomErpInputFieldWidget(
              label: AppLocaleKey.vendorName.tr(),
              hint: AppLocaleKey.selectVendorHint.tr(),
              controller: vendorController,
            ),
            Gap(12.h),
            Row(
              children: [
                Expanded(
                  child: CustomErpInputFieldWidget(
                    label: AppLocaleKey.billNumber.tr(),
                    hint: AppLocaleKey.billNumberHint.tr(),
                    controller: billNoController,
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: CustomErpInputFieldWidget(
                    label: AppLocaleKey.taxRate.tr(),
                    hint: '15%',
                    controller: taxController,
                  ),
                ),
              ],
            ),
            Gap(12.h),
            CustomErpInputFieldWidget(
              label: AppLocaleKey.totalBillAmount.tr(),
              hint: '0.00',
              controller: totalController,
              isNumber: true,
            ),
            Gap(12.h),
            CustomErpInputFieldWidget(
              label: AppLocaleKey.itemsDescription.tr(),
              hint: AppLocaleKey.itemsDescHint.tr(),
              controller: descController,
              maxLines: 2,
            ),
            Gap(20.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColor.whiteColor(context).withValues(alpha: 0.24),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppLocaleKey.draft.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColor.whiteColor(context).withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.emeraldTeal,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(AppLocaleKey.vendorBillCreated.tr()),
                        backgroundColor: AppColor.emeraldTeal,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ));
                    },
                    child: Text(
                      AppLocaleKey.postBill.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.whiteColor(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(10.h),
          ],
        ),
      ),
    );
  }
}
