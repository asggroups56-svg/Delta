import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/shared_pref/shared_pref.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/auth/data/model/workspace_module.dart';

/// Pre-login page combining workspace selection, account address, and login.
class AccountAccessScreen extends StatefulWidget {
  const AccountAccessScreen({super.key});

  @override
  State<AccountAccessScreen> createState() => _AccountAccessScreenState();
}

class _AccountAccessScreenState extends State<AccountAccessScreen> {
  final _addressController = TextEditingController();
  String? _selectedModuleId;
  String? _error;

  bool get _isArabic => context.locale.languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    final prefs = CacheHelper.sharedPreferences;
    final savedModule = prefs.getString(CacheHelper.selectedModuleKey);
    if (workspaceModuleById(savedModule) != null) {
      _selectedModuleId = savedModule;
    }
    final savedAddress = prefs.getString(CacheHelper.accountAddressKey);
    if (savedAddress != null && savedAddress.isNotEmpty) {
      _addressController.text = savedAddress;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
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
    final address = _addressController.text.trim();
    if (_selectedModuleId == null) {
      setState(() {
        _error = _isArabic
            ? 'اختر القسم الذي تريد البدء منه'
            : 'Choose the section you want to start with';
      });
      return;
    }
    if (address.isEmpty) {
      setState(() {
        _error = _isArabic
            ? 'أدخل عنوان الحساب للمتابعة'
            : 'Enter your account address to continue';
      });
      return;
    }

    await CacheHelper().saveData(
      key: CacheHelper.selectedModuleKey,
      value: _selectedModuleId!,
    );
    await CacheHelper().saveData(
      key: CacheHelper.accountAddressKey,
      value: address,
    );
    if (!mounted) return;
    NavigatorMethods.pushReplacementNamed(context, RoutesName.loginScreen);
  }

  Future<void> _continueAsTrial() async {
    await CacheHelper().saveData(
      key: CacheHelper.selectedModuleKey,
      value: _selectedModuleId ?? '',
    );
    await CacheHelper().saveData(key: CacheHelper.accountAddressKey, value: '');
    if (!mounted) return;
    NavigatorMethods.pushReplacementNamed(context, RoutesName.loginScreen);
  }

