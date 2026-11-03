import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class ReportsPageHeaderWidget extends StatelessWidget {
  final VoidCallback onExport;
  final VoidCallback onToggleLanguage;

  const ReportsPageHeaderWidget({
    super.key,
    required this.onExport,
    required this.onToggleLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              isArabic ? 'التقارير' : 'Reports',
              style: TextStyle(
                color: AppColor.royalNavy,
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _HeaderActionButton(
            icon: Icons.download_outlined,
            tooltip: AppLocaleKey.exportReport.tr(),
            onPressed: onExport,
          ),
          Gap(8.w),
          _HeaderActionButton(
            icon: Icons.translate_rounded,
            tooltip: isArabic ? 'English' : 'العربية',
            label: isArabic ? 'EN' : 'AR',
            onPressed: onToggleLanguage,
          ),
        ],
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final String? label;
  final VoidCallback onPressed;

  const _HeaderActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColor.cardColor(context),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor.borderColor(context)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12.r),
          child: SizedBox(
            height: 42.r,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 19.r, color: AppColor.royalNavy),
                  if (label != null) ...[
                    Gap(5.w),
                    Text(
                      label!,
                      style: TextStyle(
                        color: AppColor.royalNavy,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReportsSearchFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final String? hintText;

  const ReportsSearchFieldWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final hasSearchText = controller.text.isNotEmpty;
    final accent = AppColor.primaryColor(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppColor.cardSurfaceColor(context),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: hasSearchText || isFocused
                ? accent.withValues(alpha: 0.65)
                : AppColor.borderColor(context),
            width: isFocused ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: isFocused ? 0.09 : 0.025),
              blurRadius: isFocused ? 14 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            color: AppColor.titleFormFiledColor(context),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText ?? AppLocaleKey.searchReports.tr(),
            hintStyle: TextStyle(
              color: AppColor.darkTextColor(context),
              fontSize: 13.sp,
            ),
            prefixIcon: Container(
              margin: EdgeInsetsDirectional.fromSTEB(10.w, 8.h, 8.w, 8.h),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Icon(Icons.search_rounded, color: accent, size: 20.r),
            ),
            suffixIcon: hasSearchText
                ? IconButton(
                    tooltip: AppLocaleKey.clearSearch.tr(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColor.darkTextColor(context),
                      size: 18.r,
                    ),
                    onPressed: onClear,
                  )
                : null,
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 13.h,
            ),
          ),
        ),
      ),
    );
  }
}

class ReportsSearchSummaryWidget extends StatelessWidget {
  final String query;
  final int resultCount;

