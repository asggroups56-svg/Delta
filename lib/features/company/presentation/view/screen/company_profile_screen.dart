import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/exception_widget/exception_widget.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/theme/cubit/app_theme_cubit.dart';
import 'package:my_template/core/theme/theme_enum.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

import '../../../data/models/company_model.dart';
import '../cubit/company_cubit.dart';
import '../cubit/company_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CompanyProfileScreen
// Displayed as the "الملف" tab in the BottomBar.
// Shows full company data fetched from the API + settings actions.
// ─────────────────────────────────────────────────────────────────────────────
class CompanyProfileScreen extends StatefulWidget {
  final Future<void> Function()? onLogout;
  final VoidCallback? onToggleLanguage;

  const CompanyProfileScreen({
    super.key,
    this.onLogout,
    this.onToggleLanguage,
  });

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen>
    with SingleTickerProviderStateMixin {
  bool get _isAr => context.locale.languageCode == 'ar';
  String _t(String ar, String en) => _isAr ? ar : en;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  bool _notificationsEnabled = true;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -0.08),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyCubit>().getCompany(
            languageCode: context.locale.languageCode,
          );
      _animCtrl.forward();
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() => context.read<CompanyCubit>().getCompany(
        languageCode: context.locale.languageCode,
      );

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark =
        context.watch<AppThemeCubit>().theme == ThemeEnum.dark;

