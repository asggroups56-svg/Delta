import 'package:flutter/material.dart';

class JournalSummarizedReportFilter {
  final int entryType;
  final int? fromEntrySerial, toEntrySerial;
  final DateTime? fromDate, toDate;
  final String exportType;
  const JournalSummarizedReportFilter(this.entryType, this.fromEntrySerial, this.toEntrySerial, this.fromDate, this.toDate, this.exportType);
}

class JournalSummarizedReportFilterWidget extends StatefulWidget {
  final String title;
  const JournalSummarizedReportFilterWidget({super.key, required this.title});
  static Future<JournalSummarizedReportFilter?> show(BuildContext context, {required String title}) => showModalBottomSheet<JournalSummarizedReportFilter>(context: context, isScrollControlled: true, useSafeArea: true, builder: (_) => JournalSummarizedReportFilterWidget(title: title));
  @override State<JournalSummarizedReportFilterWidget> createState() => _State();
}

class _State extends State<JournalSummarizedReportFilterWidget> {
  final fromSerial = TextEditingController(), toSerial = TextEditingController();
  int entryType = 5;
  DateTime? fromDate, toDate;
  String exportType = 'pdf';
  bool get ar => Localizations.localeOf(context).languageCode == 'ar';
  Future<void> pick(bool from) async {
    final date = await showDatePicker(context: context, initialDate: from ? (fromDate ?? DateTime.now()) : (toDate ?? DateTime.now()), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (date != null) setState(() { if (from) { fromDate = date; } else { toDate = date; } });
  }
  String dateLabel(DateTime? d, String label) => d == null ? label : '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  @override
  void dispose() { fromSerial.dispose(); toSerial.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final types = <int, String>{1: ar ? 'عادي' : 'Regular', 2: ar ? 'آلي' : 'Automatic', 3: ar ? 'دوري' : 'Periodic', 4: ar ? 'جدولي' : 'Scheduled', 5: ar ? 'الجميع' : 'All'};
    return Padding(padding: EdgeInsets.fromLTRB(18, 18, 18, MediaQuery.viewInsetsOf(context).bottom + 18), child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(widget.title, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 14),
      DropdownButtonFormField<int>(initialValue: entryType, decoration: InputDecoration(labelText: ar ? 'نوع القيد' : 'Entry type'), items: types.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(), onChanged: (v) => setState(() => entryType = v ?? 5)),
      const SizedBox(height: 8), Row(children: [Expanded(child: TextField(controller: fromSerial, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: ar ? 'من رقم القيد' : 'From entry serial'))), const SizedBox(width: 8), Expanded(child: TextField(controller: toSerial, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: ar ? 'إلى رقم القيد' : 'To entry serial')))]),
      const SizedBox(height: 8), Row(children: [Expanded(child: OutlinedButton(onPressed: () => pick(true), child: Text(dateLabel(fromDate, ar ? 'من تاريخ' : 'From date')))), const SizedBox(width: 8), Expanded(child: OutlinedButton(onPressed: () => pick(false), child: Text(dateLabel(toDate, ar ? 'إلى تاريخ' : 'To date'))))]),
      const SizedBox(height: 8), DropdownButtonFormField<String>(initialValue: exportType, decoration: InputDecoration(labelText: ar ? 'صيغة التصدير' : 'Export type'), items: const [DropdownMenuItem(value: 'pdf', child: Text('PDF')), DropdownMenuItem(value: 'excel', child: Text('Excel')), DropdownMenuItem(value: 'excelformatted', child: Text('Excel formatted')), DropdownMenuItem(value: 'word', child: Text('Word'))], onChanged: (v) => setState(() => exportType = v ?? 'pdf')),
      const SizedBox(height: 14), FilledButton(onPressed: () { if ((fromDate != null && toDate != null && fromDate!.isAfter(toDate!)) || (fromSerial.text.isNotEmpty && toSerial.text.isNotEmpty && (int.tryParse(fromSerial.text) ?? 0) > (int.tryParse(toSerial.text) ?? 0))) return; Navigator.pop(context, JournalSummarizedReportFilter(entryType, int.tryParse(fromSerial.text), int.tryParse(toSerial.text), fromDate, toDate, exportType)); }, child: Text(ar ? 'استخراج التقرير' : 'Generate report')),
    ])));
  }
}
