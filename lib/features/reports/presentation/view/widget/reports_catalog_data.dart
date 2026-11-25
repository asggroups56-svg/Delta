import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/reports/presentation/view/widget/reports_screen_widgets.dart';

class ReportsCatalogData {
  static List<Map<String, dynamic>> getStatements(BuildContext context) {
    return [
      {
        'id': 'chart_of_account',
        'reportName': 'AGL004',
        'isApiReport': true,
        'title': AppLocaleKey.statementChartOfAccount.tr(),
        'desc': AppLocaleKey.statementChartOfAccountDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'treeGroup': 'accounts',
      },
      {
        'id': 'master_accounts_or_centers',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير أرصدة أبواب الحسابات'
            : 'Account Category Balances Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض أرصدة أبواب الحسابات حسب النطاق والتاريخ'
            : 'View account category balances by range and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_wallet_outlined,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL076',
        'isMasterAccountsOrCentersReport': true,
        'treeGroup': 'masterAccountsOrCenters',
      },
      {
        'id': 'master_centers_balances',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير أرصدة أبواب المراكز'
            : 'Center Category Balances Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض أرصدة أبواب المراكز حسب النطاق والتاريخ'
            : 'View center category balances by range and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_outlined,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL077B',
        'isMasterAccountsOrCentersReport': true,
        'masterAccountsOrCentersReportPageType': 2,
        'masterAccountsOrCentersSummarizedReportName': 'AGL077C',
        'masterAccountsOrCentersDetailedReportName': 'AGL077B',
        'isMasterCentersReport': true,
        'treeGroup': 'masterAccountsOrCenters',
      },
      {
        'id': 'center_on_center_analysis',
        'title': context.locale.languageCode == 'ar'
            ? 'تحليل مركز على مركز'
            : 'Center on Center Analysis',
        'desc': context.locale.languageCode == 'ar'
            ? 'تحليل مراكز التكلفة حسب نطاق المركز والتاريخ'
            : 'Analyze cost centers by center range and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.compare_arrows_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL025A',
        'isCenterOnCenterAnalysisReport': true,
        'treeGroup': 'masterAccountsOrCenters',
      },
      {
        'id': 'chart_of_account_monthly_balances',
        'reportName': 'AGL015A',
        'isChartOfAccountMonthlyBalancesReport': true,
        'isSubmenu': true,
        'chartOfAccountReportPageType': 2,
        'chartOfAccountReportAccountType': 0,
        'chartOfAccountReportName': 'AGL015A',
        'title': context.locale.languageCode == 'ar'
            ? 'الأرصدة الشهرية / كشف الحساب'
            : 'Monthly balances / Account statement',
        'desc': context.locale.languageCode == 'ar'
            ? 'تقرير الأرصدة الشهرية أو كشف الحساب'
            : 'Monthly balances or account statement report',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'treeGroup': 'accounts',
      },
      {
        'id': 'chart_of_account_monthly_movement',
        'reportName': 'AGL003',
        'isChartOfAccountMonthlyBalancesReport': true,
        'isSubmenu': true,
        'chartOfAccountReportPageType': 1,
        'chartOfAccountReportAccountType': 2,
        'chartOfAccountReportName': 'AGL003',
        'title': context.locale.languageCode == 'ar'
            ? 'الحركة الشهرية للحسابات'
            : 'Monthly account movement',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض حركة الحسابات الشهرية'
            : 'View monthly account movements',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'treeGroup': 'accounts',
      },
      {
        'id': 'account_centers_summary_for_main_accounts',
        'reportName': 'AGL0103',
        'isAccountCentersSummaryForMainAccountsReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'ملخص مراكز الحسابات الرئيسية'
            : 'Main Accounts Centers Summary',
        'desc': context.locale.languageCode == 'ar'
            ? 'ملخص الحسابات الرئيسية حسب مراكز التكلفة'
            : 'Summary of main accounts by cost centers',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_outlined,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'treeGroup': 'costCenters',
      },
      {
        'title': context.locale.languageCode == 'ar'
            ? 'التقارير الختامية'
            : 'Final Reports',
        'desc': context.locale.languageCode == 'ar'
            ? 'المتاجرة والأرباح والخسائر والميزانية والدخل والتدفقات النقدية بجميع أنواع التقارير'
            : 'Trading, profit and loss, balance sheet, income statement and cash flow in all report variants',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'isFinancialStatementsReport': true,
        'treeGroup': 'concluding',
      },
      {
        'id': 'additional_final_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ختامي إضافي'
            : 'Additional Final Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'تقرير ختامي إضافي برقم الحساب أو بدونه أو بطريقة طولية أو بالمقارنات'
            : 'Additional final report with or without account numbers, vertical, or comparative',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.playlist_add_check_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL037A',
        'isAdditionalFinalReport': true,
        'treeGroup': 'concluding',
      },
      {
        'id': 'account_centers_analytical_details_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تحليلى الحركة الحالية لمراكز الحسابات'
            : 'Current Account Center Analytical Movements',
        'desc': context.locale.languageCode == 'ar'
            ? 'تحليل الحركة الحالية للحسابات ومراكز التكلفة'
            : 'Analytical details of current account center movements',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.analytics_outlined,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL098',
        'isAccountCentersAnalyticalDetailsReport': true,
        'treeGroup': 'additional',
      },
      {
        'id': 'account_centers_analytical_groups_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تحليلى الحركة الحالية لمراكز الحسابات - مستويات'
            : 'Current Analytical Movements of Account Centers - Levels',
        'desc': context.locale.languageCode == 'ar'
            ? 'تقرير مجمع لحركة مراكز الحسابات حسب المستوى'
            : 'Summarized account center analytical movements by level',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.analytics_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL026L',
        'isAccountCentersAnalyticalGroupsReport': true,
        'treeGroup': 'additional',
      },
      {
        'id': 'status_of_daily_transactions_report',
        'title': context.locale.languageCode == 'ar' ? 'تقرير حركات التكامل بدون قيود' : 'Integration Transactions Without Vouchers',
        'desc': context.locale.languageCode == 'ar' ? 'حالة حركات التكامل حسب نوع الحركة' : 'Integration transaction status by transaction type',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.sync_alt_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL2000',
        'isStatusOfDailyTransactionsReport': true,
        'treeGroup': 'additional',
      },
      {
        'id': 'integrated_vouchers_status_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير حالة قيود التكامل من الترحيل'
            : 'Integration Voucher Posting Status Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'حالة قيود التكامل حسب حالة الترحيل والبرنامج'
            : 'Integration voucher status by posting state and program',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.sync_alt_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'TAGL111',
        'isIntegratedVouchersStatusReport': true,
        'treeGroup': 'additional',
      },
      {
        'id': 'test_integration_voucher_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير مراجعة واختبار قيود يومية التكامل'
            : 'Integration Daily Vouchers Review and Test Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'مراجعة واختبار قيود يومية التكامل حسب الرقم التسلسلي والتاريخ'
            : 'Review and test integration daily vouchers by serial and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.fact_check_outlined,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL063',
        'isTestIntegrationVoucherReport': true,
        'treeGroup': 'additional',
      },
      {
        'id': 'integration_journal_summary_by_entry_type_report',
        'title': context.locale.languageCode == 'ar'
            ? 'اليومية إجمالي حسب نوع القيد'
            : 'Daily Summary by Entry Type',
        'desc': context.locale.languageCode == 'ar'
            ? 'ملخص اليومية حسب نوع القيد'
            : 'Daily journal summary by entry type',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.rule_folder_outlined,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL900',
        'isJournalSummarizedReport': true,
        'treeGroup': 'additional',
      },
      {
        'id': 'indicator_data_standard_report',
        'title': AppLocaleKey.statementStandardIndicatorData.tr(),
        'desc': AppLocaleKey.statementStandardIndicatorDataDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.query_stats_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL066',
        'isIndicatorDataStandardReport': true,
        'treeGroup': 'concluding',
      },
      {
        'id': 'indicator_data_addition_report',
        'title': AppLocaleKey.statementAdditionalIndicatorData.tr(),
        'desc': AppLocaleKey.statementAdditionalIndicatorDataDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.stacked_line_chart_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL800A',
        'isIndicatorDataAdditionReport': true,
        'treeGroup': 'concluding',
      },
      {
        'id': 'withdraw_and_depositing_voucher_report',
        'title': AppLocaleKey.statementWithdrawalAndDeposit.tr(),
        'desc': AppLocaleKey.statementWithdrawalAndDepositDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.swap_vert_circle_outlined,
        'iconColor': AppColor.warningOrange,
        'category': 1,
        'reportName': 'AGL065',
        'isWithdrawAndDepositingVoucherReport': true,
        'treeGroup': 'cashVouchers',
      },
      {
        'id': 'activity_report',
        'title': AppLocaleKey.statementActivityReports.tr(),
        'desc': AppLocaleKey.statementActivityReportsDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.timeline_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL111',
        'isActivityReport': true,
        'treeGroup': 'activityReports',
      },
      {
        'id': 'activity_center_data_report',
        'title': AppLocaleKey.statementActivityCenterData.tr(),
        'desc': AppLocaleKey.statementActivityCenterDataDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.analytics_outlined,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL007A',
        'isActivityCenterDataReport': true,
        'treeGroup': 'activityReports',
      },
      {
        'id': 'monthly_income_and_expense_report',
        'title': AppLocaleKey.statementMonthlyIncome.tr(),
        'desc': AppLocaleKey.statementMonthlyIncomeDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_month_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL300_M',
        'isIncomeAndExpenseSituationReport': true,
        'treeGroup': 'operations',
      },
      {
        'id': 'multi_month_income_and_expense_report',
        'title': AppLocaleKey.statementMultiMonthIncome.tr(),
        'desc': AppLocaleKey.statementMultiMonthIncomeDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_view_month_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL300_MS',
        'isIncomeAndExpenseSituationReport': true,
        'treeGroup': 'operations',
      },
      {
        'id': 'quarterly_income_and_expense_report',
        'title': AppLocaleKey.statementQuarterlyIncome.tr(),
        'desc': AppLocaleKey.statementQuarterlyIncomeDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_view_week_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL300_QS',
        'isQuarterlyIncomeAndExpenseSituationReport': true,
        'treeGroup': 'operations',
      },
      {
        'id': 'cost_center_income_and_expense_report',
        'title': AppLocaleKey.statementCostCenterIncome.tr(),
        'desc': AppLocaleKey.statementCostCenterIncomeDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_outlined,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL300C',
        'isCostCenterIncomeAndExpenseSituationReport': true,
        'treeGroup': 'operations',
      },
      {
        'id': 'monthly_expenses_report',
        'title': AppLocaleKey.statementMonthlyExpenses.tr(),
        'desc': AppLocaleKey.statementMonthlyExpensesDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.money_off_csred_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL0400',
        'isMonthlyExpensesReport': true,
        'treeGroup': 'operations',
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
        'treeGroup': 'operations',
      },
      {
        'title': context.locale.languageCode == 'ar' ? 'تقرير اليومية إجمالي حسب نوع القيد' : 'Journal Summary by Entry Type',
        'desc': context.locale.languageCode == 'ar' ? 'إجمالي قيود اليومية حسب نوع القيد والفترة' : 'Journal totals by entry type and period',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.summarize_outlined,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL900',
        'isJournalSummarizedReport': true,
        'treeGroup': 'additional',
      },
      {
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير اليومية العامة'
            : 'General Journal Reports',
        'desc': context.locale.languageCode == 'ar'
            ? 'تقارير اليومية التفصيلية والإجمالية مع خيارات القيود والتاريخ'
            : 'Detailed and summary journal reports with entry and date filters',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.receipt_long_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL009',
        'isJournalReport': true,
        'treeGroup': 'journalReports',
      },
      {
        'title': context.locale.languageCode == 'ar'
            ? 'قيد اليومية للحسابات الرئيسية'
            : 'Main Accounts Journal Entry',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض قيد اليومية للحسابات الرئيسية بالتفصيل أو الإجمالي'
            : 'View main accounts journal entries in detail or summary',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL0101C',
        'isMainAccountsJournalReport': true,
        'treeGroup': 'journalReports',
      },
      {
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير اليومية مع تحديد المستويات'
            : 'Journal Report by Account Level',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض قيود اليومية حسب مستوى الحساب وفترة التقرير'
            : 'View journal entries by account level and report period',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.format_list_numbered_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL0104',
        'isGeneralJournalForLevelReport': true,
        'treeGroup': 'journalReports',
      },
      {
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير سندات القبض والصرف'
            : 'Cash In/Out Voucher Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'تقرير سندات القبض أو الصرف حسب رقم السند والبنك والتاريخ'
            : 'Report cash-in or cash-out vouchers by voucher number, bank, and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.receipt_long_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL019',
        'isCashInCashOutVoucherReport': true,
        'treeGroup': 'cashVouchers',
      },
      {
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير متابعة الشيكات'
            : 'Check Follow-up Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'متابعة الشيكات حسب الرقم والبنك وحساب النقدية والتاريخ'
            : 'Follow checks by number, bank, cash account, and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.fact_check_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL019_1',
        'isChecksDataReport': true,
        'treeGroup': 'cashVouchers',
      },
      {
        'title': AppLocaleKey.statementCheckVerification.tr(),
        'desc': AppLocaleKey.statementCheckVerificationDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.verified_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'Ams003',
        'isCheckVerificationReport': true,
        'treeGroup': 'cashVouchers',
      },
      {
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير التتبع التاريخي لليومية العامة'
            : 'General Journal Historical Tracing Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'تتبع قيود اليومية العامة حسب الرقم التسلسلي ورقم القيد والتاريخ'
            : 'Trace general journal entries by serial, entry number, and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.manage_search_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL038T',
        'isOperationTracingReport': true,
        'treeGroup': 'journalReports',
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
        'treeGroup': 'tax',
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
        'treeGroup': 'tax',
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
        'treeGroup': 'tax',
      },
      {
        'title': context.locale.languageCode == 'ar'
            ? 'إشعارات العملاء والموردين'
            : 'Customer and Supplier Notifications',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض الإشعارات حسب العملاء أو الموردين ونوع الحركة'
            : 'View notifications by customer or supplier and transaction type',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.notifications_active_outlined,
        'iconColor': AppColor.emeraldTeal,
        'category': 2,
        'reportName': 'AAR020V',
        'isCustomerSupplierNotificationsReport': true,
        'treeGroup': 'operations',
      },
      {
        'title': context.locale.languageCode == 'ar'
            ? 'موقف الفواتير من الاعتماد'
            : 'Invoice Approval Status',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض حالة اعتماد الفواتير حسب العميل والتاريخ'
            : 'View invoice approval status by customer and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.fact_check_outlined,
        'iconColor': AppColor.oceanBlue,
        'category': 2,
        'reportName': 'AAR206',
        'isInvoicesApprovedStatusReport': true,
        'treeGroup': 'operations',
      },
      {
        'title': AppLocaleKey.statementLedger.tr(),
        'desc': AppLocaleKey.statementLedgerDesc.tr(),
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL021C',
        'isLedgerReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'general_ledger_report',
        'title': context.locale.languageCode == 'ar'
            ? 'حساب الأستاذ العام'
            : 'General Ledger Account Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف حساب الأستاذ العام مع العملات والتحليلات والقيود الفرعية'
            : 'General ledger with currency, analytical, and sub-voucher filters',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL100',
        'isGeneralLedgerReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'subsidiary_ledger_account_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير حساب الأستاذ المساعد'
            : 'Subsidiary Ledger Account Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف حساب الأستاذ المساعد ملخص أو تفصيلي'
            : 'Subsidiary ledger summary or detailed account statement',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_outlined,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL021AS',
        'isSubsidiaryLedgerAccountReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'general_ledger_audit_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير تدقيق الأستاذ العام'
            : 'General Ledger Audit Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف تدقيق الأستاذ العام حسب الحساب والتاريخ'
            : 'General ledger audit by account and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.fact_check_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL100',
        'isGeneralLedgerAuditReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'general_ledger_posting_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ترحيل الأستاذ العام'
            : 'General Ledger Posting Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف ترحيل الأستاذ العام ملخص أو تفصيلي'
            : 'General ledger posting summary or detailed',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.post_add_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL021CLP',
        'isGeneralLedgerPostingReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'general_ledger_payable_aging_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير الأستاذ العام مع تحليل أعمار الذمم الدائنة'
            : 'General Ledger Report with Accounts Payable Aging Analysis (Creditors)',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف الأستاذ العام مع تحليل أعمار الذمم الدائنة ملخص أو تفصيلي'
            : 'General ledger with accounts payable aging analysis summary or detailed',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.elderly_rounded,
        'iconColor': AppColor.warningOrange,
        'category': 1,
        'reportName': 'AGL041C',
        'isGeneralLedgerPayableAgingReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'annual_ledger_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير الأستاذ العام السنوي'
            : 'Annual General Ledger Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف الأستاذ السنوي ملخص أو تفصيلي حسب نطاق الحسابات والتحليلات'
            : 'Annual ledger summary or detailed by account range and analytics',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL021Y',
        'isAnnualLedgerReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'integration_general_ledger_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير الأستاذ العام للتكامل'
            : 'Integration General Ledger Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف الأستاذ العام ملخص أو تفصيلي حسب نطاق الحسابات والتاريخ'
            : 'Summary or detailed general ledger by account range and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGLT26C',
        'isIntegrationGeneralLedgerReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'consolidated_general_ledger_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير الأستاذ العام الموحد للمنشآت'
            : 'Consolidated General Ledger Report for Establishments',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف الأستاذ العام الموحد ملخص أو تفصيلي للمنشآت'
            : 'Consolidated summary or detailed general ledger for establishments',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL021T',
        'isConsolidatedGeneralLedgerReport': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'ledger_report_assistant_accounts',
        'title': context.locale.languageCode == 'ar'
            ? 'حساب الأستاذ للحسابات المساعدة'
            : 'Assistant Accounts Ledger',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف الأستاذ للحسابات المساعدة حسب الحساب والمركز والجانب'
            : 'Assistant accounts ledger by account, center, and entry side',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL094',
        'isLedgerReportForAssistantAccounts': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'ledger_report_main_accounts',
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير حساب الأستاذ للحسابات الرئيسية'
            : 'Main Accounts Ledger Reports',
        'desc': context.locale.languageCode == 'ar'
            ? 'كشف الأستاذ للحسابات الرئيسية حسب الحساب والتحليلات'
            : 'Main accounts ledger by account and analytical ranges',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL021N',
        'isLedgerReportForMainAccounts': true,
        'treeGroup': 'ledger',
      },
      {
        'id': 'ledger_report_per_users',
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير الأستاذ حسب المستخدمين'
            : 'User-specific Ledger Reports',
        'desc': context.locale.languageCode == 'ar'
            ? 'تقارير الأستاذ للحسابات مع إمكانية التصفية حسب الحساب والتاريخ'
            : 'Ledger reports filtered by account and date',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.menu_book_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL021',
        'isLedgerReportPerUsers': true,
        'treeGroup': 'ledger',
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
        'treeGroup': 'ledger',
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
        'treeGroup': 'trialBalance',
      },
      {
        'id': 'trial_balance_by_level',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ميزان المراجعة'
            : 'Trial Balance Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'ميزان المراجعة حسب مستوى الحساب ونوع الرصيد'
            : 'Trial balance by account level and balance type',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL030',
        'isTrialBalanceByLevelReport': true,
        'treeGroup': 'trialBalance',
      },
      {
        'id': 'monthly_trial_balance',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ميزان المراجعة الشهري'
            : 'Monthly Trial Balance Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'ميزان المراجعة الشهري (AGL060 / AGL060A)'
            : 'Monthly trial balance (AGL060 / AGL060A)',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_month_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'reportName': 'AGL060',
        'isMonthlyTrialBalanceReport': true,
        'treeGroup': 'trialBalance',
      },
      {
        'id': 'monthly_trial_balance_without_account_level',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ميزان المراجعة الشهري حسب المجموعات'
            : 'Monthly Trial Balance Report by Groups',
        'desc': context.locale.languageCode == 'ar'
            ? 'ميزان المراجعة الشهري حسب نطاق الشهور'
            : 'Monthly trial balance for a selected month range',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_view_month_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL060H',
        'isMonthlyTrialBalanceWithoutAccountLevelReport': true,
        'treeGroup': 'trialBalance',
      },
      {
        'id': 'trial_balance_optional_account_level',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ميزان المراجعة حسب المراكز'
            : 'Trial Balance Report by Centers',
        'desc': context.locale.languageCode == 'ar'
            ? 'ميزان المراجعة مع مستوى حساب اختياري (AGL031)'
            : 'Trial balance with an optional account level (AGL031)',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_wallet_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL031',
        'isTrialBalanceOptionalAccountLevelReport': true,
        'treeGroup': 'trialBalance',
      },
      {
        'id': 'trial_balances_report_for_period',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير ميزان المراجعة لفترة'
            : 'Trial Balance Report for a Period',
        'desc': context.locale.languageCode == 'ar'
            ? 'ميزان مراجعة الحسابات خلال فترة زمنية'
            : 'Trial balance of accounts over a selected period',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL078',
        'isTrialBalancesReportForPeriod': true,
        'treeGroup': 'trialBalance',
      },
      {
        'id': 'account_centers_trial_balances',
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير ميزان المراجعة حسب المراكز'
            : 'Trial Balance Reports by Centers',
        'desc': context.locale.languageCode == 'ar'
            ? 'ميزان مراجعة حسابات مراكز التكلفة حسب مستوى الحساب'
            : 'Trial balance of cost center accounts by account level',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.domain_disabled_outlined,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL026C',
        'isAccountCentersTrialBalancesReport': true,
        'treeGroup': 'trialBalance',
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
        'treeGroup': 'costCenters',
      },
      {
        'id': 'centers_monthly_balance',
        'reportName': 'AGL008A',
        'isCentersMonthlyBalanceReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'الأرصدة الشهرية لمراكز التكلفة'
            : 'Cost Centers Monthly Balances',
        'desc': context.locale.languageCode == 'ar'
            ? 'عرض أرصدة مراكز التكلفة الشهرية'
            : 'View monthly cost center balances',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_month_outlined,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'treeGroup': 'costCenters',
      },
      {
        'id': 'cost_centers_transaction',
        'reportName': 'AGL028',
        'isCostCentersTransactionReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'حركة مراكز التكلفة'
            : 'Cost Centers Transactions',
        'desc': context.locale.languageCode == 'ar'
            ? 'تفاصيل وإجماليات الحسابات حسب مراكز التكلفة'
            : 'Account details and totals by cost center',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_tree_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'treeGroup': 'costCenters',
      },
      {
        'id': 'cost_centers_transaction_annual',
        'reportName': 'AGL029Y',
        'isCostCentersTransactionAnnualReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'الحركة السنوية لمراكز التكلفة'
            : 'Annual Cost Centers Transactions',
        'desc': context.locale.languageCode == 'ar'
            ? 'تفاصيل وإجماليات الحسابات حسب مراكز التكلفة سنوياً'
            : 'Annual account details and totals by cost center',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_view_month_outlined,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'treeGroup': 'costCenters',
      },
      {
        'title': context.locale.languageCode == 'ar' ? 'تقرير حركة مراكز المشتريات' : 'Purchase Centers Movement Report',
        'desc': context.locale.languageCode == 'ar' ? 'حركة المشتريات حسب المورد ومركز التكلفة' : 'Purchases by supplier and cost center',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.shopping_bag_outlined,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL1002',
        'isPurchaseOfProjectsReport': true,
        'treeGroup': 'costCenters',
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
        'treeGroup': 'costCenters',
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
        'treeGroup': 'accountComparisons',
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
        'treeGroup': 'centersComparison',
      },
      {
        'id': 'centers_comparison_report',
        'title': context.locale.languageCode == 'ar'
            ? 'مقارنة حركة المراكز الشهرية'
            : 'Monthly Cost Center Movements Comparison',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة حركة مراكز التكلفة الشهرية'
            : 'Compare monthly cost center movements',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.compare_arrows_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL092',
        'isCentersComparisonReport': true,
        'treeGroup': 'centersComparison',
      },
      {
        'id': 'centers_comparison_by_months_report',
        'title': context.locale.languageCode == 'ar'
            ? 'مقارنة المراكز بالشهور'
            : 'Cost Centers Comparison by Months',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة مراكز التكلفة خلال فترة شهرية'
            : 'Compare cost centers over a monthly period',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_month_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL091',
        'isCentersComparisonByMonthsReport': true,
        'treeGroup': 'centersComparison',
      },
      {
        'id': 'centers_comparison_by_month_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير مقارنة شهر - المراكز'
            : 'Cost Center Month Comparison Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة مراكز التكلفة في شهر محدد'
            : 'Compare cost centers in a selected month',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.event_repeat_rounded,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL090',
        'isCentersComparisonByMonthReport': true,
        'treeGroup': 'centersComparison',
      },
      {
        'id': 'centers_comparison_balances_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير مقارنة أرصدة مراكز التكلفة'
            : 'Cost Center Balances Comparison Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة أرصدة مراكز التكلفة حسب نوع الرصيد والفترة'
            : 'Compare cost center balances by balance and period type',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.account_balance_wallet_outlined,
        'iconColor': AppColor.purpleAccent,
        'category': 1,
        'reportName': 'AGL051',
        'isCentersComparisonBalancesReport': true,
        'treeGroup': 'centersComparison',
      },
      {
        'id': 'accounts_centers_comparison_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقرير مقارنة أرصدة مراكز الحسابات'
            : 'Account Center Balances Comparison Report',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة أرصدة الحسابات ومراكز التكلفة'
            : 'Compare account and cost center balances',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.compare_arrows_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL051A',
        'isAccountsCentersComparisonReport': true,
        'treeGroup': 'accountCentersComparison',
      },
      {
        'id': 'accounts_centers_monthly_comparison_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير مقارنة مراكز الحسابات بالشهور'
            : 'Account Centers Balances Comparison by Month',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة أرصدة مراكز الحسابات شهرياً'
            : 'Compare account center balances monthly',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_month_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL091B',
        'isAccountsCentersMonthlyComparisonReport': true,
        'treeGroup': 'accountCentersComparison',
      },
      {
        'id': 'accounts_centers_monthly_movements_report',
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير مقارنة حركة مراكز الحسابات الشهرية'
            : 'Account Centers Monthly Movements Comparison',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة حركة مراكز الحسابات شهرياً'
            : 'Compare account center movements monthly',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.compare_arrows_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'reportName': 'AGL092A',
        'isAccountsCentersMonthlyMovementsReport': true,
        'treeGroup': 'accountCentersComparison',
      },
      {
        'id': 'accounts_comparison',
        'reportName': 'AGL052',
        'isAccountsComparisonReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'مقارنة حركة الحسابات الشهرية'
            : 'Monthly Account Movements Comparison',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة حركة الحسابات الشهرية حسب القوائم المالية'
            : 'Compare monthly account movements by financial statement type',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.compare_arrows_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'treeGroup': 'accountComparisons',
      },
      {
        'id': 'accounts_monthly_comparison',
        'reportName': 'AGL053',
        'isAccountsMonthlyComparisonReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'مقارنة الحسابات بالشهور'
            : 'Accounts Comparison by Months',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة الحسابات بين الشهور مع تحديد نوع الرصيد'
            : 'Compare accounts across months by balance type',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.calendar_month_rounded,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'treeGroup': 'accountComparisons',
      },
      {
        'id': 'accounts_comparison_by_month',
        'reportName': 'AGL054',
        'isAccountsComparisonByMonthReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'تقارير مقارنة شهر - الحسابات'
            : 'Account Month Comparison',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة الحسابات في شهر محدد'
            : 'Compare accounts for a selected month',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.event_repeat_rounded,
        'iconColor': AppColor.oceanBlue,
        'category': 1,
        'treeGroup': 'accountComparisons',
      },
      {
        'id': 'accounts_balance_periodically',
        'reportName': 'AGL006',
        'isAccountsBalancePeriodicallyReport': true,
        'isSubmenu': true,
        'title': context.locale.languageCode == 'ar'
            ? 'مقارنة دليل الحسابات'
            : 'Chart of Accounts Comparison',
        'desc': context.locale.languageCode == 'ar'
            ? 'مقارنة دليل الحسابات حسب الرصيد والفترة'
            : 'Compare chart of accounts by balance and period',
        'status': AppLocaleKey.statusAudited.tr(),
        'icon': Icons.assessment_outlined,
        'iconColor': AppColor.emeraldTeal,
        'category': 1,
        'treeGroup': 'accountComparisons',
      },
    ];
  }

