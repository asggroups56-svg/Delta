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
import 'package:my_template/features/reports/presentation/view/widget/party_vat_report_filter_bottom_sheet_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/pdf_export_service.dart';
import 'package:my_template/features/reports/presentation/view/widget/pdf_preview_panel.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_chart_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_donut_chart_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_kpi_card_widget.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_table_item_widget.dart';
import 'package:my_template/features/lookup/presentation/widgets/customer_datum_dropdown.dart';

/// نوع المعاينة المعروضة حاليًا داخل الصفحة.
enum _PreviewKind { none, pdf }

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
  String _previewTitle = '';
  bool _isGenerating = false;

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
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children:
                      const [
                        ('pdf', 'PDF'),
                        ('excel', 'Excel'),
                        ('word', 'Word'),
                        ('excelformatted', 'Excel formatted'),
                      ].map((format) {
                        final (value, label) = format;
                        return ChoiceChip(
                          label: Text(label),
                          selected: selectedExportType == value,
                          onSelected: (_) =>
                              setModalState(() => selectedExportType = value),
                        );
                      }).toList(),
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
                  subtitle:
                      'Report/IncomeAndExpenseSituationReport (AGL300_M)',
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
                  subtitle:
                      'Report/IncomeAndExpenseSituationReport (AGL300_D)',
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
                  subtitle:
                      'Report/ExpensesWithVatReport (AGL1001E)',
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
                  subtitle:
                      'Report/PurchasesWithVatReport (AAR1001)',
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
                  subtitle:
                      'Report/LedgerReportForAllAccounts (AGL025)',
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
                  subtitle:
                      'Report/TrialBalanceByCategoriesReport (AGL055)',
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
                  subtitle:
                      'Report/CostCentersProjectsReport (Agl026)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportReport(
                      title: AppLocaleKey.statementCostCentersProjects.tr(),
                      description: AppLocaleKey
                          .statementCostCentersProjectsDesc
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
    bool isCostCentersReport = false,
    bool isCostCentersProjectsReport = false,
  }) async {
    final languageCode = context.locale.languageCode;
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

    setState(() {
      _isGenerating = true;
      _previewTitle = title;
    });

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
          isCostCentersReport ||
          isCostCentersProjectsReport ||
          reportName != null) {
        final reportsRepo = sl<ReportsRepo>();
        final result = isIncomeAndExpenseSituationReport
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
                fromCostCenterNo:
                    costCentersProjectsFilter?.fromCostCenterNo,
                toCostCenterNo:
                    costCentersProjectsFilter?.toCostCenterNo,
                fromDate: costCentersProjectsFilter?.fromDate,
                toDate: costCentersProjectsFilter?.toDate,
                reportName: costCentersProjectsFilter?.reportName ??
                    reportName ??
                    'Agl026_Project2',
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
      setState(() => _isGenerating = false);
      CommonMethods.showToast(
        message: e is Exception
            ? e.toString().replaceFirst('Exception: ', '')
            : 'حدث خطأ أثناء تحميل ملف ${_exportFormatLabel(exportType)}',
        type: ToastType.error,
      );
    }
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
        'title': AppLocaleKey.statementIncome.tr(),
        'desc': AppLocaleKey.statementIncomeDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.show_chart_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL300_M',
        'isIncomeAndExpenseSituationReport': true,
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
    ];

    final filteredStatements = statements.where((item) {
      if (_selectedCategoryTab != 0 &&
          item['category'] != _selectedCategoryTab) {
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
      backgroundColor: AppColor.scaffoldColor(context),
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
                    color: AppColor.titleFormFiledColor(context),
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
                // IconButton(
                //   onPressed: () => Navigator.pop(context),
                //   icon: Icon(
                //     context.locale.languageCode == 'ar'
                //         ? Icons.arrow_forward_ios_rounded
                //         : Icons.arrow_back_ios_rounded,
                //     size: 18.r,
                //     color: AppColor.whiteColor(context),
                //   ),
                // ),
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
                          color: AppColor.titleFormFiledColor(context),
                        ),
                      ),
                      Text(
                        AppLocaleKey.reportsDashboardSubtitle.tr(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColor.darkTextColor(context),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor(
                      context,
                    ).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColor.borderColor(context)),
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
                          color: AppColor.titleFormFiledColor(context),
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
                      : AppColor.cardColor(context),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColor.emeraldTeal
                        : AppColor.borderColor(context),
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
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? AppColor.buttonTextColor(context)
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.cardColor(context),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColor.borderColor(context)),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() {}),
          style: TextStyle(
            color: AppColor.titleFormFiledColor(context),
            fontSize: 12.sp,
          ),
          decoration: InputDecoration(
            hintText: AppLocaleKey.searchReports.tr(),
            hintStyle: TextStyle(
              color: AppColor.darkTextColor(context),
              fontSize: 12.sp,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColor.mintTeal,
              size: 20.r,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
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
                      ? AppColor.primaryColor(context).withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColor.mintTeal
                        : AppColor.borderColor(context),
                  ),
                ),
                child: Text(
                  categoryTabs[index],
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? AppColor.mintTeal
                        : AppColor.darkTextColor(context),
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
          final amount = st['amount'] as String? ?? '';
          final date = st['date'] as String? ?? '';
          final status = st['status'] as String;

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
            isCostCentersReport: st['isCostCentersReport'] == true,
            isCostCentersProjectsReport:
                st['isCostCentersProjectsReport'] == true,
          );

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
              onExportPdf: () => exportReport('pdf'),
              onExportFormat: exportReport,
            ),
          );
        },
      ),
    );
  }
}
