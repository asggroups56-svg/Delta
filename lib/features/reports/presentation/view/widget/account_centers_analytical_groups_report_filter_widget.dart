import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

class AccountCentersAnalyticalGroupsReportFilter {
  final int? levelCenter;
  final String reportName;
  final num? fromAccountNo, toAccountNo, fromCostCenterNo, toCostCenterNo;
  final DateTime? fromDate, toDate;
  final String exportType;

  const AccountCentersAnalyticalGroupsReportFilter({
    required this.levelCenter,
    required this.reportName,
    required this.fromAccountNo,
    required this.toAccountNo,
    required this.fromCostCenterNo,
    required this.toCostCenterNo,
    required this.fromDate,
    required this.toDate,
    required this.exportType,
  });
}

class AccountCentersAnalyticalGroupsReportFilterWidget extends StatefulWidget {
  final String title;
  final String initialExportType;
  final String initialReportName;
  const AccountCentersAnalyticalGroupsReportFilterWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
    this.initialReportName = 'AGL026L',
  });

  static Future<AccountCentersAnalyticalGroupsReportFilter?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
    String initialReportName = 'AGL026L',
  }) => showModalBottomSheet<AccountCentersAnalyticalGroupsReportFilter>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AccountCentersAnalyticalGroupsReportFilterWidget(
      title: title,
      initialExportType: initialExportType,
      initialReportName: initialReportName,
    ),
  );

  @override
  State<AccountCentersAnalyticalGroupsReportFilterWidget> createState() =>
      _AccountCentersAnalyticalGroupsReportFilterWidgetState();
}