    return BlocBuilder<CompanyCubit, CompanyState>(
      builder: (context, state) {
        final status = state.status;
        final company =
            status.isSuccess ? status.data?.first : null;

        return Scaffold(
          backgroundColor: AppColor.scaffoldColor(context),
          body: RefreshIndicator(
            color: AppColor.primaryColor(context),
            onRefresh: _load,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                // ── Hero Header ──────────────────────────────────────
                _buildHeroSliver(context, company, status),

                // ── Body ─────────────────────────────────────────────
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 18.w, vertical: 20.h),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // loading / error states
                      if (status.isLoading || status.isInitial)
                        _loadingPlaceholder(context),

                      if (status.isFailure)
                        ExceptionWidget(
                          message: status.error,
                          onReload: _load,
                        ),

                      // ── Company data sections ──────────────────────
                      if (company != null) ...[
                        _buildQuickStats(context, company),
                        Gap(20.h),
                        _buildSection(
                          context,
                          icon: Icons.location_on_rounded,
                          color: const Color(0xFF0984E3),
                          title: _t('العنوان والتواصل', 'Address & Contact'),
                          rows: _addressRows(context, company),
                        ),
                        Gap(14.h),
                        _buildSection(
                          context,
                          icon: Icons.receipt_long_rounded,
                          color: const Color(0xFFE17055),
                          title:
                              _t('الضرائب والتسجيل', 'Tax & Registration'),
                          rows: _taxRows(context, company),
                        ),
                        Gap(14.h),
                        _buildSection(
                          context,
                          icon: Icons.calendar_month_rounded,
                          color: const Color(0xFF6C5CE7),
                          title: _t(
                              'السنة المالية والعملة', 'Fiscal & Currency'),
                          rows: _fiscalRows(context, company),
                        ),
                        Gap(14.h),
                        _buildSection(
                          context,
                          icon: Icons.account_balance_rounded,
                          color: const Color(0xFF00B894),
                          title: _t(
                              'الحسابات الافتراضية', 'Default Accounts'),
                          rows: _accountRows(context, company),
                        ),
                        Gap(14.h),
                        _buildSection(
                          context,
                          icon: Icons.tune_rounded,
                          color: const Color(0xFF636E72),
                          title: _t('إعدادات النظام', 'System Settings'),
                          rows: _systemRows(context, company),
                        ),
                        Gap(20.h),
                      ],

                      // ── Preferences ────────────────────────────────
                      _buildSectionTitle(
                          context, _t('التفضيلات', 'Preferences'),
                          Icons.tune_rounded),
                      Gap(10.h),
                      _buildSettingsCard(context, [
                        _buildToggle(
                          context,
                          icon: Icons.notifications_outlined,
                          iconColor: AppColor.warningOrange,
                          title: _t('الإشعارات', 'Notifications'),
                          subtitle: _t('تنبيهات وتذكيرات', 'Alerts & reminders'),
                          value: _notificationsEnabled,
                          onChanged: (v) =>
                              setState(() => _notificationsEnabled = v),
                        ),
                        _divider(context),
                        _buildToggle(
                          context,
                          icon: isDark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          iconColor: const Color(0xFF6C5CE7),
                          title: AppLocaleKey.appTheme.tr(),
                          subtitle:
                              '${AppLocaleKey.themeModeSubtitle.tr()} · ${isDark ? AppLocaleKey.darkMode.tr() : AppLocaleKey.lightMode.tr()}',
                          value: isDark,
                          onChanged: (v) => context
                              .read<AppThemeCubit>()
                              .setTheme(v ? ThemeEnum.dark : ThemeEnum.light),
                        ),
                        _divider(context),
                        _buildActionTile(
                          context,
                          icon: Icons.language_rounded,
                          iconColor: AppColor.skyBlue,
                          title: _t('اللغة', 'Language'),
                          subtitle: _isAr ? 'العربية' : 'English',
                          onTap: widget.onToggleLanguage,
                        ),
                      ]),

                      Gap(14.h),

                      // ── Support ────────────────────────────────────
                      _buildSectionTitle(
                          context, _t('الدعم', 'Support'), Icons.help_outline_rounded),
                      Gap(10.h),
                      _buildSettingsCard(context, [
                        _buildActionTile(
                          context,
                          icon: Icons.help_outline_rounded,
                          iconColor: AppColor.mintTeal,
                          title: _t('المساعدة', 'Help & Support'),
                          subtitle: _t('الوثائق والأسئلة الشائعة', 'Docs & FAQs'),
                          onTap: () {},
                        ),
                        _divider(context),
                        _buildActionTile(
                          context,
                          icon: Icons.shield_outlined,
                          iconColor: AppColor.oceanBlue,
                          title: _t('الخصوصية', 'Privacy & Security'),
                          subtitle: _t('إعدادات الخصوصية', 'Data protection'),
                          onTap: () {},
                        ),
                        _divider(context),
                        _buildActionTile(
                          context,
                          icon: Icons.info_outline_rounded,
                          iconColor: const Color(0xFF636E72),
                          title: _t('حول التطبيق', 'About Delta ERP'),
                          subtitle: 'Version 1.0.0 · Build 2026',
                          onTap: () {},
                        ),
                      ]),

                      Gap(16.h),

                      // ── Logout ─────────────────────────────────────
                      _buildLogoutButton(context),
                      Gap(90.h),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Hero SliverAppBar ───────────────────────────────────────────────────────
  Widget _buildHeroSliver(
      BuildContext context, CompanyModel? c, dynamic status) {
    final name = c != null
        ? (_isAr
            ? (c.companyName ?? c.companyEname ?? '')
            : (c.companyEname ?? c.companyName ?? ''))
        : '';

    final initials = name.trim().isNotEmpty
        ? name.trim().split(RegExp(r'\s+')).take(2).map((w) => w[0]).join()
        : '؟';

    return SliverAppBar(
      expandedHeight: 220.h,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: AppColor.primaryColor(context),
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: _load,
          icon: Icon(Icons.refresh_rounded, size: 20.r, color: Colors.white),
          tooltip: _t('تحديث', 'Refresh'),
        ),
        SizedBox(width: 4.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: SlideTransition(
          position: _slideAnim,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.primaryColor(context),
                    AppColor.secondAppColor(context),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Decorative blobs
                  Positioned(
                    top: -40.h,
                    right: -40.w,
                    child: _blob(170.r, Colors.white.withValues(alpha: 0.06)),
                  ),
                  Positioned(
                    bottom: -20.h,
                    left: -50.w,
                    child: _blob(130.r, Colors.white.withValues(alpha: 0.05)),
                  ),
                  Positioned(
                    top: 60.h,
                    left: 40.w,
                    child: _blob(60.r, Colors.white.withValues(alpha: 0.04)),
                  ),

                  // Content
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Monogram
                              Container(
                                width: 64.r,
                                height: 64.r,
                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withValues(alpha: 0.18),
                                  borderRadius:
                                      BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color:
                                        Colors.white.withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    initials,
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              ),
                              Gap(14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    if (name.isNotEmpty)
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          fontFamily: 'Tajawal',
                                          height: 1.3,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    else
                                      Container(
                                        height: 18.h,
                                        width: 160.w,
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.2),
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                        ),
                                      ),
                                    Gap(4.h),
                                    if (c?.companyEname != null &&
                                        _isAr &&
                                        c!.companyEname!.isNotEmpty)
                                      Text(
                                        c.companyEname!,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.white70,
                                          fontFamily: 'Tajawal',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Gap(14.h),
                          // badges
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 6.h,
                            children: [
                              if (c?.tradeReg != null)
                                _heroBadge(
                                    Icons.business_center_rounded,
                                    'س.ت: ${c!.tradeReg}'),
                              if (c?.cityName != null)
                                _heroBadge(
                                    Icons.location_on_rounded, c!.cityName!),
                              if (c?.countryName != null)
                                _heroBadge(
                                    Icons.flag_rounded, c!.countryName!),
                              if (c?.currency != null)
                                _heroBadge(
                                    Icons.monetization_on_outlined,
                                    c!.currency!),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _blob(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );

  Widget _heroBadge(IconData icon, String label) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20.r),
          border:
              Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11.r, color: Colors.white),
            Gap(4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  // ── Quick Stats ─────────────────────────────────────────────────────────────
  Widget _buildQuickStats(BuildContext context, CompanyModel c) {
    final taxPct = (c.taxNew ?? c.taxVal ?? 0).toStringAsFixed(0);
    final fiscalStart = c.fiscalYearBegin != null
        ? '${c.fiscalYearBegin!.month}/${c.fiscalYearBegin!.year}'
        : '—';

    return Row(
      children: [
        _statCard(context,
            value: '$taxPct%',
            label: _t('الضريبة', 'VAT'),
            icon: Icons.percent_rounded,
            color: const Color(0xFFE17055)),
        Gap(10.w),
        _statCard(context,
            value: c.currency ?? '—',
            label: _t('العملة', 'Currency'),
            icon: Icons.monetization_on_outlined,
            color: const Color(0xFF0984E3)),
        Gap(10.w),
        _statCard(context,
            value: fiscalStart,
            label: _t('السنة المالية', 'Fiscal Year'),
            icon: Icons.calendar_today_rounded,
            color: const Color(0xFF6C5CE7)),
      ],
    );
  }

  Widget _statCard(
    BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: AppColor.cardColor(context),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 15.r, color: color),
            ),
            Gap(6.h),
            Text(
              value,
              style: AppTextStyle.bodyLarge(context).copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: AppColor.titleFormFiledColor(context),
                fontFamily: 'Tajawal',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: AppTextStyle.bodySmall(context).copyWith(
                fontSize: 9.sp,
                color: AppColor.darkTextColor(context),
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Generic Section ─────────────────────────────────────────────────────────
  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required List<Widget> rows,
  }) {
    final filtered = rows.whereType<_InfoRow>().toList();
    if (filtered.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.07),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20.r)),
              border: Border(
                  bottom:
                      BorderSide(color: color.withValues(alpha: 0.15))),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(7.r),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, size: 16.r, color: color),
                ),
                Gap(10.w),
                Text(
                  title,
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.titleFormFiledColor(context),
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          // Rows
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              children: _intersperse(context, rows),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _intersperse(BuildContext context, List<Widget> rows) {
    final result = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      if (rows[i] is SizedBox) continue;
      result.add(rows[i]);
      if (i < rows.length - 1) {
        result.add(
          Divider(
            height: 18.h,
            color: AppColor.borderColor(context).withValues(alpha: 0.6),
          ),
        );
      }
    }
    return result;
  }

  // ── Info Row ────────────────────────────────────────────────────────────────
  Widget _infoRow(
    BuildContext context, {
    required String label,
    required String? value,
    required IconData icon,
    required Color iconColor,
    bool copyable = false,
  }) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
    return _InfoRow(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 14.r, color: iconColor),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontSize: 10.sp,
                    color: AppColor.darkTextColor(context),
                    fontFamily: 'Tajawal',
                  ),
                ),
                Gap(2.h),
                Text(
                  value,
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.titleFormFiledColor(context),
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          if (copyable)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _t('تم النسخ ✓', 'Copied ✓'),
                      style: const TextStyle(fontFamily: 'Tajawal'),
                    ),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                    backgroundColor: AppColor.primaryColor(context),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Icon(
                  Icons.copy_rounded,
                  size: 15.r,
                  color: AppColor.darkTextColor(context)
                      .withValues(alpha: 0.45),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Account Row ─────────────────────────────────────────────────────────────
  Widget _accountRow(
    BuildContext context, {
    required String label,
    required int? value,
    required Color color,
  }) {
    if (value == null) return const SizedBox.shrink();
    return _InfoRow(
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.bodySmall(context).copyWith(
                fontSize: 12.sp,
                color: AppColor.darkTextColor(context),
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: color.withValues(alpha: 0.25)),
            ),
            child: Text(
              value.toString(),
              style: AppTextStyle.bodySmall(context).copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: color,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Settings Widgets ────────────────────────────────────────────────────────
  Widget _buildSectionTitle(
      BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColor.darkTextColor(context), size: 15.r),
        Gap(6.w),
        Text(
          title,
          style: AppTextStyle.bodySmall(context).copyWith(
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.darkTextColor(context),
            fontFamily: 'Tajawal',
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.borderColor(context)),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(BuildContext context) => Divider(
        height: 1,
        color: AppColor.borderColor(context),
        indent: 54.w,
      );

  Widget _buildToggle(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 18.r),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyle.bodySmall(context).copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.titleFormFiledColor(context),
                      fontFamily: 'Tajawal',
                    )),
                Text(subtitle,
                    style: AppTextStyle.bodySmall(context).copyWith(
                      fontSize: 10.5.sp,
                      color: AppColor.darkTextColor(context),
                      fontFamily: 'Tajawal',
                    )),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: iconColor,
              activeTrackColor: iconColor.withValues(alpha: 0.3),
              inactiveThumbColor: AppColor.darkTextColor(context),
              inactiveTrackColor: AppColor.borderColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 18.r),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyle.bodySmall(context).copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.titleFormFiledColor(context),
                        fontFamily: 'Tajawal',
                      )),
                  Text(subtitle,
                      style: AppTextStyle.bodySmall(context).copyWith(
                        fontSize: 10.5.sp,
                        color: AppColor.darkTextColor(context),
                        fontFamily: 'Tajawal',
                      )),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColor.darkTextColor(context)
                  .withValues(alpha: 0.4),
              size: 18.r,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    if (_isLoggingOut || widget.onLogout == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.cardColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7675).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout_rounded,
                color: const Color(0xFFFF7675),
                size: 20.r,
              ),
            ),
            Gap(10.w),
            Text(
              _t('تسجيل الخروج', 'Logout'),
              style: AppTextStyle.bodyLarge(context).copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        content: Text(
          _t('هل أنت متأكد من رغبتك في تسجيل الخروج؟',
              'Are you sure you want to log out?'),
          style: AppTextStyle.bodyMedium(context).copyWith(
            fontSize: 13.sp,
            color: AppColor.darkTextColor(context),
            fontFamily: 'Tajawal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              _t('إلغاء', 'Cancel'),
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColor.darkTextColor(context),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7675),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              _t('تأكيد الخروج', 'Confirm'),
              style: const TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoggingOut = true);
    try {
      await widget.onLogout!();
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: _isLoggingOut ? null : _handleLogout,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFF7675).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
              color: const Color(0xFFFF7675).withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoggingOut) ...[
              SizedBox(
                width: 18.r,
                height: 18.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFFF7675),
                ),
              ),
              Gap(10.w),
              Text(
                _t('جاري تسجيل الخروج...', 'Logging out...'),
                style: AppTextStyle.bodySmall(context).copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF7675),
                  fontFamily: 'Tajawal',
                ),
              ),
            ] else ...[
              Icon(Icons.logout_rounded,
                  color: const Color(0xFFFF7675), size: 18.r),
              Gap(8.w),
              Text(
                AppLocaleKey.logout.tr(),
                style: AppTextStyle.bodySmall(context).copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF7675),
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Loading ─────────────────────────────────────────────────────────────────
  Widget _loadingPlaceholder(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 36.r,
              height: 36.r,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColor.primaryColor(context),
              ),
            ),
            Gap(12.h),
            Text(
              _t('جاري تحميل بيانات الشركة...', 'Loading company data...'),
              style: AppTextStyle.bodySmall(context).copyWith(
                fontFamily: 'Tajawal',
                color: AppColor.darkTextColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sections Data ───────────────────────────────────────────────────────────
  List<Widget> _addressRows(BuildContext context, CompanyModel c) => [
        _infoRow(context,
            label: _t('الدولة', 'Country'),
            value: c.countryName,
            icon: Icons.flag_rounded,
            iconColor: const Color(0xFF0984E3)),
        _infoRow(context,
            label: _t('المدينة', 'City'),
            value: c.cityName,
            icon: Icons.location_city_rounded,
            iconColor: const Color(0xFF0984E3)),
        _infoRow(context,
            label: _t('الحي', 'District'),
            value: _isAr ? c.districtName : (c.districtEname ?? c.districtName),
            icon: Icons.map_rounded,
            iconColor: const Color(0xFF74B9FF)),
        _infoRow(context,
            label: _t('الشارع', 'Street'),
            value: c.streetName,
            icon: Icons.signpost_rounded,
            iconColor: const Color(0xFF74B9FF)),
        _infoRow(context,
            label: _t('رقم المبنى', 'Building No.'),
            value: c.buildingNo,
            icon: Icons.home_rounded,
            iconColor: const Color(0xFF0984E3)),
        _infoRow(context,
            label: _t('الرمز البريدي', 'Postal Code'),
            value: c.postalNo,
            icon: Icons.markunread_mailbox_rounded,
            iconColor: const Color(0xFF74B9FF)),
        _infoRow(context,
            label: _t('رقم الهاتف 1', 'Phone 1'),
            value: c.telNo1,
            icon: Icons.phone_rounded,
            iconColor: const Color(0xFF00B894),
            copyable: true),
        _infoRow(context,
            label: _t('رقم الهاتف 2', 'Phone 2'),
            value: c.telNo2,
            icon: Icons.phone_rounded,
            iconColor: const Color(0xFF00B894),
            copyable: true),
        _infoRow(context,
            label: _t('البريد الإلكتروني', 'Email'),
            value: c.eMail,
            icon: Icons.email_rounded,
            iconColor: const Color(0xFF6C5CE7),
            copyable: true),
      ];

  List<Widget> _taxRows(BuildContext context, CompanyModel c) => [
        _infoRow(context,
            label: _t('الرقم الضريبي', 'Tax Registration No.'),
            value: c.taxReg,
            icon: Icons.receipt_long_rounded,
            iconColor: const Color(0xFFE17055),
            copyable: true),
        _infoRow(context,
            label: _t('السجل التجاري', 'Trade Registration'),
            value: c.tradeReg,
            icon: Icons.business_center_rounded,
            iconColor: const Color(0xFFE17055),
            copyable: true),
        _infoRow(context,
            label: _t('نسبة الضريبة الحالية', 'Current VAT Rate'),
            value: c.taxNew != null ? '${c.taxNew!.toStringAsFixed(0)}%' : null,
            icon: Icons.percent_rounded,
            iconColor: const Color(0xFFFD79A8)),
        _infoRow(context,
            label: _t('نسبة الضريبة القديمة', 'Old VAT Rate'),
            value: c.taxVal != null ? '${c.taxVal!.toStringAsFixed(0)}%' : null,
            icon: Icons.percent_rounded,
            iconColor: const Color(0xFFBDC3C7)),
      ];

  List<Widget> _fiscalRows(BuildContext context, CompanyModel c) {
    String? fmt(DateTime? d) => d != null ? '${d.day}/${d.month}/${d.year}' : null;
    return [
      _infoRow(context,
          label: _t('بداية السنة المالية', 'Fiscal Year Start'),
          value: fmt(c.fiscalYearBegin),
          icon: Icons.play_circle_rounded,
          iconColor: const Color(0xFF6C5CE7)),
      _infoRow(context,
          label: _t('نهاية السنة المالية', 'Fiscal Year End'),
          value: fmt(c.fiscalYearEnd),
          icon: Icons.stop_circle_rounded,
          iconColor: const Color(0xFFE17055)),
      _infoRow(context,
          label: _t('العملة', 'Currency'),
          value: c.currency,
          icon: Icons.monetization_on_rounded,
          iconColor: const Color(0xFF00B894)),
      _infoRow(context,
          label: _t('الكسر (الهللة)', 'Currency Fraction'),
          value: c.currencyFraction,
          icon: Icons.money_rounded,
          iconColor: const Color(0xFF55EFC4)),
    ];
  }

  List<Widget> _accountRows(BuildContext context, CompanyModel c) {
    const color = Color(0xFF00B894);
    return [
      _accountRow(context,
          label: _t('الصندوق', 'Cash'), value: c.cashAcc, color: color),
      _accountRow(context,
          label: _t('الأرباح والخسائر', 'P&L'), value: c.profitLossAcctNo, color: color),
      _accountRow(context,
          label: _t('المبيعات', 'Sales'), value: c.salesAcc, color: color),
      _accountRow(context,
          label: _t('المشتريات', 'Purchases'), value: c.purchaseAcc, color: color),
      _accountRow(context,
          label: _t('العملاء', 'Customers'), value: c.cusAcc, color: color),
      _accountRow(context,
          label: _t('الموردون', 'Suppliers'), value: c.suppAcc, color: color),
      _accountRow(context,
          label: _t('ضريبة المبيعات', 'Sales Tax'), value: c.salTaxAcc, color: color),
      _accountRow(context,
          label: _t('ضريبة المشتريات', 'Purchase Tax'), value: c.purTaxAcc, color: color),
      _accountRow(context,
          label: _t('العربون', 'Advance'), value: c.advAcc, color: color),
      _accountRow(context,
          label: _t('المرتجع', 'Returns'), value: c.retAcc, color: color),
    ];
  }

  List<Widget> _systemRows(BuildContext context, CompanyModel c) {
    String yn(int? v) => v == 1 ? _t('نعم', 'Yes') : _t('لا', 'No');
    const color = Color(0xFF636E72);
    return [
      _infoRow(context,
          label: _t('عدد مستويات الموافقة', 'Approval Levels'),
          value: c.noOfLevels?.toString(),
          icon: Icons.layers_rounded,
          iconColor: color),
      _infoRow(context,
          label: _t('حذف القيد', 'Delete Voucher'),
          value: yn(c.delVoucher),
          icon: Icons.delete_outline_rounded,
          iconColor: color),
      _infoRow(context,
          label: _t('شعار القيد', 'Debit Sign'),
          value: c.debitSign,
          icon: Icons.text_fields_rounded,
          iconColor: color),
      _infoRow(context,
          label: _t('شعار الدائن', 'Credit Sign'),
          value: c.creditSign,
          icon: Icons.text_fields_rounded,
          iconColor: color),
      _infoRow(context,
          label: _t('الأرقام العشرية', 'Decimal Places'),
          value: c.decimal3?.toString(),
          icon: Icons.format_list_numbered_rounded,
          iconColor: color),
    ];
  }
}

/// Sentinel wrapper so empty rows can be filtered properly.
class _InfoRow extends StatelessWidget {
  final Widget child;
  const _InfoRow({required this.child});

  @override
  Widget build(BuildContext context) => child;
}
