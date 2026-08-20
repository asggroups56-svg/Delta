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
import 'package:my_template/core/theme/app_colors.dart';
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

  void _toggleLanguage() {
    if (context.locale.languageCode == 'ar') {
      context.setLocale(const Locale('en'));
    } else {
      context.setLocale(const Locale('ar'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.loginStatus.isSuccess) {
                CommonMethods.showToast(
                  message: state.loginStatus.data?.message ??
                      "loginBtn".tr() + " SUCCESS",
                );
                NavigatorMethods.pushReplacementNamed(
                    context, RoutesName.homeScreen);
              }
              if (state.loginStatus.isFailure) {
                log(state.loginStatus.error?.toString() ?? "Login failed");
                final error = state.loginStatus.error ?? "Login failed";
                CommonMethods.showToast(message: error, type: ToastType.error);
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Top Bar with Brand & Language Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF0D9488),
                              ),
                              child: Icon(
                                Icons.widgets_rounded,
                                size: 20.r,
                                color: Colors.white,
                              ),
                            ),
                            Gap(8.w),
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
                                  isArabic ? 'English' : 'العربية',
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
                    Gap(32.h),

                    // Odoo Login Glassmorphic Card
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Title
                            Text(
                              'loginTitle'.tr(),
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.titleFormFiledColor(context),
                              ),
                            ),
                            Gap(6.h),
                            Text(
                              'loginSubtitle'.tr(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColor.darkTextColor(context),
                              ),
                            ),
                            Gap(24.h),

                            // Mobile / Email Field
                            CustomFormField(
                              controller: cubit.mobileController,
                              title: 'mobileOrEmail'.tr(),
                              prefixIcon: const Icon(Icons.phone_android_rounded),
                              validator: (value) => value!.isEmpty
                                  ? 'mobileOrEmail'.tr()
                                  : null,
                            ),
                            Gap(16.h),

                            // Password Field
                            CustomFormField(
                              controller: cubit.passwordController,
                              title: 'password'.tr(),
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              isPassword: true,
                              validator: (value) =>
                                  value!.isEmpty ? 'password'.tr() : null,
                            ),
                            Gap(16.h),

                            // Account Type Field
                            CustomFormField(
                              controller: cubit.accountTypeController,
                              title: 'accountType'.tr(),
                              prefixIcon: const Icon(Icons.badge_outlined),
                              validator: (value) =>
                                  value!.isEmpty ? 'accountType'.tr() : null,
                            ),
                            Gap(12.h),

                            // Remember Me & Forgot Password Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 24.w,
                                      height: 24.h,
                                      child: Checkbox(
                                        value: cubit.rememberMe,
                                        activeColor: const Color(0xFF0D9488),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                        ),
                                        onChanged: (value) =>
                                            cubit.changeRememberMe(),
                                      ),
                                    ),
                                    Gap(8.w),
                                    Text(
                                      'rememberMe'.tr(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColor.darkTextColor(context),
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'forgotPassword'.tr(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0D9488),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap(24.h),

                            // Odoo Style Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 48.h,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    cubit.login(context: context);
                                  } else {
                                    // Fallback for direct preview navigation if needed
                                    NavigatorMethods.pushReplacementNamed(
                                      context,
                                      RoutesName.homeScreen,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D9488),
                                  elevation: 3,
                                  shadowColor:
                                      const Color(0xFF0D9488).withValues(alpha: 0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                ),
                                child: Text(
                                  'loginBtn'.tr(),
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
                    Gap(24.h),

                    // Signup Navigation Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'dontHaveAccount'.tr(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColor.darkTextColor(context),
                          ),
                        ),
                        Gap(4.w),
                        GestureDetector(
                          onTap: () {
                            NavigatorMethods.pushNamed(
                              context,
                              RoutesName.signupScreen,
                            );
                          },
                          child: Text(
                            'createNewAccount'.tr(),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0D9488),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(30.h),

                    // Footer
                    Text(
                      'versionPoweredBy'.tr(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
