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
  final String? reportCode;
  final String? categoryLabel;
  final String searchQuery;

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
    this.reportCode,
    this.categoryLabel,
    this.searchQuery = '',
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
        border: Border.all(color: iconColor.withValues(alpha: 0.16), width: 1),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
            padding: EdgeInsets.all(15.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isAudited, titleColor, descColor, context),
                Gap(10.h),
                _buildHighlightedText(
                  context: context,
                  text: description,
                  query: searchQuery,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    height: 1.4,
                    color: descColor,
                  ),
                  maxLines: 2,
                ),
                Gap(14.h),
                Container(
                  height: 1,
                  color: borderColor.withValues(alpha: 0.65),
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
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gradient icon container
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                iconColor.withValues(alpha: 0.24),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHighlightedText(
                context: context,
                text: title,
                query: searchQuery,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  height: 1.25,
                ),
                maxLines: 2,
              ),
              if ((reportCode != null && reportCode!.isNotEmpty) ||
                  (categoryLabel != null && categoryLabel!.isNotEmpty) ||
                  date.isNotEmpty ||
                  amount.isNotEmpty) ...[
                Gap(6.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (reportCode != null && reportCode!.isNotEmpty)
                      _infoChip(
                        label: reportCode!,
                        color: iconColor,
                        monospace: true,
                      ),
                    if (categoryLabel != null && categoryLabel!.isNotEmpty)
                      _infoChip(label: categoryLabel!, color: descColor),
                    if (date.isNotEmpty)
                      Text(
                        date,
                        style: TextStyle(fontSize: 10.sp, color: descColor),
                      ),
                    if (amount.isNotEmpty)
                      Text(
                        amount,
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.mintTeal,
                        ),
                      ),
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

  Widget _infoChip({
    required String label,
    required Color color,
    bool monospace = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.14)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.sp,
          fontFamily: monospace ? 'monospace' : null,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
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

  Widget _buildHighlightedText({
    required BuildContext context,
    required String text,
    required String query,
    required TextStyle style,
    int? maxLines,
  }) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return Text(
        text,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
        style: style,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = trimmedQuery.toLowerCase();
    final spans = <TextSpan>[];
    final highlightColor = AppColor.primaryColor(context);

    var start = 0;
    while (start < text.length) {
      final matchIndex = lowerText.indexOf(lowerQuery, start);
      if (matchIndex == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (matchIndex > start) {
        spans.add(TextSpan(text: text.substring(start, matchIndex)));
      }
      spans.add(
        TextSpan(
          text: text.substring(matchIndex, matchIndex + lowerQuery.length),
          style: style.copyWith(
            color: highlightColor,
            fontWeight: FontWeight.bold,
            backgroundColor: highlightColor.withValues(alpha: 0.12),
          ),
        ),
      );
      start = matchIndex + lowerQuery.length;
    }

    return Text.rich(
      TextSpan(style: style, children: spans),
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
    );
  }

  Widget _buildActionStrip(BuildContext context, Color descColor) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColor.cardSurfaceColor(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.borderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.file_download_outlined,
                size: 15.r,
                color: AppColor.mintTeal,
              ),
              Gap(5.w),
              Text(
                context.locale.languageCode == 'ar'
                    ? 'صيغ التصدير'
                    : 'Export formats',
                style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  color: descColor,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.touch_app_outlined,
                size: 13.r,
                color: descColor.withValues(alpha: 0.55),
              ),
              Gap(3.w),
              Text(
                context.locale.languageCode == 'ar'
                    ? 'اضغط لعرض التقرير'
                    : 'Tap to open',
                style: TextStyle(
                  fontSize: 9.5.sp,
                  color: descColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          Gap(8.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              _formatIconButton(
                icon: Icons.picture_as_pdf_rounded,
                label: 'PDF',
                color: const Color(0xFFEF4444),
                onTap: onExportPdf,
              ),
              _formatIconButton(
                icon: Icons.table_chart_rounded,
                label: 'Excel',
                color: const Color(0xFF10B981),
                onTap: () => onExportFormat('excel'),
              ),
              _formatIconButton(
                icon: Icons.description_rounded,
                label: 'Word',
                color: const Color(0xFF3B82F6),
                onTap: () => onExportFormat('word'),
              ),
              _formatIconButton(
                icon: Icons.grid_on_rounded,
                label: 'PRO',
                color: const Color(0xFF8B5CF6),
                onTap: () => onExportFormat('excelformatted'),
              ),
            ],
          ),
        ],
      ),
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
        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
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
