import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/network/api_consumer.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../data/models/cost_center_light_model.dart';
import '../../data/repository/lookup_repo.dart';

/// A searchable dropdown/picker that loads cost centers from
/// [CostCenter/GetLight].
class CostCenterDropdown extends StatefulWidget {
  final String? title;
  final String? hintText;
  final void Function(CostCenterLightModel?)? onSelected;
  final CostCenterLightModel? initialValue;
  final int centerType;
  final int centerKind;
  final int pageSize;

  const CostCenterDropdown({
    super.key,
    this.title,
    this.hintText,
    this.onSelected,
    this.initialValue,
    this.centerType = 1,
    this.centerKind = 0,
    this.pageSize = 20,
  });

  @override
  State<CostCenterDropdown> createState() => _CostCenterDropdownState();
}

class _CostCenterDropdownState extends State<CostCenterDropdown> {
  CostCenterLightModel? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant CostCenterDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selected = widget.initialValue;
    }
  }

  void _openPickerModal() async {
    final defaultTitle = context.locale.languageCode == 'ar'
        ? 'اختر مركز التكلفة'
        : 'Select Cost Center';

    final selected = await showModalBottomSheet<CostCenterLightModel?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CostCenterPickerModal(
        centerType: widget.centerType,
        centerKind: widget.centerKind,
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

  String get _defaultHint => context.locale.languageCode == 'ar'
      ? 'اختر مركز تكلفة'
      : 'Select a cost center';

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.purpleAccent;
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
                    Icons.business_outlined,
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
                                '${_selected!.costCenterNo}',
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
                                _selected!.centerName,
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
// Beautiful Cost Center Picker Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _CostCenterPickerModal extends StatefulWidget {
  final int centerType;
  final int centerKind;
  final CostCenterLightModel? selectedItem;
  final int pageSize;
  final String title;

  const _CostCenterPickerModal({
    required this.centerType,
    required this.centerKind,
    required this.selectedItem,
    required this.pageSize,
    required this.title,
  });

  @override
  State<_CostCenterPickerModal> createState() => _CostCenterPickerModalState();
}

class _CostCenterPickerModalState extends State<_CostCenterPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final LookupRepo _repo;

  List<CostCenterLightModel> _items = [];
  bool _isLoading = false;
  bool _hasError = false;
  bool _hasMore = false;
  int _page = 1;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _repo = LookupRepoImpl(sl<ApiConsumer>());
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fetch(page: 1, reset: true);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 120 &&
        !_isLoading &&
        _hasMore) {
      _fetch(page: _page + 1);
    }
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        _fetch(page: 1, reset: true);
      }
    });
  }

  Future<void> _fetch({required int page, bool reset = false}) async {
    if (_isLoading) return;
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      if (reset) {
        _hasError = false;
      }
    });

    final lang = context.locale.languageCode;
    final query = _searchController.text.trim();

    final result = await _repo.getCostCenterLight(
      languageCode: lang,
      centerType: widget.centerType,
      centerKind: widget.centerKind,
      searchWord: query.isEmpty ? null : query,
      page: page,
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
            _page = page;
            _hasMore = response.hasMore;
            _isLoading = false;
            if (reset) {
              _items = response.costCenters;
            } else {
              _items.addAll(response.costCenters);
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = AppColor.titleFormFiledColor(context);
    final accent = AppColor.purpleAccent;
    final isAr = context.locale.languageCode == 'ar';

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
            // Top grab handle
            Gap(10.h),
            Center(
              child: Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: foreground.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Gap(12.h),

            // Header Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.business_outlined,
                      color: accent,
                      size: 20.sp,
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: AppTextStyle.formTitleStyle(context).copyWith(
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
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
            Gap(10.h),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.textFormFillColor(context),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: foreground.withValues(alpha: 0.1),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  style: AppTextStyle.textFormStyle(context).copyWith(
                    fontSize: 13.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: isAr
                        ? 'ابحث برقم أو اسم مركز التكلفة...'
                        : 'Search by cost center no or name...',
                    hintStyle: AppTextStyle.hintStyle(context).copyWith(
                      fontSize: 12.5.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: accent,
                      size: 20.sp,
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
                              _fetch(page: 1, reset: true);
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
            Gap(12.h),

            // List of Cost Centers
            Expanded(
              child: _buildBody(foreground, accent, isAr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(Color foreground, Color accent, bool isAr) {
    if (_isLoading && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(strokeWidth: 2.5, color: accent),
            Gap(12.h),
            Text(
              isAr ? 'جاري التحميل...' : 'Loading...',
              style: TextStyle(
                color: foreground.withValues(alpha: 0.6),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      );
    }

    if (_hasError && _items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 40.sp,
                color: Colors.redAccent,
              ),
              Gap(10.h),
              Text(
                isAr
                    ? 'تعذر تحميل مراكز التكلفة'
                    : 'Failed to load cost centers',
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              Gap(12.h),
              ElevatedButton.icon(
                onPressed: () => _fetch(page: 1, reset: true),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(isAr ? 'إعادة المحاولة' : 'Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 42.sp,
              color: foreground.withValues(alpha: 0.3),
            ),
            Gap(8.h),
            Text(
              isAr
                  ? 'لا توجد مراكز تكلفة مطابقة للبحث'
                  : 'No matching cost centers found',
              style: TextStyle(
                color: foreground.withValues(alpha: 0.6),
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: _items.length + (_hasMore ? 1 : 0),
      separatorBuilder: (_, _) => Gap(6.h),
      itemBuilder: (context, index) {
        if (index == _items.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Center(
              child: SizedBox(
                width: 22.r,
                height: 22.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: accent,
                ),
              ),
            ),
          );
        }

        final item = _items[index];
        final isSelected = widget.selectedItem?.costCenterNo == item.costCenterNo;

        return Material(
          color: isSelected
              ? accent.withValues(alpha: 0.12)
              : AppColor.cardColor(context),
          borderRadius: BorderRadius.circular(12.r),
          child: InkWell(
            onTap: () => Navigator.pop(context, item),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? accent.withValues(alpha: 0.5)
                      : foreground.withValues(alpha: 0.08),
                  width: isSelected ? 1.2 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accent
                          : accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      '${item.costCenterNo}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : accent,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.centerName,
                          style: AppTextStyle.textFormStyle(context).copyWith(
                            fontSize: 13.sp,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                        ),
                        if (item.debit != null || item.credit != null) ...[
                          Gap(2.h),
                          Row(
                            children: [
                              if (item.debit != null && item.debit! > 0)
                                Text(
                                  '${isAr ? 'مدين' : 'Debit'}: ${item.debit!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppColor.emeraldTeal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              if (item.debit != null &&
                                  item.debit! > 0 &&
                                  item.credit != null &&
                                  item.credit! > 0)
                                Text(
                                  '  •  ',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: foreground.withValues(alpha: 0.4),
                                  ),
                                ),
                              if (item.credit != null && item.credit! > 0)
                                Text(
                                  '${isAr ? 'دائن' : 'Credit'}: ${item.credit!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppColor.oceanBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
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
          ),
        );
      },
    );
  }
}