  static List<ReportsCategorySectionData> buildCategorySections(
    BuildContext context,
    List<Map<String, dynamic>> filteredStatements,
  ) {
    final sections = <ReportsCategorySectionData>[];
    final isArabic = context.locale.languageCode == 'ar';
    const groups = [
      (
        id: 1,
        key: 'accounts',
        titleAr: 'دليل الحسابات',
        titleEn: 'Chart of accounts',
        icon: Icons.account_tree_rounded,
        accent: AppColor.oceanBlue,
      ),
      (
        id: 2,
        key: 'costCenters',
        titleAr: 'مراكز التكلفة',
        titleEn: 'Cost centers',
        icon: Icons.business_rounded,
        accent: AppColor.purpleAccent,
      ),
      (
        id: 4,
        key: 'accountComparisons',
        titleAr: 'تقارير المقارنة للحسابات',
        titleEn: 'Account comparison reports',
        icon: Icons.insights_rounded,
        accent: AppColor.emeraldTeal,
      ),
      (
        id: 3,
        key: 'centersComparison',
        titleAr: 'مقارنة المراكز',
        titleEn: 'Cost Centers Comparison',
        icon: Icons.compare_arrows_rounded,
        accent: AppColor.purpleAccent,
      ),
      (
        id: 9,
        key: 'accountCentersComparison',
        titleAr: 'مقارنة مراكز الحسابات',
        titleEn: 'Account Centers Comparison',
        icon: Icons.account_tree_outlined,
        accent: AppColor.oceanBlue,
      ),
      (
        id: 10,
        key: 'journalReports',
        titleAr: 'تقارير اليومية العامة',
        titleEn: 'General Journal Reports',
        icon: Icons.receipt_long_rounded,
        accent: AppColor.oceanBlue,
      ),
      (
        id: 13,
        key: 'activityReports',
        titleAr: 'تقارير الأنشطة',
        titleEn: 'Activity Reports',
        icon: Icons.timeline_rounded,
        accent: AppColor.oceanBlue,
      ),
      (
        id: 11,
        key: 'cashVouchers',
        titleAr: 'تقارير سندات القبض والدفع',
        titleEn: 'Cash Receipt and Payment Reports',
        icon: Icons.receipt_long_rounded,
        accent: AppColor.emeraldTeal,
      ),
      (
        id: 12,
        key: 'masterAccountsOrCenters',
        titleAr: 'أرصدة وأبواب',
        titleEn: 'Balances and Categories',
        icon: Icons.account_balance_wallet_outlined,
        accent: AppColor.oceanBlue,
      ),
      (
        id: 7,
        key: 'ledger',
        titleAr: 'تقارير الأستاذ والحسابات',
        titleEn: 'Ledger and account reports',
        icon: Icons.menu_book_rounded,
        accent: AppColor.oceanBlue,
      ),
      (
        id: 14,
        key: 'trialBalance',
        titleAr: 'ميزان مراجعة',
        titleEn: 'Trial Balance',
        icon: Icons.account_balance_rounded,
        accent: AppColor.oceanBlue,
      ),
      (
        id: 8,
        key: 'concluding',
        titleAr: 'التقارير الختامية',
        titleEn: 'Concluding Reports',
        icon: Icons.account_balance_rounded,
        accent: AppColor.emeraldTeal,
      ),
      (
        id: 13,
        key: 'activityReports',
        titleAr: 'تقارير الأنشطة',
        titleEn: 'Activity Reports',
        icon: Icons.timeline_rounded,
        accent: AppColor.oceanBlue,
      ),
      (
        id: 5,
        key: 'operations',
        titleAr: 'تقارير العمليات',
        titleEn: 'Operations reports',
        icon: Icons.receipt_long_rounded,
        accent: AppColor.warningOrange,
      ),
      (
        id: 6,
        key: 'tax',
        titleAr: 'تقارير ضريبة القيمة المضافة',
        titleEn: 'VAT reports',
        icon: Icons.percent_rounded,
        accent: AppColor.emeraldTeal,
      ),
      (
        id: 15,
        key: 'additional',
        titleAr: 'التقارير الإضافية',
        titleEn: 'Additional Reports',
        icon: Icons.auto_awesome_mosaic_outlined,
        accent: AppColor.purpleAccent,
      ),
    ];

    for (final group in groups) {
      final categoryReports = filteredStatements
          .where((statement) => statement['treeGroup'] == group.key)
          .toList();
      if (categoryReports.isEmpty) continue;

      sections.add(
        ReportsCategorySectionData(
          id: group.id,
          title: isArabic ? group.titleAr : group.titleEn,
          icon: group.icon,
          accent: group.accent,
          reports: categoryReports,
        ),
      );
    }

    return sections;
  }

}
