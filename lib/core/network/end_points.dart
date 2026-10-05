class EndPoints {
  static const String login = 'auth/login';
  static const String users = 'users';
  static const String incomeAndExpensesChart =
      'Dashboard/IncomeAndExpensesChart';
  static const String salesAndReturnsChart = 'Dashboard/SalesAndReturnsChart';
  static String detailsUser(int id) => '$users/$id';
}
