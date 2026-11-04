import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/home/data/models/banks_data_model.dart';
import 'package:my_template/features/lookup/data/models/cash_voucher_light_model.dart';
import 'package:my_template/features/lookup/data/repository/lookup_repo.dart';

class CashInCashOutVoucherReportFilterSelection {
  final int receiptType;
  final String? fromVoucherNo;
  final String? toVoucherNo;
  final int? fromBankCode;
  final int? toBankCode;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String exportType;

  const CashInCashOutVoucherReportFilterSelection({
    required this.receiptType,
    required this.fromVoucherNo,
    required this.toVoucherNo,
    required this.fromBankCode,
    required this.toBankCode,
    required this.fromDate,
    required this.toDate,
    required this.exportType,
  });
}

class CashInCashOutVoucherReportFilterBottomSheetWidget extends StatefulWidget {
  final String title;
  final String initialExportType;

  const CashInCashOutVoucherReportFilterBottomSheetWidget({
    super.key,
    required this.title,
    this.initialExportType = 'pdf',
  });

  static Future<CashInCashOutVoucherReportFilterSelection?> show(
    BuildContext context, {
    required String title,
    String initialExportType = 'pdf',
  }) {
    return showModalBottomSheet<CashInCashOutVoucherReportFilterSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CashInCashOutVoucherReportFilterBottomSheetWidget(
        title: title,
        initialExportType: initialExportType,
      ),
    );
  }

  @override
  State<CashInCashOutVoucherReportFilterBottomSheetWidget> createState() =>
      _CashInCashOutVoucherReportFilterBottomSheetWidgetState();
}

