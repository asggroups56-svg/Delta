import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/common_methods.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();

  final TextEditingController _identityController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  int _currentStep = 1; // 1 = Enter Email/Mobile, 2 = Enter OTP & New Password
  bool _isLoading = false;

  Future<void> _toggleLanguage() async {
    if (context.locale.languageCode == 'ar') {
      await context.setLocale(const Locale('en'));
    } else {
      await context.setLocale(const Locale('ar'));
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _onSendCode() async {
    if (_step1FormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentStep = 2;
        });
        CommonMethods.showToast(
          message: isArabicLocale ? 'تم إرسال رمز التحقق' : 'Verification code sent',
          type: ToastType.success,
        );
      }
    }
  }

  bool get isArabicLocale => context.locale.languageCode == 'ar';

  void _onResetPassword() async {
    if (_step2FormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        CommonMethods.showToast(
          message: AppLocaleKey.passwordResetSuccess.tr(),
          type: ToastType.success,
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _identityController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = isArabicLocale;

    return Scaffold(
      backgroundColor: AppColor.darkBackground,
      body: Stack(
        children: [
          // ── Background Ambient Glows ───────────────────────────────────────
          Positioned(
            top: -60.r,
            left: isArabic ? null : -60.r,
            right: isArabic ? -60.r : null,
            child: Container(
              width: 220.r,
              height: 220.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0284C7).withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50.r,
            right: isArabic ? null : -50.r,
            left: isArabic ? -50.r : null,
            child: Container(
              width: 200.r,
              height: 200.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF38BDF8).withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Main Content ───────────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Column(
                children: [
                  // Top Navigation Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (_currentStep == 2) {
                                setState(() {
                                  _currentStep = 1;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: const Color(0xFF131C2E),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: const Color(0xFF38BDF8).withValues(alpha: 0.25),
                                ),
                              ),
                              child: Icon(
                                isArabic
                                    ? Icons.arrow_forward_ios_rounded
                                    : Icons.arrow_back_ios_new_rounded,
                                size: 15.r,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Gap(10.w),
                          Text(
                            'DELTA ASG',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      // Language Switcher
                      InkWell(
                        onTap: _toggleLanguage,
                        borderRadius: BorderRadius.circular(20.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF131C2E),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.language_rounded,
                                size: 14.r,
                                color: const Color(0xFF38BDF8),
                              ),
                              Gap(5.w),
                              Text(
                                AppLocaleKey.langSwitchLabel.tr(),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF38BDF8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Gap(20.h),

                  // Step Indicator
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131C2E),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStepItem(
                            step: 1,
                            title: isArabic ? 'إرسال الرمز' : 'Send Code',
                            isActive: _currentStep >= 1,
                          ),
                        ),
                        Container(
                          width: 24.w,
                          height: 2.h,
                          margin: EdgeInsets.symmetric(horizontal: 6.w),
                          color: _currentStep >= 2
                              ? const Color(0xFF0284C7)
                              : Colors.white.withValues(alpha: 0.1),
                        ),
                        Expanded(
                          child: _buildStepItem(
                            step: 2,
                            title: isArabic ? 'كلمة المرور' : 'New Password',
                            isActive: _currentStep >= 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Gap(20.h),

                  // Enterprise Glassmorphic Card
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131C2E),
                        borderRadius: BorderRadius.circular(22.r),
                        border: Border.all(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.28),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 20.r,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: _currentStep == 1
                          ? _buildStepOneContent()
                          : _buildStepTwoContent(),
                    ),
                  ),

                  Gap(22.h),

                  // Back to Login Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          children: [
                            Icon(
                              isArabic
                                  ? Icons.arrow_forward_rounded
                                  : Icons.arrow_back_rounded,
                              size: 16.r,
                              color: const Color(0xFF38BDF8),
                            ),
                            Gap(6.w),
                            Text(
                              AppLocaleKey.backToLogin.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF38BDF8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required int step,
    required String title,
    required bool isActive,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26.r,
          height: 26.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
                  )
                : null,
            color: isActive ? null : Colors.white.withValues(alpha: 0.08),
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
        Gap(6.w),
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF38BDF8) : Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepOneContent() {
    return Form(
      key: _step1FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0284C7).withValues(alpha: 0.15),
              ),
              child: Icon(
                Icons.lock_reset_rounded,
                size: 32.r,
                color: const Color(0xFF38BDF8),
              ),
            ),
          ),
          Gap(14.h),
          Text(
            AppLocaleKey.forgotPasswordHeader.tr(),
            style: AppTextStyle.titleBold(context, fontSize: 18, color: Colors.white).copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Gap(6.h),
          Text(
            AppLocaleKey.forgotPasswordHeaderSubtitle.tr(),
            style: AppTextStyle.bodySmall(context, fontSize: 11.5, color: const Color(0xFF94A3B8)),
          ),
          Gap(20.h),

          CustomFormField(
            controller: _identityController,
            title: AppLocaleKey.mobileOrEmail.tr(),
            prefixIcon: const Icon(
              Icons.account_circle_outlined,
              color: Color(0xFF38BDF8),
            ),
            radius: 12.r,
            fillColor: const Color(0xFF0E1626),
            unFocusColor: const Color(0xFF243048),
            validator: (value) =>
                value == null || value.trim().isEmpty ? AppLocaleKey.mobileOrEmail.tr() : null,
          ),
          Gap(20.h),

          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.45),
                    blurRadius: 14.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onSendCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        AppLocaleKey.sendVerificationCode.tr(),
                        style: TextStyle(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTwoContent() {
    return Form(
      key: _step2FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0284C7).withValues(alpha: 0.15),
              ),
              child: Icon(
                Icons.security_rounded,
                size: 32.r,
                color: const Color(0xFF38BDF8),
              ),
            ),
          ),
          Gap(14.h),
          Text(
            AppLocaleKey.verificationCode.tr(),
            style: AppTextStyle.titleBold(context, fontSize: 18, color: Colors.white).copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Gap(6.h),
          Text(
            AppLocaleKey.enterVerificationCode.tr(),
            style: AppTextStyle.bodySmall(context, fontSize: 11.5, color: const Color(0xFF94A3B8)),
          ),
          Gap(18.h),

          CustomFormField(
            controller: _otpController,
            title: AppLocaleKey.verificationCode.tr(),
            keyboardType: TextInputType.number,
            maxLength: 6,
            prefixIcon: const Icon(Icons.dialpad_rounded, color: Color(0xFF38BDF8)),
            radius: 12.r,
            fillColor: const Color(0xFF0E1626),
            unFocusColor: const Color(0xFF243048),
            validator: (value) => value == null || value.trim().length < 4
                ? AppLocaleKey.enterVerificationCode.tr()
                : null,
          ),
          Gap(14.h),

          CustomFormField(
            controller: _newPasswordController,
            title: AppLocaleKey.newPassword.tr(),
            prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF38BDF8)),
            isPassword: true,
            passwordColor: const Color(0xFF38BDF8),
            radius: 12.r,
            fillColor: const Color(0xFF0E1626),
            unFocusColor: const Color(0xFF243048),
            validator: (value) => value == null || value.isEmpty
                ? AppLocaleKey.newPassword.tr()
                : null,
          ),
          Gap(14.h),

          CustomFormField(
            controller: _confirmPasswordController,
            title: AppLocaleKey.confirmNewPassword.tr(),
            prefixIcon: const Icon(Icons.lock_reset_rounded, color: Color(0xFF38BDF8)),
            isPassword: true,
            passwordColor: const Color(0xFF38BDF8),
            radius: 12.r,
            fillColor: const Color(0xFF0E1626),
            unFocusColor: const Color(0xFF243048),
            validator: (value) {
              if (value == null || value.isEmpty) return AppLocaleKey.confirmNewPassword.tr();
              if (value != _newPasswordController.text) {
                return isArabicLocale ? 'كلمات المرور غير متطابقة' : 'Passwords do not match';
              }
              return null;
            },
          ),
          Gap(16.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocaleKey.resendCode.tr(),
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              InkWell(
                onTap: () {
                  CommonMethods.showToast(
                    message: isArabicLocale ? 'تم إرسال الرمز مجدداً' : 'Code resent',
                    type: ToastType.success,
                  );
                },
                child: Text(
                  AppLocaleKey.resendCode.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF38BDF8),
                  ),
                ),
              ),
            ],
          ),
          Gap(18.h),

          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.45),
                    blurRadius: 14.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onResetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        AppLocaleKey.resetPasswordBtn.tr(),
                        style: TextStyle(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
