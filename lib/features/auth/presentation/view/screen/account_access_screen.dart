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

/// Pre-login choice between a trial account and an existing account.
class AccountAccessScreen extends StatefulWidget {
  const AccountAccessScreen({super.key});

  @override
  State<AccountAccessScreen> createState() => _AccountAccessScreenState();
}

class _AccountAccessScreenState extends State<AccountAccessScreen> {
  final _addressController = TextEditingController();
  String? _addressError;

  bool get _isArabic => context.locale.languageCode == 'ar';

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

  Future<void> _continueAsTrial() async {
    await CacheHelper().saveData(key: CacheHelper.accountAddressKey, value: '');
    if (!mounted) return;
    NavigatorMethods.pushReplacementNamed(context, RoutesName.loginScreen);
  }

  Future<void> _continueWithAddress() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      setState(() {
        _addressError = _isArabic
            ? 'أدخل عنوان الحساب للمتابعة'
            : 'Enter your account address to continue';
      });
      return;
    }

    await CacheHelper().saveData(
      key: CacheHelper.accountAddressKey,
      value: address,
    );
    if (!mounted) return;
    NavigatorMethods.pushReplacementNamed(context, RoutesName.loginScreen);
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
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    Gap(32.h),
                    _buildHero(),
                    Gap(28.h),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 760;
                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildTrialCard()),
                              Gap(20.w),
                              Expanded(child: _buildExistingAccountCard()),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            _buildTrialCard(),
                            Gap(18.h),
                            _buildExistingAccountCard(),
                          ],
                        );
                      },
                    ),
                    Gap(14.h),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => NavigatorMethods.pushNamed(
                          context,
                          RoutesName.modelSelectionScreen,
                        ),
                        icon: Icon(
                          Icons.grid_view_rounded,
                          size: 15.r,
                          color: const Color(0xFF1E40AF),
                        ),
                        label: Text(
                          _isArabic
                              ? 'أو ادخل مباشرة إلى بوابة الوحدات'
                              : 'Or go straight to the module portal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF1E40AF),
                        ),
                      ),
                    ),
                    Gap(24.h),
                    Center(
                      child: Text(
                        _isArabic
                            ? 'اختر الطريقة المناسبة لك للبدء — يمكنك تغييرها في أي وقت.'
                            : 'Choose how you want to get started — you can change this later.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          color: const Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Gap(8.h),
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
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            ),
            borderRadius: BorderRadius.circular(11.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E40AF).withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(Icons.hub_rounded, color: Colors.white, size: 21.r),
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

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
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
                Text(
                  _isArabic ? 'بوابة الدخول' : 'ACCESS PORTAL',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          Gap(16.h),
          Text(
            _isArabic
                ? 'كيف تريد استخدام DELTA ERP؟'
                : 'How would you like to use DELTA ERP?',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w900,
              height: 1.15,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
          Gap(8.h),
          Text(
            _isArabic
                ? 'ابدأ بحساب تجريبي لتجربة النظام، أو تابع إلى حسابك الحالي باستخدام عنوان الحساب.'
                : 'Start with a trial account to explore the system, or continue to your existing account with your account address.',
            style: TextStyle(
              fontSize: 12.5.sp,
              height: 1.6,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrialCard() {
    return _OptionCard(
      accent: const Color(0xFF0284C7),
      icon: Icons.rocket_launch_rounded,
      tag: _isArabic ? 'بداية سريعة' : 'QUICK START',
      title: _isArabic ? 'حساب تجريبي' : 'Trial account',
      description: _isArabic
          ? 'استكشف جميع الميزات باستخدام حساب تجريبي جاهز، دون الحاجة إلى إعداد مسبق.'
          : 'Explore every feature with a ready-to-use trial account. No setup required.',
      footer: _primaryButton(
        label: _isArabic ? 'ابدأ الحساب التجريبي' : 'Start trial account',
        icon: Icons.arrow_forward_rounded,
        onPressed: _continueAsTrial,
      ),
    );
  }

  Widget _buildExistingAccountCard() {
    return _OptionCard(
      accent: const Color(0xFF1E40AF),
      icon: Icons.domain_rounded,
      tag: _isArabic ? 'عميل حالي' : 'EXISTING CUSTOMER',
      title: _isArabic ? 'حساب قائم' : 'Existing account',
      description: _isArabic
          ? 'أدخل عنوان حسابك للوصول إلى بيانات مؤسستك والمتابعة إلى تسجيل الدخول.'
          : 'Enter your account address to access your organization and continue to sign in.',
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
              if (_addressError != null) {
                setState(() => _addressError = null);
              }
            },
          ),
          if (_addressError != null) ...[
            Gap(7.h),
            Text(
              _addressError!,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFDC2626),
              ),
            ),
          ],
          Gap(14.h),
          _primaryButton(
            label: _isArabic
                ? 'متابعة إلى تسجيل الدخول'
                : 'Continue to sign in',
            icon: Icons.login_rounded,
            onPressed: _continueWithAddress,
          ),
        ],
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(13.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E40AF).withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
            Gap(8.w),
            Icon(
              _isArabic ? Icons.arrow_back_rounded : icon,
              color: Colors.white,
              size: 17.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final Color accent;
  final IconData icon;
  final String tag;
  final String title;
  final String description;
  final Widget footer;

  const _OptionCard({
    required this.accent,
    required this.icon,
    required this.tag,
    required this.title,
    required this.description,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: accent, size: 24.r),
          ),
          Gap(16.h),
          Text(
            tag,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
              color: accent,
            ),
          ),
          Gap(6.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
              height: 1.2,
            ),
          ),
          Gap(8.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.6,
              color: const Color(0xFF64748B),
            ),
          ),
          Gap(20.h),
          footer,
        ],
      ),
    );
  }
}
