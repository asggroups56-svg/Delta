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
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/common_methods.dart';
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
import 'package:my_template/features/reports/presentation/view/widget/reports_screen_widgets.dart';
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
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: ReportsPageHeaderWidget(
                reportCount: statements.length,
                onExport: _showExportModal,
                onToggleLanguage: _toggleLanguage,
              ),
            ),
            SliverToBoxAdapter(child: _buildPreviewArea()),
            SliverToBoxAdapter(child: Gap(14.h)),
            SliverToBoxAdapter(
              child: ReportsSearchFieldWidget(
                controller: _searchController,
                focusNode: _searchFocusNode,
                isFocused: _searchFocusNode.hasFocus,
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
            SliverToBoxAdapter(child: Gap(12.h)),
            SliverToBoxAdapter(
              child: ReportsCategoryFiltersWidget(
                categories: categoryTabs,
                counts: categoryCounts,
                selectedIndex: _selectedCategoryTab,
                onSelected: (index) {
                  setState(() => _selectedCategoryTab = index);
                },
              ),
            ),
            SliverToBoxAdapter(child: Gap(16.h)),
            _buildStatementsList(filteredStatements, categoryTabs),
            SliverToBoxAdapter(child: Gap(100.h)),
          ],
        ),
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
  // Statements List
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildStatementsList(
    List<Map<String, dynamic>> filteredStatements,
    List<String> categoryTabs,
  ) {
    if (filteredStatements.isEmpty) {
      return SliverToBoxAdapter(
        child: ReportsEmptyStateWidget(
          query: _searchQuery,
          onClearSearch: _clearSearch,
          onShowAllReports: () {
            setState(() => _selectedCategoryTab = 0);
          },
        ),
      );
    }

    return ReportsStatementsSliverWidget(
      itemCount: filteredStatements.length,
      itemBuilder: (context, index) {
        final statement = filteredStatements[index];
        final title = statement['title'] as String;
        final description = statement['desc'] as String;
        final amount = statement['amount'] as String? ?? '';
        final date = statement['date'] as String? ?? '';
        final status = statement['status'] as String;
        final code = statement['reportName'] as String? ?? '';
        final category = categoryTabs[statement['category'] as int];

        Future<void> exportReport(String exportType) => _handleExportReport(
          title: title,
          description: description,
          amount: amount,
          date: date,
          status: status,
          exportType: exportType,
          reportName: statement['reportName'] as String?,
          isApiReport: statement['isApiReport'] == true,
          isIncomeAndExpenseSituationReport:
              statement['isIncomeAndExpenseSituationReport'] == true,
          isDailyIncomeAndExpenseReport:
              statement['isDailyIncomeAndExpenseReport'] == true,
          isExpensesWithVatReport: statement['isExpensesWithVatReport'] == true,
          isSalesWithVatReport: statement['isSalesWithVatReport'] == true,
          isPurchasesWithVatReport:
              statement['isPurchasesWithVatReport'] == true,
          isLedgerReport: statement['isLedgerReport'] == true,
          isAccountStatementReport:
              statement['isAccountStatementReport'] == true,
          isTrialBalanceByCategoriesReport:
              statement['isTrialBalanceByCategoriesReport'] == true,
          isFinancialStatementsReport:
              statement['isFinancialStatementsReport'] == true,
          isCostCentersReport: statement['isCostCentersReport'] == true,
          isCostCentersProjectsReport:
              statement['isCostCentersProjectsReport'] == true,
          isMonthlyAccountComparisonReport:
              statement['isMonthlyAccountComparisonReport'] == true,
          isMonthlyCostCentersComparisonReport:
              statement['isMonthlyCostCentersComparisonReport'] == true,
        );

        return FadeInUp(
          delay: Duration(milliseconds: 40 * index.clamp(0, 5)),
          child: ReportsTableItemWidget(
            title: title,
            description: description,
            amount: amount,
            date: date,
            status: status,
            icon: statement['icon'] as IconData,
            iconColor: statement['iconColor'] as Color,
            reportCode: code.isEmpty ? null : code,
            categoryLabel: category,
            searchQuery: _searchQuery,
            onExportPdf: () => exportReport('pdf'),
            onExportFormat: exportReport,
          ),
        );
      },
    );
  }
}
