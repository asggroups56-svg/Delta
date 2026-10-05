class SalesAndReturnsChartModel {
  final List<MonthlySalesAndReturns> months;

  const SalesAndReturnsChartModel({required this.months});

  factory SalesAndReturnsChartModel.fromJson(Map<String, dynamic> json) {
    if (json['success'] != true) {
      throw FormatException(
        json['message']?.toString() ?? 'Failed to load sales and returns.',
      );
    }

    final data = json['salesAndReturns'];
    if (data is! List) {
      throw const FormatException('Invalid sales and returns response.');
    }

    final months = <MonthlySalesAndReturns>[];
    for (final item in data) {
      if (item is! Map || item.keys.any((key) => key is! String)) {
        throw const FormatException('Invalid monthly sales data.');
      }
      months.add(
        MonthlySalesAndReturns.fromJson(Map<String, dynamic>.from(item)),
      );
    }
    months.sort((a, b) => a.monthNumber.compareTo(b.monthNumber));

    if (months.length != 12 ||
        months.asMap().entries.any(
          (entry) => entry.value.monthNumber != entry.key + 1,
        )) {
      throw const FormatException(
        'Sales and returns response must contain each month exactly once.',
      );
    }

    return SalesAndReturnsChartModel(months: months);
  }
}

class MonthlySalesAndReturns {
  final int monthNumber;
  final double sales;
  final double salesReturns;
  final double netSales;

  const MonthlySalesAndReturns({
    required this.monthNumber,
    required this.sales,
    required this.salesReturns,
    required this.netSales,
  });

  factory MonthlySalesAndReturns.fromJson(Map<String, dynamic> json) {
    final monthNumber = json['monthNumber'];
    final sales = json['sales'];
    final salesReturns = json['salesReturns'];
    final netSales = json['netSales'];

    if (monthNumber is! int || monthNumber < 1 || monthNumber > 12) {
      throw const FormatException('Invalid month number in sales response.');
    }
    if (sales is! num || salesReturns is! num || netSales is! num) {
      throw const FormatException('Invalid amount in sales response.');
    }

    return MonthlySalesAndReturns(
      monthNumber: monthNumber,
      sales: sales.toDouble(),
      salesReturns: salesReturns.toDouble(),
      netSales: netSales.toDouble(),
    );
  }
}