  const ReportsSearchSummaryWidget({
    super.key,
    required this.query,
    required this.resultCount,
  });

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(18.w, 8.h, 18.w, 0),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 14.r,
            color: AppColor.darkTextColor(context),
          ),
          Gap(6.w),
          Expanded(
            child: Text(
              '${AppLocaleKey.searchResultsFor.tr()} "$query"',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColor.darkTextColor(context),
              ),
            ),
          ),
          Text(
            '$resultCount',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class ReportsCategorySectionData {
  final int id;
  final String title;
  final List<Map<String, dynamic>> reports;

  const ReportsCategorySectionData({
    required this.id,
    required this.title,
    required this.reports,
  });
}

class ReportsCategoryAccordionListWidget extends StatefulWidget {
  final List<ReportsCategorySectionData> sections;
  final String searchQuery;
  final Widget Function(
    Map<String, dynamic> report, {
    required bool isSelected,
    required VoidCallback onSelect,
  })
  reportBuilder;

  const ReportsCategoryAccordionListWidget({
    super.key,
    required this.sections,
    required this.searchQuery,
    required this.reportBuilder,
  });

  @override
  State<ReportsCategoryAccordionListWidget> createState() =>
      _ReportsCategoryAccordionListWidgetState();
}

class _ReportsCategoryAccordionListWidgetState
    extends State<ReportsCategoryAccordionListWidget> {
  final Set<int> _expandedSections = {};
  Object? _selectedReportId;

  Object? _reportId(Map<String, dynamic> report) =>
      report['id'] ?? report['reportName'] ?? report['title'];

  @override
  void initState() {
    super.initState();
    _restoreDefaultExpandedSection();
  }

  @override
  void didUpdateWidget(covariant ReportsCategoryAccordionListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery.trim() != widget.searchQuery.trim()) {
      _expandedSections
        ..clear()
        ..addAll(
          widget.searchQuery.trim().isNotEmpty
              ? widget.sections.map((section) => section.id)
              : _defaultExpandedSectionIds(),
        );
      if (widget.searchQuery.trim().isEmpty) {
        _selectFirstReportInDefaultSection();
      }
    } else if (oldWidget.sections.isEmpty && widget.sections.isNotEmpty) {
      _restoreDefaultExpandedSection();
    }
  }

  Set<int> _defaultExpandedSectionIds() {
    final costCenters = widget.sections.where((section) => section.id == 2);
    final centersComparison = widget.sections.where(
      (section) => section.id == 3,
    );
    final accountCentersComparison = widget.sections.where(
      (section) => section.id == 9,
    );
    if (costCenters.isNotEmpty ||
        centersComparison.isNotEmpty ||
        accountCentersComparison.isNotEmpty) {
      return {
        if (costCenters.isNotEmpty) costCenters.first.id,
        if (centersComparison.isNotEmpty) centersComparison.first.id,
        if (accountCentersComparison.isNotEmpty)
          accountCentersComparison.first.id,
      };
    }
    return widget.sections.isEmpty ? {} : {widget.sections.first.id};
  }

  void _restoreDefaultExpandedSection() {
    _expandedSections
      ..clear()
      ..addAll(_defaultExpandedSectionIds());
    _selectFirstReportInDefaultSection();
  }

  void _selectFirstReportInDefaultSection() {
    final expanded = widget.sections.where(
      (section) => _expandedSections.contains(section.id),
    );
    _selectedReportId = expanded.isEmpty || expanded.first.reports.isEmpty
        ? null
        : _reportId(expanded.first.reports.first);
  }

  @override
  Widget build(BuildContext context) {
    final rows =
        <
          ({
            ReportsCategorySectionData section,
            Map<String, dynamic>? report,
            bool selected,
          })
        >[];
    for (final section in widget.sections) {
      final isExpanded = _expandedSections.contains(section.id);
      rows.add((section: section, report: null, selected: false));
      if (isExpanded) {
        for (final report in section.reports) {
          rows.add((
            section: section,
            report: report,
            selected: _reportId(report) == _selectedReportId,
          ));
        }
      }
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverList.builder(
        itemCount: rows.length,
        itemBuilder: (context, index) {
          final row = rows[index];
          final isFirst = index == 0;
          final isLast = index == rows.length - 1;
          final isExpanded = _expandedSections.contains(row.section.id);
          final isGroupHeader = row.report == null;
          final accent = AppColor.primaryColor(context);
          final backgroundColor = isGroupHeader
              ? (isExpanded
                    ? accent.withValues(alpha: 0.09)
                    : AppColor.cardColor(context))
              : AppColor.cardSurfaceColor(context);

          return Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                left: BorderSide(color: AppColor.borderColor(context)),
                right: BorderSide(color: AppColor.borderColor(context)),
                top: isFirst
                    ? BorderSide(color: AppColor.borderColor(context))
                    : BorderSide.none,
                bottom: BorderSide(color: AppColor.borderColor(context)),
              ),
              borderRadius: BorderRadius.vertical(
                top: isFirst ? Radius.circular(16.r) : Radius.zero,
                bottom: isLast ? Radius.circular(16.r) : Radius.zero,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: isGroupHeader
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedSections.remove(row.section.id);
                          } else {
                            _expandedSections.add(row.section.id);
                            if (row.section.reports.isNotEmpty) {
                              _selectedReportId = _reportId(
                                row.section.reports.first,
                              );
                            }
                          }
                        });
                      },
                      child: SizedBox(
                        height: 55.h,
                        child: Row(
                          children: [
                            if (Directionality.of(context) ==
                                ui.TextDirection.rtl)
                              _buildActiveEdge(isExpanded, accent),
                            if (Directionality.of(context) !=
                                ui.TextDirection.rtl)
                              _buildSectionArrow(isExpanded, accent, context),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Text(
                                  row.section.title,
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isExpanded
                                        ? accent
                                        : AppColor.titleFormFiledColor(context),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            if (Directionality.of(context) ==
                                ui.TextDirection.rtl)
                              _buildSectionArrow(isExpanded, accent, context),
                            if (Directionality.of(context) !=
                                ui.TextDirection.rtl)
                              _buildActiveEdge(isExpanded, accent),
                          ],
                        ),
                      ),
                    ),
                  )
                : widget.reportBuilder(
                    row.report!,
                    isSelected: row.selected,
                    onSelect: () => setState(
                      () => _selectedReportId = _reportId(row.report!),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildSectionArrow(
    bool isExpanded,
    Color accent,
    BuildContext context,
  ) {
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    return SizedBox(
      width: 40.w,
      child: Icon(
        isExpanded
            ? Icons.keyboard_arrow_down_rounded
            : (isRtl
                  ? Icons.chevron_left_rounded
                  : Icons.chevron_right_rounded),
        size: 21.r,
        color: isExpanded ? accent : AppColor.darkTextColor(context),
      ),
    );
  }

  Widget _buildActiveEdge(bool isExpanded, Color accent) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 3.w,
      height: double.infinity,
      color: isExpanded ? accent : Colors.transparent,
    );
  }
}

class ReportsEmptyStateWidget extends StatelessWidget {
  final String query;
  final VoidCallback onClearSearch;
  final VoidCallback onShowAllReports;

  const ReportsEmptyStateWidget({
    super.key,
    required this.query,
    required this.onClearSearch,
    required this.onShowAllReports,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final hasSearch = query.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 28.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(28.r),
        decoration: BoxDecoration(
          color: AppColor.cardColor(context),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColor.borderColor(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColor.primaryColor(context).withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.primaryColor(context).withValues(alpha: 0.16),
                ),
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 32.r,
                color: AppColor.primaryColor(context),
              ),
            ),
            Gap(14.h),
            Text(
              hasSearch
                  ? (isArabic
                        ? 'لا توجد نتائج لـ "$query"'
                        : 'No results for "$query"')
                  : (isArabic
                        ? 'لا توجد تقارير في هذا القسم'
                        : 'No reports in this section'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.titleFormFiledColor(context),
              ),
            ),
            Gap(6.h),
            Text(
              hasSearch
                  ? (isArabic
                        ? 'جرّب البحث برقم التقرير أو باسم آخر، أو امسح البحث لعرض كل التقارير'
                        : 'Try a report code or another keyword, or clear the search to view all reports')
                  : (isArabic
                        ? 'اختر قسماً آخر أو اعرض كل التقارير'
                        : 'Select another category or view all reports'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.5,
                color: AppColor.darkTextColor(context),
              ),
            ),
            Gap(14.h),
            InkWell(
              onTap: hasSearch ? onClearSearch : onShowAllReports,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColor.primaryColor(
                      context,
                    ).withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  hasSearch
                      ? AppLocaleKey.clearSearch.tr()
                      : AppLocaleKey.allReports.tr(),
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
