import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/custom_widgets/custom_loading/custom_shimmer.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/accounts_tree_model.dart';
import '../../data/repository/lookup_repo.dart';

/// Chart-of-accounts tree shown on the organization page.
///
/// Loads the flat account rows from `ChartOfAccount/GetLight`, merges paged
/// results and renders the hierarchy with expandable/collapsible levels.
class AccountsTreeSection extends StatefulWidget {
  /// Page size used while loading the tree. Large enough to render most charts
  /// in one request; a "load more" action is shown while `hasMore` is true.
  final int pageSize;

  const AccountsTreeSection({super.key, this.pageSize = 100});

  @override
  State<AccountsTreeSection> createState() => _AccountsTreeSectionState();
}

class _AccountsTreeSectionState extends State<AccountsTreeSection> {
  static const _accent = Color(0xFF7C3AED);
  static const _gradientStart = Color(0xFF3F3D9E);
  static const _gradientMiddle = Color(0xFF6D28D9);
  static const _gradientEnd = Color(0xFF9333EA);
  static const _debitColor = Color(0xFF10B981);
  static const _creditColor = Color(0xFFF97316);
  static const _levelColors = <Color>[
    Color(0xFF4F46E5), // level 1 - indigo
    Color(0xFF0284C7), // level 2 - sky
    Color(0xFF0D9488), // level 3 - teal
    Color(0xFFD97706), // level 4 - amber
    Color(0xFFE11D48), // level 5+ - rose
  ];

  final TextEditingController _searchController = TextEditingController();
  final Set<int> _collapsed = <int>{};

  Timer? _debounce;
  List<AccountsTreeModel> _accounts = <AccountsTreeModel>[];
  String _query = '';
  String? _error;
  int _page = 0;
  int _totalRecords = 0;
  int _requestId = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = false;

