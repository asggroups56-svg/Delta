import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/home/data/models/banks_data_model.dart';
import 'package:my_template/features/lookup/data/repository/lookup_repo.dart';

/// Opens the bank picker backed by `BanksData/GetLight`.
Future<BANKSDATAModel?> showBankPicker(BuildContext context) {
  return showModalBottomSheet<BANKSDATAModel>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _BankPicker(),
  );
}

/// Localized bank label, falling back to the bank code.
String bankDisplayName(BANKSDATAModel bank, {required bool isArabic}) {
  final name = isArabic ? bank.bankName : bank.bankNameEng;
  return name == null || name.isEmpty ? '${bank.bankCode}' : name;
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
      pageSize: 100,
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
