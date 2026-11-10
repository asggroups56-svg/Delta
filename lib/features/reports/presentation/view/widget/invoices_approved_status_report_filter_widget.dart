import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/lookup/data/models/customer_datum_light_model.dart';
import 'package:my_template/features/lookup/presentation/widgets/customer_datum_dropdown.dart';

class InvoicesApprovedStatusReportFilter {
  final double? fromCustomerNo;
  final double? toCustomerNo;
  final DateTime? fromTransDate;
  final DateTime? toTransDate;
  final int invoiceType;
  final String exportType;

  const InvoicesApprovedStatusReportFilter({
    required this.fromCustomerNo,
    required this.toCustomerNo,
    required this.fromTransDate,
    required this.toTransDate,
    required this.invoiceType,
    required this.exportType,
  });
}

class InvoicesApprovedStatusReportFilterWidget extends StatefulWidget {
  final String title;

  const InvoicesApprovedStatusReportFilterWidget({
    super.key,
    required this.title,
  });

  static Future<InvoicesApprovedStatusReportFilter?> show(
    BuildContext context, {
    required String title,
  }) =>
      showModalBottomSheet<InvoicesApprovedStatusReportFilter>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (_) => InvoicesApprovedStatusReportFilterWidget(title: title),
      );

  @override
  State<InvoicesApprovedStatusReportFilterWidget> createState() =>
      _InvoicesApprovedStatusReportFilterWidgetState();
}

class _InvoicesApprovedStatusReportFilterWidgetState
    extends State<InvoicesApprovedStatusReportFilterWidget> {
  CustomerDatumLightModel? _fromCustomer;
  CustomerDatumLightModel? _toCustomer;
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _includeDates = false;
  int _invoiceType = 4;
  String _exportType = 'pdf';

  bool get _isArabic => context.locale.languageCode == 'ar';

  Future<void> _pickDate({required bool from}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: (from ? _fromDate : _toDate) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (from) {
        _fromDate = DateUtils.dateOnly(selected);
      } else {
        _toDate = DateUtils.dateOnly(selected);
      }
    });
  }

  String _dateText(DateTime? date, String emptyText) => date == null
      ? emptyText
      : MaterialLocalizations.of(context).formatMediumDate(date);

  void _submit() {
    if (_fromDate != null &&
        _toDate != null &&
        _fromDate!.isAfter(_toDate!)) {
      return;
    }
    Navigator.pop(
      context,
      InvoicesApprovedStatusReportFilter(
        fromCustomerNo: _fromCustomer?.customerNo.toDouble(),
        toCustomerNo: _toCustomer?.customerNo.toDouble(),
        fromTransDate: _includeDates ? _fromDate : null,
        toTransDate: _includeDates ? _toDate : null,
        invoiceType: _invoiceType,
        exportType: _exportType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.oceanBlue;
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .9),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 8.h),
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
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                  child: Column(
                    children: [
                      CustomerDatumDropdown(
                        type: CustomerDatumType.customer,
                        title: _isArabic ? 'من عميل' : 'From customer',
                        hintText: _isArabic ? 'اختر العميل' : 'Select customer',
                        initialValue: _fromCustomer,
                        onSelected: (value) =>
                            setState(() => _fromCustomer = value),
                      ),
                      Gap(12.h),
                      CustomerDatumDropdown(
                        type: CustomerDatumType.customer,
                        title: _isArabic ? 'إلى عميل' : 'To customer',
                        hintText: _isArabic ? 'اختر العميل' : 'Select customer',
                        initialValue: _toCustomer,
                        onSelected: (value) =>
                            setState(() => _toCustomer = value),
                      ),
                      Gap(12.h),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        value: _includeDates,
                        activeThumbColor: accent,
                        title: Text(
                          _isArabic ? 'تحديد فترة التاريخ' : 'Filter by date range',
                          style: TextStyle(color: foreground, fontSize: 13.sp),
                        ),
                        onChanged: (value) =>
                            setState(() => _includeDates = value),
                      ),
                      if (_includeDates) ...[
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _pickDate(from: true),
                                child: Text(
                                  _dateText(
                                    _fromDate,
                                    _isArabic ? 'من تاريخ' : 'From date',
                                  ),
                                ),
                              ),
                            ),
                            Gap(8.w),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _pickDate(from: false),
                                child: Text(
                                  _dateText(
                                    _toDate,
                                    _isArabic ? 'إلى تاريخ' : 'To date',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(12.h),
                      ],
                      DropdownButtonFormField<int>(
                        initialValue: _invoiceType,
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'نوع الفاتورة' : 'Invoice type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: Text(_isArabic ? 'غير معتمدة' : 'Not approved'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text(_isArabic ? 'المعتمدة فقط' : 'Approved only'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text(_isArabic ? 'المشاركة فقط' : 'Shared only'),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text(_isArabic ? 'الجميع' : 'All'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _invoiceType = value);
                        },
                      ),
                      Gap(12.h),
                      DropdownButtonFormField<String>(
                        initialValue: _exportType,
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'صيغة التصدير' : 'Export format',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                          DropdownMenuItem(value: 'excel', child: Text('Excel')),
                          DropdownMenuItem(
                            value: 'excelformatted',
                            child: Text('Excel formatted'),
                          ),
                          DropdownMenuItem(value: 'word', child: Text('Word')),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _exportType = value);
                        },
                      ),
                      Gap(12.h),
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'اسم التقرير' : 'Report name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: const Text('AAR206'),
                      ),
                      Gap(16.h),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                          ),
                          child: Text(_isArabic ? 'عرض التقرير' : 'Show report'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
