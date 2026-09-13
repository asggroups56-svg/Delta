import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class ReportsTableItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final String amount;
  final String date;
  final String status;
  final IconData icon;
  final Color iconColor;

  /// يُستدعى عند الضغط على زر PDF. الشاشة الأم مسؤولة عن المعاينة.
  final VoidCallback onExportPdf;

  /// يُستدعى عند الضغط على زر Excel. الشاشة الأم مسؤولة عن المعاينة.
  final VoidCallback onExportExcel;

  const ReportsTableItemWidget({
    super.key,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
    required this.icon,
    required this.iconColor,
    required this.onExportPdf,
    required this.onExportExcel,
  });

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
          _buildHeader(context, isAudited),
          Gap(12.h),
          Divider(
            color: AppColor.whiteColor(context).withValues(alpha: 0.08),
            height: 1,
          ),
          Gap(10.h),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isAudited) {
    return Row(
      children: [
        Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: iconColor.withValues(alpha: 0.3)),
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
                  color: AppColor.whiteColor(context).withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        Gap(8.w),
        _statusChip(isAudited),
      ],
    );
  }

  Widget _statusChip(bool isAudited) {
    final color = isAudited
        ? AppColor.emeraldTeal
        : const Color(0xFFF39C12);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 12.r,
                color: AppColor.whiteColor(context).withValues(alpha: 0.5),
              ),
              Gap(4.w),
              Flexible(
                child: Text(
                  date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    color: AppColor.whiteColor(context).withValues(alpha: 0.5),
                  ),
                ),
              ),
              Gap(6.w),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.mintTeal,
                ),
              ),
              Gap(6.w),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _exportButton(
              label: 'PDF',
              icon: Icons.picture_as_pdf_rounded,
              color: const Color(0xFFFF7675),
              onTap: onExportPdf,
            ),
            Gap(8.w),
            _exportButton(
              label: 'XLSX',
              icon: Icons.table_chart_outlined,
              color: const Color(0xFF10B981),
              onTap: onExportExcel,
            ),
          ],
        ),
      ],
    );
  }

  Widget _exportButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13.r, color: color),
            Gap(3.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}