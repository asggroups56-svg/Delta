import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppColor {
  // Primary App Color: Emerald Teal
  static Color primaryColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0D9488),
      dark: const Color(0xFF0D9488),
      listen: listen,
    );
  }

  // Secondary App Color: Ocean Blue
  static Color secondAppColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0284C7),
      dark: const Color(0xFF0284C7),
      listen: listen,
    );
  }

  static Color borderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xffA6A6A6),
      dark: const Color(0xffA6A6A6),
      listen: listen,
    );
  }

  static Color scaffoldColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFF8FAFC),
      dark: const Color(0xFFF8FAFC),
      listen: listen,
    );
  }

  static Color textFormFillColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFF8FAFC),
      dark: const Color(0xFFF8FAFC),
      listen: listen,
    );
  }

  static Color hintColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xffA6A6A6),
      dark: const Color(0xffA6A6A6),
      listen: listen,
    );
  }

  static Color BackColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: Colors.black,
      dark: Colors.black,
      listen: listen,
    );
  }

  // Dark Background Base: Rich Deep Emerald
  static Color DeepColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF042F2C),
      dark: const Color(0xFF042F2C),
      listen: listen,
    );
  }

  // Primary Gradient Indigo/Teal
  static Color DeepIndigoColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0D9488),
      dark: const Color(0xFF0D9488),
      listen: listen,
    );
  }

  // Accent Color 1: Ocean Blue
  static Color AccentPurpleColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0284C7),
      dark: const Color(0xFF0284C7),
      listen: listen,
    );
  }

  // Accent Color 2: Bright Mint Teal
  static Color AccentIndigoColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF14B8A6),
      dark: const Color(0xFF14B8A6),
      listen: listen,
    );
  }

  static Color darkTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF64748B),
      dark: const Color(0xFF64748B),
      listen: listen,
    );
  }

  static Color greyColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFA5A5A5),
      dark: const Color(0xFFA5A5A5),
      listen: listen,
    );
  }

  static Color titleFormFiledColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0F172A),
      dark: const Color(0xFF0F172A),
      listen: listen,
    );
  }

  static Color whiteColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xffffffff),
      dark: const Color(0xffffffff),
      listen: listen,
    );
  }

  static Color textFormBorderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFE2E8F0),
      dark: const Color(0xFFE2E8F0),
      listen: listen,
    );
  }

  static Color textFormColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xff000000),
      dark: const Color(0xff000000),
      listen: listen,
    );
  }

  static Color appBarTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0F172A),
      dark: const Color(0xFF0F172A),
      listen: listen,
    );
  }

  static Color appBarColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xffFAFAFA),
      dark: const Color(0xffFAFAFA),
      listen: listen,
    );
  }

  static Color buttonTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xffffffff),
      dark: const Color(0xffffffff),
      listen: listen,
    );
  }
}
