import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

class ReportsTableItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? reportCode;
  final IconData? icon;
  final Color? accent;
  final String searchQuery;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onExportPdf;
  final ValueChanged<String> onExportFormat;

  const ReportsTableItemWidget({
    super.key,
    required this.title,
    this.description = '',
    this.reportCode,
    this.icon,
    this.accent,
    this.searchQuery = '',
    this.isSelected = false,
    required this.onSelect,
    required this.onExportPdf,
    required this.onExportFormat,
  });

  // ── Export Format Bottom Sheet ─────────────────────────────────────────────
  Future<void> _showExportFormats(BuildContext context) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final formats = <(String, IconData, String, Color)>[
      ('pdf', Icons.picture_as_pdf_rounded, 'PDF', AppColor.roseDanger),
      (
        'excel',
        Icons.table_chart_rounded,
        isArabic ? 'إكسل' : 'Excel',
        AppColor.emeraldTeal,
      ),
      (
        'word',
        Icons.description_rounded,
        isArabic ? 'وورد' : 'Word',
        AppColor.oceanBlue,
      ),
      (
        'excelformatted',
        Icons.grid_on_rounded,
        isArabic ? 'إكسل احترافي' : 'Excel PRO',
        AppColor.purpleAccent,
      ),
    ];

    final selectedFormat = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 20.h),
        decoration: BoxDecoration(
          color: AppColor.cardColor(sheetContext),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColor.borderColor(sheetContext),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              Gap(16.h),
              Text(
                isArabic ? 'تصدير التقرير' : 'Export report',
                style: TextStyle(
                  color: AppColor.titleFormFiledColor(sheetContext),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Gap(3.h),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColor.darkTextColor(sheetContext),
                  fontSize: 11.sp,
                ),
              ),
              Gap(14.h),
              for (final (format, formatIcon, label, color) in formats)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Material(
                    color: color.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(14.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: () => Navigator.pop(sheetContext, format),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36.r,
                              height: 36.r,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(11.r),
                              ),
                              child: Icon(formatIcon, color: color, size: 18.r),
                            ),
                            Gap(11.w),
                            Expanded(
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: AppColor.titleFormFiledColor(
                                    sheetContext,
                                  ),
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: AppColor.darkTextColor(sheetContext),
                              size: 19.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (selectedFormat == null || !context.mounted) return;
    if (selectedFormat == 'pdf') {
      onExportPdf();
    } else {
      onExportFormat(selectedFormat);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tint = accent ?? AppColor.primaryColor(context);
    final titleColor = AppColor.titleFormFiledColor(context);
    final isArabic = context.locale.languageCode == 'ar';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onSelect();
          onExportPdf();
        },
        onLongPress: () => _showExportFormats(context),
        borderRadius: BorderRadius.circular(16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColor.cardColor(context),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? tint.withValues(alpha: 0.35)
                  : AppColor.borderColor(context),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? tint.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: isSelected ? 16 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              children: [
                // ── Gradient background tint ─────────────────────────────
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          tint.withValues(alpha: isSelected ? 0.05 : 0.03),
                          Colors.transparent,
                        ],
                        begin: AlignmentDirectional.centerStart,
                        end: AlignmentDirectional.centerEnd,
                      ),
                    ),
                  ),
                ),

                // ── Left accent bar ──────────────────────────────────────
                PositionedDirectional(
                  start: 0,
                  top: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 4.w,
                    decoration: BoxDecoration(
                      color: tint,
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(16.r),
                        bottomStart: Radius.circular(16.r),
                      ),
                    ),
                  ),
                ),

                // ── Card Content ─────────────────────────────────────────
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    14.w,
                    12.h,
                    12.w,
                    12.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon container
                      Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              tint.withValues(
                                alpha: isSelected ? 0.22 : 0.13,
                              ),
                              tint.withValues(
                                alpha: isSelected ? 0.12 : 0.07,
                              ),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(13.r),
                          border: Border.all(
                            color: tint.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Icon(
                          icon ?? Icons.description_outlined,
                          color: tint,
                          size: 21.r,
                        ),
                      ),
                      Gap(12.w),

                      // Title + description column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Top row: title + report-code badge
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: _buildHighlightedTitle(
                                    context,
                                    title,
                                    isSelected ? tint : titleColor,
                                  ),
                                ),
                                if (reportCode != null &&
                                    reportCode!.trim().isNotEmpty) ...[
                                  Gap(6.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 7.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: tint.withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color: tint.withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: Text(
                                      reportCode!,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: tint,
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            if (description.trim().isNotEmpty) ...[
                              Gap(4.h),
                              Text(
                                description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColor.darkTextColor(context),
                                  fontSize: 11.sp,
                                  height: 1.35,
                                ),
                              ),
                            ],

                            // Format chip row
                            Gap(8.h),
                            _FormatChipRow(
                              tint: tint,
                              isArabic: isArabic,
                              onChipTap: (format) async {
                                if (format == 'pdf') {
                                  onExportPdf();
                                } else {
                                  onExportFormat(format);
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      Gap(6.w),

                      // Download button
                      Tooltip(
                        message: isArabic ? 'صيغ التصدير' : 'Export formats',
                        child: Material(
                          color: tint.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(11.r),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(11.r),
                            onTap: () => _showExportFormats(context),
                            child: SizedBox(
                              width: 36.r,
                              height: 36.r,
                              child: Icon(
                                Icons.download_rounded,
                                color: tint,
                                size: 18.r,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
      fontSize: 13.5.sp,
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
      height: 1.3,
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
    final accentColor = AppColor.primaryColor(context);
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, matchIndex)),
          TextSpan(
            text: text.substring(matchIndex, matchEnd),
            style: style.copyWith(
              color: accentColor,
              fontWeight: FontWeight.bold,
              backgroundColor: accentColor.withValues(alpha: 0.12),
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

// ── Format Chip Row ────────────────────────────────────────────────────────────
class _FormatChipRow extends StatelessWidget {
  final Color tint;
  final bool isArabic;
  final Future<void> Function(String format) onChipTap;

  const _FormatChipRow({
    required this.tint,
    required this.isArabic,
    required this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    final chips = <(String, IconData, String, Color)>[
      ('pdf', Icons.picture_as_pdf_rounded, 'PDF', AppColor.roseDanger),
      (
        'excel',
        Icons.table_chart_rounded,
        isArabic ? 'إكسل' : 'Excel',
        AppColor.emeraldTeal,
      ),
      (
        'word',
        Icons.description_rounded,
        isArabic ? 'وورد' : 'Word',
        AppColor.oceanBlue,
      ),
      (
        'excelformatted',
        Icons.grid_on_rounded,
        isArabic ? 'PRO' : 'PRO',
        AppColor.purpleAccent,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: chips.map((chip) {
          final (format, chipIcon, label, color) = chip;
          return Padding(
            padding: EdgeInsetsDirectional.only(end: 6.w),
            child: GestureDetector(
              onTap: () => onChipTap(format),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: color.withValues(alpha: 0.22),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(chipIcon, color: color, size: 11.r),
                    Gap(4.w),
                    Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
