class IncomeAndExpensesChartModel {
  final List<MonthlyIncomeAndExpenses> months;

  const IncomeAndExpensesChartModel({required this.months});

  factory IncomeAndExpensesChartModel.fromJson(Map<String, dynamic> json) {
    if (json['success'] != true) {
      throw FormatException(
        json['message']?.toString() ?? 'Failed to load income and expenses.',
      );
    }

    final data = json['incomeAndExpenses'];
    if (data is! List) {
      throw const FormatException('Invalid income and expenses response.');
    }

    final months = <MonthlyIncomeAndExpenses>[];
    for (final item in data) {
      if (item is! Map || item.keys.any((key) => key is! String)) {
        throw const FormatException('Invalid monthly chart data.');
      }
      months.add(
        MonthlyIncomeAndExpenses.fromJson(Map<String, dynamic>.from(item)),
      );
    }
    months.sort((a, b) => a.monthNumber.compareTo(b.monthNumber));

    if (months.length != 12 ||
        months.asMap().entries.any(
          (entry) => entry.value.monthNumber != entry.key + 1,
        )) {
      throw const FormatException(
        'Income and expenses response must contain each month exactly once.',
      );
    }

    return IncomeAndExpensesChartModel(months: months);
  }
}

class MonthlyIncomeAndExpenses {
  final int monthNumber;
  final double income;
  final double expenses;

  const MonthlyIncomeAndExpenses({
    required this.monthNumber,
    required this.income,
    required this.expenses,
  });

  factory MonthlyIncomeAndExpenses.fromJson(Map<String, dynamic> json) {
    final monthNumber = json['monthNumber'];
    final income = json['income'];
    final expenses = json['expenses'];

    if (monthNumber is! int || monthNumber < 1 || monthNumber > 12) {
      throw const FormatException('Invalid month number in chart response.');
    }
    if (income is! num || expenses is! num) {
      throw const FormatException('Invalid amount in chart response.');
    }

    return MonthlyIncomeAndExpenses(
      monthNumber: monthNumber,
      income: income.toDouble(),
      expenses: expenses.toDouble(),
    );
  }
}
