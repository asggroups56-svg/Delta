import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/reports/data/models/report_date_formatter.dart';

class OperationTracingReportFilter {
  final int? fromEntrySerial, toEntrySerial;
  final String? fromEntryNo, toEntryNo;
  final DateTime? fromDate, toDate;
  final String exportType;
  const OperationTracingReportFilter({this.fromEntrySerial, this.toEntrySerial, this.fromEntryNo, this.toEntryNo, this.fromDate, this.toDate, required this.exportType});
}

class OperationTracingReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialExportType;
  const OperationTracingReportFilterBottomSheetWidget({super.key, required this.title, this.initialExportType = 'pdf'});
  static Future<OperationTracingReportFilter?> show(BuildContext context, {required String title, String initialExportType = 'pdf'}) => showModalBottomSheet<OperationTracingReportFilter>(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent, builder: (_) => OperationTracingReportFilterBottomSheetWidget(title: title, initialExportType: initialExportType));
  @override
  State<OperationTracingReportFilterBottomSheetWidget> createState() => _OperationTracingReportFilterBottomSheetWidgetState();
}

class _OperationTracingReportFilterBottomSheetWidgetState extends State<OperationTracingReportFilterBottomSheetWidget> {
  final _fromSerial = TextEditingController(), _toSerial = TextEditingController(), _fromNumber = TextEditingController(), _toNumber = TextEditingController();
  DateTime? _fromDate, _toDate;
  late String _exportType;
  String? _validationMessage;
  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';
  @override
  void initState() { super.initState(); _exportType = widget.initialExportType; }
  @override
  void dispose() { _fromSerial.dispose(); _toSerial.dispose(); _fromNumber.dispose(); _toNumber.dispose(); super.dispose(); }
  Future<void> _chooseDate(bool from) async {
    final existing = from ? _fromDate : _toDate;
    final selected = await showDatePicker(context: context, initialDate: DateUtils.dateOnly(existing ?? DateTime.now()), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (selected == null || !mounted) return;
    setState(() { if (from) { _fromDate = DateUtils.dateOnly(selected); } else { _toDate = DateUtils.dateOnly(selected); } _validationMessage = null; });
  }
  void _submit() {
    final fromSerial = int.tryParse(_fromSerial.text.trim()), toSerial = int.tryParse(_toSerial.text.trim());
    if ((_fromSerial.text.trim().isNotEmpty && fromSerial == null) || (_toSerial.text.trim().isNotEmpty && toSerial == null)) { setState(() => _validationMessage = _isArabic ? 'الرقم التسلسلي يجب أن يكون رقمًا صحيحًا' : 'Entry serial must be a whole number'); return; }
    if ((_fromDate == null) != (_toDate == null)) { setState(() => _validationMessage = _isArabic ? 'اختر تاريخ البداية والنهاية معًا أو اتركهما فارغين' : 'Select both dates or leave both empty'); return; }
    if (_fromDate != null && _fromDate!.isAfter(_toDate!)) { setState(() => _validationMessage = _isArabic ? 'تاريخ البداية يجب أن يسبق أو يساوي تاريخ النهاية' : 'From date must be before or equal to To date'); return; }
    Navigator.pop(context, OperationTracingReportFilter(fromEntrySerial: fromSerial, toEntrySerial: toSerial, fromEntryNo: _fromNumber.text.trim().isEmpty ? null : _fromNumber.text.trim(), toEntryNo: _toNumber.text.trim().isEmpty ? null : _toNumber.text.trim(), fromDate: _fromDate, toDate: _toDate, exportType: _exportType));
  }
  Widget _dateButton(bool from) { final date = from ? _fromDate : _toDate; return Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(from ? (_isArabic ? 'من تاريخ' : 'From date') : (_isArabic ? 'إلى تاريخ' : 'To date'), style: TextStyle(fontSize: 11.sp, color: AppColor.darkTextColor(context))), Gap(6.h), InkWell(onTap: () => _chooseDate(from), borderRadius: BorderRadius.circular(12.r), child: Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h), decoration: BoxDecoration(border: Border.all(color: AppColor.borderColor(context)), borderRadius: BorderRadius.circular(12.r)), child: Text(date == null ? (_isArabic ? 'اختر التاريخ' : 'Select date') : formatReportDateOnly(date), style: TextStyle(color: AppColor.titleFormFiledColor(context), fontSize: 12.sp))))])); }
  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    return Container(constraints: BoxConstraints(maxHeight: 0.9.sh), decoration: BoxDecoration(color: AppColor.cardColor(context), borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))), child: SafeArea(top: false, child: Padding(padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 12.h), child: Row(children: [Expanded(child: Text(widget.title, style: TextStyle(color: foreground, fontSize: 18.sp, fontWeight: FontWeight.bold))), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded))])),
      Flexible(child: SingleChildScrollView(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_isArabic ? 'نطاق القيود' : 'Entry range', style: TextStyle(color: foreground, fontSize: 13.sp, fontWeight: FontWeight.w600)), Gap(8.h),
        Row(children: [Expanded(child: CustomFormField(width: double.infinity, radius: 12.r, controller: _fromSerial, hintText: _isArabic ? 'من الرقم التسلسلي' : 'From serial', keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly])), Gap(10.w), Expanded(child: CustomFormField(width: double.infinity, radius: 12.r, controller: _toSerial, hintText: _isArabic ? 'إلى الرقم التسلسلي' : 'To serial', keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly]))]), Gap(10.h),
        Row(children: [Expanded(child: CustomFormField(width: double.infinity, radius: 12.r, controller: _fromNumber, hintText: _isArabic ? 'من رقم القيد' : 'From entry number')), Gap(10.w), Expanded(child: CustomFormField(width: double.infinity, radius: 12.r, controller: _toNumber, hintText: _isArabic ? 'إلى رقم القيد' : 'To entry number'))]), Gap(14.h),
        Text(_isArabic ? 'فترة التقرير' : 'Report period', style: TextStyle(color: foreground, fontSize: 13.sp, fontWeight: FontWeight.w600)), Gap(8.h), Row(children: [_dateButton(true), Gap(10.w), _dateButton(false)]), Gap(14.h),
        DropdownButtonFormField<String>(initialValue: _exportType, decoration: InputDecoration(labelText: _isArabic ? 'نوع التصدير' : 'Export type', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))), items: const [DropdownMenuItem(value: 'pdf', child: Text('PDF')), DropdownMenuItem(value: 'excel', child: Text('Excel')), DropdownMenuItem(value: 'excelformatted', child: Text('Excel formatted')), DropdownMenuItem(value: 'word', child: Text('Word'))], onChanged: (value) { if (value != null) setState(() => _exportType = value); }),
        if (_validationMessage != null) ...[Gap(10.h), Text(_validationMessage!, style: TextStyle(color: AppColor.roseDanger, fontSize: 12.sp))], Gap(16.h), SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _submit, child: Text(_isArabic ? 'تصدير التقرير' : 'Export report'))),
      ]))),
    ]))));
  }
}
