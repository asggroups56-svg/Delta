import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyle {
  static TextStyle appBarStyle(BuildContext context, {bool listen = true}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: AppColor.appBarTextColor(context, listen: listen),
    );
  }

  static TextStyle buttonStyle(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.buttonTextColor(context, listen: listen),
    );
  }

  static TextStyle text16SDark(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.darkTextColor(context, listen: listen),
    );
  }
   static TextStyle text12SDark(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.darkTextColor(context, listen: listen),
    );
  }
  static TextStyle text10SDark(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.darkTextColor(context, listen: listen),
    );
  }
  

  static TextStyle text14MPrimary(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.primaryColor(context, listen: listen),
    );
  }

  static TextStyle text16MSecond(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
    );
  }

  static TextStyle text14RGrey(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.greyColor(context, listen: listen),
    );
  }

  static TextStyle textFormStyle(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.greyColor(context, listen: listen),
    );
  }

  static TextStyle formTitleStyle(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.greyColor(context, listen: listen),
    );
  }

  static TextStyle mainAppColor(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.primaryColor(context, listen: listen),
    );
  }

  static TextStyle hintStyle(
    BuildContext context, {
    bool listen = true,
    Color? color,
  }) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.greyColor(context, listen: listen),
    );
  }

  // ── Reusable Standard Styles ──────────────────────────────────────────────
  static TextStyle titleBold(BuildContext context, {double fontSize = 16, Color? color}) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontWeight: FontWeight.bold,
      color: color ?? AppColor.titleFormFiledColor(context),
    );
  }

  static TextStyle bodyMedium(BuildContext context, {double fontSize = 14, Color? color}) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.darkTextColor(context),
    );
  }

  static TextStyle bodySmall(BuildContext context, {double fontSize = 12, Color? color}) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontWeight: FontWeight.normal,
      color: color ?? AppColor.greyColor(context),
    );
  }
}
