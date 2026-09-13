import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/home/presentation/view/widget/ai_chat_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/excel_export_service.dart';
import 'package:my_template/features/reports/presentation/view/widget/excel_preview_panel.dart';
import 'package:my_template/features/reports/presentation/view/widget/pdf_export_service.dart';
import 'package:my_template/features/reports/presentation/view/widget/pdf_preview_panel.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_chart_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_donut_chart_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_kpi_card_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_table_item_widget.dart';


/// نوع المعاينة المعروضة حاليًا داخل الصفحة.
enum _PreviewKind { none, pdf, excel }

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

  // ── Preview state ────────────────────────────────────────────────────────
  _PreviewKind _previewKind = _PreviewKind.none;
  File? _pdfFile;
  List<List<String>>? _excelRows;
  String _previewTitle = '';
  bool _isGenerating = false;

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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColor.darkCardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(
            color: AppColor.whiteColor(context).withValues(alpha: 0.1),
          ),
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
                  color: AppColor.whiteColor(context).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            Gap(16.h),
            Text(
              AppLocaleKey.exportReport.tr(),
              style: TextStyle(
                color: AppColor.whiteColor(context),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(16.h),
            _buildExportOption(
              icon: Icons.picture_as_pdf_rounded,
              color: const Color(0xFFFF7675),
              title: AppLocaleKey.exportPdf.tr(),
              subtitle: 'Executive Summary & Audited Statements (PDF)',
              onTap: () {
                Navigator.pop(ctx);
                _handleExportPdf(
                  title: AppLocaleKey.reportsDashboardTitle.tr(),
                  description: AppLocaleKey.reportsDashboardSubtitle.tr(),
                  amount: 'SAR 1,391,000',
                  date: 'Jun 2026 (YTD)',
                  status: AppLocaleKey.statusAudited.tr(),
                );
              },
            ),
            Gap(10.h),
            _buildExportOption(
              icon: Icons.table_chart_outlined,
              color: const Color(0xFF10B981),
              title: AppLocaleKey.exportExcel.tr(),
              subtitle: 'Raw Data & Trial Balance Spreadsheet (XLSX)',
              onTap: () {
                Navigator.pop(ctx);
                _handleExportExcel(
                  title: AppLocaleKey.reportsDashboardTitle.tr(),
                  description: AppLocaleKey.reportsDashboardSubtitle.tr(),
                  amount: 'SAR 1,391,000',
                  date: 'Jun 2026 (YTD)',
                  status: AppLocaleKey.statusAudited.tr(),
                );
              },
            ),
            Gap(10.h),
            _buildExportOption(
              icon: Icons.share_rounded,
              color: AppColor.oceanBlue,
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
                      color: AppColor.whiteColor(context),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColor.whiteColor(context).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColor.whiteColor(context).withValues(alpha: 0.4),
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }

  // ── PDF Export ───────────────────────────────────────────────────────────
  Future<void> _handleExportPdf({
    required String title,
    required String description,
    required String amount,
    required String date,
    required String status,
  }) async {
    setState(() => _isGenerating = true);

    try {
      final file = await PdfExportService.generate(
        title: title,
        description: description,
        amount: amount,
        date: date,
        status: status,
      );

      if (!mounted) return;

      setState(() {
        _pdfFile = file;
        _excelRows = null;
        _previewTitle = title;
        _previewKind = _PreviewKind.pdf;
        _isGenerating = false;
      });

      // نمرّر للأعلى لعرض المعاينة.
      _scrollToPreview();

      CommonMethods.showToast(
        message: '${AppLocaleKey.downloadingPdf.tr()} ($title)',
        type: ToastType.success,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isGenerating = false);
      CommonMethods.showToast(
        message: 'حدث خطأ أثناء إنشاء ملف PDF',
        type: ToastType.error,
      );
    }
  }

  // ── Excel Export ─────────────────────────────────────────────────────────
  Future<void> _handleExportExcel({
    required String title,
    required String description,
    required String amount,
    required String date,
    required String status,
  }) async {
    setState(() => _isGenerating = true);

    try {
      await ExcelExportService.generate(
        title: title,
        description: description,
        amount: amount,
        date: date,
        status: status,
      );

      if (!mounted) return;

      setState(() {
        _excelRows = [
          ['البند', 'التفاصيل', 'المبلغ', 'التاريخ', 'الحالة'],
          [title, description, amount, date, status],
        ];
        _pdfFile = null;
        _previewTitle = title;
        _previewKind = _PreviewKind.excel;
        _isGenerating = false;
      });

      _scrollToPreview();

      CommonMethods.showToast(
        message: '${AppLocaleKey.exportingExcel.tr()} ($title)',
        type: ToastType.success,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isGenerating = false);
      CommonMethods.showToast(
        message: 'حدث خطأ أثناء إنشاء ملف Excel',
        type: ToastType.error,
      );
    }
  }

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
      _excelRows = null;
    });
  }

  // ── Dispose ──────────────────────────────────────────────────────────────
  @override
  void dispose() {
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
      AppLocaleKey.tabOverview.tr(),
      AppLocaleKey.tabFinancials.tr(),
      AppLocaleKey.tabSales.tr(),
      AppLocaleKey.tabInventory.tr(),
      AppLocaleKey.tabTax.tr(),
    ];

    final List<Map<String, dynamic>> statements = [
      {
        'title': AppLocaleKey.statementIncome.tr(),
        'desc': AppLocaleKey.statementIncomeDesc.tr(),
        'amount': 'SAR 1,391,000',
        'date': 'Jun 2026 (YTD)',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.show_chart_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
      },
      {
        'title': AppLocaleKey.statementBalanceSheet.tr(),
        'desc': AppLocaleKey.statementBalanceSheetDesc.tr(),
        'amount': 'SAR 4,820,500',
        'date': 'Q2 2026',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
      },
      {
        'title': AppLocaleKey.statementCashFlow.tr(),
        'desc': AppLocaleKey.statementCashFlowDesc.tr(),
        'amount': 'SAR +444,000',
        'date': 'Monthly Inflow',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.swap_horiz_rounded,
        'iconColor': AppColor.mintTeal,
        'category': 1,
      },
      {
        'title': AppLocaleKey.statementAging.tr(),
        'desc': AppLocaleKey.statementAgingDesc.tr(),
        'amount': 'SAR 218,400 Overdue',
        'date': '12 Invoices Pending',
        'status': AppLocaleKey.statusDraft.tr(),
        'icon': Icons.pending_actions_rounded,
        'iconColor': const Color(0xFFFF7675),
        'category': 2,
      },
      {
        'title': AppLocaleKey.statementTaxVat.tr(),
        'desc': AppLocaleKey.statementTaxVatDesc.tr(),
        'amount': 'SAR 142,650 Due',
        'date': 'Q2 ZATCA Return',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.receipt_long_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 4,
      },
      {
        'title': AppLocaleKey.statementStockValuation.tr(),
        'desc': AppLocaleKey.statementStockValuationDesc.tr(),
        'amount': 'SAR 1,180,000',
        'date': '99.4% Availability',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.inventory_2_outlined,
        'iconColor': AppColor.warningOrange,
        'category': 3,
      },
    ];

    final filteredStatements = statements.where((item) {
      if (_selectedCategoryTab != 0 && item['category'] != _selectedCategoryTab) {
        return false;
      }
      if (_searchController.text.trim().isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        final title = (item['title'] as String).toLowerCase();
        final desc = (item['desc'] as String).toLowerCase();
        return title.contains(query) || desc.contains(query);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColor.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Bar ────────────────────────────────────────────────
              _buildTopBar(),

              // ── Preview Panel (داخل الصفحة نفسها) ─────────────────────
              _buildPreviewArea(),

              // ── Time-Period Selector ───────────────────────────────────
              _buildPeriodSelector(periods),
              Gap(12.h),

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
              Gap(24.h),

              // ── Reports List Header ────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  AppLocaleKey.topReportsListTitle.tr(),
                  style: TextStyle(
                    color: AppColor.whiteColor(context),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Gap(12.h),

              // ── Search Bar ─────────────────────────────────────────────
              _buildSearchBar(),
              Gap(12.h),

              // ── Category Chips ─────────────────────────────────────────
              _buildCategoryChips(categoryTabs),
              Gap(16.h),

              // ── Statements List ────────────────────────────────────────
              _buildStatementsList(filteredStatements),

              Gap(100.h),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Top Bar
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    context.locale.languageCode == 'ar'
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.arrow_back_ios_rounded,
                    size: 18.r,
                    color: AppColor.whiteColor(context),
                  ),
                ),
                Gap(4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocaleKey.reportsDashboardTitle.tr(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.whiteColor(context),
                        ),
                      ),
                      Text(
                        AppLocaleKey.reportsDashboardSubtitle.tr(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color:
                              AppColor.whiteColor(context).withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: _showExportModal,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColor.emeraldTeal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColor.emeraldTeal.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.download_rounded,
                    size: 18.r,
                    color: AppColor.emeraldTeal,
                  ),
                ),
              ),
              Gap(8.w),
              InkWell(
                onTap: _toggleLanguage,
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color:
                          AppColor.whiteColor(context).withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        size: 14.r,
                        color: AppColor.mintTeal,
                      ),
                      Gap(4.w),
                      Text(
                        AppLocaleKey.langSwitchShort.tr(),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.whiteColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
        child: SizedBox(
          height: 400.h,
          child: _buildPreviewContent(),
        ),
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (_isGenerating) {
      return Container(
        decoration: BoxDecoration(
          color: AppColor.darkCardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColor.whiteColor(context).withValues(alpha: 0.08),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF06B6D4)),
              Gap(14.h),
              Text(
                'جاري إنشاء المعاينة...',
                style: TextStyle(
                  color: AppColor.whiteColor(context).withValues(alpha: 0.7),
                  fontSize: 12.sp,
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

      case _PreviewKind.excel:
        if (_excelRows == null) return const SizedBox.shrink();
        return ExcelPreviewPanel(
          rows: _excelRows!,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.emeraldTeal
                      : AppColor.darkCardBackground,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColor.emeraldTeal
                        : AppColor.whiteColor(context).withValues(alpha: 0.1),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.emeraldTeal.withValues(alpha: 0.4),
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
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? AppColor.whiteColor(context)
                        : AppColor.whiteColor(context).withValues(alpha: 0.7),
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
                            color: AppColor.whiteColor(context),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color:
                            AppColor.whiteColor(context).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Ask AI',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.whiteColor(context),
                            ),
                          ),
                          Gap(3.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 11.r,
                            color: AppColor.whiteColor(context),
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
                  color: AppColor.whiteColor(context).withValues(alpha: 0.85),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.darkCardBackground,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColor.whiteColor(context).withValues(alpha: 0.1),
          ),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() {}),
          style: TextStyle(
            color: AppColor.whiteColor(context),
            fontSize: 12.sp,
          ),
          decoration: InputDecoration(
            hintText: AppLocaleKey.searchReports.tr(),
            hintStyle: TextStyle(
              color: AppColor.whiteColor(context).withValues(alpha: 0.4),
              fontSize: 12.sp,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColor.mintTeal,
              size: 20.r,
            ),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Category Chips
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCategoryChips(List<String> categoryTabs) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: List.generate(categoryTabs.length, (index) {
          final isSelected = _selectedCategoryTab == index;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: InkWell(
              onTap: () => setState(() => _selectedCategoryTab = index),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.whiteColor(context).withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColor.mintTeal
                        : AppColor.whiteColor(context).withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  categoryTabs[index],
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? AppColor.mintTeal
                        : AppColor.whiteColor(context).withValues(alpha: 0.6),
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
  // Statements List
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildStatementsList(List<Map<String, dynamic>> filteredStatements) {
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
          final amount = st['amount'] as String;
          final date = st['date'] as String;
          final status = st['status'] as String;

          return FadeInUp(
            delay: Duration(milliseconds: 80 * index),
            child: ReportsTableItemWidget(
              title: title,
              description: description,
              amount: amount,
              date: date,
              status: status,
              icon: st['icon'] as IconData,
              iconColor: st['iconColor'] as Color,
              // ── ربط المعاينة داخل الصفحة نفسها ──
              onExportPdf: () => _handleExportPdf(
                title: title,
                description: description,
                amount: amount,
                date: date,
                status: status,
              ),
              onExportExcel: () => _handleExportExcel(
                title: title,
                description: description,
                amount: amount,
                date: date,
                status: status,
              ),
            ),
          );
        },
      ),
    );
  }
}