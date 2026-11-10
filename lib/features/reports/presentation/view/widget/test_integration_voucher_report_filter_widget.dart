import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';

class TestIntegrationVoucherReportFilter {
  final int? fromEntrySerial;
  final int? toEntrySerial;
  final int? entryType;
  final String reportName;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String exportType;

  const TestIntegrationVoucherReportFilter({
    required this.fromEntrySerial,
    required this.toEntrySerial,
    required this.entryType,
    required this.reportName,
    required this.fromDate,
    required this.toDate,
    required this.exportType,
  });
}

class TestIntegrationVoucherReportFilterWidget extends StatefulWidget {
  final String title;
  final String initialExportType;
  final String initialReportName;
  const TestIntegrationVoucherReportFilterWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
    this.initialReportName = 'AGL063',
  });

  static Future<TestIntegrationVoucherReportFilter?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
    String initialReportName = 'AGL063',
  }) => showModalBottomSheet<TestIntegrationVoucherReportFilter>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => TestIntegrationVoucherReportFilterWidget(
      title: title,
      initialExportType: initialExportType,
      initialReportName: initialReportName,
    ),
  );

  @override
  State<TestIntegrationVoucherReportFilterWidget> createState() =>
      _TestIntegrationVoucherReportFilterWidgetState();
}

class _TestIntegrationVoucherReportFilterWidgetState
    extends State<TestIntegrationVoucherReportFilterWidget> {
  final _fromSerial = TextEditingController();
  final _toSerial = TextEditingController();
  DateTime? _fromDate, _toDate;
  late String _exportType;
  late String _reportName;
  int _entryType = 5;
  String? _error;
  bool get _ar => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _exportType = widget.initialExportType;
    _reportName = widget.initialReportName;
  }

  @override
  void dispose() {
    _fromSerial.dispose();
    _toSerial.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool from) async {
    final value = await showDatePicker(
      context: context,
      initialDate: DateUtils.dateOnly((from ? _fromDate : _toDate) ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (value == null || !mounted) return;
    setState(() {
      if (from) {
        _fromDate = DateUtils.dateOnly(value);
      } else {
        _toDate = DateUtils.dateOnly(value);
      }
      _error = null;
    });
  }

  void _submit() {
    final fromSerial = int.tryParse(_fromSerial.text.trim());
    final toSerial = int.tryParse(_toSerial.text.trim());
    if ((_fromSerial.text.trim().isNotEmpty && fromSerial == null) ||
        (_toSerial.text.trim().isNotEmpty && toSerial == null)) {
      setState(() => _error = _ar ? 'أدخل رقمًا تسلسليًا صحيحًا' : 'Enter a valid entry serial');
      return;
    }
    if (fromSerial != null && toSerial != null && fromSerial > toSerial) {
      setState(() => _error = _ar ? 'نطاق الرقم التسلسلي غير صحيح' : 'Enter a valid serial range');
      return;
    }
    if ((_fromDate == null) != (_toDate == null) ||
        (_fromDate != null && _fromDate!.isAfter(_toDate!))) {
      setState(() => _error = _ar ? 'أدخل نطاق تاريخ صحيحًا' : 'Enter a valid date range');
      return;
    }
    Navigator.pop(context, TestIntegrationVoucherReportFilter(
      fromEntrySerial: fromSerial,
      toEntrySerial: toSerial,
      entryType: _reportName == 'AGL900' ? _entryType : null,
      reportName: _reportName,
      fromDate: _fromDate,
      toDate: _toDate,
      exportType: _exportType,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final exports = {'pdf': 'PDF', 'excel': 'Excel', 'excelformatted': 'Excel formatted', 'word': 'Word'};
    final entryTypes = <int, String>{
      1: _ar ? 'عادي' : 'Normal',
      2: _ar ? 'إلى' : 'To',
      3: _ar ? 'دوري' : 'Periodic',
      4: _ar ? 'جدولي' : 'Tabular',
      5: _ar ? 'الجميع' : 'All',
    };
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .9),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(26.r))),
      child: SafeArea(top: false, child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(padding: EdgeInsets.fromLTRB(20.w, 12.h, 12.w, 14.h), child: Column(children: [
          Container(width: 38.w, height: 4.h, decoration: BoxDecoration(color: scheme.onSurface.withValues(alpha: .2), borderRadius: BorderRadius.circular(8.r))),
          Gap(14.h),
          Row(children: [
            Container(padding: EdgeInsets.all(10.r), decoration: BoxDecoration(color: scheme.primary.withValues(alpha: .1), borderRadius: BorderRadius.circular(14.r)), child: Icon(Icons.fact_check_outlined, color: scheme.primary)),
            Gap(12.w), Expanded(child: Text(widget.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
          ]),
        ])),
        Flexible(child: SingleChildScrollView(padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 18.h), child: Column(children: [
          if (_reportName == 'AGL900') ...[
            DropdownButtonFormField<int>(
              initialValue: _entryType,
              decoration: InputDecoration(labelText: _ar ? 'نوع القيد' : 'Entry type', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
              items: entryTypes.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
              onChanged: (value) { if (value != null) setState(() => _entryType = value); },
            ),
            Gap(12.h),
          ],
          CustomFormField(controller: _fromSerial, title: _ar ? 'من رقم القيد' : 'From entry serial', keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
          Gap(10.h),
          CustomFormField(controller: _toSerial, title: _ar ? 'إلى رقم القيد' : 'To entry serial', keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
          Gap(12.h),
          Row(children: [
            Expanded(child: OutlinedButton.icon(onPressed: () => _pickDate(true), icon: const Icon(Icons.calendar_today_outlined), label: Text(_fromDate == null ? (_ar ? 'من تاريخ' : 'From date') : MaterialLocalizations.of(context).formatMediumDate(_fromDate!)))),
            Gap(8.w),
            Expanded(child: OutlinedButton.icon(onPressed: () => _pickDate(false), icon: const Icon(Icons.event_outlined), label: Text(_toDate == null ? (_ar ? 'إلى تاريخ' : 'To date') : MaterialLocalizations.of(context).formatMediumDate(_toDate!)))),
          ]),
          Gap(10.h),
          DropdownButtonFormField<String>(initialValue: _exportType, decoration: InputDecoration(labelText: _ar ? 'صيغة التصدير' : 'Export format', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))), items: exports.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(), onChanged: (value) { if (value != null) setState(() => _exportType = value); }),
          if (_error != null) Padding(padding: EdgeInsets.only(top: 8.h), child: Text(_error!, style: TextStyle(color: scheme.error))),
          Gap(16.h),
          SizedBox(width: double.infinity, height: 50.h, child: FilledButton.icon(onPressed: _submit, icon: const Icon(Icons.play_arrow_rounded), label: Text(_ar ? 'عرض التقرير' : 'Generate report'))),
        ]))),
      ])),
    );
  }
}
