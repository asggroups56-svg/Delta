import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class ReportsPageHeaderWidget extends StatelessWidget {
  final int reportCount;
  final VoidCallback onExport;
  final VoidCallback onToggleLanguage;

  const ReportsPageHeaderWidget({
    super.key,
    required this.reportCount,
    required this.onExport,
    required this.onToggleLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 12.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocaleKey.reportsLibraryTitle.tr(),
                  style: TextStyle(
                    color: AppColor.titleFormFiledColor(context),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Gap(4.h),
                Text(
                  '$reportCount ${AppLocaleKey.reportsCount.tr()}',
                  style: TextStyle(
                    color: AppColor.darkTextColor(context),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: AppLocaleKey.exportReport.tr(),
            onPressed: onExport,
            icon: Icon(
              Icons.download_rounded,
              color: AppColor.primaryColor(context),
            ),
          ),
          InkWell(
            onTap: onToggleLanguage,
            borderRadius: BorderRadius.circular(10.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Text(
                isArabic ? 'EN' : 'AR',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor(context),
                ),
              ),
            ),
          ),
        ],
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

  const ReportsSearchFieldWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
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
            hintText: AppLocaleKey.searchReports.tr(),
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

class ReportsCategoryFiltersWidget extends StatelessWidget {
  final List<String> categories;
  final List<int> counts;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ReportsCategoryFiltersWidget({
    super.key,
    required this.categories,
    required this.counts,
    required this.selectedIndex,
    required this.onSelected,
  }) : assert(categories.length == counts.length);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: List.generate(categories.length, (index) {
          final isSelected = selectedIndex == index;
          final accent = AppColor.primaryColor(context);

          return Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: InkWell(
              onTap: () => onSelected(index),
              borderRadius: BorderRadius.circular(16.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(colors: [accent, AppColor.oceanBlue])
                      : null,
                  color: isSelected ? null : AppColor.cardColor(context),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected ? accent : AppColor.borderColor(context),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.28),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppColor.titleFormFiledColor(context),
                      ),
                    ),
                    Gap(6.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : accent.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: Text(
                        '${counts[index]}',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : AppColor.darkTextColor(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
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

class ReportsStatementsSliverWidget extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const ReportsStatementsSliverWidget({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
        ),
      ),
    );
  }
}
