import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Page header
// ─────────────────────────────────────────────────────────────────────────────
class ReportsPageHeaderWidget extends StatelessWidget {
  final VoidCallback onExport;
  final VoidCallback onToggleLanguage;
  final int reportCount;
  final int categoryCount;

  const ReportsPageHeaderWidget({
    super.key,
    required this.onExport,
    required this.onToggleLanguage,
    this.reportCount = 0,
    this.categoryCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final subtitle = isArabic
        ? '$reportCount تقرير · $categoryCount أقسام'
        : '$reportCount reports · $categoryCount sections';

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 4.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isArabic ? 'التقارير' : 'Reports',
                  style: TextStyle(
                    color: AppColor.titleFormFiledColor(context),
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                Gap(5.h),
                Row(
                  children: [
                    Container(
                      width: 6.r,
                      height: 6.r,
                      decoration: const BoxDecoration(
                        color: AppColor.emeraldTeal,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(6.w),
                    Flexible(
                      child: Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColor.darkTextColor(context),
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(10.w),
          _HeaderActionButton(
            icon: Icons.download_rounded,
            label: isArabic ? 'تصدير' : 'Export',
            tooltip: AppLocaleKey.exportReport.tr(),
            onPressed: onExport,
            filled: true,
          ),
          Gap(8.w),
          _HeaderActionButton(
            icon: Icons.translate_rounded,
            tooltip: isArabic ? 'English' : 'العربية',
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
  final bool filled;

  const _HeaderActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.label,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = AppColor.primaryColor(context);
    final foreground = filled ? Colors.white : accent;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: filled ? accent : AppColor.cardColor(context),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: filled ? accent : AppColor.borderColor(context),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12.r),
          child: SizedBox(
            height: 40.r,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: filled ? 14.w : 11.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18.r, color: foreground),
                  if (label != null) ...[
                    Gap(5.w),
                    Text(
                      label!,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
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

// ─────────────────────────────────────────────────────────────────────────────
// Search
// ─────────────────────────────────────────────────────────────────────────────
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
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 2.h),
      child:  CustomFormField(
                radius: 12.r,
                controller: controller,
                onChanged: onChanged,
                hintText: hintText ?? AppLocaleKey.searchReports.tr(),
                  hintStyle: TextStyle(
                    color: AppColor.darkTextColor(
                      context,
                    ).withValues(alpha: 0.65),
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w400,
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
    final accent = AppColor.primaryColor(context);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(18.w, 10.h, 18.w, 0),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 13.r,
            color: AppColor.darkTextColor(context),
          ),
          Gap(6.w),
          Expanded(
            child: Text(
              '${AppLocaleKey.searchResultsFor.tr()} "$query"',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5.sp,
                color: AppColor.darkTextColor(context),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '$resultCount',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category sections
// ─────────────────────────────────────────────────────────────────────────────
class ReportsCategorySectionData {
  final int id;
  final String title;
  final IconData icon;
  final Color accent;
  final List<Map<String, dynamic>> reports;

  const ReportsCategorySectionData({
    required this.id,
    required this.title,
    required this.icon,
    required this.accent,
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
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverList.builder(
        itemCount: widget.sections.length,
        itemBuilder: (context, index) {
          final section = widget.sections[index];
          final isExpanded = _expandedSections.contains(section.id);
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildSectionCard(context, section, isExpanded),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    ReportsCategorySectionData section,
    bool isExpanded,
  ) {
    final accent = section.accent;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isExpanded
              ? accent.withValues(alpha: 0.28)
              : AppColor.borderColor(context),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSectionHeader(context, section, isExpanded),
              ClipRect(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: isExpanded
                      ? _buildReportList(context, section)
                      : const SizedBox(width: double.infinity, height: 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    ReportsCategorySectionData section,
    bool isExpanded,
  ) {
    final isArabic = context.locale.languageCode == 'ar';
    final accent = section.accent;

    return InkWell(
      onTap: () {
        setState(() {
          if (isExpanded) {
            _expandedSections.remove(section.id);
          } else {
            _expandedSections.add(section.id);
            if (section.reports.isNotEmpty) {
              _selectedReportId = _reportId(section.reports.first);
            }
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accent.withValues(alpha: 0.18),
                    accent.withValues(alpha: 0.07),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: accent.withValues(alpha: 0.18)),
              ),
              child: Icon(section.icon, color: accent, size: 21.r),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    section.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isExpanded
                          ? accent
                          : AppColor.titleFormFiledColor(context),
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  Gap(3.h),
                  Text(
                    '${section.reports.length} ${isArabic ? 'تقارير' : 'reports'}',
                    style: TextStyle(
                      color: AppColor.darkTextColor(context),
                      fontSize: 11.sp,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Gap(8.w),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22.r,
                color: isExpanded ? accent : AppColor.darkTextColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportList(
    BuildContext context,
    ReportsCategorySectionData section,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColor.borderColor(context))),
      ),
      child: Column(
        children: [
          for (var i = 0; i < section.reports.length; i++) ...[
            if (i > 0)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColor.borderColor(context).withValues(alpha: 0.6),
                ),
              ),
            widget.reportBuilder(
              section.reports[i],
              isSelected: _reportId(section.reports[i]) == _selectedReportId,
              onSelect: () => setState(
                () => _selectedReportId = _reportId(section.reports[i]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────
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
    final accent = AppColor.primaryColor(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(28.r),
        decoration: BoxDecoration(
          color: AppColor.cardColor(context),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: AppColor.borderColor(context)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68.r,
              height: 68.r,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accent.withValues(alpha: 0.16),
                    accent.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: accent.withValues(alpha: 0.18)),
              ),
              child: Icon(Icons.search_off_rounded, size: 30.r, color: accent),
            ),
            Gap(16.h),
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
                fontWeight: FontWeight.w700,
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
                height: 1.55,
                color: AppColor.darkTextColor(context),
              ),
            ),
            Gap(18.h),
            Material(
              color: accent,
              borderRadius: BorderRadius.circular(12.r),
              child: InkWell(
                onTap: hasSearch ? onClearSearch : onShowAllReports,
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 10.h,
                  ),
                  child: Text(
                    hasSearch
                        ? AppLocaleKey.clearSearch.tr()
                        : AppLocaleKey.allReports.tr(),
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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
