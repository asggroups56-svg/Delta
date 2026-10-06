import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/network/api_consumer.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../data/models/chart_of_account_light_model.dart';
import '../../data/repository/lookup_repo.dart';

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
  late final LookupRepo _repo;
  ChartOfAccountLightModel? _selected;

  List<ChartOfAccountLightModel> _allItems = [];
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _repo = LookupRepoImpl(sl<ApiConsumer>());
    _selected = widget.initialValue;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fetch();
    });
  }

  @override
  void didUpdateWidget(covariant ChartOfAccountDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selected = widget.initialValue;
    }
  }

  Future<void> _fetch() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    final lang = context.locale.languageCode;
    final result = await _repo.getChartOfAccountLight(
      languageCode: lang,
      accountType: widget.accountType,
      includeAccountsHasCostCenters: widget.includeAccountsHasCostCenters,
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
            _allItems = response.chartOfAccounts;
            _isLoading = false;
          });
        }
      },
    );
  }

  void _openPickerModal() async {
    final selected = await showModalBottomSheet<ChartOfAccountLightModel?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ChartOfAccountPickerModal(
        items: _allItems,
        selectedItem: _selected,
        isLoading: _isLoading,
        hasError: _hasError,
        onRetry: _fetch,
        title: widget.title ?? (context.locale.languageCode == 'ar' ? 'اختر الحساب' : 'Select Account'),
      ),
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
                                color: AppColor.primaryColor(context)
                                    .withValues(alpha: 0.15),
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
                else if (_isLoading)
                  SizedBox(
                    width: 16.r,
                    height: 16.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.primaryColor(context),
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
  final List<ChartOfAccountLightModel> items;
  final ChartOfAccountLightModel? selectedItem;
  final bool isLoading;
  final bool hasError;
  final VoidCallback onRetry;
  final String title;

  const _ChartOfAccountPickerModal({
    required this.items,
    required this.selectedItem,
    required this.isLoading,
    required this.hasError,
    required this.onRetry,
    required this.title,
  });

  @override
  State<_ChartOfAccountPickerModal> createState() =>
      _ChartOfAccountPickerModalState();
}

class _ChartOfAccountPickerModalState
    extends State<_ChartOfAccountPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  List<ChartOfAccountLightModel> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
  }

  void _onSearch(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filtered = widget.items;
      } else {
        final q = query.trim().toLowerCase();
        _filtered = widget.items
            .where((item) =>
                item.accountName.toLowerCase().contains(q) ||
                item.accountNo.toString().contains(q))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                          '${_filtered.length} ${context.locale.languageCode == 'ar' ? 'حساب متاح' : 'accounts available'}',
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
              child: widget.hasError
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
                                ? 'حدث خطأ في تحميل الحسابات'
                                : 'Failed to load accounts',
                            style: AppTextStyle.bodySmall(context),
                          ),
                          Gap(10.h),
                          ElevatedButton.icon(
                            onPressed: widget.onRetry,
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
                  : widget.isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: accent),
                        )
                      : _filtered.isEmpty
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
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              itemCount: _filtered.length,
                              separatorBuilder: (context, index) => Gap(6.h),
                              itemBuilder: (ctx, index) {
                                final item = _filtered[index];
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
                                            borderRadius:
                                                BorderRadius.circular(6.r),
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
