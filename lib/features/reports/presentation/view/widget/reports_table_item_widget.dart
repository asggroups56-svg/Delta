import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

class ReportsTableItemWidget extends StatelessWidget {
  final String title;
  final String? reportCode;
  final String searchQuery;
  final VoidCallback onExportPdf;
  final ValueChanged<String> onExportFormat;

  const ReportsTableItemWidget({
    super.key,
    required this.title,
    this.reportCode,
    this.searchQuery = '',
    required this.onExportPdf,
    required this.onExportFormat,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = AppColor.titleFormFiledColor(context);
    final mutedColor = AppColor.darkTextColor(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onExportPdf,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 12.w, 12.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHighlightedTitle(context, title, titleColor),
                    if (reportCode != null && reportCode!.isNotEmpty) ...[
                      Gap(3.h),
                      Text(
                        reportCode!,
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: isArabic ? 'تصدير التقرير' : 'Export report',
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: mutedColor,
                  size: 20.r,
                ),
                onSelected: (format) {
                  if (format == 'pdf') {
                    onExportPdf();
                  } else {
                    onExportFormat(format);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'pdf',
                    child: _ReportExportMenuItem(
                      icon: Icons.picture_as_pdf_rounded,
                      label: 'PDF',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'excel',
                    child: _ReportExportMenuItem(
                      icon: Icons.table_chart_rounded,
                      label: isArabic ? 'إكسل' : 'Excel',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'word',
                    child: _ReportExportMenuItem(
                      icon: Icons.description_rounded,
                      label: isArabic ? 'وورد' : 'Word',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'excelformatted',
                    child: _ReportExportMenuItem(
                      icon: Icons.grid_on_rounded,
                      label: isArabic ? 'إكسل احترافي' : 'Excel PRO',
                    ),
                  ),
                ],
              ),
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: AppColor.primaryColor(context),
                size: 22.r,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedTitle(
    BuildContext context,
    String text,
    Color color,
  ) {
    final query = searchQuery.trim();
    final style = TextStyle(
      color: color,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
    );
    if (query.isEmpty) {
      return Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final matchIndex = lowerText.indexOf(lowerQuery);
    if (matchIndex < 0) {
      return Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }

    final matchEnd = matchIndex + lowerQuery.length;
    final accent = AppColor.primaryColor(context);
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, matchIndex)),
          TextSpan(
            text: text.substring(matchIndex, matchEnd),
            style: style.copyWith(
              color: accent,
              fontWeight: FontWeight.bold,
              backgroundColor: accent.withValues(alpha: 0.12),
            ),
          ),
          TextSpan(text: text.substring(matchEnd)),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ReportExportMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ReportExportMenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.r),
        Gap(10.w),
        Text(label),
      ],
    );
  }
}
