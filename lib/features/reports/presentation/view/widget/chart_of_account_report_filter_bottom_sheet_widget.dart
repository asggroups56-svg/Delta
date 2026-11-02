import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';

class ChartOfAccountReportFilterSelection {
  final num? fromAccountNo;
  final num? toAccountNo;
  final String? fromCurrencyCode;
  final String? toCurrencyCode;
  final int? fromAccountLevel;
  final int? toAccountLevel;
  final int accountType;
  final int finalAccount;
  final String reportName;
  final String exportType;

  const ChartOfAccountReportFilterSelection({
    this.fromAccountNo,
    this.toAccountNo,
    this.fromCurrencyCode,
    this.toCurrencyCode,
    this.fromAccountLevel,
    this.toAccountLevel,
    required this.accountType,
    required this.finalAccount,
    required this.reportName,
    required this.exportType,
  });
}

class ChartOfAccountReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialExportType;

  const ChartOfAccountReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    required this.initialExportType,
  });

  static Future<ChartOfAccountReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<ChartOfAccountReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChartOfAccountReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<ChartOfAccountReportFilterBottomSheetWidget> createState() =>
      _ChartOfAccountReportFilterBottomSheetWidgetState();
}

class _ChartOfAccountReportFilterBottomSheetWidgetState
    extends State<ChartOfAccountReportFilterBottomSheetWidget> {
  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  final _fromCurrencyController = TextEditingController();
  final _toCurrencyController = TextEditingController();
  final _fromLevelController = TextEditingController();
  final _toLevelController = TextEditingController();

  int _accountType = 2;
  int _finalAccount = 4;
  String _reportName = 'AGL004';
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _exportType = widget.initialExportType;
  }

  @override
  void dispose() {
    _fromCurrencyController.dispose();
    _toCurrencyController.dispose();
    _fromLevelController.dispose();
    _toLevelController.dispose();
    super.dispose();
  }

  void _submit() {
    final fromAccountNo = _fromAccount?.accountNo;
    final toAccountNo = _toAccount?.accountNo;
    final fromAccountLevel = _parseLevel(_fromLevelController);
    final toAccountLevel = _parseLevel(_toLevelController);

    if ((_fromLevelController.text.trim().isNotEmpty &&
            fromAccountLevel == null) ||
        (_toLevelController.text.trim().isNotEmpty && toAccountLevel == null)) {
      setState(() {
        _validationMessage = _isArabic
            ? 'أدخل مستوى حساب صحيحاً'
            : 'Enter a valid account level';
      });
      return;
    }

    if (fromAccountNo != null &&
        toAccountNo != null &&
        fromAccountNo > toAccountNo) {
      setState(() {
        _validationMessage = _isArabic
            ? 'رقم الحساب من يجب أن يكون أقل من أو يساوي رقم الحساب إلى'
            : 'From account must be less than or equal to To account';
      });
      return;
    }
    if (fromAccountLevel != null &&
        toAccountLevel != null &&
        fromAccountLevel > toAccountLevel) {
      setState(() {
        _validationMessage = _isArabic
            ? 'مستوى البداية يجب أن يكون أقل من أو يساوي مستوى النهاية'
            : 'From level must be less than or equal to To level';
      });
      return;
    }

    Navigator.pop(
      context,
      ChartOfAccountReportFilterSelection(
        fromAccountNo: fromAccountNo,
        toAccountNo: toAccountNo,
        fromCurrencyCode: _optionalText(_fromCurrencyController),
        toCurrencyCode: _optionalText(_toCurrencyController),
        fromAccountLevel: fromAccountLevel,
        toAccountLevel: toAccountLevel,
        accountType: _accountType,
        finalAccount: _finalAccount,
        reportName: _reportName,
        exportType: _exportType,
      ),
    );
  }

  int? _parseLevel(TextEditingController controller) =>
      int.tryParse(controller.text.trim());

  String? _optionalText(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.oceanBlue;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.92,
      ),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: foreground.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                Gap(14.h),
                Row(
                  children: [
                    Icon(Icons.account_tree_rounded, color: accent, size: 24.r),
                    Gap(10.w),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: foreground,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: _isArabic ? 'إغلاق' : 'Close',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                Text(
                  'Report/ChartOfAccountReport',
                  style: TextStyle(
                    color: foreground.withValues(alpha: 0.5),
                    fontSize: 11.sp,
                    fontFamily: 'monospace',
                  ),
                ),
                Gap(18.h),
                _sectionTitle(_isArabic ? 'نطاق الحسابات' : 'Account range'),
                Gap(8.h),
                ChartOfAccountDropdown(
                  title: _isArabic ? 'من حساب' : 'From account',
                  hintText: _isArabic ? 'كل الحسابات' : 'All accounts',
                  accountType: 2,
                  initialValue: _fromAccount,
                  onSelected: (account) {
                    setState(() {
                      _fromAccount = account;
                      _fromCurrencyController.text =
                          account?.currencyCode?.toString() ?? '';
                      _fromLevelController.text =
                          account?.accountLevel.toString() ?? '';
                      _validationMessage = null;
                    });
                  },
                ),
                Gap(12.h),
                ChartOfAccountDropdown(
                  title: _isArabic ? 'إلى حساب' : 'To account',
                  hintText: _isArabic ? 'كل الحسابات' : 'All accounts',
                  accountType: 2,
                  initialValue: _toAccount,
                  onSelected: (account) {
                    setState(() {
                      _toAccount = account;
                      _toCurrencyController.text =
                          account?.currencyCode?.toString() ?? '';
                      _toLevelController.text =
                          account?.accountLevel.toString() ?? '';
                      _validationMessage = null;
                    });
                  },
                ),
                Gap(12.h),
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        controller: _fromCurrencyController,
                        label: _isArabic ? 'من عملة' : 'From currency',
                      ),
                    ),
                    Gap(10.w),
                    Expanded(
                      child: _textField(
                        controller: _toCurrencyController,
                        label: _isArabic ? 'إلى عملة' : 'To currency',
                      ),
                    ),
                  ],
                ),
                Gap(12.h),
                Row(
                  children: [
                    Expanded(
                      child: _levelField(
                        controller: _fromLevelController,
                        label: _isArabic ? 'من مستوى' : 'From level',
                      ),
                    ),
                    Gap(10.w),
                    Expanded(
                      child: _levelField(
                        controller: _toLevelController,
                        label: _isArabic ? 'إلى مستوى' : 'To level',
                      ),
                    ),
                  ],
                ),
                Gap(14.h),
                _dropdown<int>(
                  label: _isArabic ? 'نوع الحساب' : 'Account type',
                  value: _accountType,
                  options: [
                    (0, _isArabic ? 'رئيسي' : 'Main'),
                    (1, _isArabic ? 'فرعي' : 'Sub'),
                    (2, _isArabic ? 'الجميع' : 'All'),
                  ],
                  onChanged: (value) => setState(() => _accountType = value),
                ),
                Gap(12.h),
                _dropdown<int>(
                  label: _isArabic ? 'القوائم النهائية' : 'Final account',
                  value: _finalAccount,
                  options: [
                    (0, _isArabic ? 'بدون' : 'None'),
                    (1, _isArabic ? 'متاجرة وتشغيل' : 'Trading and operating'),
                    (2, _isArabic ? 'الأرباح والخسائر' : 'Profit and loss'),
                    (3, _isArabic ? 'الميزانية' : 'Balance sheet'),
                    (4, _isArabic ? 'الجميع' : 'All'),
                  ],
                  onChanged: (value) => setState(() => _finalAccount = value),
                ),
                Gap(12.h),
                _dropdown<String>(
                  label: _isArabic ? 'شكل التقرير' : 'Report format',
                  value: _reportName,
                  options: [
                    (
                      'AGL001',
                      _isArabic
                          ? 'بدون أرصدة (AGL001)'
                          : 'Without balances (AGL001)',
                    ),
                    (
                      'AGL002',
                      _isArabic
                          ? 'بالأرصدة (AGL002)'
                          : 'With balances (AGL002)',
                    ),
                    (
                      'AGL002a',
                      _isArabic
                          ? 'بالملاحظات (AGL002a)'
                          : 'With notes (AGL002a)',
                    ),
                    (
                      'AGL001A',
                      _isArabic ? 'شجري (AGL001A)' : 'Tree (AGL001A)',
                    ),
                    (
                      'AGL004',
                      _isArabic ? 'بالعملات (AGL004)' : 'By currency (AGL004)',
                    ),
                  ],
                  onChanged: (value) => setState(() => _reportName = value),
                ),
                Gap(12.h),
                _dropdown<String>(
                  label: _isArabic ? 'صيغة التصدير' : 'Export type',
                  value: _exportType,
                  options: [
                    ('pdf', 'PDF'),
                    ('excel', 'Excel'),
                    ('excelformatted', 'Excel PRO'),
                    ('word', 'Word'),
                  ],
                  onChanged: (value) => setState(() => _exportType = value),
                ),
                if (_validationMessage != null) ...[
                  Gap(12.h),
                  Text(
                    _validationMessage!,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
                Gap(20.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(_isArabic ? 'إلغاء' : 'Cancel'),
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _submit,
                        icon: Icon(switch (_exportType) {
                          'excel' => Icons.table_chart_rounded,
                          'excelformatted' => Icons.grid_on_rounded,
                          'word' => Icons.description_rounded,
                          _ => Icons.picture_as_pdf_rounded,
                        }),
                        label: Text(_isArabic ? 'عرض التقرير' : 'View report'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: TextStyle(
      color: AppColor.titleFormFiledColor(context),
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _textField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.characters,
      decoration: _decoration(label),
    );
  }

  Widget _levelField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: _decoration(label),
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    isDense: true,
    filled: true,
    fillColor: AppColor.textFormFillColor(context),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
  );

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<(T, String)> options,
    required ValueChanged<T> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      key: ValueKey('$label-$value'),
      initialValue: value,
      isExpanded: true,
      decoration: _decoration(label),
      items: [
        for (final (optionValue, optionLabel) in options)
          DropdownMenuItem<T>(
            value: optionValue,
            child: Text(optionLabel, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (nextValue) {
        if (nextValue != null) onChanged(nextValue);
      },
    );
  }
}
