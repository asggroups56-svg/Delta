import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_catalog_data.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_explore_header_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_export_bottom_sheet.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_export_handler_mixin.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_preview_area_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_screen_widgets.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_table_item_widget.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with ReportsExportHandlerMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _searchDebounce;
  String _searchQuery = '';
  int _selectedReportCategory = 0;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_handleSearchFocus);
  }

  void _handleSearchFocus() {
    if (mounted) setState(() {});
  }

  String _normalizeSearchText(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[\u064B-\u0652\u0670]'), '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .trim();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 180), () {
      if (!mounted) return;
      setState(() => _searchQuery = value.trim());
    });
  }

  void _applySearch(String value) {
    _searchDebounce?.cancel();
    _searchController
      ..text = value
      ..selection = TextSelection.collapsed(offset: value.length);
    setState(() {
      _searchQuery = value.trim();
    });
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  Future<void> _toggleLanguage() async {
    if (context.locale.languageCode == 'ar') {
      await context.setLocale(const Locale('en'));
    } else {
      await context.setLocale(const Locale('ar'));
    }
    if (mounted) setState(() {});
  }

  void _showExportModal() {
    ReportsExportBottomSheet.show(
      context,
      onExportReport: handleExportReport,
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchFocusNode.dispose();
    _searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryTabs = [
      AppLocaleKey.allReports.tr(),
      AppLocaleKey.tabFinancials.tr(),
      AppLocaleKey.tabSales.tr(),
      AppLocaleKey.tabInventory.tr(),
      AppLocaleKey.tabTax.tr(),
    ];

    final statements = ReportsCatalogData.getStatements(context);

    final normalizedQuery = _normalizeSearchText(_searchQuery);
    final filteredStatements = statements.where((item) {
      if (_selectedReportCategory != 0 &&
          item['category'] != _selectedReportCategory) {
        return false;
      }
      if (normalizedQuery.isEmpty) {
        return true;
      }

      final title = _normalizeSearchText(item['title'] as String);
      final desc = _normalizeSearchText(item['desc'] as String);
      final code = _normalizeSearchText(item['reportName'] as String? ?? '');
      final category = _normalizeSearchText(
        categoryTabs[(item['category'] as int)],
      );
      return title.contains(normalizedQuery) ||
          desc.contains(normalizedQuery) ||
          code.contains(normalizedQuery) ||
          category.contains(normalizedQuery);
    }).toList();

    final visibleSections = ReportsCatalogData.buildCategorySections(
      context,
      filteredStatements,
    );
    final totalCategories = statements
        .map((statement) => statement['treeGroup'])
        .whereType<String>()
        .toSet()
        .length;

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: ReportsPageHeaderWidget(
                onExport: _showExportModal,
                onToggleLanguage: _toggleLanguage,
                reportCount: statements.length,
                categoryCount: totalCategories,
              ),
            ),
            SliverToBoxAdapter(
              child: ReportsPreviewAreaWidget(
                previewKind: previewKind,
                isGenerating: isGenerating,
                pdfFile: pdfFile,
                previewTitle: previewTitle,
                onClosePreview: closePreview,
              ),
            ),
            SliverToBoxAdapter(child: Gap(14.h)),
            SliverToBoxAdapter(
              child: ReportsSearchFieldWidget(
                controller: _searchController,
                focusNode: _searchFocusNode,
                isFocused: _searchFocusNode.hasFocus,
                hintText: context.locale.languageCode == 'ar'
                    ? 'ابحث في ${statements.length} تقرير...'
                    : 'Search ${statements.length} reports...',
                onChanged: _onSearchChanged,
                onSubmitted: _applySearch,
                onClear: _clearSearch,
              ),
            ),
            SliverToBoxAdapter(
              child: ReportsSearchSummaryWidget(
                query: _searchQuery,
                resultCount: filteredStatements.length,
              ),
            ),
            SliverToBoxAdapter(
              child: ReportsCategoryFilterWidget(
                categories: categoryTabs,
                selectedCategory: _selectedReportCategory,
                reportCounts: [
                  statements.length,
                  statements.where((item) => item['category'] == 1).length,
                  statements.where((item) => item['category'] == 2).length,
                  statements.where((item) => item['category'] == 3).length,
                  statements.where((item) => item['category'] == 4).length,
                ],
                onSelected: (category) => setState(
                  () => _selectedReportCategory = category,
                ),
              ),
            ),
            SliverToBoxAdapter(child: Gap(8.h)),
            if (visibleSections.isNotEmpty)
              SliverToBoxAdapter(
                child: ReportsExploreHeaderWidget(
                  count: filteredStatements.length,
                ),
              ),
            if (visibleSections.isEmpty)
              SliverToBoxAdapter(
                child: ReportsEmptyStateWidget(
                  query: _searchQuery,
                  onClearSearch: _clearSearch,
                  onShowAllReports: _clearSearch,
                ),
              )
            else
              ReportsCategoryAccordionListWidget(
                sections: visibleSections,
                searchQuery: _searchQuery,
                reportBuilder: _buildReportItem,
              ),
            SliverToBoxAdapter(child: Gap(100.h)),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(
    Map<String, dynamic> statement, {
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    return ReportsTableItemWidget(
      title: statement['title'] as String,
      description: statement['desc'] as String,
      reportCode: statement['reportName'] as String?,
      icon: statement['icon'] as IconData?,
      accent: statement['iconColor'] as Color?,
      searchQuery: _searchQuery,
      isSelected: isSelected,
      onSelect: onSelect,
      onExportPdf: () => exportReportFromStatement(statement, 'pdf'),
      onExportFormat: (format) => exportReportFromStatement(statement, format),
    );
  }
}
