import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
          message: 'verificationCodeSent'.tr(),
          type: ToastType.success,
        );
      }
    }
  }

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
          message: 'passwordResetSuccess'.tr(),
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
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              // Top Bar with Back Button & Language Switcher
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Expanded(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_currentStep == 2) {
                                setState(() {
                                  _currentStep = 1;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            icon: Icon(
                              context.locale.languageCode == 'ar'
                                  ? Icons.arrow_forward_ios_rounded
                                  : Icons.arrow_back_ios_rounded,
                              size: 18.r,
                              color: AppColor.titleFormFiledColor(context),
                            ),
                          ),
                          Gap(4.w),
                          Expanded(
                            child: Text(
                              'appName'.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: AppColor.titleFormFiledColor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(8.w),
                  // Language Switcher
                  InkWell(
                    onTap: _toggleLanguage,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFF0D9488).withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.language_rounded,
                            size: 16.r,
                            color: const Color(0xFF0D9488),
                          ),
                          Gap(6.w),
                          Text(
                            AppLocaleKey.langSwitchLabel.tr(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0D9488),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Gap(24.h),

              // Step Indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStepItem(
                        step: 1,
                        title: context.locale.languageCode == 'ar'
                            ? 'إرسال الرمز'
                            : 'Send Code',
                        isActive: _currentStep >= 1,
                      ),
                    ),
                    Container(
                      width: 24.w,
                      height: 2.h,
                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                      color: _currentStep >= 2
                          ? const Color(0xFF0D9488)
                          : Colors.grey.withValues(alpha: 0.3),
                    ),
                    Expanded(
                      child: _buildStepItem(
                        step: 2,
                        title: context.locale.languageCode == 'ar'
                            ? 'كلمة المرور'
                            : 'New Password',
                        isActive: _currentStep >= 2,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(24.h),

              // Enterprise Card
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.15),
                    ),
                  ),
                  child: _currentStep == 1
                      ? _buildStepOneContent()
                      : _buildStepTwoContent(),
                ),
              ),
              Gap(24.h),

              // Back to Login Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_rounded,
                          size: 16.r,
                          color: const Color(0xFF0D9488),
                        ),
                        Gap(6.w),
                        Text(
                          'backToLogin'.tr(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D9488),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(24.h),
            ],
          ),
        ),
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
            color: isActive
                ? const Color(0xFF0D9488)
                : Colors.grey.withValues(alpha: 0.2),
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
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
              color: isActive
                  ? const Color(0xFF0D9488)
                  : AppColor.darkTextColor(context),
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
          // Icon & Header
          Center(
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0D9488).withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.lock_reset_rounded,
                size: 36.r,
                color: const Color(0xFF0D9488),
              ),
            ),
          ),
          Gap(16.h),
          Text(
            'forgotPasswordHeader'.tr(),
            style: TextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.titleFormFiledColor(context),
            ),
          ),
          Gap(6.h),
          Text(
            'forgotPasswordHeaderSubtitle'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.4,
              color: AppColor.darkTextColor(context),
            ),
          ),
          Gap(24.h),

          // Email or Mobile Field
          CustomFormField(
            controller: _identityController,
            title: 'mobileOrEmail'.tr(),
            prefixIcon: const Icon(Icons.account_circle_outlined),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'mobileOrEmail'.tr() : null,
          ),
          Gap(24.h),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _onSendCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                elevation: 3,
                shadowColor: const Color(0xFF0D9488).withValues(alpha: 0.4),
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
                      'sendVerificationCode'.tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
          // Icon & Header
          Center(
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0D9488).withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.security_rounded,
                size: 36.r,
                color: const Color(0xFF0D9488),
              ),
            ),
          ),
          Gap(16.h),
          Text(
            'verificationCode'.tr(),
            style: TextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.titleFormFiledColor(context),
            ),
          ),
          Gap(6.h),
          Text(
            'enterVerificationCode'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.4,
              color: AppColor.darkTextColor(context),
            ),
          ),
          Gap(20.h),

          // OTP Code Field
          CustomFormField(
            controller: _otpController,
            title: 'verificationCode'.tr(),
            keyboardType: TextInputType.number,
            maxLength: 6,
            prefixIcon: const Icon(Icons.dialpad_rounded),
            validator: (value) => value == null || value.trim().length < 4
                ? 'enterVerificationCode'.tr()
                : null,
          ),
          Gap(14.h),

          // New Password Field
          CustomFormField(
            controller: _newPasswordController,
            title: 'newPassword'.tr(),
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            isPassword: true,
            validator: (value) => value == null || value.isEmpty
                ? 'newPassword'.tr()
                : null,
          ),
          Gap(14.h),

          // Confirm New Password Field
          CustomFormField(
            controller: _confirmPasswordController,
            title: 'confirmNewPassword'.tr(),
            prefixIcon: const Icon(Icons.lock_reset_rounded),
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) return 'confirmNewPassword'.tr();
              if (value != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          Gap(20.h),

          // Resend Code link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'resendCode'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColor.darkTextColor(context),
                ),
              ),
              InkWell(
                onTap: () {
                  CommonMethods.showToast(
                    message: 'verificationCodeSent'.tr(),
                    type: ToastType.success,
                  );
                },
                child: Text(
                  'resendCode'.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D9488),
                  ),
                ),
              ),
            ],
          ),
          Gap(20.h),

          // Reset Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _onResetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                elevation: 3,
                shadowColor: const Color(0xFF0D9488).withValues(alpha: 0.4),
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
                      'resetPasswordBtn'.tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