class _CashInCashOutVoucherReportFilterBottomSheetWidgetState
    extends State<CashInCashOutVoucherReportFilterBottomSheetWidget> {
  int _receiptType = 1;
  String? _fromVoucherNo;
  String? _toVoucherNo;
  BANKSDATAModel? _fromBank;
  BANKSDATAModel? _toBank;
  DateTime? _fromDate;
  DateTime? _toDate;
  late String _exportType;
  String? _validationMessage;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
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

  Future<void> _selectVoucher({required bool isFromVoucher}) async {
    final voucherNo = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CashVoucherPicker(voucherType: _receiptType),
    );
    if (!mounted || voucherNo == null) return;
    setState(() {
      if (isFromVoucher) {
        _fromVoucherNo = voucherNo;
      } else {
        _toVoucherNo = voucherNo;
      }
      _validationMessage = null;
    });
  }

  Future<void> _selectBank({required bool isFromBank}) async {
    final bank = await showModalBottomSheet<BANKSDATAModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _BankPicker(),
    );
    if (!mounted || bank == null) return;
    setState(() {
      if (isFromBank) {
        _fromBank = bank;
      } else {
        _toBank = bank;
      }
    });
  }

  void _submit() {
    if ((_fromDate == null) != (_toDate == null)) {
      _showValidation(
        _isArabic
            ? 'اختر تاريخ البداية والنهاية معًا أو اتركهما فارغين'
            : 'Select both dates or leave both empty',
      );
      return;
    }
    if (_fromDate != null && _toDate != null && _fromDate!.isAfter(_toDate!)) {
      _showValidation(
        _isArabic
            ? 'تاريخ البداية يجب أن يسبق أو يساوي تاريخ النهاية'
            : 'From date must be before or equal to To date',
      );
      return;
    }
    Navigator.pop(
      context,
      CashInCashOutVoucherReportFilterSelection(
        receiptType: _receiptType,
        fromVoucherNo: _fromVoucherNo,
        toVoucherNo: _toVoucherNo,
        fromBankCode: _fromBank?.bankCode,
        toBankCode: _toBank?.bankCode,
        fromDate: _fromDate,
        toDate: _toDate,
        exportType: _exportType,
      ),
    );
  }

  void _showValidation(String message) {
    setState(() => _validationMessage = message);
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dropdown<int>(
                        label: _isArabic ? 'نوع الإيصال' : 'Receipt type',
                        value: _receiptType,
                        options: [
                          (1, _isArabic ? 'قبض' : 'Cash in'),
                          (2, _isArabic ? 'دفع' : 'Cash out'),
                        ],
                        onChanged: (value) => setState(() {
                          _receiptType = value;
                          _fromVoucherNo = null;
                          _toVoucherNo = null;
                        }),
                      ),
                      Gap(14.h),
                      _sectionTitle(
                        _isArabic ? 'نطاق أرقام الإيصالات' : 'Voucher range',
                        foreground,
                      ),
                      Gap(8.h),
                      Row(
                        children: [
                          Expanded(
                            child: _pickButton(
                              label: _isArabic ? 'من إيصال' : 'From voucher',
                              value: _fromVoucherNo,
                              onPressed: () =>
                                  _selectVoucher(isFromVoucher: true),
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: _pickButton(
                              label: _isArabic ? 'إلى إيصال' : 'To voucher',
                              value: _toVoucherNo,
                              onPressed: () =>
                                  _selectVoucher(isFromVoucher: false),
                            ),
                          ),
                        ],
                      ),
                      Gap(14.h),
                      _sectionTitle(
                        _isArabic ? 'نطاق البنوك' : 'Bank range',
                        foreground,
                      ),
                      Gap(8.h),
                      Row(
                        children: [
                          Expanded(
                            child: _pickButton(
                              label: _isArabic ? 'من بنك' : 'From bank',
                              value: _bankLabel(_fromBank),
                              onPressed: () => _selectBank(isFromBank: true),
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: _pickButton(
                              label: _isArabic ? 'إلى بنك' : 'To bank',
                              value: _bankLabel(_toBank),
                              onPressed: () => _selectBank(isFromBank: false),
                            ),
                          ),
                        ],
                      ),
                      Gap(14.h),
                      _sectionTitle(
                        _isArabic ? 'فترة التقرير' : 'Report period',
                        foreground,
                      ),
                      Gap(8.h),
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
                      Gap(14.h),
                      _dropdown<String>(
                        label: _isArabic ? 'صيغة التصدير' : 'Export format',
                        value: _exportType,
                        options: const [
                          ('pdf', 'PDF'),
                          ('excel', 'Excel'),
                          ('excelformatted', 'Excel formatted'),
                          ('word', 'Word'),
                        ],
                        onChanged: (value) =>
                            setState(() => _exportType = value),
                      ),
                      if (_validationMessage != null) ...[
                        Gap(10.h),
                        Text(
                          _validationMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        ),
                      ],
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

  String? _bankLabel(BANKSDATAModel? bank) {
    if (bank == null) return null;
    final name = _isArabic ? bank.bankName : bank.bankNameEng;
    return name == null || name.isEmpty ? '${bank.bankCode}' : name;
  }

  Widget _sectionTitle(String title, Color foreground) => Text(
    title,
    style: TextStyle(
      color: foreground,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _pickButton({
    required String label,
    required String? value,
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
        const Icon(Icons.search_rounded, size: 16),
        Gap(6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 10.sp)),
              Gap(2.h),
              Text(
                value ?? (_isArabic ? 'الكل' : 'All'),
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

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<(T, String)> options,
    required ValueChanged<T> onChanged,
  }) {
    final foreground = AppColor.titleFormFiledColor(context);
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColor.textFormFillColor(context),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      ),
      dropdownColor: AppColor.cardColor(context),
      style: TextStyle(color: foreground, fontSize: 13.sp),
      items: options
          .map(
            (option) =>
                DropdownMenuItem<T>(value: option.$1, child: Text(option.$2)),
          )
          .toList(),
      onChanged: (selected) {
        if (selected != null) onChanged(selected);
      },
    );
  }
}

class _CashVoucherPicker extends StatefulWidget {
  final int voucherType;

  const _CashVoucherPicker({required this.voucherType});

  @override
  State<_CashVoucherPicker> createState() => _CashVoucherPickerState();
}

class _CashVoucherPickerState extends State<_CashVoucherPicker> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<CashVoucherLightModel> _vouchers = [];
  int _page = 1;
  int _requestId = 0;
  bool _isLoading = false;
  bool _hasMore = false;
  String? _errorMessage;
  Timer? _debounce;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load(reset: true));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load({bool reset = false}) async {
    if (_isLoading && !reset) return;
    final requestId = ++_requestId;
    final page = reset ? 1 : _page + 1;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      if (reset) {
        _vouchers = [];
        _hasMore = false;
      }
    });
    final result = await sl<LookupRepo>().getCashVoucherLight(
      languageCode: Localizations.localeOf(context).languageCode,
      voucherType: widget.voucherType,
      searchWord: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
      page: page,
    );
    if (!mounted || requestId != _requestId) return;
    result.fold(
      (failure) => setState(() {
        _isLoading = false;
        _errorMessage = failure.errMessage;
      }),
      (response) => setState(() {
        _page = page;
        _isLoading = false;
        _hasMore = response.hasMore;
        _vouchers = reset
            ? response.vouchers
            : [..._vouchers, ...response.vouchers];
      }),
    );
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 80 &&
        !_isLoading &&
        _hasMore) {
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _isArabic;
    final foreground = AppColor.titleFormFiledColor(context);
    final title = widget.voucherType == 1
        ? (isArabic ? 'اختيار إيصال قبض' : 'Select cash receipt')
        : (isArabic ? 'اختيار إيصال دفع' : 'Select payment voucher');
    return Container(
      height: 0.75.sh,
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 12.h, 12.w, 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: foreground,
                      fontSize: 16.sp,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomFormField(
              width: double.infinity,
              radius: 12.r,
              controller: _searchController,
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: isArabic ? 'بحث برقم الإيصال' : 'Search voucher no.',
              onChanged: (_) {
                _debounce?.cancel();
                _debounce = Timer(
                  const Duration(milliseconds: 350),
                  () => _load(reset: true),
                );
              },
            ),
          ),
          Gap(8.h),
          Expanded(
            child: _errorMessage != null && _vouchers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_errorMessage!, textAlign: TextAlign.center),
                        TextButton(
                          onPressed: () => _load(reset: true),
                          child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _vouchers.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _vouchers.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final voucher = _vouchers[index];
                      final description = _isArabic
                          ? voucher.description
                          : voucher.englishDescription;
                      return ListTile(
                        title: Text(
                          _isArabic
                              ? 'سند رقم ${voucher.voucherNo}'
                              : 'Voucher ${voucher.voucherNo}',
                        ),
                        subtitle: description?.isNotEmpty == true
                            ? Text(description!)
                            : (voucher.description?.isNotEmpty == true
                                  ? Text(voucher.description!)
                                  : null),
                        onTap: () => Navigator.pop(context, voucher.voucherNo),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _BankPicker extends StatefulWidget {
  const _BankPicker();

  @override
  State<_BankPicker> createState() => _BankPickerState();
}

class _BankPickerState extends State<_BankPicker> {
  final _searchController = TextEditingController();
  List<BANKSDATAModel> _banks = [];
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _debounce;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final result = await sl<LookupRepo>().getBanksDataLight(
      languageCode: Localizations.localeOf(context).languageCode,
      searchWord: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _isLoading = false;
        _errorMessage = failure.errMessage;
      }),
      (banks) => setState(() {
        _isLoading = false;
        _banks = banks;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    return Container(
      height: 0.6.sh,
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 12.h, 12.w, 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _isArabic ? 'اختيار بنك' : 'Select bank',
                    style: TextStyle(
                      color: foreground,
                      fontSize: 16.sp,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomFormField(
              width: double.infinity,
              radius: 12.r,
              controller: _searchController,
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: _isArabic ? 'بحث عن بنك' : 'Search banks',
              onChanged: (_) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 350), _load);
              },
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_errorMessage != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_errorMessage!, textAlign: TextAlign.center),
                    TextButton(
                      onPressed: _load,
                      child: Text(_isArabic ? 'إعادة المحاولة' : 'Retry'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _banks.length,
                itemBuilder: (context, index) {
                  final bank = _banks[index];
                  final name = _isArabic ? bank.bankName : bank.bankNameEng;
                  return ListTile(
                    title: Text(
                      name?.isNotEmpty == true ? name! : '${bank.bankCode}',
                    ),
                    subtitle: Text(
                      bank.bankCode?.toString() ??
                          (_isArabic
                              ? 'رمز البنك غير متوفر'
                              : 'Bank code unavailable'),
                    ),
                    onTap: bank.bankCode == null
                        ? null
                        : () => Navigator.pop(context, bank),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
