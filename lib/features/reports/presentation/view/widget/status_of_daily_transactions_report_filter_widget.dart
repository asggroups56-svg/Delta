import 'package:flutter/material.dart';

class StatusOfDailyTransactionsFilter {
  final DateTime? fromDate;
  final DateTime? toDate;
  final int transactionType;
  final String exportType;
  const StatusOfDailyTransactionsFilter(this.fromDate, this.toDate, this.transactionType, this.exportType);
}

class StatusOfDailyTransactionsReportFilterWidget extends StatefulWidget {
  final String title;
  const StatusOfDailyTransactionsReportFilterWidget({super.key, required this.title});
  static Future<StatusOfDailyTransactionsFilter?> show(BuildContext context, {required String title}) =>
      showModalBottomSheet<StatusOfDailyTransactionsFilter>(context: context, isScrollControlled: true, useSafeArea: true, builder: (_) => StatusOfDailyTransactionsReportFilterWidget(title: title));
  @override
  State<StatusOfDailyTransactionsReportFilterWidget> createState() => _State();
}

class _State extends State<StatusOfDailyTransactionsReportFilterWidget> {
  DateTime? from, to;
  int transactionType = 12;
  String exportType = 'pdf';
  bool get ar => Localizations.localeOf(context).languageCode == 'ar';
  String formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T00:00:00';
  Future<void> pick(bool isFrom) async {
    final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (date != null) setState(() { if (isFrom) { from = date; } else { to = date; } });
  }
  @override
  Widget build(BuildContext context) {
    final labels = <int, String>{
      1: ar ? 'يومية عامة معلقة' : 'Pending general journal', 2: ar ? 'يومية عامة معتمدة' : 'Approved general journal', 3: ar ? 'جميع اليوميات العامة' : 'All general journals',
      4: ar ? 'سندات قبض معلقة' : 'Pending receipt vouchers', 5: ar ? 'سندات قبض معتمدة' : 'Approved receipt vouchers', 6: ar ? 'جميع سندات القبض' : 'All receipt vouchers',
      7: ar ? 'سندات دفع معلقة' : 'Pending payment vouchers', 8: ar ? 'سندات دفع معتمدة' : 'Approved payment vouchers', 9: ar ? 'جميع سندات الدفع' : 'All payment vouchers',
      10: ar ? 'الحركات المعلقة' : 'Pending transactions', 11: ar ? 'الحركات المعتمدة' : 'Approved transactions', 12: ar ? 'جميع أنواع الحركة' : 'All transaction types',
    };
    return SafeArea(top: false, child: Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.viewInsetsOf(context).bottom + 20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(widget.title, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 16),
      DropdownButtonFormField<int>(initialValue: transactionType, decoration: InputDecoration(labelText: ar ? 'نوع الحركة' : 'Transaction type'), items: labels.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(), onChanged: (v) => setState(() => transactionType = v ?? 12)),
      const SizedBox(height: 12), Row(children: [Expanded(child: OutlinedButton(onPressed: () => pick(true), child: Text(from == null ? (ar ? 'من تاريخ' : 'From date') : formatDate(from!)))), const SizedBox(width: 8), Expanded(child: OutlinedButton(onPressed: () => pick(false), child: Text(to == null ? (ar ? 'إلى تاريخ' : 'To date') : formatDate(to!))))]) ,
      const SizedBox(height: 12), DropdownButtonFormField<String>(initialValue: exportType, decoration: InputDecoration(labelText: ar ? 'صيغة التصدير' : 'Export type'), items: const [DropdownMenuItem(value: 'pdf', child: Text('PDF')), DropdownMenuItem(value: 'excel', child: Text('Excel')), DropdownMenuItem(value: 'excelformatted', child: Text('Excel formatted')), DropdownMenuItem(value: 'word', child: Text('Word'))], onChanged: (v) => setState(() => exportType = v ?? 'pdf')),
      const SizedBox(height: 16), FilledButton(onPressed: () { if (from != null && to != null && from!.isAfter(to!)) return; Navigator.pop(context, StatusOfDailyTransactionsFilter(from, to, transactionType, exportType)); }, child: Text(ar ? 'استخراج التقرير' : 'Generate report')),
    ])));
  }
}
