import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _accountTypeController = TextEditingController();

  bool _agreeTerms = true;

  void _toggleLanguage() {
    if (context.locale.languageCode == 'ar') {
      context.setLocale(const Locale('en'));
    } else {
      context.setLocale(const Locale('ar'));
    }
  }

  void _onSignup() {
    if (_formKey.currentState!.validate()) {
      NavigatorMethods.pushReplacementNamed(context, RoutesName.homeScreen);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _accountTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Top Bar with Brand & Language Switcher
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            isArabic
                                ? Icons.arrow_forward_ios_rounded
                                : Icons.arrow_back_ios_rounded,
                            size: 18.r,
                            color: AppColor.titleFormFiledColor(context),
                          ),
                        ),
                        Gap(4.w),
                        Text(
                          'appName'.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppColor.titleFormFiledColor(context),
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
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF714B67).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: const Color(0xFF714B67).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.language_rounded,
                              size: 16.r,
                              color: const Color(0xFF714B67),
                            ),
                            Gap(6.w),
                            Text(
                              isArabic ? 'English' : 'العربية',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF714B67),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(20.h),

                // Odoo Signup Glassmorphic Card
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: Container(
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF714B67).withValues(alpha: 0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'signupTitle'.tr(),
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.titleFormFiledColor(context),
                          ),
                        ),
                        Gap(6.h),
                        Text(
                          'signupSubtitle'.tr(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColor.darkTextColor(context),
                          ),
                        ),
                        Gap(20.h),

                        // Full Name Field
                        CustomFormField(
                          controller: _fullNameController,
                          title: 'fullName'.tr(),
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          validator: (value) =>
                              value!.isEmpty ? 'fullName'.tr() : null,
                        ),
                        Gap(14.h),

                        // Mobile / Email Field
                        CustomFormField(
                          controller: _emailController,
                          title: 'mobileOrEmail'.tr(),
                          prefixIcon: const Icon(Icons.email_outlined),
                          validator: (value) =>
                              value!.isEmpty ? 'mobileOrEmail'.tr() : null,
                        ),
                        Gap(14.h),

                        // Company / Database Field (Signature Odoo Feature)
                        CustomFormField(
                          controller: _companyController,
                          title: 'companyName'.tr(),
                          prefixIcon: const Icon(Icons.business_rounded),
                          validator: (value) =>
                              value!.isEmpty ? 'companyName'.tr() : null,
                        ),
                        Gap(14.h),

                        // Password Field
                        CustomFormField(
                          controller: _passwordController,
                          title: 'password'.tr(),
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          isPassword: true,
                          validator: (value) =>
                              value!.isEmpty ? 'password'.tr() : null,
                        ),
                        Gap(14.h),

                        // Confirm Password Field
                        CustomFormField(
                          controller: _confirmPasswordController,
                          title: 'confirmPassword'.tr(),
                          prefixIcon: const Icon(Icons.lock_reset_rounded),
                          isPassword: true,
                          validator: (value) {
                            if (value!.isEmpty) return 'confirmPassword'.tr();
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        Gap(14.h),

                        // Account Type Field
                        CustomFormField(
                          controller: _accountTypeController,
                          title: 'accountType'.tr(),
                          prefixIcon: const Icon(Icons.badge_outlined),
                          validator: (value) =>
                              value!.isEmpty ? 'accountType'.tr() : null,
                        ),
                        Gap(16.h),

                        // Agree Terms Checkbox
                        Row(
                          children: [
                            SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: Checkbox(
                                value: _agreeTerms,
                                activeColor: const Color(0xFF714B67),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _agreeTerms = value ?? true;
                                  });
                                },
                              ),
                            ),
                            Gap(8.w),
                            Expanded(
                              child: Text(
                                'agreeTerms'.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColor.darkTextColor(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(24.h),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: _onSignup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF714B67),
                              elevation: 3,
                              shadowColor:
                                  const Color(0xFF714B67).withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            child: Text(
                              'signupBtn'.tr(),
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
                  ),
                ),
                Gap(20.h),

                // Navigation to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'alreadyHaveAccount'.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColor.darkTextColor(context),
                      ),
                    ),
                    Gap(4.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'loginBtn'.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF714B67),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
