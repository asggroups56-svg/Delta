import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';


const _kAccent = Color(0xFF3B82F6);

class LoginFieldLabel extends StatelessWidget {
  final String text;
  const LoginFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
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

TextStyle _fieldTextStyle(BuildContext context) => TextStyle(
  fontSize: 13.5.sp,
  fontWeight: FontWeight.w600,
  color: AppColor.textFormColor(context),
);

class UsernameField extends StatelessWidget {
  const UsernameField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LoginFieldLabel(AppLocaleKey.loginUsername.tr()),
        Gap(8.h),
        CustomFormField(
          controller: cubit.usernameController,
          hintText: AppLocaleKey.loginUsernameHint.tr(),
          textStyle: _fieldTextStyle(context),
          prefixIcon: const Icon(
            Icons.person_outline_rounded,
            color: _kAccent,
          ),
          radius: 12.r,
          fillColor: AppColor.textFormFillColor(context),
          unFocusColor: AppColor.textFormBorderColor(context),
          focusColor: _kAccent,
          validator: (value) => value!.isEmpty
              ? (AppLocaleKey.loginUsernameRequired.tr())
              : null,
        ),
      ],
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LoginFieldLabel(AppLocaleKey.password.tr()),
        Gap(8.h),
        CustomFormField(
          controller: cubit.passwordController,
          hintText: AppLocaleKey.loginPasswordHint.tr(),
          textStyle: _fieldTextStyle(context),
          prefixIcon: const Icon(Icons.lock_outline_rounded, color: _kAccent),
          isPassword: true,
          passwordColor: const Color(0xFF64748B),
          radius: 12.r,
          fillColor: AppColor.textFormFillColor(context),
          unFocusColor: AppColor.textFormBorderColor(context),
          focusColor: _kAccent,
          validator: (value) => value!.isEmpty
              ? (AppLocaleKey.loginPasswordRequired.tr())
              : null,
        ),
      ],
    );
  }
}

/// Typed by the user. Required for a workspace; optional for a demo account.
class ConnectionNameField extends StatelessWidget {
  final bool isRequired;

  const ConnectionNameField({
    super.key,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            LoginFieldLabel(AppLocaleKey.loginConnectionName.tr()),
            // if (!isRequired) ...[
            //   Gap(6.w),
            //   Text(
            //     AppLocaleKey.loginOptional.tr(),
            //     style: TextStyle(
            //       fontSize: 9.sp,
            //       fontWeight: FontWeight.w700,
            //       letterSpacing: 0.4,
            //       color: const Color(0xFF94A3B8),
            //     ),
            //   ),
            // ],
          ],
        ),
        Gap(8.h),
        CustomFormField(
          controller: cubit.connectionNameController,
          hintText: AppLocaleKey.loginConnectionNameHint.tr(),
          textStyle: _fieldTextStyle(context),
          prefixIcon: const Icon(Icons.storage_rounded, color: _kAccent),
          textDirection: ui.TextDirection.ltr,
          radius: 12.r,
          fillColor: AppColor.textFormFillColor(context),
          unFocusColor: AppColor.textFormBorderColor(context),
          focusColor: _kAccent,
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty && isRequired) {
              return AppLocaleKey.loginConnectionNameRequired.tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}