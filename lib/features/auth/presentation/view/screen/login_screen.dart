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
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColor.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.loginStatus.isSuccess) {
                CommonMethods.showToast(
                  message: state.loginStatus.data?.message ??
                      "${AppLocaleKey.loginBtn.tr()} SUCCESS",
                );
                NavigatorMethods.pushReplacementNamed(
                    context, RoutesName.mainShellScreen);
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
                    // Top App Bar: Brand & Language Switcher
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF00B894), Color(0xFF0984E3)],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.emeraldTeal.withValues(alpha: 0.35),
                                      blurRadius: 8.r,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.widgets_rounded,
                                  size: 18.r,
                                  color: Colors.white,
                                ),
                              ),
                              Gap(10.w),
                              Expanded(
                                child: Text(
                                  AppLocaleKey.appName.tr(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(8.w),
                        // Language Switcher Pill
                        InkWell(
                          onTap: _toggleLanguage,
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColor.emeraldTeal.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: AppColor.emeraldTeal.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.language_rounded,
                                  size: 15.r,
                                  color: AppColor.emeraldTeal,
                                ),
                                Gap(6.w),
                                Text(
                                  AppLocaleKey.langSwitchLabel.tr(),
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.mintTeal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(28.h),

                    // Enterprise Glassmorphic Login Card
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        padding: EdgeInsets.all(22.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141D2B),
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 24.r,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: AppColor.emeraldTeal.withValues(alpha: 0.04),
                              blurRadius: 20.r,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Title & Icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocaleKey.loginTitle.tr(),
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Gap(4.h),
                                      Text(
                                        AppLocaleKey.loginSubtitle.tr(),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColor.whiteColor(context).withValues(alpha: 0.55),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(12.w),
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    color: AppColor.emeraldTeal.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.lock_person_rounded,
                                    color: AppColor.emeraldTeal,
                                    size: 22.r,
                                  ),
                                ),
                              ],
                            ),
                            Gap(22.h),

                            // Mobile / Email Field
                            CustomFormField(
                              controller: cubit.mobileController,
                              title: AppLocaleKey.mobileOrEmail.tr(),
                              prefixIcon: const Icon(Icons.phone_android_rounded),
                              validator: (value) => value!.isEmpty
                                  ? AppLocaleKey.mobileOrEmail.tr()
                                  : null,
                            ),
                            Gap(16.h),

                            // Password Field
                            CustomFormField(
                              controller: cubit.passwordController,
                              title: AppLocaleKey.password.tr(),
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              isPassword: true,
                              validator: (value) =>
                                  value!.isEmpty ? AppLocaleKey.password.tr() : null,
                            ),
                            Gap(16.h),

                            // Account Type Field
                            CustomFormField(
                              controller: cubit.accountTypeController,
                              title: AppLocaleKey.accountType.tr(),
                              prefixIcon: const Icon(Icons.badge_outlined),
                              validator: (value) =>
                                  value!.isEmpty ? AppLocaleKey.accountType.tr() : null,
                            ),
                            Gap(12.h),

                            // Remember Me & Forgot Password Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () => cubit.changeRememberMe(),
                                  borderRadius: BorderRadius.circular(4.r),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 22.w,
                                        height: 22.h,
                                        child: Checkbox(
                                          value: state.rememberMe,
                                          activeColor: AppColor.emeraldTeal,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.r),
                                          ),
                                          onChanged: (value) =>
                                              cubit.changeRememberMe(value),
                                        ),
                                      ),
                                      Gap(6.w),
                                      Text(
                                        AppLocaleKey.rememberMe.tr(),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColor.whiteColor(context).withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    NavigatorMethods.pushNamed(
                                      context,
                                      RoutesName.forgotPasswordScreen,
                                    );
                                  },
                                  child: Text(
                                    AppLocaleKey.forgotPassword.tr(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.mintTeal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap(22.h),

                            // Submit Button with Gradient
                            SizedBox(
                              width: double.infinity,
                              height: 48.h,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF00B894), Color(0xFF0984E3)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.emeraldTeal.withValues(alpha: 0.35),
                                      blurRadius: 12.r,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      cubit.login(context: context);
                                    } else {
                                      NavigatorMethods.pushReplacementNamed(
                                        context,
                                        RoutesName.mainShellScreen,
                                      );
                                    }
                                  },
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
                                      Text(
                                        AppLocaleKey.loginBtn.tr(),
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Gap(8.w),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
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
                          AppLocaleKey.dontHaveAccount.tr(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColor.whiteColor(context).withValues(alpha: 0.6),
                          ),
                        ),
                        Gap(6.w),
                        GestureDetector(
                          onTap: () {
                            NavigatorMethods.pushNamed(
                              context,
                              RoutesName.signupScreen,
                            );
                          },
                          child: Text(
                            AppLocaleKey.createNewAccount.tr(),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.mintTeal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(28.h),

                    // Footer
                    Text(
                      AppLocaleKey.versionPoweredBy.tr(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColor.whiteColor(context).withValues(alpha: 0.35),
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