  void _selectModule(WorkspaceModule module) {
    setState(() {
      _selectedModuleId = module.id;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    Gap(24.h),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 900;
                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 4, child: _buildHero()),
                              Gap(22.w),
                              Expanded(flex: 5, child: _buildFormCard()),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            _buildHero(compact: true),
                            Gap(18.h),
                            _buildFormCard(),
                          ],
                        );
                      },
                    ),
                    Gap(20.h),
                    Center(
                      child: Text(
                        _isArabic
                            ? '© Delta ASG — منصة إدارة موارد المؤسسة'
                            : '© Delta ASG — Enterprise resource platform',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Gap(6.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E40AF).withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(Icons.hub_rounded, color: Colors.white, size: 22.r),
        ),
        Gap(11.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DELTA ASG',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              _isArabic ? 'منصة إدارة الأعمال' : 'Enterprise ERP Suite',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: _toggleLanguage,
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language_rounded,
                  size: 14.r,
                  color: const Color(0xFF3B82F6),
                ),
                Gap(5.w),
                Text(
                  _isArabic ? 'EN' : 'AR',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHero({bool compact = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 22.w : 30.w,
        vertical: compact ? 24.h : 34.h,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.28),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60.r,
            right: -50.r,
            child: Container(
              width: 170.r,
              height: 170.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.r,
                      height: 6.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFF34D399),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(7.w),
                    Flexible(
                      child: Text(
                        _isArabic
                            ? 'بوابة الدخول الموحدة'
                            : 'UNIFIED ACCESS PORTAL',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(compact ? 16.h : 24.h),
              Text(
                _isArabic
                    ? 'منصة واحدة\nلكل أعمالك'
                    : 'One platform.\nEvery business function.',
                style: TextStyle(
                  fontSize: compact ? 24.sp : 32.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                  letterSpacing: -0.6,
                  color: Colors.white,
                ),
              ),
              Gap(10.h),
              Text(
                _isArabic
                    ? 'اختر القسم الذي تريد البدء منه، أدخل عنوان حسابك، ثم تابع إلى تسجيل الدخول.'
                    : 'Pick the section you want to start with, enter your account address, then continue to sign in.',
                style: TextStyle(
                  fontSize: 12.sp,
                  height: 1.6,
                  color: Colors.white.withValues(alpha: 0.72),
                ),
              ),
              Gap(compact ? 18.h : 28.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _heroChip(
                    Icons.account_balance_rounded,
                    'المحاسبة',
                    'Accounting',
                  ),
                  _heroChip(Icons.domain_rounded, 'الأصول', 'Assets'),
                  _heroChip(Icons.point_of_sale_rounded, 'المبيعات', 'Sales'),
                  _heroChip(
                    Icons.shopping_cart_rounded,
                    'المشتريات',
                    'Purchases',
                  ),
                  _heroChip(Icons.inventory_2_rounded, 'المخزون', 'Inventory'),
                ],
              ),
              if (!compact) ...[
                Gap(30.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        color: const Color(0xFF93C5FD),
                        size: 18.r,
                      ),
                      Gap(10.w),
                      Expanded(
                        child: Text(
                          _isArabic
                              ? 'اتصال آمن ومشفر لبيانات مؤسستك'
                              : 'Secure, encrypted access to your organization',
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.78),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroChip(IconData icon, String labelAr, String labelEn) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.r, color: const Color(0xFF93C5FD)),
          Gap(6.w),
          Flexible(
            child: Text(
              _isArabic ? labelAr : labelEn,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    final selected = _selectedModule;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _stepBadge('1'),
              Gap(10.w),
              Expanded(
                child: Text(
                  _isArabic ? 'اختر مساحة العمل' : 'Choose your workspace',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
              if (selected != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: selected.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _isArabic ? selected.titleAr : selected.titleEn,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: selected.color,
                    ),
                  ),
                ),
            ],
          ),
          Gap(6.h),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 34.w),
            child: Text(
              _isArabic
                  ? 'يمكنك البدء من أي قسم وتغييره لاحقاً من داخل النظام.'
                  : 'Start anywhere — you can switch sections later inside the system.',
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.5,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Gap(16.h),
          _buildModuleGrid(),
          Gap(22.h),
          Row(
            children: [
              _stepBadge('2'),
              Gap(10.w),
              Expanded(
                child: Text(
                  _isArabic ? 'حسابك' : 'Your account',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          Gap(6.h),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 34.w),
            child: Text(
              _isArabic
                  ? 'أدخل عنوان الحساب الذي تريد الدخول إليه.'
                  : 'Enter the address of the account you want to access.',
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.5,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Gap(14.h),
          Text(
            _isArabic ? 'عنوان الحساب' : 'Account address',
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF334155),
              letterSpacing: 0.2,
            ),
          ),
          Gap(8.h),
          CustomFormField(
            controller: _addressController,
            hintText: _isArabic
                ? 'مثال: company.delta-icloud.com'
                : 'e.g. company.delta-icloud.com',
            keyboardType: TextInputType.url,
            textDirection: ui.TextDirection.ltr,
            prefixIcon: const Icon(
              Icons.language_rounded,
              color: Color(0xFF3B82F6),
            ),
            radius: 12.r,
            fillColor: Colors.white,
            unFocusColor: const Color(0xFFE2E8F0),
            focusColor: const Color(0xFF3B82F6),
            onChanged: (_) {
              if (_error != null) {
                setState(() => _error = null);
              }
            },
          ),
          if (_error != null) ...[
            Gap(9.h),
            Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 15,
                  color: Color(0xFFDC2626),
                ),
                Gap(5.w),
                Expanded(
                  child: Text(
                    _error!,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                ),
              ],
            ),
          ],
          Gap(18.h),
          _primaryButton(
            label: _isArabic
                ? 'متابعة إلى تسجيل الدخول'
                : 'Continue to sign in',
            icon: Icons.login_rounded,
            onPressed: _continueToLogin,
          ),
          Gap(10.h),
          Center(
            child: TextButton(
              onPressed: _continueAsTrial,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF3B82F6),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              ),
              child: Text(
                _isArabic
                    ? 'أو ابدأ بحساب تجريبي'
                    : 'Or start with a trial account',
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final columns = constraints.maxWidth >= 420 ? 2 : 1;
        final width = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (var i = 0; i < workspaceModules.length; i++)
              SizedBox(
                width: columns == 2 && i == workspaceModules.length - 1
                    ? constraints.maxWidth
                    : width,
                child: _buildModuleCard(workspaceModules[i]),
              ),
          ],
        );
      },
    );
  }

  Widget _buildModuleCard(WorkspaceModule module) {
    final isSelected = _selectedModuleId == module.id;
    return InkWell(
      onTap: () => _selectModule(module),
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(13.r),
        decoration: BoxDecoration(
          color: isSelected
              ? module.color.withValues(alpha: 0.07)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? module.color : const Color(0xFFE2E8F0),
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: module.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Icon(module.icon, color: module.color, size: 20.r),
            ),
            Gap(11.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isArabic ? module.titleAr : module.titleEn,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    _isArabic ? module.descriptionAr : module.descriptionEn,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.sp,
                      height: 1.35,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Gap(6.w),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? module.color : const Color(0xFFCBD5E1),
              size: 19.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepBadge(String value) {
    return Container(
      width: 24.r,
      height: 24.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF1E40AF),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E40AF).withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            Gap(8.w),
            Icon(
              _isArabic ? Icons.arrow_back_rounded : icon,
              color: Colors.white,
              size: 18.r,
            ),
          ],
        ),
      ),
    );
  }
}
