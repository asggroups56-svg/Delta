import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/network/api_consumer.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../data/models/customer_datum_light_model.dart';
import '../../data/repository/lookup_repo.dart';

/// Type of party to load.
enum CustomerDatumType {
  /// CustSuppType = 1
  customer,

  /// CustSuppType = 2
  supplier,
}

/// A searchable dropdown/picker that loads customers or suppliers from
/// [CustomerDatum/GetLight] depending on [type].
class CustomerDatumDropdown extends StatefulWidget {
  final CustomerDatumType type;
  final String? title;
  final String? hintText;
  final void Function(CustomerDatumLightModel?)? onSelected;
  final CustomerDatumLightModel? initialValue;
  final int pageSize;

  const CustomerDatumDropdown({
    super.key,
    required this.type,
    this.title,
    this.hintText,
    this.onSelected,
    this.initialValue,
    this.pageSize = 50,
  });

  @override
  State<CustomerDatumDropdown> createState() => _CustomerDatumDropdownState();
}

class _CustomerDatumDropdownState extends State<CustomerDatumDropdown> {
  CustomerDatumLightModel? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant CustomerDatumDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selected = widget.initialValue;
    }
  }

  void _openPickerModal() async {
    final defaultTitle = widget.type == CustomerDatumType.customer
        ? (context.locale.languageCode == 'ar' ? 'اختر العميل' : 'Select Customer')
        : (context.locale.languageCode == 'ar' ? 'اختر المورد' : 'Select Supplier');

    final selected = await showModalBottomSheet<CustomerDatumLightModel?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CustomerDatumPickerModal(
        type: widget.type,
        selectedItem: _selected,
        pageSize: widget.pageSize,
        title: widget.title ?? defaultTitle,
      ),
    );

    if (!mounted) return;

    if (selected != null) {
      setState(() => _selected = selected);
      widget.onSelected?.call(selected);
    }
  }

  void _clearSelection() {
    setState(() => _selected = null);
    widget.onSelected?.call(null);
  }

  String get _defaultHint => widget.type == CustomerDatumType.customer
      ? (context.locale.languageCode == 'ar' ? 'اختر عميلاً' : 'Select a customer')
      : (context.locale.languageCode == 'ar' ? 'اختر موردًا' : 'Select a supplier');

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = widget.type == CustomerDatumType.customer
        ? AppColor.primaryColor(context)
        : AppColor.oceanBlue;
    final isSelected = _selected != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: AppTextStyle.formTitleStyle(context).copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
          Gap(6.h),
        ],
        InkWell(
          onTap: _openPickerModal,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: AppColor.textFormFillColor(context),
              border: Border.all(
                color: isSelected
                    ? accent.withValues(alpha: 0.5)
                    : foreground.withValues(alpha: 0.12),
                width: isSelected ? 1.2 : 1.0,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accent.withValues(alpha: 0.12)
                        : foreground.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    widget.type == CustomerDatumType.customer
                        ? Icons.person_outline_rounded
                        : Icons.store_outlined,
                    size: 17.sp,
                    color: isSelected
                        ? accent
                        : foreground.withValues(alpha: 0.5),
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: isSelected
                      ? Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Text(
                                '${_selected!.customerNo}',
                                style: TextStyle(
                                  color: accent,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Gap(8.w),
                            Expanded(
                              child: Text(
                                _selected!.customerName,
                                style: AppTextStyle.textFormStyle(context)
                                    .copyWith(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          widget.hintText ?? _defaultHint,
                          style: AppTextStyle.hintStyle(context).copyWith(
                            fontSize: 13.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
                Gap(8.w),
                if (isSelected)
                  InkWell(
                    onTap: _clearSelection,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16.sp,
                        color: foreground.withValues(alpha: 0.5),
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: foreground.withValues(alpha: 0.5),
                    size: 20.sp,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Beautiful Customer/Supplier Picker Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _CustomerDatumPickerModal extends StatefulWidget {
  final CustomerDatumType type;
  final CustomerDatumLightModel? selectedItem;
  final int pageSize;
  final String title;

  const _CustomerDatumPickerModal({
    required this.type,
    required this.selectedItem,
    required this.pageSize,
    required this.title,
  });

  @override
  State<_CustomerDatumPickerModal> createState() =>
      _CustomerDatumPickerModalState();
}

class _CustomerDatumPickerModalState extends State<_CustomerDatumPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final LookupRepo _repo;

  List<CustomerDatumLightModel> _items = [];
  bool _isLoading = false;
  bool _hasError = false;
  bool _hasMore = false;
  int _page = 1;
  String _lastSearch = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _repo = LookupRepoImpl(sl<ApiConsumer>());
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fetch(reset: true);
    });
  }

  int get _custSuppType => widget.type == CustomerDatumType.customer ? 1 : 2;

  Future<void> _fetch({bool reset = false, String? search}) async {
    if (!mounted) return;
    if (reset) {
      _page = 1;
      _items = [];
    }
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    final lang = context.locale.languageCode;
    final result = await _repo.getCustomerDatumLight(
      languageCode: lang,
      custSuppType: _custSuppType,
      searchWord: search?.isNotEmpty == true ? search : null,
      page: _page,
      pageSize: widget.pageSize,
    );
    if (!mounted) return;
    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
      },
      (response) {
        if (mounted) {
          setState(() {
            if (reset) {
              _items = response.customerDatas;
            } else {
              _items = [..._items, ...response.customerDatas];
            }
            _hasMore = response.hasMore;
            _isLoading = false;
          });
        }
      },
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoading &&
        _hasMore) {
      _page++;
      _fetch(search: _lastSearch.isNotEmpty ? _lastSearch : null);
    }
  }

  void _onSearchChanged(String value) {
    _lastSearch = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      _fetch(reset: true, search: value.isNotEmpty ? value : null);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = widget.type == CustomerDatumType.customer
        ? AppColor.primaryColor(context)
        : AppColor.oceanBlue;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(color: foreground.withValues(alpha: 0.08)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(10.h),
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: foreground.withValues(alpha: 0.24),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            Gap(12.h),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Row(
                children: [
                  Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      widget.type == CustomerDatumType.customer
                          ? Icons.person_search_rounded
                          : Icons.store_rounded,
                      color: accent,
                      size: 20.r,
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: foreground.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Gap(12.h),
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.textFormFillColor(context),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: foreground.withValues(alpha: 0.08)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: AppTextStyle.textFormStyle(context),
                  decoration: InputDecoration(
                    hintText: context.locale.languageCode == 'ar'
                        ? 'ابحث بالاسم أو الرقم...'
                        : 'Search by name or number...',
                    hintStyle: AppTextStyle.hintStyle(context).copyWith(
                      fontSize: 13.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 20.sp,
                      color: accent,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              size: 18.sp,
                              color: foreground.withValues(alpha: 0.5),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
            ),
            Gap(10.h),
            const Divider(height: 1, thickness: 0.6),
            // Content
            Expanded(
              child: _hasError
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: AppColor.roseDanger,
                            size: 32.sp,
                          ),
                          Gap(8.h),
                          Text(
                            context.locale.languageCode == 'ar'
                                ? 'حدث خطأ في تحميل البيانات'
                                : 'Failed to load data',
                            style: AppTextStyle.bodySmall(context),
                          ),
                          Gap(10.h),
                          ElevatedButton.icon(
                            onPressed: () => _fetch(reset: true, search: _lastSearch),
                            icon: const Icon(Icons.refresh_rounded, size: 16),
                            label: Text(
                              context.locale.languageCode == 'ar'
                                  ? 'إعادة المحاولة'
                                  : 'Retry',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : (_items.isEmpty && !_isLoading)
                      ? Center(
                          child: Text(
                            context.locale.languageCode == 'ar'
                                ? 'لا توجد نتائج'
                                : 'No results found',
                            style: TextStyle(
                              color: foreground.withValues(alpha: 0.5),
                              fontSize: 13.sp,
                            ),
                          ),
                        )
                      : ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          itemCount: _items.length + (_hasMore ? 1 : 0),
                          separatorBuilder: (context, index) => Gap(6.h),
                          itemBuilder: (ctx, index) {
                            if (index == _items.length) {
                              return Padding(
                                padding: EdgeInsets.all(12.r),
                                child: Center(
                                  child: SizedBox(
                                    width: 20.r,
                                    height: 20.r,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: accent,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final item = _items[index];
                            final isSelected =
                                item.customerNo == widget.selectedItem?.customerNo;

                            return InkWell(
                              onTap: () => Navigator.pop(context, item),
                              borderRadius: BorderRadius.circular(10.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? accent.withValues(alpha: 0.08)
                                      : AppColor.cardSurfaceColor(context),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? accent.withValues(alpha: 0.4)
                                        : foreground.withValues(alpha: 0.05),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 7.w,
                                        vertical: 3.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: accent.withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                      ),
                                      child: Text(
                                        '${item.customerNo}',
                                        style: TextStyle(
                                          color: accent,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Gap(10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.customerName,
                                            style: TextStyle(
                                              color: foreground,
                                              fontSize: 13.sp,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                            ),
                                          ),
                                          if (item.currencyName != null &&
                                              item.currencyName!.isNotEmpty) ...[
                                            Gap(2.h),
                                            Text(
                                              '${item.currencyName} (${item.exchangeRate})',
                                              style: TextStyle(
                                                color: foreground.withValues(
                                                  alpha: 0.45,
                                                ),
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle_rounded,
                                        color: accent,
                                        size: 20.sp,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
