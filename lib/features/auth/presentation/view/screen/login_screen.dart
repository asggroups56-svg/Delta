import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _toggleLanguage() async {
    if (context.locale.languageCode == 'ar') {
      await context.setLocale(const Locale('en'));
    } else {
      await context.setLocale(const Locale('ar'));
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.loginStatus.isSuccess) {
                CommonMethods.showToast(
                  message:
                      state.loginStatus.data?.message ??
                      "${AppLocaleKey.loginBtn.tr()} SUCCESS",
                );
                NavigatorMethods.pushReplacementNamed(
                  context,
                  RoutesName.mainShellScreen,
                );
              }
              if (state.loginStatus.isFailure) {
                log(state.loginStatus.error?.toString() ?? "Login failed");
                final error = state.loginStatus.error ?? "Login failed";
                CommonMethods.showToast(
                  message: error,
                  type: ToastType.error,
                );
              }
            },
            builder: (context, state) {
              final isLoading = state.loginStatus.isLoading;
      
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                     
                      children: [
                        // ═══════════════════════════════════════════════
                        //  LEFT SIDE - Branding Panel (Enterprise ERP Look)
                        // ═══════════════════════════════════════════════
                        if (constraints.maxWidth > 900)
                          Expanded(
                            flex: 5,
                            child: _BrandingPanel(isArabic: isArabic),
                          ),
      
                        // ═══════════════════════════════════════════════
                        //  RIGHT SIDE - Login Form
                        // ═══════════════════════════════════════════════
                        Expanded(
                          flex: 4,
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 42.w,
                              vertical: 32.h,
                            ),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 460,
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Top Bar: Language Switcher
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 38.r,
                                                height: 38.r,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFF1E3A8A),
                                                          Color(0xFF3B82F6),
                                                        ],
                                                      ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10.r,
                                                      ),
                                                ),
                                                child: Icon(
                                                  Icons.hub_rounded,
                                                  color: Colors.white,
                                                  size: 20.r,
                                                ),
                                              ),
                                              Gap(10.w),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'DELTA ASG',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      letterSpacing: 1.1,
                                                      color: const Color(
                                                        0xFF0F172A,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Enterprise ERP Suite',
                                                    style: TextStyle(
                                                      fontSize: 9.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                        0xFF3B82F6,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: _toggleLanguage,
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                            child: Container(
                                              padding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 6.h,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFFF1F5F9,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      20.r,
                                                    ),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFE2E8F0,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.language_rounded,
                                                    size: 14.r,
                                                    color: const Color(
                                                      0xFF3B82F6,
                                                    ),
                                                  ),
                                                  Gap(5.w),
                                                  Text(
                                                    isArabic ? 'EN' : 'AR',
                                                    style: TextStyle(
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: const Color(
                                                        0xFF0F172A,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
      
                                      Gap(48.h),
      
                                      // Welcome Title
                                      FadeInUp(
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 4.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFFDBEAFE,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      6.r,
                                                    ),
                                              ),
                                              child: Text(
                                                isArabic
                                                    ? 'بوابة آمنة'
                                                    : 'SECURE PORTAL',
                                                style: TextStyle(
                                                  fontSize: 9.sp,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 1.5,
                                                  color: const Color(
                                                    0xFF1E40AF,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Gap(12.h),
                                            Text(
                                              isArabic
                                                  ? 'مرحبًا بك مجددًا 👋'
                                                  : 'Welcome Back 👋',
                                              style: TextStyle(
                                                fontSize: 26.sp,
                                                fontWeight: FontWeight.w900,
                                                color: const Color(
                                                  0xFF0F172A,
                                                ),
                                                letterSpacing: -0.5,
                                                height: 1.1,
                                              ),
                                            ),
                                            Gap(6.h),
                                            Text(
                                              isArabic
                                                  ? 'سجّل الدخول للوصول إلى لوحة التحكم وإدارة موارد المؤسسة'
                                                  : 'Sign in to access your enterprise dashboard and manage business resources',
                                              style: TextStyle(
                                                fontSize: 12.5.sp,
                                                color: const Color(
                                                  0xFF64748B,
                                                ),
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
      
                                      Gap(32.h),
      
                                      // Username
                                      _buildLabel(
                                        isArabic
                                            ? 'اسم المستخدم'
                                            : 'Username',
                                      ),
                                      Gap(8.h),
                                      CustomFormField(
                                        controller:
                                            cubit.usernameController,
                                        hintText: isArabic
                                            ? 'أدخل اسم المستخدم'
                                            : 'Enter your username',
                                        textStyle: TextStyle(
                                          fontSize: 13.5.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF0F172A),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.person_outline_rounded,
                                          color: Color(0xFF3B82F6),
                                        ),
                                        radius: 12.r,
                                        fillColor: const Color(0xFFF8FAFC),
                                        unFocusColor:
                                            const Color(0xFFE2E8F0),
                                        focusColor: const Color(0xFF3B82F6),
                                        validator: (value) =>
                                            value!.isEmpty
                                            ? (isArabic
                                                  ? 'اسم المستخدم مطلوب'
                                                  : 'Username is required')
                                            : null,
                                      ),
                                      Gap(18.h),
      
                                      // Password
                                      _buildLabel(
                                        AppLocaleKey.password.tr(),
                                      ),
                                      Gap(8.h),
                                      CustomFormField(
                                        controller:
                                            cubit.passwordController,
                                        hintText: isArabic
                                            ? 'أدخل كلمة المرور'
                                            : 'Enter your password',
                                        textStyle: TextStyle(
                                          fontSize: 13.5.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF0F172A),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.lock_outline_rounded,
                                          color: Color(0xFF3B82F6),
                                        ),
                                        isPassword: true,
                                        passwordColor: const Color(
                                          0xFF64748B,
                                        ),
                                        radius: 12.r,
                                        fillColor: const Color(0xFFF8FAFC),
                                        unFocusColor:
                                            const Color(0xFFE2E8F0),
                                        focusColor: const Color(0xFF3B82F6),
                                        validator: (value) =>
                                            value!.isEmpty
                                            ? (isArabic
                                                  ? 'كلمة المرور مطلوبة'
                                                  : 'Password is required')
                                            : null,
                                      ),
                                      Gap(18.h),
      
                                      // Connection Name
                                      _buildLabel(
                                        isArabic
                                            ? 'اسم الاتصال'
                                            : 'Connection name',
                                      ),
                                      Gap(8.h),
                                      CustomFormField(
                                        controller:
                                            cubit.connectionNameController,
                                        hintText: isArabic
                                            ? 'أدخل اسم الاتصال'
                                            : 'Enter connection name',
                                        textStyle: TextStyle(
                                          fontSize: 13.5.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF0F172A),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.storage_rounded,
                                          color: Color(0xFF3B82F6),
                                        ),
                                        radius: 12.r,
                                        fillColor: const Color(0xFFF8FAFC),
                                        unFocusColor:
                                            const Color(0xFFE2E8F0),
                                        focusColor: const Color(0xFF3B82F6),
                                        validator: (value) =>
                                            value!.isEmpty
                                            ? (isArabic
                                                  ? 'اسم الاتصال مطلوب'
                                                  : 'Connection name is required')
                                            : null,
                                      ),
      
                                      Gap(30.h),
      
                                      // Login Button
                                      SizedBox(
                                        width: double.infinity,
                                        height: 52.h,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF1E40AF),
                                                Color(0xFF3B82F6),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(14.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF1E40AF,
                                                ).withValues(alpha: 0.35),
                                                blurRadius: 20.r,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: isLoading
                                                ? null
                                                : () {
                                                    if (_formKey
                                                        .currentState!
                                                        .validate()) {
                                                      cubit.login(
                                                        context: context,
                                                      );
                                                    }
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      14.r,
                                                    ),
                                              ),
                                            ),
                                            child: isLoading
                                                ? SizedBox(
                                                    width: 22.r,
                                                    height: 22.r,
                                                    child:
                                                        const CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2.2,
                                                        ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        AppLocaleKey.loginBtn
                                                            .tr(),
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color:
                                                              Colors.white,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                      Gap(8.w),
                                                      Icon(
                                                        isArabic
                                                            ? Icons
                                                                  .arrow_back_rounded
                                                            : Icons
                                                                  .arrow_forward_rounded,
                                                        color: Colors.white,
                                                        size: 18.r,
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ),
      
                                      Gap(32.h),
      
                                      // Version Info
                                      Center(
                                        child: Text(
                                          AppLocaleKey.versionPoweredBy.tr(),
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: const Color(0xFF94A3B8),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF334155),
        letterSpacing: 0.2,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BRANDING PANEL (Left Side)
// ═══════════════════════════════════════════════════════════════
class _BrandingPanel extends StatelessWidget {
  final bool isArabic;
  const _BrandingPanel({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E3A8A),
            Color(0xFF1E40AF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -100,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
              ),
            ),
          ),
          // Grid pattern
          Positioned.fill(
            child: CustomPaint(painter: _GridPainter()),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(48.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top logo
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF3B82F6,
                            ).withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.hub_rounded,
                        color: Colors.white,
                        size: 22.r,
                      ),
                    ),
                    Gap(14.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DELTA ASG',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Enterprise Cloud ERP',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF93C5FD),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Middle content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
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
                          Gap(8.w),
                          Text(
                            isArabic
                                ? 'النظام يعمل بكفاءة'
                                : 'All systems operational',
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(24.h),
                    Text(
                      isArabic
                          ? 'إدارة ذكية\nلجميع موارد مؤسستك'
                          : 'Smart Management\nfor your entire enterprise',
                      style: TextStyle(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.15,
                        letterSpacing: -0.8,
                      ),
                    ),
                    Gap(18.h),
                    Text(
                      isArabic
                          ? 'نظام ERP متكامل يمنحك تحكمًا كاملاً في الموارد، العمليات المالية، سلسلة التوريد، والموارد البشرية من منصة واحدة.'
                          : 'A complete ERP system giving you full control over resources, finance, supply chain, and HR — all from a single unified platform.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.7,
                      ),
                    ),
                    Gap(32.h),
                    // Feature chips
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: [
                        _featureChip(
                          icon: Icons.inventory_2_rounded,
                          label: isArabic ? 'المخزون' : 'Inventory',
                        ),
                        _featureChip(
                          icon: Icons.account_balance_wallet_rounded,
                          label: isArabic ? 'المالية' : 'Finance',
                        ),
                        _featureChip(
                          icon: Icons.groups_rounded,
                          label: isArabic ? 'الموارد البشرية' : 'HR',
                        ),
                        _featureChip(
                          icon: Icons.local_shipping_rounded,
                          label: isArabic ? 'التوريد' : 'Supply Chain',
                        ),
                        _featureChip(
                          icon: Icons.insights_rounded,
                          label: isArabic ? 'التقارير' : 'Analytics',
                        ),
                      ],
                    ),
                  ],
                ),

                // Bottom stats
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    vertical: 18.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _stat(
                          value: '99.9%',
                          label: isArabic ? 'وقت التشغيل' : 'Uptime',
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 34,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      Expanded(
                        child: _stat(
                          value: '256-bit',
                          label: isArabic ? 'التشفير' : 'Encryption',
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 34,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      Expanded(
                        child: _stat(
                          value: '24/7',
                          label: isArabic ? 'الدعم الفني' : 'Support',
                        ),
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

  Widget _featureChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: const Color(0xFF93C5FD)),
          Gap(6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        Gap(3.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;

    const spacing = 45.0;
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