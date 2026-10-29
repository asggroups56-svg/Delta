import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/custom_widgets/date_range_bottom_sheet_widget.dart';
import 'package:my_template/core/custom_widgets/month_range_bottom_sheet_widget.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/home/presentation/view/widget/ai_chat_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/data/repository/reports_repo.dart';
import 'package:my_template/features/reports/presentation/view/widget/file_download_service.dart';
import 'package:my_template/features/reports/presentation/view/widget/account_statement_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/cost_centers_projects_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/fullscreen_pdf_viewer_screen.dart';
import 'package:my_template/features/reports/presentation/view/widget/ledger_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/monthly_comparison_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/party_vat_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/pdf_export_service.dart';
import 'package:my_template/features/reports/presentation/view/widget/pdf_preview_panel.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_chart_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_donut_chart_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_kpi_card_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_table_item_widget.dart';
import 'package:my_template/features/lookup/presentation/widgets/customer_datum_dropdown.dart';

enum _PreviewKind { none, pdf }

class _ReportOption {
  final String title;
  final String description;
  final String reportName;
  final int? financialStatementReportType;

  const _ReportOption({
    required this.title,
    required this.description,
    required this.reportName,
    this.financialStatementReportType,
  });
}

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // ── State ────────────────────────────────────────────────────────────────
  int _selectedPeriodIndex = 2;
  int _selectedCategoryTab = 0;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _searchDebounce;
  String _searchQuery = '';

  // ── Preview state ────────────────────────────────────────────────────────
  _PreviewKind _previewKind = _PreviewKind.none;
  File? _pdfFile;
  String _previewTitle = '';
  bool _isGenerating = false;

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
    if (value.trim().isNotEmpty && _selectedCategoryTab != 0) {
      setState(() => _selectedCategoryTab = 0);
    }
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
      _selectedCategoryTab = 0;
    });
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  Future<_ReportOption?> _selectReportOption({
    required String title,
    required List<_ReportOption> options,
  }) {
    return showModalBottomSheet<_ReportOption>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.85,
        ),
        decoration: BoxDecoration(
          color: AppColor.cardColor(sheetContext),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
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
              Gap(18.h),
              Text(
                title,
                style: TextStyle(
                  color: AppColor.titleFormFiledColor(sheetContext),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(10.h),
              ...options.map(
                (option) => Card(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(option.title),
                    subtitle: Text(
                      '${option.description}\n${option.reportName}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_left_rounded),
                    onTap: () => Navigator.pop(sheetContext, option),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int?> _selectCostCenterType() {
    final options = [
      (type: 2, label: AppLocaleKey.allCostCenters.tr()),
      (type: 0, label: AppLocaleKey.mainCostCenters.tr()),
      (type: 1, label: AppLocaleKey.subCostCenters.tr()),
    ];

    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        decoration: BoxDecoration(
          color: AppColor.cardColor(sheetContext),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(color: AppColor.borderColor(sheetContext)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColor.darkTextColor(sheetContext),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            Gap(16.h),
            Text(
              AppLocaleKey.selectCostCenterType.tr(),
              style: TextStyle(
                color: AppColor.titleFormFiledColor(sheetContext),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(8.h),
            ...options.map(
              (option) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.account_tree_outlined,
                  color: AppColor.emeraldTeal,
                ),
                title: Text(
                  option.label,
                  style: TextStyle(
                    color: AppColor.titleFormFiledColor(sheetContext),
                    fontSize: 14.sp,
                  ),
                ),
                onTap: () => Navigator.pop(sheetContext, option.type),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Language ─────────────────────────────────────────────────────────────
  Future<void> _toggleLanguage() async {
    if (context.locale.languageCode == 'ar') {
      await context.setLocale(const Locale('en'));
    } else {
      await context.setLocale(const Locale('ar'));
    }
    if (mounted) setState(() {});
  }

  // ── AI Chat ──────────────────────────────────────────────────────────────
  void _openAiChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AiChatBottomSheetWidget(),
    );
  }

  // ── Export Modal (اختيار نوع التصدير) ────────────────────────────────────
  void _showExportModal() {
    var selectedExportType = 'pdf';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(ctx).height * 0.85,
          ),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColor.cardColor(context),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            border: Border.all(color: AppColor.borderColor(context)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColor.darkTextColor(context),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                Gap(16.h),
                Text(
                  AppLocaleKey.exportReport.tr(),
                  style: TextStyle(
                    color: AppColor.titleFormFiledColor(context),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(16.h),
                Row(
                  children: [
                    Expanded(
                      child: _formatSelectCard(
                        icon: Icons.picture_as_pdf_rounded,
                        label: 'PDF',
                        color: const Color(0xFFEF4444),
                        isSelected: selectedExportType == 'pdf',
                        onTap: () =>
                            setModalState(() => selectedExportType = 'pdf'),
                      ),
                    ),
                    Gap(8.w),
                    Expanded(
                      child: _formatSelectCard(
                        icon: Icons.table_chart_rounded,
                        label: 'Excel',
                        color: const Color(0xFF10B981),
                        isSelected: selectedExportType == 'excel',
                        onTap: () =>
                            setModalState(() => selectedExportType = 'excel'),
                      ),
                    ),
                    Gap(8.w),
                    Expanded(
                      child: _formatSelectCard(
                        icon: Icons.description_rounded,
                        label: 'Word',
                        color: const Color(0xFF3B82F6),
                        isSelected: selectedExportType == 'word',
                        onTap: () =>
                            setModalState(() => selectedExportType = 'word'),
                      ),
                    ),
                    Gap(8.w),
                    Expanded(
                      child: _formatSelectCard(
                        icon: Icons.grid_on_rounded,
                        label: 'PRO',
                        color: const Color(0xFF8B5CF6),
                        isSelected: selectedExportType == 'excelformatted',
                        onTap: () => setModalState(
                          () => selectedExportType = 'excelformatted',
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(16.h),
                _buildExportOption(
                  icon: Icons.account_tree_rounded,
                  color: AppColor.oceanBlue,
                  title: AppLocaleKey.statementChartOfAccount.tr(),
                  subtitle: 'Report/ChartOfAccountReport (AGL001)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementChartOfAccount.tr(),
                      description: AppLocaleKey.statementChartOfAccountDesc
                          .tr(),
                      amount: '',
                      date: '',
                      status: AppLocaleKey.statusAudited.tr(),
                      reportName: 'AGL001',
                      isApiReport: true,
                      exportType: selectedExportType,
                    );
                  },
                ),
                Gap(10.h),
                _buildExportOption(
                  icon: Icons.show_chart_rounded,
                  color: AppColor.emeraldTeal,
                  title: AppLocaleKey.statementIncome.tr(),
                  subtitle: 'Report/IncomeAndExpenseSituationReport (AGL300_M)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementIncome.tr(),
                      description: AppLocaleKey.statementIncomeDesc.tr(),
                      amount: '',
                      date: '',
                      status: AppLocaleKey.statusAudited.tr(),
                      reportName: 'AGL300_M',
                      isIncomeAndExpenseSituationReport: true,
                      exportType: selectedExportType,
                    );
                  },
                ),
                Gap(10.h),
                _buildExportOption(
                  icon: Icons.calendar_view_day_rounded,
                  color: AppColor.oceanBlue,
                  title: AppLocaleKey.statementDailyIncome.tr(),
                  subtitle: 'Report/IncomeAndExpenseSituationReport (AGL300_D)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementDailyIncome.tr(),
                      description: AppLocaleKey.statementDailyIncomeDesc.tr(),
                      amount: '',
                      date: '',
                      status: AppLocaleKey.statusAudited.tr(),
                      reportName: 'AGL300_D',
                      isDailyIncomeAndExpenseReport: true,
                      exportType: selectedExportType,
                    );
                  },
                ),
                Gap(10.h),
                _buildExportOption(
                  icon: Icons.receipt_long_outlined,
                  color: AppColor.purpleAccent,
                  title: AppLocaleKey.statementExpensesWithVat.tr(),
                  subtitle: 'Report/ExpensesWithVatReport (AGL1001E)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementExpensesWithVat.tr(),
                      description: AppLocaleKey.statementExpensesWithVatDesc
                          .tr(),
                      amount: '',
                      date: '',
                      status: AppLocaleKey.statusAudited.tr(),
                      reportName: 'AGL1001E',
                      isExpensesWithVatReport: true,
                      exportType: selectedExportType,
                    );
                  },
                ),
                Gap(10.h),
                _buildExportOption(
                  icon: Icons.point_of_sale_rounded,
                  color: AppColor.emeraldTeal,
                  title: AppLocaleKey.statementSalesWithVat.tr(),
                  subtitle: 'Report/SalesWithVatReport (AAR1000)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementSalesWithVat.tr(),
                      description: AppLocaleKey.statementSalesWithVatDesc.tr(),
                      amount: '',
                      date: '',
                      status: AppLocaleKey.statusAudited.tr(),
                      reportName: 'AAR1000',
                      isSalesWithVatReport: true,
                      exportType: selectedExportType,
                    );
                  },
                ),
                Gap(10.h),
                _buildExportOption(
                  icon: Icons.shopping_bag_rounded,
                  color: AppColor.oceanBlue,
                  title: AppLocaleKey.statementPurchasesWithVat.tr(),
                  subtitle: 'Report/PurchasesWithVatReport (AAR1001)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementPurchasesWithVat.tr(),
                      description: AppLocaleKey.statementPurchasesWithVatDesc
                          .tr(),
                      amount: '',
                      date: '',
                      status: AppLocaleKey.statusAudited.tr(),
                      reportName: 'AAR1001',
                      isPurchasesWithVatReport: true,
                      exportType: selectedExportType,
                    );
                  },
                ),
                Gap(10.h),
                _buildExportOption(
                  icon: Icons.menu_book_rounded,
                  color: AppColor.oceanBlue,
                  title: AppLocaleKey.statementLedger.tr(),
                  subtitle: 'Report/LedgerReportForAllAccounts (AGL025)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementLedger.tr(),
                      description: AppLocaleKey.statementLedgerDesc.tr(),
                      amount: '',
                      date: '',
                      status: AppLocaleKey.statusAudited.tr(),
                      reportName: 'AGL025',
                      isLedgerReport: true,
                      exportType: selectedExportType,
                    );
                  },
                ),
                Gap(10.h),
                _buildExportOption(
                  icon: Icons.receipt_long_rounded,
                  color: AppColor.oceanBlue,
                  title: AppLocaleKey.statementAccountStatement.tr(),
                  subtitle: 'Report/AccountStatementReport (AGL079)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementAccountStatement.tr(),
                      description: AppLocaleKey.statementAccountStatementDesc
                          .tr(),
                      amount: '',
                      date: '',
                      status: AppLocaleKey.statusAudited.tr(),
                      reportName: 'AGL079',
                      isAccountStatementReport: true,
                      exportType: selectedExportType,
                    );
                  },
                ),
                Gap(10.h),
                _buildExportOption(
                  icon: Icons.account_balance_wallet_outlined,
                  color: AppColor.emeraldTeal,
                  title: AppLocaleKey.statementTrialBalanceByCategories.tr(),
                  subtitle: 'Report/TrialBalanceByCategoriesReport (AGL055)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementTrialBalanceByCategories
                          .tr(),
                      description: AppLocaleKey
                          .statementTrialBalanceByCategoriesDesc
                          .tr(),
                      amount: '',
                      date: '',
                      status: AppLocaleKey.statusAudited.tr(),
                      reportName: 'AGL055',
                      isTrialBalanceByCategoriesReport: true,
                      exportType: selectedExportType,
                    );
                  },
                ),
                Gap(10.h),
                _buildExportOption(
                  icon: Icons.business_outlined,
                  color: AppColor.purpleAccent,
                  title: AppLocaleKey.statementCostCenters.tr(),
                  subtitle: 'Report/CostCentersReport (AGL007)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementCostCenters.tr(),
                      description: AppLocaleKey.statementCostCentersDesc.tr(),
                      amount: '',
                      date: '',
                      status: AppLocaleKey.statusAudited.tr(),
                      reportName: 'AGL007',
                      isCostCentersReport: true,
                      exportType: selectedExportType,
                    );
                  },
                ),
                Gap(10.h),
                _buildExportOption(
                  icon: Icons.domain_rounded,
                  color: AppColor.oceanBlue,
                  title: AppLocaleKey.statementCostCentersProjects.tr(),
                  subtitle: 'Report/CostCentersProjectsReport (Agl026)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementCostCentersProjects.tr(),
                      description: AppLocaleKey.statementCostCentersProjectsDesc
                          .tr(),
                      amount: '',
                      date: '',
                      status: AppLocaleKey.statusAudited.tr(),
                      reportName: 'Agl026_Project2',
                      isCostCentersProjectsReport: true,
                      exportType: selectedExportType,
                    );
                  },
                ),
                Gap(10.h),
                _buildExportOption(
                  icon: Icons.compare_arrows_rounded,
                  color: AppColor.oceanBlue,
                  title: AppLocaleKey.statementMonthlyAccountsComparison.tr(),
                  subtitle: 'Report/MonthlyAccountComparsionReport (AGL003)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementMonthlyAccountsComparison
                          .tr(),
                      description: AppLocaleKey
                          .statementMonthlyAccountsComparisonDesc
                          .tr(),
                      amount: '',
                      date: '',
                      status: AppLocaleKey.statusAudited.tr(),
                      reportName: 'AGL003_Bar',
                      isMonthlyAccountComparisonReport: true,
                      exportType: selectedExportType,
                    );
                  },
                ),
                Gap(10.h),
                _buildExportOption(
                  icon: Icons.insights_rounded,
                  color: AppColor.purpleAccent,
                  title: AppLocaleKey.statementMonthlyCostCentersComparison
                      .tr(),
                  subtitle:
                      'Report/MonthlyCostCentersComparsionReport (AGL008)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementMonthlyCostCentersComparison
                          .tr(),
                      description: AppLocaleKey
                          .statementMonthlyCostCentersComparisonDesc
                          .tr(),
                      amount: '',
                      date: '',
                      status: AppLocaleKey.statusAudited.tr(),
                      reportName: 'AGL008_Chart',
                      isMonthlyCostCentersComparisonReport: true,
                      exportType: selectedExportType,
                    );
                  },
                ),
                Gap(10.h),
                _buildExportOption(
                  icon: Icons.share_rounded,
                  color: AppColor.purpleAccent,
                  title: AppLocaleKey.shareReport.tr(),
                  subtitle: 'Direct Link & Board Presentation Format',
                  onTap: () {
                    Navigator.pop(ctx);
                    CommonMethods.showToast(
                      message: AppLocaleKey.reportExportSuccess.tr(),
                      type: ToastType.success,
                    );
                  },
                ),
                Gap(20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20.r),
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
                      color: AppColor.titleFormFiledColor(context),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColor.darkTextColor(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColor.darkTextColor(context),
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _formatSelectCard({
    required IconData icon,
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.18)
              : AppColor.primaryColor(context).withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? color : AppColor.borderColor(context),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20.r, color: color),
            Gap(4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? color
                    : AppColor.titleFormFiledColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Report Export ────────────────────────────────────────────────────────
  Future<void> _handleExportReport({
    required String title,
    required String description,
    required String amount,
    required String date,
    required String status,
    String exportType = 'pdf',
    String? reportName,
    bool isApiReport = false,
    bool isIncomeAndExpenseSituationReport = false,
    bool isDailyIncomeAndExpenseReport = false,
    bool isExpensesWithVatReport = false,
    bool isSalesWithVatReport = false,
    bool isPurchasesWithVatReport = false,
    bool isLedgerReport = false,
    bool isAccountStatementReport = false,
    bool isTrialBalanceByCategoriesReport = false,
    bool isFinancialStatementsReport = false,
    bool isCostCentersReport = false,
    bool isCostCentersProjectsReport = false,
    bool isMonthlyAccountComparisonReport = false,
    bool isMonthlyCostCentersComparisonReport = false,
  }) async {
    final languageCode = context.locale.languageCode;
    if (isTrialBalanceByCategoriesReport) {
      final selection = await _selectReportOption(
        title: 'اختر طريقة ترتيب ميزان المراجعة',
        options: const [
          _ReportOption(
            title: 'بدون ترتيب',
            description: 'ميزان المراجعة حسب الفئات',
            reportName: 'AGL055',
          ),
          _ReportOption(
            title: 'ترتيب رقمي',
            description: 'عرض الحسابات بترتيب رقمي',
            reportName: 'AGL055H',
          ),
          _ReportOption(
            title: 'ترتيب شجري',
            description: 'عرض الحسابات كتسلسل شجري',
            reportName: 'AGL055H',
          ),
        ],
      );
      if (!mounted || selection == null) return;
      reportName = selection.reportName;
    }

    _ReportOption? financialStatementSelection;
    if (isFinancialStatementsReport) {
      financialStatementSelection = await _selectReportOption(
        title: 'اختر نوع القائمة المالية',
        options: const [
          _ReportOption(
            title: 'الأرباح والخسائر',
            description: 'قائمة الأرباح والخسائر',
            reportName: 'AGL035',
            financialStatementReportType: 2,
          ),
          _ReportOption(
            title: 'الميزانية العمومية',
            description: 'بيان الأصول والخصوم وحقوق الملكية',
            reportName: 'AGL036',
            financialStatementReportType: 3,
          ),
          _ReportOption(
            title: 'قائمة الدخل',
            description: 'بيان الدخل والإيرادات والمصروفات',
            reportName: 'AGL069',
            financialStatementReportType: 4,
          ),
          _ReportOption(
            title: 'التدفقات النقدية',
            description: 'التدفقات التشغيلية والاستثمارية والتمويلية',
            reportName: 'AGL073',
            financialStatementReportType: 5,
          ),
        ],
      );
      if (!mounted || financialStatementSelection == null) return;
      reportName = financialStatementSelection.reportName;
    }

    MonthRangeSelection? monthRange;
    if (isIncomeAndExpenseSituationReport) {
      monthRange = await MonthRangeBottomSheetWidget.show(
        context,
        title: AppLocaleKey.selectMonthRange.tr(),
      );
      if (!mounted || monthRange == null) return;
    }
    LedgerReportFilterSelection? ledgerFilter;
    if (isLedgerReport) {
      ledgerFilter = await LedgerReportFilterBottomSheetWidget.show(
        context,
        title: title,
      );
      if (!mounted || ledgerFilter == null) return;
    }
    AccountStatementFilterSelection? accountStatementFilter;
    if (isAccountStatementReport) {
      accountStatementFilter =
          await AccountStatementFilterBottomSheetWidget.show(
            context,
            title: title,
          );
      if (!mounted || accountStatementFilter == null) return;
    }
    PartyVatReportFilterSelection? partyVatFilter;
    if (isSalesWithVatReport || isPurchasesWithVatReport) {
      partyVatFilter = await PartyVatReportFilterBottomSheetWidget.show(
        context,
        title: title,
        reportCode: isSalesWithVatReport ? 'AAR1000' : 'AAR1001',
        type: isSalesWithVatReport
            ? CustomerDatumType.customer
            : CustomerDatumType.supplier,
      );
      if (!mounted || partyVatFilter == null) return;
    }
    DateRangeSelection? dateRange;
    if (isDailyIncomeAndExpenseReport || isExpensesWithVatReport) {
      dateRange = await DateRangeBottomSheetWidget.show(
        context,
        title: AppLocaleKey.selectDateRange.tr(),
        allowAllDates: isExpensesWithVatReport,
      );
      if (!mounted || dateRange == null) return;
    }
    int? costCenterType;
    if (isCostCentersReport) {
      costCenterType = await _selectCostCenterType();
      if (!mounted || costCenterType == null) return;
    }
    CostCentersProjectsReportFilterSelection? costCentersProjectsFilter;
    if (isCostCentersProjectsReport) {
      costCentersProjectsFilter =
          await CostCentersProjectsReportFilterBottomSheetWidget.show(
            context,
            title: title,
            initialReportName: reportName ?? 'Agl026_Project2',
          );
      if (!mounted || costCentersProjectsFilter == null) return;
    }
    MonthlyComparisonReportFilterSelection? monthlyComparisonFilter;
    if (isMonthlyAccountComparisonReport ||
        isMonthlyCostCentersComparisonReport) {
      monthlyComparisonFilter =
          await MonthlyComparisonReportFilterBottomSheetWidget.show(
            context,
            title: title,
            mode: isMonthlyAccountComparisonReport
                ? MonthlyComparisonReportMode.accounts
                : MonthlyComparisonReportMode.costCenters,
          );
      if (!mounted || monthlyComparisonFilter == null) return;
      reportName = monthlyComparisonFilter.reportName;
    }

    setState(() {
      _isGenerating = true;
      _previewTitle = title;
    });
    _showReportPreparationDialog();

    try {
      final File file;
      if (isApiReport ||
          isIncomeAndExpenseSituationReport ||
          isDailyIncomeAndExpenseReport ||
          isExpensesWithVatReport ||
          isSalesWithVatReport ||
          isPurchasesWithVatReport ||
          isLedgerReport ||
          isAccountStatementReport ||
          isTrialBalanceByCategoriesReport ||
          isFinancialStatementsReport ||
          isCostCentersReport ||
          isCostCentersProjectsReport ||
          isMonthlyAccountComparisonReport ||
          isMonthlyCostCentersComparisonReport ||
          reportName != null) {
        final reportsRepo = sl<ReportsRepo>();
        final result = isFinancialStatementsReport
            ? await reportsRepo.getFinancialStatementsReport(
                financialStatementReportType:
                    financialStatementSelection!.financialStatementReportType!,
                reportName: reportName!,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isIncomeAndExpenseSituationReport
            ? await reportsRepo.getIncomeAndExpenseSituationReport(
                fromMonth: monthRange?.fromMonth,
                toMonth: monthRange?.toMonth,
                exportType: exportType,
              )
            : isDailyIncomeAndExpenseReport
            ? await reportsRepo.getDailyIncomeAndExpenseSituationReport(
                fromDate: dateRange?.fromDate,
                toDate: dateRange?.toDate,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isExpensesWithVatReport
            ? await reportsRepo.getExpensesWithVatReport(
                fromVoucherDate: dateRange?.fromDate,
                toVoucherDate: dateRange?.toDate,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isSalesWithVatReport
            ? await reportsRepo.getSalesWithVatReport(
                fromCustomerNo: partyVatFilter?.fromCustomerNo,
                toCustomerNo: partyVatFilter?.toCustomerNo,
                fromTransDate: partyVatFilter?.fromTransDate,
                toTransDate: partyVatFilter?.toTransDate,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isPurchasesWithVatReport
            ? await reportsRepo.getPurchasesWithVatReport(
                fromCustomerNo: partyVatFilter?.fromCustomerNo,
                toCustomerNo: partyVatFilter?.toCustomerNo,
                fromTransDate: partyVatFilter?.fromTransDate,
                toTransDate: partyVatFilter?.toTransDate,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isLedgerReport
            ? await reportsRepo.getLedgerReportForAllAccounts(
                fromDate: ledgerFilter?.fromDate,
                toDate: ledgerFilter?.toDate,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isAccountStatementReport
            ? await reportsRepo.getAccountStatementReport(
                subVoucherAccountNo:
                    accountStatementFilter?.subVoucherAccountNo,
                subVoucherOraDate: accountStatementFilter?.subVoucherOraDate,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isTrialBalanceByCategoriesReport
            ? await reportsRepo.getTrialBalanceByCategoriesReport(
                reportName: reportName ?? 'AGL055',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isCostCentersReport
            ? await reportsRepo.getCostCentersReport(
                costCenterType: costCenterType!,
                languageCode: languageCode,
                exportType: exportType,
              )
            : isCostCentersProjectsReport
            ? await reportsRepo.getCostCentersProjectsReport(
                fromCostCenterNo: costCentersProjectsFilter?.fromCostCenterNo,
                toCostCenterNo: costCentersProjectsFilter?.toCostCenterNo,
                fromDate: costCentersProjectsFilter?.fromDate,
                toDate: costCentersProjectsFilter?.toDate,
                reportName:
                    costCentersProjectsFilter?.reportName ??
                    reportName ??
                    'Agl026_Project2',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isMonthlyAccountComparisonReport
            ? await reportsRepo.getMonthlyAccountComparisonReport(
                fromAccountNo: monthlyComparisonFilter?.fromNo,
                toAccountNo: monthlyComparisonFilter?.toNo,
                accountType: monthlyComparisonFilter?.accountType ?? 3,
                reportName: monthlyComparisonFilter?.reportName ?? 'AGL003_Bar',
                languageCode: languageCode,
                exportType: exportType,
              )
            : isMonthlyCostCentersComparisonReport
            ? await reportsRepo.getMonthlyCostCentersComparisonReport(
                fromCostCenterNo: monthlyComparisonFilter?.fromNo,
                toCostCenterNo: monthlyComparisonFilter?.toNo,
                accountType: monthlyComparisonFilter?.accountType ?? 3,
                reportName:
                    monthlyComparisonFilter?.reportName ?? 'AGL008_Chart',
                languageCode: languageCode,
                exportType: exportType,
              )
            : await reportsRepo.getChartOfAccountReport(
                reportName: reportName ?? 'AGL001',
                exportType: exportType,
              );

        file = result.fold(
          (failure) => throw Exception(failure.errMessage),
          (savedFile) => savedFile,
        );
      } else {
        if (exportType != 'pdf') {
          throw UnsupportedError(
            'صيغة ${_exportFormatLabel(exportType)} غير مدعومة لهذا التقرير',
          );
        }
        file = await PdfExportService.generate(
          title: title,
          description: description,
          amount: amount,
          date: date,
          status: status,
        );
      }

      if (!mounted) return;

      // ── حفظ وتنزيل الملف تلقائياً في مجلد التنزيلات بالجهاز ──
      final baseName = reportName != null && reportName.isNotEmpty
          ? reportName
          : title;
      final fileName =
          '${baseName.replaceAll(RegExp(r'\s+'), '_')}_${DateTime.now().millisecondsSinceEpoch}.${_fileExtension(exportType)}';
      final savedFile = await FileDownloadService.saveFileToDevice(
        sourceFile: file,
        defaultFileName: fileName,
      );
      if (savedFile == null) {
        throw Exception('تعذر حفظ التقرير على الجهاز');
      }
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      if (exportType == 'pdf') {
        setState(() {
          _pdfFile = file;
          _previewTitle = title;
          _previewKind = _PreviewKind.pdf;
          _isGenerating = false;
        });
        _scrollToPreview();
        CommonMethods.showToast(
          message: 'تم جلب وتنزيل التقرير بنجاح ($title)',
          type: ToastType.success,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullscreenPdfViewerScreen(
              file: file,
              title: title,
              reportName: reportName,
              autoDownloaded: true,
            ),
          ),
        );
      } else {
        final opened = await FileDownloadService.openFile(savedFile.path);
        if (!mounted) return;
        if (!opened) {
          throw Exception(
            'تم تنزيل التقرير، لكن لا يوجد تطبيق لفتح صيغة ${_exportFormatLabel(exportType)}',
          );
        }
        setState(() {
          _previewKind = _PreviewKind.none;
          _pdfFile = null;
          _isGenerating = false;
        });
        CommonMethods.showToast(
          message:
              'تم تنزيل وفتح التقرير بصيغة ${_exportFormatLabel(exportType)}',
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      setState(() => _isGenerating = false);
      String errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'حدث خطأ أثناء تحميل ملف ${_exportFormatLabel(exportType)}';

      if (errorMessage.contains('404')) {
        errorMessage = 'لا توجد بيانات';
      } else if (errorMessage.contains('401') || errorMessage.contains('403')) {
        errorMessage = 'لا توجد صلاحيات';
      }

      CommonMethods.showToast(message: errorMessage, type: ToastType.error);
    }
  }

  void _showReportPreparationDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 30.h),
            decoration: BoxDecoration(
              color: AppColor.cardColor(dialogContext),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 48.r,
                  height: 48.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 4,
                    color: AppColor.oceanBlue,
                  ),
                ),
                Gap(22.h),
                Text(
                  'جاري تحضير التقرير...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.titleFormFiledColor(dialogContext),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10.h),
                Text(
                  'قد يستغرق هذا بعض الوقت للتقارير الكبيرة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.darkTextColor(dialogContext),
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _exportFormatLabel(String exportType) => switch (exportType) {
    'pdf' => 'PDF',
    'excel' => 'Excel',
    'word' => 'Word',
    'excelformatted' => 'Excel formatted',
    _ => exportType,
  };

  String _fileExtension(String exportType) => switch (exportType) {
    'pdf' => 'pdf',
    'excel' || 'excelformatted' => 'xlsx',
    'word' => 'docx',
    _ => throw ArgumentError.value(exportType, 'exportType', 'Unsupported'),
  };

  // ── Scroll to preview ────────────────────────────────────────────────────
  final ScrollController _scrollController = ScrollController();

  void _scrollToPreview() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _closePreview() {
    setState(() {
      _previewKind = _PreviewKind.none;
      _pdfFile = null;
    });
  }

  // ── Dispose ──────────────────────────────────────────────────────────────
  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchFocusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final periods = [
      AppLocaleKey.periodToday.tr(),
      AppLocaleKey.periodThisWeek.tr(),
      AppLocaleKey.periodThisMonth.tr(),
      AppLocaleKey.periodThisQuarter.tr(),
      AppLocaleKey.periodThisYear.tr(),
    ];

    final categoryTabs = [
      AppLocaleKey.allReports.tr(),
      AppLocaleKey.tabFinancials.tr(),
      AppLocaleKey.tabSales.tr(),
      AppLocaleKey.tabInventory.tr(),
      AppLocaleKey.tabTax.tr(),
    ];

    final List<Map<String, dynamic>> statements = [
      {
        'id': 'chart_of_account',
        'reportName': 'AGL001',
        'isApiReport': true,
        'title': AppLocaleKey.statementChartOfAccount.tr(),
        'desc': AppLocaleKey.statementChartOfAccountDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
      },
      {
        'title': 'القوائم المالية',
        'desc': 'اختر: الأرباح والخسائر، الميزانية، الدخل أو التدفقات النقدية',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'isFinancialStatementsReport': true,
      },
      {
        'title': AppLocaleKey.statementDailyIncome.tr(),
        'desc': AppLocaleKey.statementDailyIncomeDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_view_day_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL300_D',
        'isDailyIncomeAndExpenseReport': true,
      },
      {
        'title': AppLocaleKey.statementExpensesWithVat.tr(),
        'desc': AppLocaleKey.statementExpensesWithVatDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.receipt_long_outlined,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL1001E',
        'isExpensesWithVatReport': true,
      },
      {
        'title': AppLocaleKey.statementSalesWithVat.tr(),
        'desc': AppLocaleKey.statementSalesWithVatDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.point_of_sale_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 2,
        'reportName': 'AAR1000',
        'isSalesWithVatReport': true,
      },
      {
        'title': AppLocaleKey.statementPurchasesWithVat.tr(),
        'desc': AppLocaleKey.statementPurchasesWithVatDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.shopping_bag_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 2,
        'reportName': 'AAR1001',
        'isPurchasesWithVatReport': true,
      },
      {
        'title': AppLocaleKey.statementLedger.tr(),
        'desc': AppLocaleKey.statementLedgerDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL025',
        'isLedgerReport': true,
      },
      {
        'title': AppLocaleKey.statementAccountStatement.tr(),
        'desc': AppLocaleKey.statementAccountStatementDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.receipt_long_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL079',
        'isAccountStatementReport': true,
      },
      {
        'title': AppLocaleKey.statementTrialBalanceByCategories.tr(),
        'desc': AppLocaleKey.statementTrialBalanceByCategoriesDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_wallet_outlined,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL055',
        'isTrialBalanceByCategoriesReport': true,
      },
      {
        'title': AppLocaleKey.statementCostCenters.tr(),
        'desc': AppLocaleKey.statementCostCentersDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.business_outlined,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL007',
        'isCostCentersReport': true,
      },
      {
        'title': AppLocaleKey.statementCostCentersProjects.tr(),
        'desc': AppLocaleKey.statementCostCentersProjectsDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.domain_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'Agl026_Project2',
        'isCostCentersProjectsReport': true,
      },
      {
        'title': AppLocaleKey.statementMonthlyAccountsComparison.tr(),
        'desc': AppLocaleKey.statementMonthlyAccountsComparisonDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.compare_arrows_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL003_Bar',
        'isMonthlyAccountComparisonReport': true,
      },
      {
        'title': AppLocaleKey.statementMonthlyCostCentersComparison.tr(),
        'desc': AppLocaleKey.statementMonthlyCostCentersComparisonDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.insights_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL008_Chart',
        'isMonthlyCostCentersComparisonReport': true,
      },
    ];

    final normalizedQuery = _normalizeSearchText(_searchQuery);
    final filteredStatements = statements.where((item) {
      if (normalizedQuery.isEmpty) {
        return _selectedCategoryTab == 0 ||
            item['category'] == _selectedCategoryTab;
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

    final categoryCounts = List<int>.generate(
      categoryTabs.length,
      (index) => statements
          .where((item) => index == 0 || item['category'] == index)
          .length,
    );

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Header ────────────────────────────────────────────
              _buildHeroHeader(
                reportCount: statements.length,
                sectionCount: categoryTabs.length - 1,
              ),

              // ── Preview Panel (داخل الصفحة نفسها) ─────────────────────
              _buildPreviewArea(),

              // ── Overview Section ───────────────────────────────────────
              _buildSectionHeader(
                icon: Icons.insights_rounded,
                title: AppLocaleKey.insightsSectionTitle.tr(),
                subtitle: AppLocaleKey.insightsSectionSubtitle.tr(),
                accent: AppColor.emeraldTeal,
              ),
              Gap(8.h),

              // ── Time-Period Selector ───────────────────────────────────
              _buildPeriodSelector(periods),
              Gap(10.h),

              // ── AI Executive Insights Banner ───────────────────────────
              _buildAiBanner(),
              Gap(20.h),

              // ── KPI Cards ──────────────────────────────────────────────
              _buildKpiGrid(),
              Gap(24.h),

              // ── Charts ─────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const ReportsChartWidget(),
              ),
              Gap(16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const ReportsDonutChartWidget(),
              ),
              Gap(28.h),

              // ── Reports Library Section ────────────────────────────────
              _buildSectionHeader(
                icon: Icons.analytics_rounded,
                title: AppLocaleKey.reportsLibraryTitle.tr(),
                subtitle: AppLocaleKey.reportsLibrarySubtitle.tr(),
                accent: AppColor.oceanBlue,
                trailing: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor(
                      context,
                    ).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColor.borderColor(context)),
                  ),
                  child: Text(
                    '${filteredStatements.length} ${AppLocaleKey.reportsCount.tr()}',
                    style: TextStyle(
                      color: AppColor.mintTeal,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Gap(14.h),

              // ── Search Bar ─────────────────────────────────────────────
              _buildSearchBar(),

              // ── Search summary / suggestions ───────────────────────────
              _buildSearchMeta(filteredStatements.length),
              Gap(12.h),

              // ── Category Chips ─────────────────────────────────────────
              _buildCategoryChips(categoryTabs, categoryCounts),
              Gap(16.h),

              // ── Statements List ────────────────────────────────────────
              _buildStatementsList(filteredStatements, categoryTabs),

              Gap(100.h),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Hero Header
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeroHeader({
    required int reportCount,
    required int sectionCount,
  }) {
    final isAr = context.locale.languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColor.royalNavy,
              AppColor.oceanBlue,
              AppColor.emeraldTeal,
            ],
            stops: [0, 0.58, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.royalNavy.withValues(alpha: 0.24),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26.r),
          child: Stack(
            children: [
              Positioned(
                top: -46.r,
                right: -28.r,
                child: _heroCircle(150.r, Colors.white),
              ),
              Positioned(
                bottom: -72.r,
                left: -34.r,
                child: _heroCircle(180.r, Colors.white),
              ),
              Padding(
                padding: EdgeInsets.all(18.r),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 46.r,
                          height: 46.r,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.22),
                            ),
                          ),
                          child: Icon(
                            Icons.analytics_rounded,
                            color: Colors.white,
                            size: 24.r,
                          ),
                        ),
                        Gap(12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocaleKey.reportsDashboardTitle.tr(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Gap(3.h),
                              Text(
                                AppLocaleKey.reportsDashboardSubtitle.tr(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5.sp,
                                  height: 1.4,
                                  color: Colors.white.withValues(alpha: 0.72),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(8.w),
                        _heroLanguageButton(isAr),
                      ],
                    ),
                    Gap(18.h),
                    Container(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                    Gap(14.h),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 14.w,
                      runSpacing: 12.h,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _heroStat(
                              value: '$reportCount',
                              label: AppLocaleKey.reportsCount.tr(),
                            ),
                            Container(
                              width: 1,
                              height: 24.h,
                              margin: EdgeInsets.symmetric(horizontal: 16.w),
                              color: Colors.white.withValues(alpha: 0.16),
                            ),
                            _heroStat(
                              value: '$sectionCount',
                              label: AppLocaleKey.sectionsCount.tr(),
                            ),
                          ],
                        ),
                        FilledButton.icon(
                          onPressed: _showExportModal,
                          icon: Icon(Icons.download_rounded, size: 17.r),
                          label: Text(
                            AppLocaleKey.exportReport.tr(),
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColor.royalNavy,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 11.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.07),
      ),
    );
  }

  Widget _heroStat({required String value, required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1,
          ),
        ),
        Gap(3.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.68),
          ),
        ),
      ],
    );
  }

  Widget _heroLanguageButton(bool isAr) {
    return InkWell(
      onTap: _toggleLanguage,
      borderRadius: BorderRadius.circular(13.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(13.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.translate_rounded, size: 15.r, color: Colors.white),
            Gap(5.w),
            Text(
              isAr ? 'EN' : 'AR',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Section Header
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accent,
    Widget? trailing,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: accent.withValues(alpha: 0.18)),
            ),
            child: Icon(icon, size: 18.r, color: accent),
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColor.titleFormFiledColor(context),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(2.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColor.darkTextColor(context),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[Gap(8.w), trailing],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Preview Area (تظهر ديناميكيًا داخل الصفحة)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildPreviewArea() {
    // إذا لا يوجد معاينة → مساحة صفرية.
    if (_previewKind == _PreviewKind.none && !_isGenerating) {
      return const SizedBox.shrink();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        child: SizedBox(height: 500.h, child: _buildPreviewContent()),
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (_isGenerating) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColor.emeraldTeal.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.emeraldTeal.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColor.emeraldTeal.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 32.r,
                  height: 32.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColor.emeraldTeal,
                  ),
                ),
              ),
              Gap(16.h),
              Text(
                'جاري جلب وإنشاء التقرير المالي...',
                style: TextStyle(
                  color: AppColor.titleFormFiledColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
              Gap(6.h),
              Text(
                'Report API • $_previewTitle',
                style: TextStyle(
                  color: AppColor.mintTeal.withValues(alpha: 0.8),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    switch (_previewKind) {
      case _PreviewKind.pdf:
        if (_pdfFile == null) return const SizedBox.shrink();
        return PdfPreviewPanel(
          file: _pdfFile!,
          title: _previewTitle,
          onClose: _closePreview,
        );

      case _PreviewKind.none:
        return const SizedBox.shrink();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Period Selector
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildPeriodSelector(List<String> periods) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      child: Row(
        children: List.generate(periods.length, (index) {
          final isSelected = _selectedPeriodIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: InkWell(
              onTap: () => setState(() => _selectedPeriodIndex = index),
              borderRadius: BorderRadius.circular(20.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppColor.primaryColor(context),
                            AppColor.oceanBlue,
                          ],
                        )
                      : null,
                  color: isSelected ? null : AppColor.cardColor(context),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColor.primaryColor(context)
                        : AppColor.borderColor(context),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.primaryColor(
                              context,
                            ).withValues(alpha: 0.28),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  periods[index],
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontSize: 11.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppColor.titleFormFiledColor(context),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // AI Banner
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAiBanner() {
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0D9488).withValues(alpha: 0.2),
                const Color(0xFF6C5CE7).withValues(alpha: 0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColor.mintTeal.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0D9488),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            size: 15.r,
                            color: AppColor.titleFormFiledColor(context),
                          ),
                        ),
                        Gap(8.w),
                        Expanded(
                          child: Text(
                            AppLocaleKey.aiExecutiveInsightTitle.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.mintTeal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(8.w),
                  InkWell(
                    onTap: _openAiChat,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor(
                          context,
                        ).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Ask AI',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.titleFormFiledColor(context),
                            ),
                          ),
                          Gap(3.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 11.r,
                            color: AppColor.titleFormFiledColor(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Gap(10.h),
              Text(
                AppLocaleKey.aiExecutiveInsightBody.tr(),
                style: TextStyle(
                  fontSize: 11.sp,
                  height: 1.5,
                  color: AppColor.darkTextColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // KPI Grid
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildKpiGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.85,
        children: [
          ReportsKpiCardWidget(
            title: AppLocaleKey.kpiTotalRevenue.tr(),
            value: 'SAR 1.39M',
            change: '+18.4%',
            isPositive: true,
            icon: Icons.payments_outlined,
            gradient: [AppColor.emeraldTeal, AppColor.mintTeal],
            sparklineData: const [20, 30, 45, 40, 65, 75, 90],
          ),
          ReportsKpiCardWidget(
            title: AppLocaleKey.kpiNetProfit.tr(),
            value: 'SAR 345K',
            change: '+24.8%',
            isPositive: true,
            icon: Icons.trending_up_rounded,
            gradient: [AppColor.purpleAccent, const Color(0xFFA29BFE)],
            sparklineData: const [15, 25, 20, 40, 50, 60, 85],
          ),
          ReportsKpiCardWidget(
            title: AppLocaleKey.kpiOperatingExpenses.tr(),
            value: 'SAR 602K',
            change: '-6.2%',
            isPositive: true,
            icon: Icons.receipt_long_rounded,
            gradient: [const Color(0xFFFF7675), const Color(0xFFE84393)],
            sparklineData: const [80, 75, 70, 65, 60, 58, 55],
          ),
          ReportsKpiCardWidget(
            title: AppLocaleKey.kpiCashFlow.tr(),
            value: 'SAR +444K',
            change: '+12.1%',
            isPositive: true,
            icon: Icons.account_balance_wallet_outlined,
            gradient: [AppColor.oceanBlue, AppColor.skyBlue],
            sparklineData: const [30, 35, 45, 50, 60, 70, 80],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Search Bar
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    final hasSearchText = _searchController.text.isNotEmpty;
    final isFocused = _searchFocusNode.hasFocus;
    final accent = AppColor.primaryColor(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppColor.cardColor(context),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: hasSearchText || isFocused
                ? accent.withValues(alpha: 0.55)
                : AppColor.borderColor(context),
            width: isFocused ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: isFocused ? 0.12 : 0.04),
              blurRadius: isFocused ? 18 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: _onSearchChanged,
          onSubmitted: (value) => _applySearch(value),
          textInputAction: TextInputAction.search,
          style: TextStyle(
            color: AppColor.titleFormFiledColor(context),
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: AppLocaleKey.searchReports.tr(),
            hintStyle: TextStyle(
              color: AppColor.darkTextColor(context),
              fontSize: 12.sp,
            ),
            prefixIcon: Container(
              margin: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
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
                    onPressed: _clearSearch,
                  )
                : Icon(
                    Icons.tune_rounded,
                    color: AppColor.darkTextColor(
                      context,
                    ).withValues(alpha: 0.55),
                    size: 18.r,
                  ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),
          ),
        ),
      ),
    );
  }

  bool get _hasSearch => _searchQuery.trim().isNotEmpty;

  Widget _buildSearchMeta(int resultCount) {
    if (_hasSearch) {
      final accent = AppColor.primaryColor(context);
      return Padding(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(13.r),
            border: Border.all(color: accent.withValues(alpha: 0.14)),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, size: 15.r, color: accent),
              Gap(7.w),
              Expanded(
                child: Text(
                  '${AppLocaleKey.searchResultsFor.tr()} "$_searchQuery" • $resultCount',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.titleFormFiledColor(context),
                  ),
                ),
              ),
              InkWell(
                onTap: _clearSearch,
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  child: Text(
                    AppLocaleKey.clearSearch.tr(),
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.bold,
                      color: accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final quickSearches = [
      'AGL001',
      'AGL055',
      'AGL003',
      'AGL008',
      AppLocaleKey.tabTax.tr(),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 0, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Icon(Icons.bolt_rounded, size: 15.r, color: AppColor.warningOrange),
            Gap(5.w),
            Text(
              AppLocaleKey.quickSearch.tr(),
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.darkTextColor(context),
              ),
            ),
            Gap(8.w),
            ...quickSearches.map(_buildQuickSearchChip),
            Gap(16.w),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSearchChip(String label) {
    return Padding(
      padding: EdgeInsets.only(right: 6.w),
      child: InkWell(
        onTap: () => _applySearch(label),
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColor.cardColor(context),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColor.borderColor(context)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9.5.sp,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
              color: AppColor.darkTextColor(context),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Category Chips
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCategoryChips(
    List<String> categoryTabs,
    List<int> categoryCounts,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: List.generate(categoryTabs.length, (index) {
          final isSelected = _selectedCategoryTab == index;
          final count = categoryCounts[index];
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: InkWell(
              onTap: () => setState(() => _selectedCategoryTab = index),
              borderRadius: BorderRadius.circular(16.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppColor.primaryColor(context),
                            AppColor.oceanBlue,
                          ],
                        )
                      : null,
                  color: isSelected ? null : AppColor.cardColor(context),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColor.primaryColor(context)
                        : AppColor.borderColor(context),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.primaryColor(
                              context,
                            ).withValues(alpha: 0.28),
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
                      categoryTabs[index],
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
                            : AppColor.primaryColor(
                                context,
                              ).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: Text(
                        '$count',
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

  // ─────────────────────────────────────────────────────────────────────────
  // Statements List
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildStatementsList(
    List<Map<String, dynamic>> filteredStatements,
    List<String> categoryTabs,
  ) {
    if (filteredStatements.isEmpty) {
      final isAr = context.locale.languageCode == 'ar';

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
                    color: AppColor.primaryColor(
                      context,
                    ).withValues(alpha: 0.16),
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
                _hasSearch
                    ? (isAr
                          ? 'لا توجد نتائج لـ "$_searchQuery"'
                          : 'No results for "$_searchQuery"')
                    : (isAr
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
                _hasSearch
                    ? (isAr
                          ? 'جرّب البحث برقم التقرير أو باسم آخر، أو امسح البحث لعرض كل التقارير'
                          : 'Try a report code or another keyword, or clear the search to view all reports')
                    : (isAr
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
                onTap: () {
                  if (_hasSearch) {
                    _clearSearch();
                  } else {
                    setState(() => _selectedCategoryTab = 0);
                  }
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor(
                      context,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColor.primaryColor(
                        context,
                      ).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    _hasSearch
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredStatements.length,
        itemBuilder: (context, index) {
          final st = filteredStatements[index];
          final title = st['title'] as String;
          final description = st['desc'] as String;
          final amount = st['amount'] as String? ?? '';
          final date = st['date'] as String? ?? '';
          final status = st['status'] as String;
          final code = st['reportName'] as String? ?? '';
          final category = categoryTabs[st['category'] as int];

          Future<void> exportReport(String exportType) => _handleExportReport(
            title: title,
            description: description,
            amount: amount,
            date: date,
            status: status,
            exportType: exportType,
            reportName: st['reportName'] as String?,
            isApiReport: st['isApiReport'] == true,
            isIncomeAndExpenseSituationReport:
                st['isIncomeAndExpenseSituationReport'] == true,
            isDailyIncomeAndExpenseReport:
                st['isDailyIncomeAndExpenseReport'] == true,
            isExpensesWithVatReport: st['isExpensesWithVatReport'] == true,
            isSalesWithVatReport: st['isSalesWithVatReport'] == true,
            isPurchasesWithVatReport: st['isPurchasesWithVatReport'] == true,
            isLedgerReport: st['isLedgerReport'] == true,
            isAccountStatementReport: st['isAccountStatementReport'] == true,
            isTrialBalanceByCategoriesReport:
                st['isTrialBalanceByCategoriesReport'] == true,
            isFinancialStatementsReport:
                st['isFinancialStatementsReport'] == true,
            isCostCentersReport: st['isCostCentersReport'] == true,
            isCostCentersProjectsReport:
                st['isCostCentersProjectsReport'] == true,
            isMonthlyAccountComparisonReport:
                st['isMonthlyAccountComparisonReport'] == true,
            isMonthlyCostCentersComparisonReport:
                st['isMonthlyCostCentersComparisonReport'] == true,
          );

          return FadeInUp(
            delay: Duration(milliseconds: 60 * index),
            child: ReportsTableItemWidget(
              title: title,
              description: description,
              amount: amount,
              date: date,
              status: status,
              icon: st['icon'] as IconData,
              iconColor: st['iconColor'] as Color,
              reportCode: code.isEmpty ? null : code,
              categoryLabel: category,
              searchQuery: _searchQuery,
              // ── ربط المعاينة داخل الصفحة نفسها ──
              onExportPdf: () => exportReport('pdf'),
              onExportFormat: exportReport,
            ),
          );
        },
      ),
    );
  }
}
