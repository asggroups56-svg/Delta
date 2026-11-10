import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/data/models/cost_center_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';
import 'package:my_template/features/lookup/presentation/widgets/cost_center_dropdown.dart';

class AccountCentersAnalyticalDetailsReportFilter {
  final num? fromAccountNo, toAccountNo, fromCostCenterNo, toCostCenterNo;
  final int? fromAccAnal, toAccAnal, fromCentAnal, toCentAnal;
  final int? fromAnalytical, toAnalytical;
  final DateTime? fromDate, toDate;
  final String exportType;

  const AccountCentersAnalyticalDetailsReportFilter({
    required this.fromAccountNo,
    required this.toAccountNo,
    required this.fromCostCenterNo,
    required this.toCostCenterNo,
    required this.fromAccAnal,
    required this.toAccAnal,
    required this.fromCentAnal,
    required this.toCentAnal,
    required this.fromAnalytical,
    required this.toAnalytical,
    required this.fromDate,
    required this.toDate,
    required this.exportType,
  });
}

class AccountCentersAnalyticalDetailsReportFilterWidget extends StatefulWidget {
  final String title;
  final String initialExportType;

  const AccountCentersAnalyticalDetailsReportFilterWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<AccountCentersAnalyticalDetailsReportFilter?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) => showModalBottomSheet<AccountCentersAnalyticalDetailsReportFilter>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AccountCentersAnalyticalDetailsReportFilterWidget(
      title: title,
      initialExportType: initialExportType,
    ),
  );

  @override
  State<AccountCentersAnalyticalDetailsReportFilterWidget> createState() =>
      _AccountCentersAnalyticalDetailsReportFilterWidgetState();
}

