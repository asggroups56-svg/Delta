class EndPoints {
  static const String login = 'auth/login';
  static const String users = 'users';
  static const String incomeAndExpensesChart =
      'Dashboard/IncomeAndExpensesChart';
  static const String salesAndReturnsChart = 'Dashboard/SalesAndReturnsChart';
  static const String chartOfAccountReport = 'Report/ChartOfAccountReport';
  static const String incomeAndExpenseSituationReport =
      'Report/IncomeAndExpenseSituationReport';
  static const String expensesWithVatReport = 'Report/ExpensesWithVatReport';
  static const String ledgerReportForAllAccounts =
      'Report/LedgerReportForAllAccounts';
  static const String trialBalanceByCategoriesReport =
      'Report/TrialBalanceByCategoriesReport';
  static const String costCentersReport = 'Report/CostCentersReport';
  static const String costCentersProjectsReport =
      'Report/CostCentersProjectsReport';
  static const String accountStatementReport = 'Report/AccountStatementReport';
  static const String salesWithVatReport = 'Report/SalesWithVatReport';
  static const String purchasesWithVatReport = 'Report/PurchasesWithVatReport';
  static const String currenciesReport = 'Report/CurrenciesReport';
  static const String chartOfAccountLight = 'ChartOfAccount/GetLight';
  static const String customerDatumLight = 'CustomerDatum/GetLight';
  static const String costCenterLight = 'CostCenter/GetLight';
  static String detailsUser(int id) => '$users/$id';
}
