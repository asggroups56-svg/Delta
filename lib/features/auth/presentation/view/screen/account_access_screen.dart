import 'dart:ui' as ui;

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/shared_pref/shared_pref.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/auth/data/model/workspace_module.dart';

/// Pre-login page where the user picks the workspace to start from (or a
/// demo account) and continues to the login screen.
class AccountAccessScreen extends StatefulWidget {
  const AccountAccessScreen({super.key});

  @override
  State<AccountAccessScreen> createState() => _AccountAccessScreenState();
}

class _AccountAccessScreenState extends State<AccountAccessScreen> {
  String? _selectedModuleId;
  String? _moduleError;
  bool _isSubmitting = false;

  bool get _isArabic => context.locale.languageCode == 'ar';

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    final prefs = CacheHelper.sharedPreferences;
    final savedModule = prefs.getString(CacheHelper.selectedModuleKey);
    if (workspaceModuleById(savedModule) != null) {
      _selectedModuleId = savedModule;
    }
  }

  Future<void> _toggleLanguage() async {
    if (_isArabic) {
      await context.setLocale(const Locale('en'));
    } else {
      await context.setLocale(const Locale('ar'));
    }
    if (mounted) setState(() {});
  }

  WorkspaceModule? get _selectedModule =>
      workspaceModuleById(_selectedModuleId);

  Future<void> _continueToLogin() async {
    if (_isSubmitting) return;

    final missingModule = _selectedModuleId == null;

    setState(() {
      _moduleError = missingModule
          ? (_isArabic
                ? 'اختر القسم الذي تريد البدء منه'
                : 'Choose the section you want to start with')
          : null;
    });
    if (missingModule) return;

    setState(() => _isSubmitting = true);
    await CacheHelper().saveData(
      key: CacheHelper.selectedModuleKey,
      value: _selectedModuleId!,
    );
    if (!mounted) return;
    NavigatorMethods.pushReplacementNamed(context, RoutesName.loginScreen);
  }

  Future<void> _continueAsTrial() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    await CacheHelper().saveData(key: CacheHelper.selectedModuleKey, value: '');
    if (!mounted) return;
    NavigatorMethods.pushReplacementNamed(context, RoutesName.loginScreen);
  }

  void _selectModule(WorkspaceModule module) {
    setState(() {
      _selectedModuleId = module.id;
      _moduleError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: Stack(
        children: [
          // Soft ambient glow behind the page.
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.95, -1),
                    radius: 1.25,
                    colors: [
                      const Color(
                        0xFF3B82F6,
                      ).withValues(alpha: _isDark ? 0.16 : 0.1),
                      AppColor.scaffoldColor(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopBar(),
                        Gap(22.h),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 920;
                            // Card width is known up-front, so the module grid
                            // can pick its column count without an inner
                            // LayoutBuilder (which breaks IntrinsicHeight).
                            final cardWidth = isWide
                                ? (constraints.maxWidth - 22.w) * 6 / 11
                                : constraints.maxWidth;
                            if (isWide) {
                              return IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: FadeInUp(
                                        duration: const Duration(
                                          milliseconds: 450,
                                        ),
                                        from: 24,
                                        child: _buildHero(),
                                      ),
                                    ),
                                    Gap(22.w),
                                    Expanded(
                                      flex: 6,
                                      child: FadeInUp(
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        delay: const Duration(milliseconds: 80),
                                        from: 28,
                                        child: _buildFormCard(width: cardWidth),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Column(
                              children: [
                                FadeInUp(
                                  duration: const Duration(milliseconds: 450),
                                  from: 20,
                                  child: _buildHero(compact: true),
                                ),
                                Gap(16.h),
                                FadeInUp(
                                  duration: const Duration(milliseconds: 500),
                                  delay: const Duration(milliseconds: 80),
                                  from: 24,
                                  child: _buildFormCard(width: cardWidth),
                                ),
                              ],
                            );
                          },
                        ),
                        Gap(18.h),
                        _buildFooter(),
                        Gap(4.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  TOP BAR
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(13.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E40AF).withValues(alpha: 0.28),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(Icons.hub_rounded, color: AppColor.whiteColor(context), size: 22.r),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'DELTA ASG',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  color: AppColor.titleFormFiledColor(context),
                ),
              ),
              Gap(1.h),
              Text(
                _isArabic ? 'منصة إدارة الأعمال' : 'Enterprise ERP Suite',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: AppColor.primaryColor(context),
                ),
              ),
            ],
          ),
        ),
        Gap(10.w),
        _buildLanguageButton(),
      ],
    );
  }

  Widget _buildLanguageButton() {
    return Semantics(
      button: true,
      label: AppLocaleKey.changeLanguage.tr(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleLanguage,
          borderRadius: BorderRadius.circular(30.r),
          child: Container(
            height: 44.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.cardColor(context),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: AppColor.borderColor(context)),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF0F172A,
                  ).withValues(alpha: _isDark ? 0.3 : 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language_rounded,
                  size: 15.r,
                  color: AppColor.primaryColor(context),
                ),
                Gap(6.w),
                Text(
                  _isArabic ? 'EN' : 'AR',
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColor.titleFormFiledColor(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  HERO
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildHero({bool compact = false}) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A1222), Color(0xFF15285A), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E40AF).withValues(alpha: 0.22),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Blueprint grid
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),

          // Ambient glows
          Positioned(
            top: -120.r,
            right: -90.r,
            child: _glow(
              330.r,
              const Color(0xFF3B82F6).withValues(alpha: 0.32),
            ),
          ),
          Positioned(
            bottom: -130.r,
            left: -100.r,
            child: _glow(
              300.r,
              const Color(0xFF0EA5E9).withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            top: 70.r,
            right: -70.r,
            child: Container(
              width: 220.r,
              height: 220.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.06)),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(
              compact ? 20.w : 30.w,
              compact ? 22.h : 32.h,
              compact ? 20.w : 30.w,
              compact ? 22.h : 30.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The hero is stretched to the form card's height on wide
                // screens; these flexible gaps centre the content and pin the
                // trust card to the bottom edge.
                if (!compact) const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusPill(),
                    Gap(compact ? 16.h : 24.h),
                    Text(
                      _isArabic
                          ? 'منصة واحدة\nلكل أعمالك'
                          : 'One platform.\nEvery business function.',
                      style: TextStyle(
                        fontSize: compact ? 25.sp : 30.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.16,
                        letterSpacing: -0.7,
                        color: AppColor.whiteColor(context),
                      ),
                    ),
                    Gap(compact ? 8.h : 12.h),
                    Text(
                      _isArabic
                          ? 'اختر القسم الذي تريد البدء منه، ثم تابع إلى تسجيل الدخول لإدخال بياناتك.'
                          : 'Pick the section you want to start with, then continue to sign in with your credentials.',
                      style: TextStyle(
                        fontSize: compact ? 11.5.sp : 12.5.sp,
                        height: 1.65,
                        color: AppColor.whiteColor(context).withValues(alpha: 0.72),
                      ),
                    ),
                    Gap(compact ? 16.h : 26.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        for (final module in workspaceModules)
                          _buildHeroChip(module),
                      ],
                    ),
                    if (!compact) ...[Gap(22.h), _buildValueList()],
                  ],
                ),
                // Anchors the trust card to the bottom of the panel when the
                // hero is stretched to match the taller form card.
                if (!compact) const Spacer(),
                if (!compact) ...[Gap(20.h), _buildTrustCard()],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }

  Widget _buildStatusPill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: const Color(0xFF34D399),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF34D399).withValues(alpha: 0.6),
                  blurRadius: 7,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          Gap(8.w),
          Text(
            _isArabic ? 'بوابة الدخول الموحدة' : 'UNIFIED ACCESS PORTAL',
            style: TextStyle(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColor.whiteColor(context).withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroChip(WorkspaceModule module) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context).withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            module.icon,
            size: 13.r,
            color: Color.lerp(module.color, AppColor.whiteColor(context), 0.25),
          ),
          Gap(6.w),
          Text(
            module.title(_isArabic),
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.whiteColor(context).withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueList() {
    final values = [
      (
        Icons.verified_user_rounded,
        _isArabic ? 'أمان بمعايير المؤسسات' : 'Enterprise-grade security',
      ),
      (
        Icons.sync_rounded,
        _isArabic
            ? 'هوية واحدة بين جميع الأقسام'
            : 'One identity across modules',
      ),
      (
        Icons.insights_rounded,
        _isArabic
            ? 'بيانات لحظية لقرارات أفضل'
            : 'Live data for better decisions',
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < values.length; i++) ...[
          if (i > 0) Gap(10.h),
          Row(
            children: [
              Container(
                width: 26.r,
                height: 26.r,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  values[i].$1,
                  size: 14.r,
                  color: const Color(0xFF93C5FD),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: Text(
                  values[i].$2,
                  style: TextStyle(
                    fontSize: 11.3.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    color: AppColor.whiteColor(context).withValues(alpha: 0.82),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTrustCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.09)),
      ),
      child: Row(
        children: [
          Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              color: AppColor.whiteColor(context).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_outlined,
              size: 17.r,
              color: const Color(0xFF93C5FD),
            ),
          ),
          Gap(11.w),
          Expanded(
            child: Text(
              _isArabic
                  ? 'اتصال آمن ومشفر لبيانات مؤسستك بالكامل'
                  : 'Secure, encrypted access to your organization',
              style: TextStyle(
                fontSize: 10.8.sp,
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: AppColor.whiteColor(context).withValues(alpha: 0.78),
              ),
            ),
          ),
          Gap(8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: const Color(0xFF34D399).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '256-bit',
              textDirection: ui.TextDirection.ltr,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
                color: const Color(0xFF6EE7B7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  FORM CARD
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildFormCard({required double width}) {
    final twoColumns = width - 44.r >= 430;
    final selected = _selectedModule;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: AppColor.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF0F172A,
            ).withValues(alpha: _isDark ? 0.32 : 0.06),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            title: _isArabic ? 'اختر مساحة العمل' : 'Choose your workspace',
            subtitle: _isArabic
                ? 'يمكنك البدء من أي قسم وتغييره لاحقاً من داخل النظام.'
                : 'Start anywhere — you can switch sections later inside the system.',
            trailing: selected == null ? null : _buildSelectedChip(selected),
          ),
          Gap(16.h),
          _buildModuleGrid(twoColumns: twoColumns),
          if (_moduleError != null) ...[
            Gap(10.h),
            _buildErrorBanner(_moduleError!),
          ],
          Gap(22.h),
          _buildPrimaryButton(),
          Gap(14.h),
          _buildOrDivider(),
          Gap(10.h),
          _buildTrialButton(),
          Gap(10.h),
          Text(
            _isArabic
                ? 'الحساب التجريبي يُكمل من صفحة تسجيل الدخول.'
                : 'Demo account — continue from the sign-in page.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.8.sp,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: AppColor.hintColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    String? step,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (step != null) ...[
          Container(
            width: 28.r,
            height: 28.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(9.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E40AF).withValues(alpha: 0.24),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              step,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
                color: AppColor.whiteColor(context),
              ),
            ),
          ),
          Gap(10.w),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.5.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  letterSpacing: -0.2,
                  color: AppColor.titleFormFiledColor(context),
                ),
              ),
              Gap(3.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10.8.sp,
                  height: 1.45,
                  color: AppColor.darkTextColor(context),
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[Gap(8.w), trailing],
      ],
    );
  }

  Widget _buildSelectedChip(WorkspaceModule module) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Container(
        key: ValueKey(module.id),
        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: module.color.withValues(alpha: _isDark ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: module.color.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(module.icon, size: 11.r, color: module.color),
            Gap(5.w),
            Text(
              module.title(_isArabic),
              style: TextStyle(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w800,
                color: module.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleGrid({required bool twoColumns}) {
    const spacing = 10.0;
    // Rows of Expanded cards keep widths pixel-perfect without a
    // LayoutBuilder (which would break IntrinsicHeight) or manual maths.
    // An odd last module spans the full width.
    if (!twoColumns) {
      return Column(
        children: [
          for (var i = 0; i < workspaceModules.length; i++) ...[
            if (i > 0) const SizedBox(height: spacing),
            _buildModuleCard(workspaceModules[i]),
          ],
        ],
      );
    }

    final rows = <Widget>[];
    for (var i = 0; i < workspaceModules.length; i += 2) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: spacing));
      final first = workspaceModules[i];
      final second = i + 1 < workspaceModules.length
          ? workspaceModules[i + 1]
          : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildModuleCard(first)),
              if (second != null) ...[
                const SizedBox(width: spacing),
                Expanded(child: _buildModuleCard(second)),
              ],
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildModuleCard(WorkspaceModule module) {
    final isSelected = _selectedModuleId == module.id;
    final muted = AppColor.darkTextColor(context);

    return Semantics(
      button: true,
      selected: isSelected,
      label: module.title(_isArabic),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectModule(module),
          borderRadius: BorderRadius.circular(14.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: isSelected
                  ? module.color.withValues(alpha: _isDark ? 0.18 : 0.07)
                  : AppColor.cardSurfaceColor(context),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isSelected
                    ? module.color
                    : AppColor.borderColor(context),
                width: isSelected ? 1.6 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: module.color.withValues(alpha: 0.14),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: module.color.withValues(
                      alpha: _isDark ? 0.22 : 0.12,
                    ),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Icon(module.icon, color: module.color, size: 19.r),
                ),
                Gap(11.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title(_isArabic),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColor.titleFormFiledColor(context),
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        module.description(_isArabic),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9.5.sp,
                          height: 1.35,
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(6.w),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20.r,
                  height: 20.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? module.color : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? module.color
                          : AppColor.borderColor(context),
                      width: 1.4,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          size: 13.r,
                          color: AppColor.whiteColor(context),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    final errorColor = _isDark
        ? const Color(0xFFFCA5A5)
        : const Color(0xFFDC2626);

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: errorColor.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: errorColor.withValues(alpha: 0.22)),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, size: 15.r, color: errorColor),
            Gap(7.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 10.8.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                  color: errorColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E40AF).withValues(alpha: 0.32),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _continueToLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: _isSubmitting
              ? SizedBox(
                  width: 21.r,
                  height: 21.r,
                  child:  CircularProgressIndicator(
                    color: AppColor.whiteColor(context),
                    strokeWidth: 2.2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        _isArabic
                            ? 'متابعة إلى تسجيل الدخول'
                            : 'Continue to sign in',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                          color: AppColor.whiteColor(context),
                        ),
                      ),
                    ),
                    Gap(8.w),
                    Icon(
                      _isArabic
                          ? Icons.arrow_back_rounded
                          : Icons.arrow_forward_rounded,
                      color: AppColor.whiteColor(context),
                      size: 18.r,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColor.borderColor(context))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            AppLocaleKey.orLabel.tr(),
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AppColor.hintColor(context),
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColor.borderColor(context))),
      ],
    );
  }

  Widget _buildTrialButton() {
    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: OutlinedButton.icon(
        onPressed: _isSubmitting ? null : _continueAsTrial,
        icon: Icon(
          Icons.explore_outlined,
          size: 16.r,
          color: AppColor.primaryColor(context),
        ),
        label: Text(
          _isArabic ? 'ابدأ بحساب تجريبي' : 'Start with a demo account',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.primaryColor(context),
          backgroundColor: AppColor.primaryColor(
            context,
          ).withValues(alpha: _isDark ? 0.08 : 0.04),
          side: BorderSide(
            color: AppColor.primaryColor(context).withValues(alpha: 0.28),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Text(
            _isArabic
                ? '© Delta ASG — منصة إدارة موارد المؤسسة'
                : '© Delta ASG — Enterprise resource platform',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.5.sp,
              color: AppColor.hintColor(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          Gap(4.h),
          Text(
            AppLocaleKey.versionPoweredBy.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.5.sp,
              color: AppColor.hintColor(context).withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  BLUEPRINT GRID
// ═══════════════════════════════════════════════════════════════════
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1;

    const spacing = 42.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
