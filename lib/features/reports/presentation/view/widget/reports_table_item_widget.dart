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

  /// يُستدعى عند الضغط على زر التقرير / معاينة PDF
  final VoidCallback onExportPdf;

  /// يُستدعى عند اختيار صيغة تصدير إضافية (Excel / Word / Formatted)
  final ValueChanged<String> onExportFormat;

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
    required this.onExportFormat,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAudited = status == AppLocaleKey.statusAudited.tr();
    final cardColor = AppColor.cardColor(context);
    final borderColor = AppColor.borderColor(context);
    final titleColor = AppColor.titleFormFiledColor(context);
    final descColor = AppColor.darkTextColor(context);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: borderColor.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: onExportPdf,
          borderRadius: BorderRadius.circular(18.r),
          splashColor: iconColor.withValues(alpha: 0.08),
          highlightColor: iconColor.withValues(alpha: 0.04),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isAudited, titleColor, descColor),
                Gap(10.h),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    height: 1.35,
                    color: descColor,
                  ),
                ),
                Gap(14.h),
                Container(
                  height: 1,
                  color: borderColor.withValues(alpha: 0.6),
                ),
                Gap(12.h),
                _buildActionStrip(context, descColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    bool isAudited,
    Color titleColor,
    Color descColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Glowing Icon Container
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                iconColor.withValues(alpha: 0.22),
                iconColor.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: iconColor.withValues(alpha: 0.35),
              width: 1.2,
            ),
          ),
          child: Icon(icon, color: iconColor, size: 22.r),
        ),
        Gap(12.w),
        // Title & Optional tags
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  height: 1.25,
                ),
              ),
              if (date.isNotEmpty || amount.isNotEmpty) ...[
                Gap(4.h),
                Row(
                  children: [
                    if (date.isNotEmpty)
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: descColor,
                        ),
                      ),
                    if (amount.isNotEmpty) ...[
                      Gap(6.w),
                      Text(
                        amount,
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.mintTeal,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
        Gap(8.w),
        _statusChip(isAudited),
      ],
    );
  }

  Widget _statusChip(bool isAudited) {
    final color = isAudited ? AppColor.emeraldTeal : const Color(0xFFF39C12);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.55),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          Gap(4.w),
          Text(
            status,
            style: TextStyle(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionStrip(BuildContext context, Color descColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label with icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.file_download_outlined,
              size: 15.r,
              color: AppColor.mintTeal,
            ),
            Gap(4.w),
            Text(
              context.locale.languageCode == 'ar' ? 'الصيغ :' : 'Formats:',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: descColor,
              ),
            ),
          ],
        ),

        // Quick Format Icons: PDF, Excel, Word, Formatted Excel
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // PDF Button
            _formatIconButton(
              icon: Icons.picture_as_pdf_rounded,
              label: 'PDF',
              color: const Color(0xFFEF4444),
              onTap: onExportPdf,
            ),
            Gap(6.w),
            // Excel Button
            _formatIconButton(
              icon: Icons.table_chart_rounded,
              label: 'Excel',
              color: const Color(0xFF10B981),
              onTap: () => onExportFormat('excel'),
            ),
            Gap(6.w),
            // Word Button
            _formatIconButton(
              icon: Icons.description_rounded,
              label: 'Word',
              color: const Color(0xFF3B82F6),
              onTap: () => onExportFormat('word'),
            ),
            Gap(6.w),
            // Excel Formatted Button
            _formatIconButton(
              icon: Icons.grid_on_rounded,
              label: 'PRO',
              color: const Color(0xFF8B5CF6),
              onTap: () => onExportFormat('excelformatted'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _formatIconButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: color.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13.r, color: color),
            Gap(4.w),
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
