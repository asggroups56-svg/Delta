import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class IntegratedVouchersStatusReportFilter {
  final DateTime? fromDate;
  final DateTime? toDate;
  final int integratedVouchersStatusType;
  final int programType;
  final String exportType;

  const IntegratedVouchersStatusReportFilter({
    required this.fromDate,
    required this.toDate,
    required this.integratedVouchersStatusType,
    required this.programType,
    required this.exportType,
  });
}

class IntegratedVouchersStatusReportFilterWidget extends StatefulWidget {
  final String title;
  final String initialExportType;
  const IntegratedVouchersStatusReportFilterWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<IntegratedVouchersStatusReportFilter?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) => showModalBottomSheet<IntegratedVouchersStatusReportFilter>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => IntegratedVouchersStatusReportFilterWidget(
      title: title,
      initialExportType: initialExportType,
    ),
  );

  @override
  State<IntegratedVouchersStatusReportFilterWidget> createState() =>
      _IntegratedVouchersStatusReportFilterWidgetState();
}

class _IntegratedVouchersStatusReportFilterWidgetState
    extends State<IntegratedVouchersStatusReportFilterWidget> {
  DateTime? _fromDate, _toDate;
  int _statusType = 3;
  int _programType = 6;
  late String _exportType;
  String? _error;
  bool get _ar => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _exportType = widget.initialExportType;
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
    if ((_fromDate == null) != (_toDate == null) ||
        (_fromDate != null && _fromDate!.isAfter(_toDate!))) {
      setState(() => _error = _ar ? 'أدخل نطاق تاريخ صحيحًا' : 'Enter a valid date range');
      return;
    }
    Navigator.pop(context, IntegratedVouchersStatusReportFilter(
      fromDate: _fromDate,
      toDate: _toDate,
      integratedVouchersStatusType: _statusType,
      programType: _programType,
      exportType: _exportType,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final exportTypes = {'pdf': 'PDF', 'excel': 'Excel', 'excelformatted': 'Excel formatted', 'word': 'Word'};
    final statusTypes = <int, String>{
      1: _ar ? 'القيود المرحلة' : 'Posted vouchers',
      2: _ar ? 'القيود الغير المرحلة' : 'Unposted vouchers',
      3: _ar ? 'الجميع' : 'All',
    };
    final programTypes = <int, String>{
      1: _ar ? 'الأصول الثابتة' : 'Fixed assets',
      2: _ar ? 'العملاء والمبيعات' : 'Customers and sales',
      3: _ar ? 'مراقبة المخزون' : 'Inventory control',
      4: _ar ? 'الحركة المالية' : 'Financial transactions',
      5: _ar ? 'الموردين والمشتريات' : 'Suppliers and purchases',
      6: _ar ? 'الجميع' : 'All',
    };

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .9),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
      ),
      child: SafeArea(top: false, child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 12.w, 14.h),
          child: Column(children: [
            Container(width: 38.w, height: 4.h, decoration: BoxDecoration(color: colorScheme.onSurface.withValues(alpha: .2), borderRadius: BorderRadius.circular(8.r))),
            Gap(14.h),
            Row(children: [
              Container(padding: EdgeInsets.all(10.r), decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: .1), borderRadius: BorderRadius.circular(14.r)), child: Icon(Icons.sync_alt_rounded, color: colorScheme.primary)),
              Gap(12.w),
              Expanded(child: Text(widget.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
            ]),
          ]),
        ),
        Flexible(child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 18.h),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _label(_ar ? 'حالة القيود' : 'Voucher status'),
            Gap(6.h),
            DropdownButtonFormField<int>(
              initialValue: _statusType,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
              items: statusTypes.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
              onChanged: (value) { if (value != null) setState(() => _statusType = value); },
            ),
            Gap(14.h),
            _label(_ar ? 'نوع البرنامج' : 'Program type'),
            Gap(6.h),
            DropdownButtonFormField<int>(
              initialValue: _programType,
              isExpanded: true,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
              items: programTypes.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (value) { if (value != null) setState(() => _programType = value); },
            ),
            Gap(14.h),
            _label(_ar ? 'الفترة' : 'Date range'),
            Gap(6.h),
            Row(children: [
              Expanded(child: OutlinedButton.icon(onPressed: () => _pickDate(true), icon: const Icon(Icons.calendar_today_outlined), label: Text(_fromDate == null ? (_ar ? 'من تاريخ' : 'From date') : MaterialLocalizations.of(context).formatMediumDate(_fromDate!)))),
              Gap(8.w),
              Expanded(child: OutlinedButton.icon(onPressed: () => _pickDate(false), icon: const Icon(Icons.event_outlined), label: Text(_toDate == null ? (_ar ? 'إلى تاريخ' : 'To date') : MaterialLocalizations.of(context).formatMediumDate(_toDate!)))),
            ]),
            Gap(10.h),
            DropdownButtonFormField<String>(
              initialValue: _exportType,
              decoration: InputDecoration(labelText: _ar ? 'صيغة التصدير' : 'Export format', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
              items: exportTypes.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
              onChanged: (value) { if (value != null) setState(() => _exportType = value); },
            ),
            if (_error != null) Padding(padding: EdgeInsets.only(top: 8.h), child: Text(_error!, style: TextStyle(color: colorScheme.error))),
            Gap(16.h),
            SizedBox(width: double.infinity, height: 50.h, child: FilledButton.icon(onPressed: _submit, icon: const Icon(Icons.picture_as_pdf_outlined), label: Text(_ar ? 'عرض التقرير' : 'Generate report'))),
          ]),
        )),
      ])),
    );
  }

  Widget _label(String value) => Text(value, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700));
}
