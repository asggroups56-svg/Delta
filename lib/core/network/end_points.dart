class EndPoints {
  static const String login = 'auth/login';
  static const String users = 'users';
  static const String incomeAndExpensesChart =
      'Dashboard/IncomeAndExpensesChart';
  static const String salesAndReturnsChart = 'Dashboard/SalesAndReturnsChart';
  static const String chartOfAccountReport = 'Report/ChartOfAccountReport';
  static const String currenciesReport = 'Report/CurrenciesReport';
  static String detailsUser(int id) => '$users/$id';
}
