class EndPoints {
  static const String login = 'auth/login';
  static const String users = 'users';
  static const String incomeAndExpensesChart =
      'Dashboard/IncomeAndExpensesChart';
  static const String salesAndReturnsChart = 'Dashboard/SalesAndReturnsChart';
  static const String chartOfAccountReport = 'Report/ChartOfAccountReport';
  static const String chartOfAccountMonthlyBalancesOrStatementReport =
      'Report/ChartOfAccountMonthlyBalancesOrStatementReport';
  static const String incomeAndExpenseSituationReport =
      'Report/IncomeAndExpenseSituationReport';
  static const String journalReport = 'Report/JournalReport';
  static const String generalJournalForLevelReport =
      'Report/GeneralJournalForLevelReport';
  static const String cashInCashOutVoucherReport =
      'Report/CashInCashOutVoucherReport';
  static const String checksDataReport = 'Report/ChecksDataReport';
  static const String masterAccountsOrCentersReport =
      'Report/MasterAccountsOrCentersReport';
  static const String centerOnCenterAnalysisReport =
      'Report/CenterOnCenterAnalysisReport';
  static const String financialStatementsReport =
      'Report/FinancialStatementsReport';
  static const String expensesWithVatReport = 'Report/ExpensesWithVatReport';
  static const String ledgerReport = 'Report/LedgerReport';
  static const String ledgerReportForAllAccounts =
      'Report/LedgerReportForAllAccounts';
  static const String ledgerReportForAssistantAccounts =
      'Report/LedgerReportForAssistantAccounts';
  static const String ledgerReportForMainAccounts =
      'Report/LedgerReportForMainAccounts';
  static const String ledgerReportPerUsers = 'Report/LedgerReportPerUsers';
  static const String trialBalanceByCategoriesReport =
      'Report/TrialBalanceByCategoriesReport';
  static const String costCentersReport = 'Report/CostCentersReport';
  static const String centersMonthlyBalanceReport =
      'Report/CentersMonthlyBalanceReport';
  static const String costCentersTransactionReport =
      'Report/CostCentersTransactionReport';
  static const String costCentersTransactionAnnualReport =
      'Report/CostCentersTransactionAnnualReport';
  static const String costCentersProjectsReport =
      'Report/CostCentersProjectsReport';
  static const String accountCentersSummaryForMainAccountsReport =
      'Report/AccountCentersSummaryForMainAccountsReport';
  static const String accountStatementReport = 'Report/AccountStatementReport';
  static const String salesWithVatReport = 'Report/SalesWithVatReport';
  static const String purchasesWithVatReport = 'Report/PurchasesWithVatReport';
  static const String monthlyAccountComparisonReport =
      'Report/MonthlyAccountComparsionReport';
  static const String accountsComparsionReport =
      'Report/AccountsComparsionReport';
  static const String monthlyCostCentersComparisonReport =
      'Report/MonthlyCostCentersComparsionReport';
  static const String centersComparisonReport =
      'Report/CentersComparsionReport';
  static const String accountsCentersComparisonReport =
      'Report/AccountsCentersComparisonReport';
  static const String currenciesReport = 'Report/CurrenciesReport';
  static const String chartOfAccountLight = 'ChartOfAccount/GetLight';
  static const String accountCategoryLight = 'AccCat/GetLight';
  static const String centerCategory = 'CenterCat/Get';
  static const String assistantCode = 'AssistantCode/Get';
  static const String currencyDataLight = 'CurrencyData/GetLight';
  static const String customerDatumLight = 'CustomerDatum/GetLight';
  static const String costCenterLight = 'CostCenter/GetLight';
  static const String cashVoucherLight = 'CashVoucher/GetLight';
  static const String banksDataLight = 'BanksData/GetLight';
  static String detailsUser(int id) => '$users/$id';
}
