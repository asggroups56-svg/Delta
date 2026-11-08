import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/home/data/models/banks_data_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/bank_picker.dart';
import 'package:my_template/features/reports/data/models/report_date_formatter.dart';

class CheckVerificationFilter {
  final int? fromBankCode, toBankCode;
  final DateTime? fromDate, toDate;
  final String? receiveName;
  final int checkStatus;
  final String exportType;
  const CheckVerificationFilter({this.fromBankCode, this.toBankCode, this.fromDate, this.toDate, this.receiveName, required this.checkStatus, required this.exportType});
}

class CheckVerificationReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialExportType;
  const CheckVerificationReportFilterBottomSheetWidget({super.key, required this.title, this.initialExportType = 'pdf'});
  static Future<CheckVerificationFilter?> show(BuildContext context, {required String title, String initialExportType = 'pdf'}) => showModalBottomSheet<CheckVerificationFilter>(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent, builder: (_) => CheckVerificationReportFilterBottomSheetWidget(title: title, initialExportType: initialExportType));
  @override
  State<CheckVerificationReportFilterBottomSheetWidget> createState() => _CheckVerificationReportFilterBottomSheetWidgetState();
}

class _CheckVerificationReportFilterBottomSheetWidgetState extends State<CheckVerificationReportFilterBottomSheetWidget> {
  final _receiveController = TextEditingController();
  BANKSDATAModel? _fromBank, _toBank;
  DateTime? _fromDate, _toDate;
  int _checkStatus = 2;
  late String _exportType;
  String? _validationMessage;
  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';
  @override
  void initState() { super.initState(); _exportType = widget.initialExportType; }
  @override
  void dispose() { _receiveController.dispose(); super.dispose(); }

  Future<void> _selectBank(bool from) async {
    final bank = await showBankPicker(context);
    if (!mounted || bank == null) return;
    setState(() { if (from) { _fromBank = bank; } else { _toBank = bank; } _validationMessage = null; });
  }
  Future<void> _selectDate(bool from) async {
    final current = from ? _fromDate : _toDate;
    final selected = await showDatePicker(context: context, initialDate: DateUtils.dateOnly(current ?? DateTime.now()), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (!mounted || selected == null) return;
    setState(() { if (from) { _fromDate = DateUtils.dateOnly(selected); } else { _toDate = DateUtils.dateOnly(selected); } _validationMessage = null; });
  }
  void _submit() {
    if ((_fromDate == null) != (_toDate == null)) { setState(() => _validationMessage = _isArabic ? 'اختر تاريخ البداية والنهاية معًا أو اتركهما فارغين' : 'Select both dates or leave both empty'); return; }
    if (_fromDate != null && _fromDate!.isAfter(_toDate!)) { setState(() => _validationMessage = _isArabic ? 'تاريخ البداية يجب أن يسبق أو يساوي تاريخ النهاية' : 'From date must be before or equal to To date'); return; }
    Navigator.pop(context, CheckVerificationFilter(fromBankCode: _fromBank?.bankCode, toBankCode: _toBank?.bankCode, fromDate: _fromDate, toDate: _toDate, receiveName: _receiveController.text.trim().isEmpty ? null : _receiveController.text.trim(), checkStatus: _checkStatus, exportType: _exportType));
  }
  String _bankLabel(BANKSDATAModel? bank) => bank == null ? (_isArabic ? 'اختر بنكًا' : 'Select bank') : bankDisplayName(bank, isArabic: _isArabic);
  Widget _pickButton({required String label, required String value, required VoidCallback onPressed}) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontSize: 11.sp, color: AppColor.darkTextColor(context))), Gap(6.h), InkWell(onTap: onPressed, borderRadius: BorderRadius.circular(12.r), child: Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h), decoration: BoxDecoration(border: Border.all(color: AppColor.borderColor(context)), borderRadius: BorderRadius.circular(12.r)), child: Row(children: [Expanded(child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColor.titleFormFiledColor(context), fontSize: 12.sp))), Icon(Icons.keyboard_arrow_down_rounded, color: AppColor.darkTextColor(context))]))) ]);
  Widget _dateButton(bool from) { final value = from ? _fromDate : _toDate; return Expanded(child: _pickButton(label: from ? (_isArabic ? 'من تاريخ' : 'From date') : (_isArabic ? 'إلى تاريخ' : 'To date'), value: value == null ? (_isArabic ? 'اختر التاريخ' : 'Select date') : formatReportDateOnly(value), onPressed: () => _selectDate(from))); }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    return Container(constraints: BoxConstraints(maxHeight: 0.9.sh), decoration: BoxDecoration(color: AppColor.cardColor(context), borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))), child: SafeArea(top: false, child: Padding(padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 12.h), child: Row(children: [Expanded(child: Text(widget.title, style: TextStyle(color: foreground, fontSize: 18.sp, fontWeight: FontWeight.bold))), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded))])),
      Flexible(child: SingleChildScrollView(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_isArabic ? 'نطاق البنوك' : 'Bank range', style: TextStyle(color: foreground, fontSize: 13.sp, fontWeight: FontWeight.w600)), Gap(8.h),
        Row(children: [Expanded(child: _pickButton(label: _isArabic ? 'من بنك' : 'From bank', value: _bankLabel(_fromBank), onPressed: () => _selectBank(true))), Gap(10.w), Expanded(child: _pickButton(label: _isArabic ? 'إلى بنك' : 'To bank', value: _bankLabel(_toBank), onPressed: () => _selectBank(false)))]), Gap(14.h),
        Text(_isArabic ? 'فترة التقرير' : 'Report period', style: TextStyle(color: foreground, fontSize: 13.sp, fontWeight: FontWeight.w600)), Gap(8.h), Row(children: [_dateButton(true), Gap(10.w), _dateButton(false)]), Gap(14.h),
        CustomFormField(width: double.infinity, radius: 12.r, controller: _receiveController, hintText: _isArabic ? 'اسم المستلم' : 'Receive name', prefixIcon: const Icon(Icons.person_outline_rounded)), Gap(12.h),
        DropdownButtonFormField<int>(value: _checkStatus, decoration: InputDecoration(labelText: _isArabic ? 'حالة التصديق' : 'Verification status', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))), items: [DropdownMenuItem(value: 0, child: Text(_isArabic ? 'غير مصدق' : 'Unverified')), DropdownMenuItem(value: 1, child: Text(_isArabic ? 'مصدق' : 'Verified')), DropdownMenuItem(value: 2, child: Text(_isArabic ? 'الجميع' : 'All'))], onChanged: (value) { if (value != null) setState(() => _checkStatus = value); }), Gap(12.h),
        DropdownButtonFormField<String>(value: _exportType, decoration: InputDecoration(labelText: _isArabic ? 'نوع التصدير' : 'Export type', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))), items: const [DropdownMenuItem(value: 'pdf', child: Text('PDF')), DropdownMenuItem(value: 'excel', child: Text('Excel')), DropdownMenuItem(value: 'excelformatted', child: Text('Excel formatted')), DropdownMenuItem(value: 'word', child: Text('Word'))], onChanged: (value) { if (value != null) setState(() => _exportType = value); }),
        if (_validationMessage != null) ...[Gap(10.h), Text(_validationMessage!, style: TextStyle(color: AppColor.roseDanger, fontSize: 12.sp))], Gap(16.h), SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _submit, child: Text(_isArabic ? 'تصدير التقرير' : 'Export report'))),
      ]))),
    ]))));
  }
}
