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
///
/// When [autoLoad] is `false` the initial fetch is deferred until an external
/// caller (e.g. the parent collapsible section) calls [fetchIfNeeded] via a
/// [GlobalKey<AccountsTreeSectionState>].
class AccountsTreeSection extends StatefulWidget {
  /// Page size used while loading the tree. Large enough to render most charts
  /// in one request; a "load more" action is shown while `hasMore` is true.
  final int pageSize;

  /// Drops the card background/border so the tree can sit inside another
  /// container (e.g. the collapsible company section) without a nested card.
  final bool embedded;

  /// Whether the widget loads data automatically on first build.
  /// Set to [false] when embedding inside a collapsed section so the API call
  /// is deferred until the section is actually opened by the user.
  final bool autoLoad;

  const AccountsTreeSection({
    super.key,
    this.pageSize = 100,
    this.embedded = false,
    this.autoLoad = true,
  });

  @override
  State<AccountsTreeSection> createState() => AccountsTreeSectionState();
}

class AccountsTreeSectionState extends State<AccountsTreeSection>
    with AutomaticKeepAliveClientMixin<AccountsTreeSection> {
  /// Keeps loaded pages and manually collapsed/expanded nodes alive while the
  /// section scrolls out of view, instead of rebuilding (and re-expanding)
  /// the tree when it comes back.
  @override
  bool get wantKeepAlive => true;

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
  int? _natureFilter; // null = all, 0 = debit, 1 = credit

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
    if (widget.autoLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _fetch(page: 1, reset: true);
      });
    }
  }

  /// Called externally (e.g. when the parent accordion opens) to trigger the
  /// first load only once.  Safe to call multiple times – subsequent calls are
  /// no-ops once data has been fetched.
  void fetchIfNeeded() {
    if (_accounts.isEmpty && !_isLoading && _error == null) {
      _fetch(page: 1, reset: true);
    }
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

  List<AccountsTreeNode> _filterForestByNature(List<AccountsTreeNode> nodes) {
    if (_natureFilter == null) return nodes;
    final result = <AccountsTreeNode>[];
    for (final node in nodes) {
      final filteredChildren = _filterForestByNature(node.children);
      final matches = _natureFilter == 1
          ? (node.account.acctNature == 1)
          : (node.account.acctNature != 1);
      if (matches || filteredChildren.isNotEmpty) {
        result.add(AccountsTreeNode(
          account: node.account,
          children: filteredChildren.isNotEmpty ? filteredChildren : node.children,
        ));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final rawForest = buildAccountsForest(_accounts);
    final forest = _filterForestByNature(rawForest);
    final foreground = AppColor.titleFormFiledColor(context);
    final maxLevel = _accounts.fold<int>(
      0,
      (max, account) => account.accountLevel > max ? account.accountLevel : max,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildContent(context, forest, foreground, maxLevel),
        if (_hasMore) ...[
          Gap(12.h),
          _buildLoadMore(context),
        ],
      ],
    );
  }

  // ── Tree Header & Controls ────────────────────────────────────────────────

  Widget _buildContent(
    BuildContext context,
    List<AccountsTreeNode> forest,
    Color foreground,
    int maxLevel,
  ) {
    if (_isLoading) return _buildSkeleton(context);

    if (_error != null && _accounts.isEmpty) {
      return _buildErrorState(context, foreground);
    }

    if (_accounts.isEmpty) {
      return _buildEmptyState(foreground);
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColor.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header Row ──
          Row(
            children: [
              // ايقونة المدرسة بجانب كلمة شجرة الحسابات
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColor.primaryColor(context).withValues(alpha: 0.22),
                  ),
                ),
                child: Icon(
                  Icons.school_rounded,
                  size: 20.r,
                  color: AppColor.primaryColor(context),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t('شجرة الحسابات', 'Chart of Accounts'),
                      style: TextStyle(
                        fontSize: 15.5.sp,
                        fontWeight: FontWeight.w800,
                        color: foreground,
                        fontFamily: 'Tajawal',
                        letterSpacing: -0.2,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      '${_totalRecords > 0 ? _totalRecords : _accounts.length} ${_t('حساب', 'accounts')}${maxLevel > 0 ? ' · $maxLevel ${_t('مستويات', 'levels')}' : ''}',
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        color: AppColor.darkTextColor(context),
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _actionIconButton(
                context,
                icon: _collapsed.isEmpty
                    ? Icons.unfold_less_rounded
                    : Icons.unfold_more_rounded,
                tooltip: _collapsed.isEmpty
                    ? _t('طي الكل', 'Collapse all')
                    : _t('توسيع الكل', 'Expand all'),
                onTap: _accounts.isEmpty ? null : _toggleAll,
              ),
              Gap(6.w),
              _actionIconButton(
                context,
                icon: Icons.refresh_rounded,
                tooltip: _t('تحديث', 'Refresh'),
                onTap: _isLoading ? null : () => _fetch(page: 1, reset: true),
              ),
              Gap(8.w),
              // وفي النهاية أيقونة الشجرة
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_gradientStart, _gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: _accent.withValues(alpha: 0.28),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.account_tree_rounded,
                  size: 20.r,
                  color: Colors.white,
                ),
              ),
            ],
          ),
         

          // ── Nature Filter Chips ──
        
          Gap(12.h),
          Divider(
            height: 1,
            color: AppColor.borderColor(context).withValues(alpha: 0.45),
          ),
          Gap(10.h),

          // ── Tree Nodes or Filter Empty State ──
          if (forest.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.filter_list_off_rounded,
                      size: 32.r,
                      color: foreground.withValues(alpha: 0.4),
                    ),
                    Gap(8.h),
                    Text(
                      _t('لا توجد حسابات مطابقة للفلتر', 'No accounts match the filter'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: foreground.withValues(alpha: 0.6),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Gap(8.h),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _natureFilter = null;
                        });
                        if (_query.isNotEmpty) _clearSearch();
                      },
                      child: Text(_t('إعادة تعيين الفلتر', 'Reset filter')),
                    ),
                  ],
                ),
              ),
            )
          else
            for (var i = 0; i < forest.length; i++) ...[
              _buildTreeNode(
                context,
                forest[i],
                foreground,
                depth: 0,
                isLast: i == forest.length - 1,
              ),
              if (i < forest.length - 1)
                Divider(
                  height: 14.h,
                  thickness: 0.8,
                  color: AppColor.borderColor(context).withValues(alpha: 0.35),
                ),
            ],

          if (_error != null) ...[
            Gap(10.h),
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

  Widget _actionIconButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.all(7.r),
            decoration: BoxDecoration(
              color: AppColor.borderColor(context).withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColor.borderColor(context).withValues(alpha: 0.5),
              ),
            ),
            child: Icon(
              icon,
              size: 18.r,
              color: onTap == null
                  ? AppColor.darkTextColor(context).withValues(alpha: 0.4)
                  : AppColor.titleFormFiledColor(context),
            ),
          ),
        ),
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

  // ── Tree Renderer ─────────────────────────────────────────────────────────

  Widget _buildTreeNode(
    BuildContext context,
    AccountsTreeNode node,
    Color foreground, {
    required int depth,
    bool isLast = false,
  }) {
    final account = node.account;
    final color = _levelColor(account.accountLevel);
    final hasChildren = node.children.isNotEmpty;
    final isCollapsed = _collapsed.contains(account.accountNo);
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    final isRoot = depth == 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: hasChildren ? () => _toggleNode(account.accountNo) : null,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: isRoot ? 8.h : 6.h,
                horizontal: isRoot ? 8.w : 4.w,
              ),
              decoration: isRoot
                  ? BoxDecoration(
                      color: color.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: color.withValues(alpha: 0.18)),
                    )
                  : null,
              child: Row(
                children: [
                  // Branch connector for child nodes
                  if (!isRoot) ...[
                    Container(
                      width: 8.w,
                      height: 1.4,
                      color: color.withValues(alpha: 0.35),
                    ),
                    Gap(4.w),
                  ],

                  // Expand/collapse indicator or terminal bullet
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: hasChildren
                        ? AnimatedRotation(
                            turns: isCollapsed ? (isRtl ? 0.25 : -0.25) : 0,
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOutCubic,
                            child: Icon(
                              Icons.expand_more_rounded,
                              size: 18.r,
                              color: color,
                            ),
                          )
                        : Center(
                            child: Container(
                              width: 5.r,
                              height: 5.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                  ),
                  Gap(4.w),

                  // Node icon: Folder for parent, Document for leaf
                  Icon(
                    hasChildren
                        ? (isCollapsed
                            ? Icons.folder_rounded
                            : Icons.folder_open_rounded)
                        : Icons.description_outlined,
                    size: isRoot ? 18.r : 16.r,
                    color: color,
                  ),
                  Gap(6.w),

                  // Account number pill
                  _numberPill(account.accountNo, color, filled: isRoot),
                  Gap(8.w),

                  // Account name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.nameFor(isArabic: _isAr),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isRoot ? 13.sp : 11.5.sp,
                            fontWeight: isRoot
                                ? FontWeight.w800
                                : (hasChildren ? FontWeight.w700 : FontWeight.w600),
                            color: foreground.withValues(alpha: isRoot ? 1 : 0.92),
                            fontFamily: 'Tajawal',
                            height: 1.25,
                          ),
                        ),
                        if (account.eaccountName != null &&
                            account.eaccountName!.isNotEmpty &&
                            _isAr &&
                            isRoot)
                          Text(
                            account.eaccountName!,
                            style: TextStyle(
                              fontSize: 9.5.sp,
                              color: foreground.withValues(alpha: 0.55),
                              fontFamily: 'Tajawal',
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Child count badge if parent
                  if (hasChildren) ...[
                    Gap(6.w),
                    _childCountBadge(node.children.length, color),
                  ],
                  Gap(6.w),

                  // Nature badge (مدين / دائن)
                  _natureBadge(account.acctNature),
                ],
              ),
            ),
          ),
        ),

        // ── Children branch connected with vertical guide line ──
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: hasChildren && !isCollapsed
              ? Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: isRoot ? 18.w : 14.w,
                    top: 2.h,
                    bottom: 2.h,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: BorderDirectional(
                        start: BorderSide(
                          color: color.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                    ),
                    padding: EdgeInsetsDirectional.only(start: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var c = 0; c < node.children.length; c++)
                          _buildTreeNode(
                            context,
                            node.children[c],
                            foreground,
                            depth: depth + 1,
                            isLast: c == node.children.length - 1,
                          ),
                      ],
                    ),
                  ),
                )
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
        border: filled ? null : Border.all(color: color.withValues(alpha: 0.18)),
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
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        '$count ${_t('مستوي', 'sub')}',
        style: TextStyle(
          fontSize: 8.5.sp,
          fontWeight: FontWeight.w700,
          color: color,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _natureBadge(int? nature) {
    final color = _natureColor(nature);
    final label = nature == 1 ? _t('دائن', 'Cr') : _t('مدين', 'Dr');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 8.5.sp,
          fontWeight: FontWeight.w700,
          color: color,
          fontFamily: 'Tajawal',
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
