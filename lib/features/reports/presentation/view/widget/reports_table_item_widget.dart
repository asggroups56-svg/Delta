import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/common_methods.dart';

class ReportsTableItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final String amount;
  final String date;
  final String status;
  final IconData icon;
  final Color iconColor;

  const ReportsTableItemWidget({
    super.key,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
    required this.icon,
    required this.iconColor,
  });

  void _onExportPdf(BuildContext context) {
    CommonMethods.showToast(
      message: '${AppLocaleKey.downloadingPdf.tr()} ($title)',
      type: ToastType.success,
    );
  }

  void _onExportExcel(BuildContext context) {
    CommonMethods.showToast(
      message: '${AppLocaleKey.exportingExcel.tr()} ($title)',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAudited = status == AppLocaleKey.statusAudited.tr();

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 22.r),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.whiteColor(context),
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColor.whiteColor(context)
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isAudited
                      ? AppColor.emeraldTeal.withValues(alpha: 0.15)
                      : const Color(0xFFF39C12).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isAudited
                        ? AppColor.emeraldTeal.withValues(alpha: 0.3)
                        : const Color(0xFFF39C12).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: isAudited
                        ? AppColor.emeraldTeal
                        : const Color(0xFFF39C12),
                  ),
                ),
              ),
            ],
          ),
          Gap(12.h),
          Divider(
            color: AppColor.whiteColor(context).withValues(alpha: 0.08),
            height: 1,
          ),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 13.r,
                      color: AppColor.whiteColor(context).withValues(alpha: 0.5),
                    ),
                    Gap(4.w),
                    Expanded(
                      child: Text(
                        date,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color:
                              AppColor.whiteColor(context).withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Gap(8.w),
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.mintTeal,
                      ),
                    ),
                    Gap(8.w),
                  ],
                ),
              ),
              Row(
                children: [
                  // PDF Export button
                  InkWell(
                    onTap: () => _onExportPdf(context),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7675).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color:
                              const Color(0xFFFF7675).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.picture_as_pdf_rounded,
                            size: 13.r,
                            color: const Color(0xFFFF7675),
                          ),
                          Gap(3.w),
                          Text(
                            'PDF',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF7675),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(8.w),
                  // Excel Export button
                  InkWell(
                    onTap: () => _onExportExcel(context),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color:
                              const Color(0xFF10B981).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.table_chart_outlined,
                            size: 13.r,
                            color: const Color(0xFF10B981),
                          ),
                          Gap(3.w),
                          Text(
                            'XLSX',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF10B981),
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
        ],
      ),
    );
  }
}
