import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyle {
  /// Generic factory method to create custom text styles - reduces code duplication
  static TextStyle _buildStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
    double? height,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }

  // ─── Size & Weight Presets ───
  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _semibold = FontWeight.w600;
  static const FontWeight _bold = FontWeight.w700;

  // ─── Semantic text styles ───
  static TextStyle appBarStyle(BuildContext context, {bool listen = true}) {
    return _buildStyle(
      fontSize: 16.sp,
      fontWeight: _medium,
      color: AppColor.appBarTextColor(context, listen: listen),
    );
  }

  static TextStyle buttonStyle(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return _buildStyle(
      fontSize: 16.sp,
      fontWeight: _medium,
      color: color ?? AppColor.buttonTextColor(context, listen: listen),
    );
  }

  // ─── Dark text styles (size: 16, 12, 10 with weight 600) ───
  static TextStyle text16SDark(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return _buildStyle(
      fontSize: 16.sp,
      fontWeight: _semibold,
      color: color ?? AppColor.darkTextColor(context, listen: listen),
    );
  }

  static TextStyle text12SDark(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return _buildStyle(
      fontSize: 12.sp,
      fontWeight: _semibold,
      color: color ?? AppColor.darkTextColor(context, listen: listen),
    );
  }

  static TextStyle text10SDark(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return _buildStyle(
      fontSize: 10.sp,
      fontWeight: _semibold,
      color: color ?? AppColor.darkTextColor(context, listen: listen),
    );
  }

  // ─── Primary color text styles ───
  static TextStyle text14MPrimary(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return _buildStyle(
      fontSize: 14.sp,
      fontWeight: _medium,
      color: color ?? AppColor.primaryColor(context, listen: listen),
    );
  }

  // ─── Secondary color text styles ───
  static TextStyle text16MSecond(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return _buildStyle(
      fontSize: 16.sp,
      fontWeight: _medium,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
    );
  }

  // ─── Grey text styles ───
  static TextStyle text14RGrey(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return _buildStyle(
      fontSize: 14.sp,
      fontWeight: _medium,
      color: color ?? AppColor.greyColor(context, listen: listen),
    );
  }

  static TextStyle textFormStyle(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return _buildStyle(
      fontSize: 16.sp,
      fontWeight: _medium,
      color: color ?? AppColor.greyColor(context, listen: listen),
    );
  }

  static TextStyle formTitleStyle(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return _buildStyle(
      fontSize: 16.sp,
      fontWeight: _medium,
      color: color ?? AppColor.greyColor(context, listen: listen),
    );
  }

  static TextStyle mainAppColor(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return _buildStyle(
      fontSize: 16.sp,
      fontWeight: _medium,
      color: color ?? AppColor.primaryColor(context, listen: listen),
    );
  }

  static TextStyle hintStyle(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return _buildStyle(
      fontSize: 16.sp,
      fontWeight: _medium,
      color: color ?? AppColor.greyColor(context, listen: listen),
    );
  }

  // ─── Reusable Standard Styles ───────────────────────────────────────────
  static TextStyle titleBold(BuildContext context, {double fontSize = 16, Color? color}) {
    return _buildStyle(
      fontSize: fontSize.sp,
      fontWeight: _bold,
      color: color ?? AppColor.titleFormFiledColor(context),
    );
  }

  static TextStyle bodyMedium(BuildContext context, {double fontSize = 14, Color? color}) {
    return _buildStyle(
      fontSize: fontSize.sp,
      fontWeight: _medium,
      color: color ?? AppColor.darkTextColor(context),
    );
  }

  static TextStyle bodySmall(BuildContext context, {double fontSize = 12, Color? color}) {
    return _buildStyle(
      fontSize: fontSize.sp,
      fontWeight: _regular,
      color: color ?? AppColor.greyColor(context),
    );
  }

  // ─── Additional common text styles for better code reuse ───

  /// Large heading style
  static TextStyle heading1(BuildContext context, {Color? color}) {
    return _buildStyle(
      fontSize: 28.sp,
      fontWeight: _bold,
      color: color ?? AppColor.darkTextColor(context),
    );
  }

  /// Medium heading style
  static TextStyle heading2(BuildContext context, {Color? color}) {
    return _buildStyle(
      fontSize: 24.sp,
      fontWeight: _bold,
      color: color ?? AppColor.darkTextColor(context),
    );
  }

  /// Small heading style
  static TextStyle heading3(BuildContext context, {Color? color}) {
    return _buildStyle(
      fontSize: 20.sp,
      fontWeight: _semibold,
      color: color ?? AppColor.darkTextColor(context),
    );
  }

  /// Body large text
  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    return _buildStyle(
      fontSize: 16.sp,
      fontWeight: _regular,
      color: color ?? AppColor.darkTextColor(context),
    );
  }

  /// Body extra small text
  static TextStyle bodyExtraSmall(BuildContext context, {Color? color}) {
    return _buildStyle(
      fontSize: 10.sp,
      fontWeight: _regular,
      color: color ?? AppColor.greyColor(context),
    );
  }

  /// Caption text (extra small)
  static TextStyle caption(BuildContext context, {Color? color}) {
    return _buildStyle(
      fontSize: 10.sp,
      fontWeight: _regular,
      color: color ?? AppColor.greyColor(context),
    );
  }

  /// Label text
  static TextStyle label(BuildContext context, {Color? color}) {
    return _buildStyle(
      fontSize: 12.sp,
      fontWeight: _semibold,
      color: color ?? AppColor.darkTextColor(context),
    );
  }
}
