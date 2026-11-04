import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/chart_of_account_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/chart_of_account_dropdown.dart';

class LedgerReportPerUsersFilterSelection {
  final num? fromAccountNo;
  final num? toAccountNo;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reportName;
  final String exportType;

  const LedgerReportPerUsersFilterSelection({
    required this.fromAccountNo,
    required this.toAccountNo,
    required this.fromDate,
    required this.toDate,
    required this.reportName,
    required this.exportType,
  });
}

class LedgerReportPerUsersFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialExportType;

  const LedgerReportPerUsersFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<LedgerReportPerUsersFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<LedgerReportPerUsersFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LedgerReportPerUsersFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<LedgerReportPerUsersFilterBottomSheetWidget> createState() =>
      _LedgerReportPerUsersFilterBottomSheetWidgetState();
}

class _LedgerReportPerUsersFilterBottomSheetWidgetState
    extends State<LedgerReportPerUsersFilterBottomSheetWidget> {
  static const _reportOptions = <String, (String, String)>{
    'AGL021': ('ح/ الأستاذ إجمالي', 'Main ledger summary'),
    'AGL023': ('ح/ الأستاذ تفصيلي', 'Main ledger detailed'),
    'AGL023B': (
      'ح/ الأستاذ تفصيلي - ج مدين/دائن',
      'Detailed ledger - debit/credit',
    ),
    'AGL022': ('الأستاذ إجمالي بعملة', 'Ledger summary by currency'),
    'AGL024': ('ح/ الأستاذ تفصيلي بعملة', 'Detailed ledger by currency'),
    'AGL023A': ('ح/ الأستاذ مجمل تفصيلي', 'Combined detailed ledger'),
    'AGL0107': ('تحليلي أرصدة الحسابات', 'Analytical account balances'),
    'AGL0108': ('كشف حساب تفصيلي', 'Detailed account statement'),
  };

  ChartOfAccountLightModel? _fromAccount;
  ChartOfAccountLightModel? _toAccount;
  DateTime? _fromDate;
  DateTime? _toDate;
  late String _reportName;
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _reportName = _reportOptions.keys.first;
    _exportType = widget.initialExportType;
  }

  Future<void> _selectDate({required bool isFromDate}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateUtils.dateOnly(
        (isFromDate ? _fromDate : _toDate) ?? DateTime.now(),
      ),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (isFromDate) {
        _fromDate = DateUtils.dateOnly(selected);
      } else {
        _toDate = DateUtils.dateOnly(selected);
      }
      _validationMessage = null;
    });
  }

  void _submit() {
    if (_fromDate != null && _toDate != null && _fromDate!.isAfter(_toDate!)) {
      setState(() {
        _validationMessage = _isArabic
            ? 'تاريخ البداية يجب أن يسبق أو يساوي تاريخ النهاية'
            : 'From date must be before or equal to To date';
      });
      return;
    }

    Navigator.pop(
      context,
      LedgerReportPerUsersFilterSelection(
        fromAccountNo: _fromAccount?.accountNo,
        toAccountNo: _toAccount?.accountNo,
        fromDate: _fromDate,
        toDate: _toDate,
        reportName: _reportName,
        exportType: _exportType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    return Container(
      constraints: BoxConstraints(maxHeight: 0.9.sh),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 12.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: foreground,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _reportName,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'نوع التقرير' : 'Report type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: _reportOptions.entries
                            .map(
                              (entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(
                                  _isArabic ? entry.value.$1 : entry.value.$2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _reportName = value);
                          }
                        },
                      ),
                      Gap(12.h),
                      ChartOfAccountDropdown(
                        title: _isArabic ? 'من حساب' : 'From account',
                        accountType: 1,
                        initialValue: _fromAccount,
                        onSelected: (account) {
                          setState(() => _fromAccount = account);
                        },
                      ),
                      Gap(8.h),
                      ChartOfAccountDropdown(
                        title: _isArabic ? 'إلى حساب' : 'To account',
                        accountType: 1,
                        initialValue: _toAccount,
                        onSelected: (account) {
                          setState(() => _toAccount = account);
                        },
                      ),
                      Gap(12.h),
                      Row(
                        children: [
                          Expanded(
                            child: _dateButton(
                              label: _isArabic ? 'من تاريخ' : 'From date',
                              date: _fromDate,
                              onPressed: () => _selectDate(isFromDate: true),
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: _dateButton(
                              label: _isArabic ? 'إلى تاريخ' : 'To date',
                              date: _toDate,
                              onPressed: () => _selectDate(isFromDate: false),
                            ),
                          ),
                        ],
                      ),
                      if (_validationMessage != null) ...[
                        Gap(10.h),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            _validationMessage!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                      Gap(12.h),
                      DropdownButtonFormField<String>(
                        initialValue: _exportType,
                        decoration: InputDecoration(
                          labelText: _isArabic
                              ? 'صيغة التصدير'
                              : 'Export format',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                          DropdownMenuItem(
                            value: 'excel',
                            child: Text('Excel'),
                          ),
                          DropdownMenuItem(
                            value: 'excelformatted',
                            child: Text('Excel formatted'),
                          ),
                          DropdownMenuItem(value: 'word', child: Text('Word')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _exportType = value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColor.oceanBlue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(_isArabic ? 'عرض التقرير' : 'Show report'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onPressed,
  }) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColor.oceanBlue,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
    child: Row(
      children: [
        const Icon(Icons.calendar_today_rounded, size: 16),
        Gap(8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 10.sp)),
              Gap(2.h),
              Text(
                date == null
                    ? (_isArabic ? 'الكل' : 'All dates')
                    : MaterialLocalizations.of(context).formatMediumDate(date),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
