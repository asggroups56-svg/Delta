
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import '../models/income_and_expenses_chart_model.dart';
import '../models/sales_and_returns_chart_model.dart';

class HomeRepo {
  final ApiConsumer _apiConsumer;

  HomeRepo(this._apiConsumer);

  Future<IncomeAndExpensesChartModel> getIncomeAndExpensesChart() async {
    final response = await _apiConsumer.post(
      EndPoints.incomeAndExpensesChart,
      body: {
        'AccountNo': null,
        'AccountType': null,
        'FinalAccount': null,
      },
    );
    if (response is! Map || response.keys.any((key) => key is! String)) {
      throw const FormatException('Invalid income and expenses response.');
    }
    return IncomeAndExpensesChartModel.fromJson(
      Map<String, dynamic>.from(response),
    );
  }

  Future<SalesAndReturnsChartModel> getSalesAndReturnsChart() async {
    final response = await _apiConsumer.post(
      EndPoints.salesAndReturnsChart,
      body: {
        'AccountNo': null,
        'AccountType': null,
        'FinalAccount': null,
      },
    );
    if (response is! Map || response.keys.any((key) => key is! String)) {
      throw const FormatException('Invalid sales and returns response.');
    }
    return SalesAndReturnsChartModel.fromJson(
      Map<String, dynamic>.from(response),
    );
  }
}
