import 'package:flutter/material.dart';
import 'package:my_template/features/lookup/data/models/customer_datum_light_model.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/customer_datum_dropdown.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

class PurchaseOfProjectsReportFilter {
  final num? fromCustomerNo, toCustomerNo, fromCostCenterNo, toCostCenterNo;
  final DateTime? fromDate, toDate;
  final String exportType;
  const PurchaseOfProjectsReportFilter(this.fromCustomerNo, this.toCustomerNo, this.fromCostCenterNo, this.toCostCenterNo, this.fromDate, this.toDate, this.exportType);
}

class PurchaseOfProjectsReportFilterWidget extends StatefulWidget {
  final String title;
  const PurchaseOfProjectsReportFilterWidget({super.key, required this.title});
  static Future<PurchaseOfProjectsReportFilter?> show(BuildContext context, {required String title}) => showModalBottomSheet<PurchaseOfProjectsReportFilter>(context: context, isScrollControlled: true, useSafeArea: true, builder: (_) => PurchaseOfProjectsReportFilterWidget(title: title));
  @override State<PurchaseOfProjectsReportFilterWidget> createState() => _State();
}

class _State extends State<PurchaseOfProjectsReportFilterWidget> {
  CustomerDatumLightModel? fromSupplier, toSupplier;
  CostCenterLightModel? fromCenter, toCenter;
  DateTime? fromDate, toDate;
  String exportType = 'pdf';
  bool get ar => Localizations.localeOf(context).languageCode == 'ar';
  Future<void> pick(bool from) async {
    final value = await showDatePicker(context: context, initialDate: from ? (fromDate ?? DateTime.now()) : (toDate ?? DateTime.now()), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (value != null) setState(() { if (from) { fromDate = value; } else { toDate = value; } });
  }
  String dateText(DateTime? value, String label) => value == null ? label : '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  @override Widget build(BuildContext context) => Padding(padding: EdgeInsets.fromLTRB(18, 18, 18, MediaQuery.viewInsetsOf(context).bottom + 18), child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    Text(widget.title, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 14),
    CustomerDatumDropdown(type: CustomerDatumType.supplier, title: ar ? 'من المورد' : 'From supplier', hintText: ar ? 'من المورد' : 'From supplier', onSelected: (v) => fromSupplier = v),
    const SizedBox(height: 8), CustomerDatumDropdown(type: CustomerDatumType.supplier, title: ar ? 'إلى المورد' : 'To supplier', hintText: ar ? 'إلى المورد' : 'To supplier', onSelected: (v) => toSupplier = v),
    const SizedBox(height: 8), CostCenterDropdown(title: ar ? 'من مركز التكلفة' : 'From cost center', hintText: ar ? 'من مركز التكلفة' : 'From cost center', centerType: 1, centerKind: 0, pageSize: 3, onSelected: (v) => fromCenter = v),
    const SizedBox(height: 8), CostCenterDropdown(title: ar ? 'إلى مركز التكلفة' : 'To cost center', hintText: ar ? 'إلى مركز التكلفة' : 'To cost center', centerType: 1, centerKind: 0, pageSize: 3, onSelected: (v) => toCenter = v),
    const SizedBox(height: 8), Row(children: [Expanded(child: OutlinedButton(onPressed: () => pick(true), child: Text(dateText(fromDate, ar ? 'من تاريخ' : 'From date')))), const SizedBox(width: 8), Expanded(child: OutlinedButton(onPressed: () => pick(false), child: Text(dateText(toDate, ar ? 'إلى تاريخ' : 'To date'))))]),
    const SizedBox(height: 8), DropdownButtonFormField<String>(value: exportType, decoration: InputDecoration(labelText: ar ? 'صيغة التصدير' : 'Export type'), items: const [DropdownMenuItem(value: 'pdf', child: Text('PDF')), DropdownMenuItem(value: 'excel', child: Text('Excel')), DropdownMenuItem(value: 'excelformatted', child: Text('Excel formatted')), DropdownMenuItem(value: 'word', child: Text('Word'))], onChanged: (v) => setState(() => exportType = v ?? 'pdf')),
    const SizedBox(height: 14), FilledButton(onPressed: () { if (fromDate != null && toDate != null && fromDate!.isAfter(toDate!)) return; Navigator.pop(context, PurchaseOfProjectsReportFilter(fromSupplier?.customerNo, toSupplier?.customerNo, fromCenter?.costCenterNo, toCenter?.costCenterNo, fromDate, toDate, exportType)); }, child: Text(ar ? 'استخراج التقرير' : 'Generate report')),
  ])));
}