  bool get _isAr => context.locale.languageCode == 'ar';
  String _t(String ar, String en) => _isAr ? ar : en;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fetch(page: 1, reset: true);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetch({required int page, bool reset = false}) async {
    if (!mounted) return;
    if (!reset && (_isLoading || _isLoadingMore || !_hasMore)) return;

    final requestId = ++_requestId;
    final languageCode = context.locale.languageCode;
    final query = _query.trim();

    setState(() {
      if (reset) {
        _isLoading = true;
        _isLoadingMore = false;
        _accounts = <AccountsTreeModel>[];
        _page = 0;
        _totalRecords = 0;
        _hasMore = false;
        _collapsed.clear();
      } else {
        _isLoadingMore = true;
      }
      _error = null;
    });

    final result = await sl<LookupRepo>().getAccountsTree(
      languageCode: languageCode,
      accountNo: int.tryParse(query),
      accountName: _isNumeric(query) ? null : (query.isEmpty ? null : query),
      page: page,
      pageSize: widget.pageSize,
    );

    if (!mounted || requestId != _requestId) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
          _error = failure.errMessage;
        });
      },
      (response) {
        // Merge pages by account number so re-fetching a page never duplicates.
        final merged = <int, AccountsTreeModel>{};
        if (!reset) {
          for (final account in _accounts) {
            merged[account.accountNo] = account;
          }
        }
        for (final account in response.accounts) {
          merged[account.accountNo] = account;
        }

        setState(() {
          _accounts = merged.values.toList();
          _page = page;
          _totalRecords = response.totalRecords;
          _hasMore = response.hasMore;
          _isLoading = false;
          _isLoadingMore = false;
          _error = null;
        });
      },
    );
  }

  bool _isNumeric(String value) => int.tryParse(value) != null;

  void _onSearchChanged(String value) {
    _query = value;
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) _fetch(page: 1, reset: true);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  void _toggleNode(int accountNo) {
    setState(() {
      if (!_collapsed.add(accountNo)) {
        _collapsed.remove(accountNo);
      }
    });
  }

  void _toggleAll() {
    if (_accounts.isEmpty) return;
    setState(() {
      if (_collapsed.isEmpty) {
        _collapsed.addAll(_accounts.map((account) => account.accountNo));
      } else {
        _collapsed.clear();
      }
    });
  }

  Color _levelColor(int level) {
    final index = (level - 1).clamp(0, _levelColors.length - 1);
    return _levelColors[index];
  }

  Color _natureColor(int? nature) => nature == 1 ? _creditColor : _debitColor;

  String _natureLabel(int? nature) => nature == 1
      ? _t('طبيعة دائنة', 'Credit nature')
      : _t('طبيعة مدينة', 'Debit nature');

  @override
  Widget build(BuildContext context) {
    final forest = buildAccountsForest(_accounts);
    final foreground = AppColor.titleFormFiledColor(context);
    final maxLevel = _accounts.fold<int>(
      0,
      (max, account) => account.accountLevel > max ? account.accountLevel : max,
    );
    final accountCount = _totalRecords > 0 ? _totalRecords : _accounts.length;
    final valueOrDash = _isLoading ? '—' : null;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: AppColor.borderColor(context).withValues(alpha: 0.9),
        ),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(
            context,
            foreground,
            total: valueOrDash ?? '$accountCount',
            roots: valueOrDash ?? '${forest.length}',
            levels: valueOrDash ?? '$maxLevel',
          ),
          if (_accounts.isNotEmpty && !_isLoading)
            _buildToolbar(context, foreground),
          _buildContent(context, forest, foreground),
          if (_hasMore) _buildLoadMore(context),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(
    BuildContext context,
    Color foreground, {
    required String total,
    required String roots,
    required String levels,
  }) {
    return Container(
      decoration: const BoxDecoration(
       
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Stack(
        children: [
       
         
        ],
      ),
    );
  }
  // ── Toolbar ───────────────────────────────────────────────────────────────

  Widget _buildToolbar(BuildContext context, Color foreground) {
    final debitCount = _accounts
        .where((account) => account.acctNature != 1)
        .length;
    final creditCount = _accounts
        .where((account) => account.acctNature == 1)
        .length;

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 2.h),
      child: Row(
        children: [
          Icon(
            Icons.hub_rounded,
            size: 14.r,
            color: _accent.withValues(alpha: 0.8),
          ),
          Gap(6.w),
          Flexible(
            child: Text(
              _t('تصنيف الأرصدة', 'Balance nature'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w700,
                color: foreground.withValues(alpha: 0.62),
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          const Spacer(),
          _legendChip(_debitColor, _t('مدين', 'Debit'), debitCount),
          Gap(6.w),
          _legendChip(_creditColor, _t('دائن', 'Credit'), creditCount),
        ],
      ),
    );
  }

  Widget _legendChip(Color color, String label, int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Gap(4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: color,
              fontFamily: 'Tajawal',
            ),
          ),
          Gap(3.w),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w800,
              color: color,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  // ── Content states ────────────────────────────────────────────────────────

  Widget _buildContent(
    BuildContext context,
    List<AccountsTreeNode> forest,
    Color foreground,
  ) {
    if (_isLoading) return _buildSkeleton(context);

    if (_error != null && _accounts.isEmpty) {
      return _buildErrorState(context, foreground);
    }

    if (_accounts.isEmpty) {
      return _buildEmptyState(foreground);
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final root in forest) _buildRootGroup(context, root, foreground),
          if (_error != null) ...[
            Gap(4.h),
            Center(
              child: TextButton.icon(
                onPressed: () => _fetch(page: 1, reset: true),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(
                  _t('تعذر التحديث، أعد المحاولة', 'Refresh failed. Try again'),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    final fill = AppColor.borderColor(context).withValues(alpha: 0.55);
    final shimmer = AppColor.cardColor(context).withValues(alpha: 0.7);

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
      child: Column(
        children: [
          for (var i = 0; i < 5; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == 4 ? 0 : 10.h),
              child: Row(
                children: [
                  CustomShimmer(
                    width: 38.r,
                    height: 38.r,
                    radius: 11.r,
                    fillColor: fill,
                    shimmerColor: shimmer,
                  ),
                  Gap(10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomShimmer(
                          width: i.isEven ? 170.w : 135.w,
                          height: 11.h,
                          radius: 6.r,
                          fillColor: fill,
                          shimmerColor: shimmer,
                        ),
                        Gap(7.h),
                        CustomShimmer(
                          width: i.isEven ? 92.w : 70.w,
                          height: 8.h,
                          radius: 5.r,
                          fillColor: fill,
                          shimmerColor: shimmer,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Color foreground) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 26.h, 20.w, 26.h),
      child: Column(
        children: [
          Container(
            width: 58.r,
            height: 58.r,
            decoration: BoxDecoration(
              color: AppColor.roseDanger.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_off_rounded,
              size: 27.r,
              color: AppColor.roseDanger,
            ),
          ),
          Gap(11.h),
          Text(
            _t('تعذر تحميل شجرة الحسابات', 'Could not load the accounts tree'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: foreground,
              fontFamily: 'Tajawal',
            ),
          ),
          Gap(4.h),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              height: 1.4,
              color: foreground.withValues(alpha: 0.55),
              fontFamily: 'Tajawal',
            ),
          ),
          Gap(14.h),
          FilledButton.icon(
            onPressed: () => _fetch(page: 1, reset: true),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: Text(_t('إعادة المحاولة', 'Try again')),
            style: FilledButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              textStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color foreground) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 26.h, 20.w, 26.h),
      child: Column(
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off_rounded, size: 26.r, color: _accent),
          ),
          Gap(11.h),
          Text(
            _query.trim().isEmpty
                ? _t('لا توجد حسابات لعرضها', 'No accounts to display')
                : _t('لا توجد نتائج مطابقة', 'No matching accounts'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: foreground,
              fontFamily: 'Tajawal',
            ),
          ),
          Gap(4.h),
          Text(
            _query.trim().isEmpty
                ? _t(
                    'لم تُرجع قاعدة البيانات أي حسابات.',
                    'The database returned no accounts.',
                  )
                : _t(
                    'جرّب تعديل رقم أو اسم الحساب.',
                    'Try a different account number or name.',
                  ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              color: foreground.withValues(alpha: 0.52),
              fontFamily: 'Tajawal',
            ),
          ),
          if (_query.trim().isNotEmpty) ...[
            Gap(10.h),
            TextButton.icon(
              onPressed: _clearSearch,
              icon: const Icon(Icons.close_rounded, size: 16),
              label: Text(_t('مسح البحث', 'Clear search')),
            ),
          ],
        ],
      ),
    );
  }

  // ── Tree ──────────────────────────────────────────────────────────────────

  Widget _buildRootGroup(
    BuildContext context,
    AccountsTreeNode node,
    Color foreground,
  ) {
    final account = node.account;
    final color = _levelColor(account.accountLevel);
    final hasChildren = node.children.isNotEmpty;
    final isCollapsed = _collapsed.contains(account.accountNo);
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: hasChildren ? () => _toggleNode(account.accountNo) : null,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.11),
                      color.withValues(alpha: 0.035),
                    ],
                    begin: AlignmentDirectional.centerStart,
                    end: AlignmentDirectional.centerEnd,
                  ),
                  border: BorderDirectional(
                    start: BorderSide(color: color, width: 3.5.w),
                    bottom: BorderSide(color: color.withValues(alpha: 0.12)),
                  ),
                ),
                padding: EdgeInsetsDirectional.fromSTEB(10.w, 10.h, 12.w, 10.h),
                child: Row(
                  children: [
                    Container(
                      width: 38.r,
                      height: 38.r,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withValues(alpha: 0.72)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(11.r),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.28),
                            blurRadius: 9,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.account_balance_rounded,
                        size: 19.r,
                        color: Colors.white,
                      ),
                    ),
                    Gap(10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.nameFor(isArabic: _isAr),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              height: 1.25,
                              fontWeight: FontWeight.w800,
                              color: foreground,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          Gap(5.h),
                          Row(
                            children: [
                              _numberPill(
                                account.accountNo,
                                color,
                                filled: true,
                              ),
                              Gap(6.w),
                              Flexible(
                                child: Text(
                                  hasChildren
                                      ? _t(
                                          '${node.children.length} حساب فرعي',
                                          '${node.children.length} sub-accounts',
                                        )
                                      : _t('حساب رئيسي', 'Main account'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 9.3.sp,
                                    fontWeight: FontWeight.w600,
                                    color: color.withValues(alpha: 0.92),
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gap(6.w),
                    _natureDot(account.acctNature),
                    if (hasChildren) ...[
                      Gap(8.w),
                      AnimatedRotation(
                        turns: isCollapsed ? (isRtl ? 0.25 : -0.25) : 0,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        child: Container(
                          width: 30.r,
                          height: 30.r,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color.withValues(alpha: 0.18),
                            ),
                          ),
                          child: Icon(
                            Icons.expand_more_rounded,
                            size: 20.r,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: hasChildren && !isCollapsed
                ? _buildChildren(context, node.children, foreground, color)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildChildren(
    BuildContext context,
    List<AccountsTreeNode> children,
    Color foreground,
    Color color,
  ) {
    final railColor = color.withValues(alpha: 0.32);

    return Padding(
      padding: EdgeInsetsDirectional.only(start: 14.w, end: 8.w, bottom: 4.h),
      child: Container(
        padding: EdgeInsetsDirectional.only(start: 9.w),
        decoration: BoxDecoration(
          border: BorderDirectional(
            start: BorderSide(color: railColor, width: 1.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final child in children)
              _buildChildNode(context, child, foreground),
          ],
        ),
      ),
    );
  }

  Widget _buildChildNode(
    BuildContext context,
    AccountsTreeNode node,
    Color foreground,
  ) {
    final account = node.account;
    final color = _levelColor(account.accountLevel);
    final hasChildren = node.children.isNotEmpty;
    final isCollapsed = _collapsed.contains(account.accountNo);
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    final railColor = color.withValues(alpha: 0.32);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: hasChildren ? () => _toggleNode(account.accountNo) : null,
            borderRadius: BorderRadius.circular(10.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                children: [
                  Container(width: 9.w, height: 1.2, color: railColor),
                  Gap(5.w),
                  SizedBox(
                    width: 22.w,
                    child: hasChildren
                        ? AnimatedRotation(
                            turns: isCollapsed ? (isRtl ? 0.25 : -0.25) : 0,
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOutCubic,
                            child: Icon(
                              Icons.expand_more_rounded,
                              size: 19.sp,
                              color: color,
                            ),
                          )
                        : Center(
                            child: Container(
                              width: 5.r,
                              height: 5.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: color.withValues(alpha: 0.55),
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                  ),
                  Gap(5.w),
                  _numberPill(account.accountNo, color),
                  Gap(8.w),
                  Expanded(
                    child: Text(
                      account.nameFor(isArabic: _isAr),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        height: 1.3,
                        fontWeight: hasChildren
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: foreground.withValues(
                          alpha: hasChildren ? 1 : 0.88,
                        ),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  if (hasChildren) ...[
                    Gap(6.w),
                    _childCountBadge(node.children.length, color),
                  ],
                  Gap(7.w),
                  _natureDot(account.acctNature),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: hasChildren && !isCollapsed
              ? _buildChildren(context, node.children, foreground, color)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _numberPill(int accountNo, Color color, {bool filled = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: filled
            ? null
            : Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Text(
        '$accountNo',
        style: TextStyle(
          fontSize: 10.sp,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: filled ? Colors.white : color,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _childCountBadge(int count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: color,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _natureDot(int? nature) {
    final color = _natureColor(nature);
    return Tooltip(
      message: _natureLabel(nature),
      child: Container(
        width: 7.r,
        height: 7.r,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 5,
              spreadRadius: 0.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMore(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 2.h, 14.w, 14.h),
      child: OutlinedButton.icon(
        onPressed: _isLoadingMore ? null : () => _fetch(page: _page + 1),
        icon: _isLoadingMore
            ? SizedBox(
                width: 14.r,
                height: 14.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _accent,
                ),
              )
            : const Icon(Icons.expand_more_rounded, size: 17),
        label: Text(_t('تحميل المزيد', 'Load more')),
        style: OutlinedButton.styleFrom(
          foregroundColor: _accent,
          minimumSize: Size.fromHeight(38.h),
          side: BorderSide(color: _accent.withValues(alpha: 0.28)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    );
  }
}
