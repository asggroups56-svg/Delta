import 'dart:async';

import 'package:dartz/dartz.dart' show Either;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../data/models/chart_of_account_light_model.dart';
import '../../data/repository/lookup_repo.dart';

typedef _ChartOfAccountPageLoader =
    Future<Either<Failure, ChartOfAccountLightResponse>> Function({
      required String searchWord,
      required int page,
    });

/// A searchable dropdown/picker that loads accounts from [ChartOfAccount/GetLight].
class ChartOfAccountDropdown extends StatefulWidget {
  final String? title;
  final String? hintText;
  final void Function(ChartOfAccountLightModel?)? onSelected;
  final ChartOfAccountLightModel? initialValue;
  final int accountType;
  final bool includeAccountsHasCostCenters;

  const ChartOfAccountDropdown({
    super.key,
    this.title,
    this.hintText,
    this.onSelected,
    this.initialValue,
    this.accountType = 1,
    this.includeAccountsHasCostCenters = true,
  });

  @override
  State<ChartOfAccountDropdown> createState() => _ChartOfAccountDropdownState();
}

class _ChartOfAccountDropdownState extends State<ChartOfAccountDropdown> {
  ChartOfAccountLightModel? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant ChartOfAccountDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selected = widget.initialValue;
    }
  }

  void _openPickerModal() async {
    final selected = await showModalBottomSheet<ChartOfAccountLightModel?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final languageCode = ctx.locale.languageCode;
        final repo = LookupRepoImpl(sl<ApiConsumer>());
        return _ChartOfAccountPickerModal(
          selectedItem: _selected,
          title:
              widget.title ??
              (languageCode == 'ar' ? 'اختر الحساب' : 'Select Account'),
          loadPage: ({required searchWord, required page}) =>
              repo.getChartOfAccountLight(
                languageCode: languageCode,
                accountType: widget.accountType,
                includeAccountsHasCostCenters:
                    widget.includeAccountsHasCostCenters,
                searchWord: searchWord.isEmpty ? null : searchWord,
                page: page,
                pageSize: 100,
              ),
        );
      },
    );

    if (!mounted) return;

    // If returned an item, or explicitly null (cleared)
    if (selected != null) {
      setState(() => _selected = selected);
      widget.onSelected?.call(selected);
    } else if (selected == null && _selected != null && _wasCleared) {
      setState(() => _selected = null);
      widget.onSelected?.call(null);
      _wasCleared = false;
    }
  }

  bool _wasCleared = false;

  void _clearSelection() {
    setState(() => _selected = null);
    widget.onSelected?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final isSelected = _selected != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: AppTextStyle.formTitleStyle(
              context,
            ).copyWith(fontWeight: FontWeight.w600, fontSize: 13.sp),
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
                    ? AppColor.primaryColor(context).withValues(alpha: 0.5)
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
                        ? AppColor.primaryColor(context).withValues(alpha: 0.12)
                        : foreground.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.account_tree_outlined,
                    size: 17.sp,
                    color: isSelected
                        ? AppColor.primaryColor(context)
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
                                color: AppColor.primaryColor(
                                  context,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Text(
                                '${_selected!.accountNo}',
                                style: TextStyle(
                                  color: AppColor.primaryColor(context),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Gap(8.w),
                            Expanded(
                              child: Text(
                                _selected!.accountName,
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
                          widget.hintText ??
                              (context.locale.languageCode == 'ar'
                                  ? 'اختر حساباً'
                                  : 'Select an account'),
                          style: AppTextStyle.hintStyle(
                            context,
                          ).copyWith(fontSize: 13.sp),
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
// Beautiful Picker Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ChartOfAccountPickerModal extends StatefulWidget {
  final ChartOfAccountLightModel? selectedItem;
  final String title;
  final _ChartOfAccountPageLoader loadPage;

  const _ChartOfAccountPickerModal({
    required this.selectedItem,
    required this.title,
    required this.loadPage,
  });

  @override
  State<_ChartOfAccountPickerModal> createState() =>
      _ChartOfAccountPickerModalState();
}

class _ChartOfAccountPickerModalState
    extends State<_ChartOfAccountPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChartOfAccountLightModel> _items = [];
  bool _isLoading = false;
  bool _hasError = false;
  bool _hasMore = false;
  int _page = 0;
  int _totalRecords = 0;
  int _requestId = 0;
  String? _errorMessage;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fetch(page: 1, reset: true);
    });
  }

  Future<void> _fetch({required int page, bool reset = false}) async {
    if (!mounted || (!reset && (_isLoading || !_hasMore))) return;
    final requestId = ++_requestId;
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
      if (reset) {
        _items = [];
        _totalRecords = 0;
        _hasMore = false;
      }
    });
    final result = await widget.loadPage(
      searchWord: _searchController.text.trim(),
      page: page,
    );
    if (!mounted || requestId != _requestId) return;
    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = failure.errMessage;
        });
      },
      (response) {
        setState(() {
          _page = page;
          _hasMore = response.hasMore;
          _totalRecords = response.totalRecords;
          _isLoading = false;
          _errorMessage = null;
          if (reset) {
            _items = response.chartOfAccounts;
          } else {
            _items = [..._items, ...response.chartOfAccounts];
          }
        });
      },
    );
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoading &&
        _hasMore) {
      _fetch(page: _page + 1);
    }
  }

  void _onSearch(String query) {
    _debounce?.cancel();
    setState(() {
      _requestId++;
      _isLoading = true;
      _hasError = false;
    });
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) _fetch(page: 1, reset: true);
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
    final accent = AppColor.primaryColor(context);

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
                      Icons.account_tree_rounded,
                      color: accent,
                      size: 20.r,
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: foreground,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$_totalRecords ${context.locale.languageCode == 'ar' ? 'حساب متاح' : 'accounts available'}',
                          style: TextStyle(
                            color: foreground.withValues(alpha: 0.5),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
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
                  onChanged: _onSearch,
                  style: AppTextStyle.textFormStyle(context),
                  decoration: InputDecoration(
                    hintText: context.locale.languageCode == 'ar'
                        ? 'ابحث باسم أو رقم الحساب...'
                        : 'Search by account name or number...',
                    hintStyle: AppTextStyle.hintStyle(
                      context,
                    ).copyWith(fontSize: 13.sp),
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
                              _onSearch('');
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
              child: _hasError && _items.isEmpty
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
                            _errorMessage ??
                                (context.locale.languageCode == 'ar'
                                    ? 'حدث خطأ في تحميل الحسابات'
                                    : 'Failed to load accounts'),
                            style: AppTextStyle.bodySmall(context),
                          ),
                          Gap(10.h),
                          ElevatedButton.icon(
                            onPressed: () => _fetch(page: 1, reset: true),
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
                  : _isLoading && _items.isEmpty
                  ? Center(child: CircularProgressIndicator(color: accent))
                  : _items.isEmpty
                  ? Center(
                      child: Text(
                        context.locale.languageCode == 'ar'
                            ? 'لا توجد نتائج مطابقة للبحث'
                            : 'No accounts found',
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
                      itemCount:
                          _items.length + (_isLoading || _hasError ? 1 : 0),
                      separatorBuilder: (context, index) => Gap(6.h),
                      itemBuilder: (ctx, index) {
                        if (index == _items.length) {
                          if (_hasError) {
                            return Center(
                              child: TextButton.icon(
                                onPressed: () => _fetch(page: _page + 1),
                                icon: const Icon(Icons.refresh_rounded),
                                label: Text(
                                  context.locale.languageCode == 'ar'
                                      ? 'تعذر تحميل المزيد، أعد المحاولة'
                                      : 'Could not load more. Retry',
                                ),
                              ),
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.all(12.r),
                            child: Center(
                              child: CircularProgressIndicator(color: accent),
                            ),
                          );
                        }
                        final item = _items[index];
                        final isSelected =
                            item.accountNo == widget.selectedItem?.accountNo;

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
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    '${item.accountNo}',
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
                                        item.accountName,
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
                                          '${item.currencyName} (${item.currencyExchangeRate ?? 1})',
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
