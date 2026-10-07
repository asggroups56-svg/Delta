import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/reports/data/models/account_statement_report_request_model.dart';
import 'package:my_template/features/reports/data/models/daily_income_and_expense_situation_report_request_model.dart';
import 'package:my_template/features/reports/data/models/expenses_with_vat_report_request_model.dart';
import 'package:my_template/features/reports/data/models/ledger_report_request_model.dart';
import 'package:my_template/features/reports/data/models/purchases_with_vat_report_request_model.dart';
import 'package:my_template/features/reports/data/models/sales_with_vat_report_request_model.dart';

void main() {
  test('all report date fields serialize as quoted ISO date strings', () {
    final date = DateTime(2026, 10, 6, 16, 42);
    final requests = <(Map<String, dynamic>, List<String>)>[
      (
        AccountStatementReportRequestModel(subVoucherOraDate: date).toJson(),
        ['SubVoucherOraDate'],
      ),
      (
        DailyIncomeAndExpenseSituationReportRequestModel(
          fromDate: date,
          toDate: date,
        ).toJson(),
        ['FromDate', 'ToDate'],
      ),
      (
        ExpensesWithVatReportRequestModel(
          fromVoucherDate: date,
          toVoucherDate: date,
          fromTransDate: date,
          toTransDate: date,
        ).toJson(),
        ['FromVoucherDate', 'ToVoucherDate', 'FromTransDate', 'ToTransDate'],
      ),
      (
        LedgerReportRequestModel(fromDate: date, toDate: date).toJson(),
        ['FromDate', 'ToDate'],
      ),
      (
        SalesWithVatReportRequestModel(
          fromTransDate: date,
          toTransDate: date,
        ).toJson(),
        ['FromTransDate', 'ToTransDate'],
      ),
      (
        PurchasesWithVatReportRequestModel(
          fromTransDate: date,
          toTransDate: date,
        ).toJson(),
        ['FromTransDate', 'ToTransDate'],
      ),
    ];

    for (final (request, dateFields) in requests) {
      final encodedRequest = jsonEncode(request);
      for (final field in dateFields) {
        expect(request[field], '2026-10-06T00:00:00');
        expect(encodedRequest, contains('"$field":"2026-10-06T00:00:00"'));
      }
    }
  });
}