class _AccountCentersAnalyticalDetailsReportFilterWidgetState
    extends State<AccountCentersAnalyticalDetailsReportFilterWidget> {
  ChartOfAccountLightModel? _fromAccount, _toAccount;
  CostCenterLightModel? _fromCostCenter, _toCostCenter;
  final _fromAccAnal = TextEditingController();
  final _toAccAnal = TextEditingController();
  final _fromCentAnal = TextEditingController();
  final _toCentAnal = TextEditingController();
  final _fromAnalytical = TextEditingController();
  final _toAnalytical = TextEditingController();
  DateTime? _fromDate, _toDate;
  late String _exportType;
  String? _error;

  bool get _ar => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _exportType = widget.initialExportType;
  }

  @override
  void dispose() {
    _fromAccAnal.dispose();
    _toAccAnal.dispose();
    _fromCentAnal.dispose();
    _toCentAnal.dispose();
    _fromAnalytical.dispose();
    _toAnalytical.dispose();
    super.dispose();
  }

  int? _number(TextEditingController c) =>
      c.text.trim().isEmpty ? null : int.tryParse(c.text.trim());

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
    final controls = [_fromAccAnal, _toAccAnal, _fromCentAnal, _toCentAnal, _fromAnalytical, _toAnalytical];
    if (controls.any((c) => c.text.trim().isNotEmpty && _number(c) == null)) {
      setState(() => _error = _ar ? 'أدخل أرقامًا صحيحة في حقول التحليل' : 'Enter valid numbers in analytical fields');
      return;
    }
    if ((_fromDate == null) != (_toDate == null) ||
        (_fromDate != null && _fromDate!.isAfter(_toDate!))) {
      setState(() => _error = _ar ? 'أدخل نطاق تاريخ صحيحًا' : 'Enter a valid date range');
      return;
    }
    Navigator.pop(context, AccountCentersAnalyticalDetailsReportFilter(
      fromAccountNo: _fromAccount?.accountNo,
      toAccountNo: _toAccount?.accountNo,
      fromCostCenterNo: _fromCostCenter?.costCenterNo,
      toCostCenterNo: _toCostCenter?.costCenterNo,
      fromAccAnal: _number(_fromAccAnal), toAccAnal: _number(_toAccAnal),
      fromCentAnal: _number(_fromCentAnal), toCentAnal: _number(_toCentAnal),
      fromAnalytical: _number(_fromAnalytical), toAnalytical: _number(_toAnalytical),
      fromDate: _fromDate, toDate: _toDate, exportType: _exportType,
    ));
  }

  Widget _numericField(String label, TextEditingController c) => CustomFormField(
    controller: c,
    title: label,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  );

  Widget _dateButton(bool from) => OutlinedButton.icon(
    onPressed: () => _pickDate(from),
    icon: const Icon(Icons.calendar_month_outlined),
    label: Text((from ? _fromDate : _toDate) == null
        ? (from ? (_ar ? 'من تاريخ' : 'From date') : (_ar ? 'إلى تاريخ' : 'To date'))
        : MaterialLocalizations.of(context).formatMediumDate((from ? _fromDate : _toDate)!)),
  );

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final options = {'pdf': 'PDF', 'excel': 'Excel', 'excelformatted': 'Excel formatted', 'word': 'Word'};
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .92),
      decoration: BoxDecoration(color: AppColor.cardColor(context), borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      child: SafeArea(top: false, child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(padding: EdgeInsets.all(16.r), child: Row(children: [
          Expanded(child: Text(widget.title, style: TextStyle(color: foreground, fontSize: 18.sp, fontWeight: FontWeight.bold))),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
        ])),
        Flexible(child: SingleChildScrollView(padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h), child: Column(children: [
          ChartOfAccountDropdown(title: _ar ? 'من حساب' : 'From account', accountType: 1, includeAccountRangeFields: false, includeAccountsHasCostCenters: null, initialValue: _fromAccount, onSelected: (v) => setState(() => _fromAccount = v)),
          Gap(8.h),
          ChartOfAccountDropdown(title: _ar ? 'إلى حساب' : 'To account', accountType: 1, includeAccountRangeFields: false, includeAccountsHasCostCenters: null, initialValue: _toAccount, onSelected: (v) => setState(() => _toAccount = v)),
          Gap(8.h),
          CostCenterDropdown(title: _ar ? 'من مركز تكلفة' : 'From cost center', centerType: 1, centerKind: 0, accountType: 1, initialValue: _fromCostCenter, onSelected: (v) => setState(() => _fromCostCenter = v)),
          Gap(8.h),
          CostCenterDropdown(title: _ar ? 'إلى مركز تكلفة' : 'To cost center', centerType: 1, centerKind: 0, accountType: 1, initialValue: _toCostCenter, onSelected: (v) => setState(() => _toCostCenter = v)),
          Gap(8.h),
          _numericField(_ar ? 'من تحليل الحساب' : 'From account analysis', _fromAccAnal),
          _numericField(_ar ? 'إلى تحليل الحساب' : 'To account analysis', _toAccAnal),
          _numericField(_ar ? 'من تحليل مركز التكلفة' : 'From cost center analysis', _fromCentAnal),
          _numericField(_ar ? 'إلى تحليل مركز التكلفة' : 'To cost center analysis', _toCentAnal),
          _numericField(_ar ? 'من التحليل' : 'From analytical', _fromAnalytical),
          _numericField(_ar ? 'إلى التحليل' : 'To analytical', _toAnalytical),
          Row(children: [Expanded(child: _dateButton(true)), Gap(8.w), Expanded(child: _dateButton(false))]),
          DropdownButtonFormField<String>(initialValue: _exportType, decoration: InputDecoration(labelText: _ar ? 'صيغة التصدير' : 'Export type'), items: options.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(), onChanged: (v) { if (v != null) setState(() => _exportType = v); }),
          if (_error != null) Padding(padding: EdgeInsets.only(top: 8.h), child: Text(_error!, style: const TextStyle(color: Colors.red))),
          Gap(14.h),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: _submit, child: Text(_ar ? 'عرض التقرير' : 'Generate report'))),
        ]))),
      ])),
    );
  }
}