class _AccountCentersAnalyticalGroupsReportFilterWidgetState
    extends State<AccountCentersAnalyticalGroupsReportFilterWidget> {
  final _level = TextEditingController();
  ChartOfAccountLightModel? _fromAccount, _toAccount;
  CostCenterLightModel? _fromCenter, _toCenter;
  DateTime? _fromDate, _toDate;
  late String _exportType;
  late String _reportName;
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
    _level.dispose();
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
    setState(() => from ? _fromDate = DateUtils.dateOnly(value) : _toDate = DateUtils.dateOnly(value));
  }

  void _submit() {
    final level = _level.text.trim().isEmpty ? null : int.tryParse(_level.text.trim());
    if (_level.text.trim().isNotEmpty && level == null) {
      setState(() => _error = _ar ? 'أدخل مستوى صحيحًا' : 'Enter a valid center level');
      return;
    }
    if ((_fromDate == null) != (_toDate == null) || (_fromDate != null && _fromDate!.isAfter(_toDate!))) {
      setState(() => _error = _ar ? 'أدخل نطاق تاريخ صحيحًا' : 'Enter a valid date range');
      return;
    }
    Navigator.pop(context, AccountCentersAnalyticalGroupsReportFilter(
      levelCenter: level,
      reportName: _reportName,
      fromAccountNo: _fromAccount?.accountNo,
      toAccountNo: _toAccount?.accountNo,
      fromCostCenterNo: _fromCenter?.costCenterNo,
      toCostCenterNo: _toCenter?.costCenterNo,
      fromDate: _fromDate,
      toDate: _toDate,
      exportType: _exportType,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final level = int.tryParse(_level.text.trim());
    final options = {'pdf': 'PDF', 'excel': 'Excel', 'excelformatted': 'Excel formatted', 'word': 'Word'};
    final foreground = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .92),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
      ),
      child: SafeArea(top: false, child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(padding: EdgeInsets.fromLTRB(20.w, 12.h, 12.w, 12.h), child: Column(children: [
          Container(width: 38.w, height: 4.h, decoration: BoxDecoration(color: foreground.withValues(alpha: .22), borderRadius: BorderRadius.circular(8.r))),
          Gap(14.h),
          Row(children: [
            Container(padding: EdgeInsets.all(10.r), decoration: BoxDecoration(color: primary.withValues(alpha: .1), borderRadius: BorderRadius.circular(14.r)), child: Icon(Icons.analytics_outlined, color: primary)),
            Gap(12.w), Expanded(child: Text(widget.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
          ]),
        ])),
        Flexible(child: SingleChildScrollView(padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 16.h), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle(_ar ? 'نوع التقرير' : 'Report type', foreground),
          Gap(8.h),
          Row(children: [
            Expanded(child: _reportTypeCard('AGL026L', _ar ? 'إجمالي' : 'Summary', _reportName == 'AGL026L', primary, () => setState(() => _reportName = 'AGL026L'))),
            Gap(10.w),
            Expanded(child: _reportTypeCard('AGL099', _ar ? 'تفصيلي' : 'Detailed', _reportName == 'AGL099', primary, () => setState(() => _reportName = 'AGL099'))),
          ]),
          Gap(16.h),
          _sectionTitle(_ar ? 'المستوى والحسابات' : 'Level and accounts', foreground),
          Gap(8.h),
          CustomFormField(controller: _level, title: _ar ? 'مستوى مركز التكلفة' : 'Cost center level', keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], onChanged: (_) => setState(() { _fromCenter = null; _toCenter = null; })),
          Gap(8.h),
          ChartOfAccountDropdown(title: _ar ? 'من حساب' : 'From account', accountType: 1, includeAccountRangeFields: false, includeAccountsHasCostCenters: null, initialValue: _fromAccount, onSelected: (v) => setState(() => _fromAccount = v)),
          Gap(8.h),
          ChartOfAccountDropdown(title: _ar ? 'إلى حساب' : 'To account', accountType: 1, includeAccountRangeFields: false, includeAccountsHasCostCenters: null, initialValue: _toAccount, onSelected: (v) => setState(() => _toAccount = v)),
          Gap(16.h),
          _sectionTitle(_ar ? 'مراكز التكلفة' : 'Cost centers', foreground),
          Gap(8.h),
          CostCenterDropdown(key: ValueKey('from_$level'), title: _ar ? 'من مركز' : 'From center', centerType: null, centerKind: null, centerLevel: level ?? 1, accountType: 1, pageSize: 10, initialValue: _fromCenter, onSelected: (v) => setState(() => _fromCenter = v)),
          Gap(8.h),
          CostCenterDropdown(key: ValueKey('to_$level'), title: _ar ? 'إلى مركز' : 'To center', centerType: null, centerKind: null, centerLevel: level ?? 1, accountType: 1, pageSize: 10, initialValue: _toCenter, onSelected: (v) => setState(() => _toCenter = v)),
          Gap(16.h),
          _sectionTitle(_ar ? 'الفترة والتصدير' : 'Period and export', foreground),
          Gap(8.h),
          Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () => _pickDate(true), icon: const Icon(Icons.calendar_today_outlined), label: Text(_fromDate == null ? (_ar ? 'من تاريخ' : 'From date') : MaterialLocalizations.of(context).formatMediumDate(_fromDate!)))), Gap(8.w), Expanded(child: OutlinedButton.icon(onPressed: () => _pickDate(false), icon: const Icon(Icons.event_outlined), label: Text(_toDate == null ? (_ar ? 'إلى تاريخ' : 'To date') : MaterialLocalizations.of(context).formatMediumDate(_toDate!))))]),
          DropdownButtonFormField<String>(initialValue: _exportType, decoration: InputDecoration(labelText: _ar ? 'صيغة التصدير' : 'Export format'), items: options.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(), onChanged: (v) { if (v != null) setState(() => _exportType = v); }),
          if (_error != null) Padding(padding: EdgeInsets.only(top: 8.h), child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          Gap(16.h),
          SizedBox(width: double.infinity, height: 50.h, child: FilledButton.icon(onPressed: _submit, icon: const Icon(Icons.picture_as_pdf_outlined), label: Text(_ar ? 'عرض التقرير' : 'Generate report'))),
        ]))),
      ])),
    );
  }

  Widget _sectionTitle(String title, Color color) => Text(title, style: TextStyle(color: color.withValues(alpha: .72), fontSize: 13.sp, fontWeight: FontWeight.w700));

  Widget _reportTypeCard(String code, String label, bool selected, Color primary, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14.r),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: selected ? primary.withValues(alpha: .1) : Theme.of(context).colorScheme.surface,
        border: Border.all(color: selected ? primary : Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(children: [Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, size: 18.r, color: selected ? primary : Theme.of(context).disabledColor), Gap(8.w), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp)), Text(code, style: TextStyle(color: Theme.of(context).hintColor, fontSize: 11.sp))]))]),
    ),
  );
}
